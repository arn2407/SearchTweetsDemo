//
//  TweetSearchViewController.swift
//  SearchTweetsDemo
//
//  Created by Arun Kumar on 22/09/17.
//  Copyright © 2017 NEO. All rights reserved.
//

import UIKit
import CoreLocation
class TweetSearchViewController: UIViewController {

    @IBOutlet weak var mSearchBar : UISearchBar!
    @IBOutlet weak var collectionTweets : UICollectionView!
  private var tweets = [SearchTweetModel]()
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mSearchBar.barTintColor = .white
        mSearchBar.layer.borderColor = UIColor.lightGray.cgColor
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mSearchBar.becomeFirstResponder()
    }
    @IBAction func actionBack(_ sender : Any)
    {
        navigationController?.popViewController(animated: false)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TweetSearchViewController : UISearchBarDelegate
{
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text ?? "").isEmpty || searchBar.text!.characters.count < 3 {return}
       searchHashtag(text: getHashTagString(forString: searchBar.text!))
        searchBar.resignFirstResponder()
        
    }
    private func getHashTagString(forString string : String) -> String
    {
    let stringComponents = string.components(separatedBy: " ")
        let hashTagString = stringComponents.map { !$0.hasPrefix("#") ? "#" + $0 : $0
        }
        return hashTagString.joined(separator: " ")
    }
    private func searchHashtag(text : String)
    {
        guard CLLocationManager.authorizationStatus() == .authorizedWhenInUse else {
            print("Please enable location service for this app.")
            return}
        guard let coordinate = locationManager.location?.coordinate else {
            print("No location found please try again.")
            return}
        
        let geocode = "\(coordinate.latitude),\(coordinate.longitude),10km"
        guard let  aMonthBackDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else {return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sinceDate = dateFormatter.string(from: aMonthBackDate)
        
        CustomLoader.loader.showLoader()
        TwitterAPIClient.shared.fetchSearchResults(forQuery: text, sinceDate: sinceDate, geoCode: geocode) {[weak self] (success, results) in
            CustomLoader.loader.hideLoader()
            guard let `self` = self else {return}
            if let searchResults = results as? [SearchTweetModel]
            {
                self.tweets = searchResults
                self.collectionTweets.reloadData()
            }
            else{
                print("No data found")
            }
        }
    }
}

extension TweetSearchViewController : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    private func height(fortext text : String , width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(max(boundingBox.height, 20.0))
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
     return tweets.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let tweet = tweets[section]
        return tweet.tweetImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width - 16.0
        let tweet = tweets[indexPath.section]
        let tweetText = tweet.tweet + "\n" + tweet.tweetTime
        let textHeight : CGFloat = self.height(fortext: tweetText, width: width - 16, font: UIFont.systemFont(ofSize: 13.0))
        let height = 200.0 + textHeight
        return CGSize.init(width: width, height: height)
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetsSearchCell", for: indexPath) as! TweetsSearchCell
        let tweet = tweets[indexPath.section]
        let tweetImage = tweet.tweetImages[indexPath.item]
        cell.imageView.downloadImage(forTweet: tweetImage)
        cell.labelTweet.text = tweet.tweet + "\n" + tweet.tweetTime
        return cell
    }
}
extension TweetSearchViewController : CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}
