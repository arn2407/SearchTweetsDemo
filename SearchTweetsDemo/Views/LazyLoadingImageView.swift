//
//  LazyLoadingImageView.swift
//  SearchTweetsDemo
//
//  Created by Arun Kumar on 23/09/17.
//  Copyright © 2017 NEO. All rights reserved.
//

import Foundation
import UIKit



class LazyLoadingImageView: UIImageView {
    

    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private var path : String?
    func downloadImage(forTweet tweetImage : SearchTweetModel.TweetImages)  {
        let urlString = tweetImage.imagePath
        path = urlString
      
        switch tweetImage.state {
        case .new:
            self.image = tweetImage.image
            guard let url = URL.init(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)  else {
                tweetImage.state = .failed
                return}
            
            downloadsSession.dataTask(with: url, completionHandler: {[weak self] (data, response, error) in
                guard let `self` = self else {return}
                guard let content = data ,
                    let image = UIImage.init(data: content) else {
                        tweetImage.state = .failed
                        return
                }
                DispatchQueue.main.async {
                    [weak self] in
                    guard let `self` = self else {return}
                    if let currentPath = self.path , currentPath == tweetImage.imagePath
                    {
                        tweetImage.image = image
                        tweetImage.state = .downloaded
                        self.image = image
                      
                    }
                }
                
            }).resume()
            
            tweetImage.state = .downloading
        case .downloading , .failed:
            self.image = #imageLiteral(resourceName: "placeholder")
        default:
           
                self.image = tweetImage.image
              
            break
        }
    }
}
