//
//  ViewController.swift
//  SearchTweetsDemo
//
//  Created by Arun Kumar on 22/09/17.
//  Copyright © 2017 NEO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var buttonSearch : UIButton!
    @IBOutlet weak var constraintButtonTopSpace : NSLayoutConstraint!
    @IBOutlet weak var constraintButtonLeading : NSLayoutConstraint!
    @IBOutlet weak var constraintButtonTrailing : NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonSearch.layer.borderColor = UIColor.lightGray.cgColor
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateSearchButton()
    }
    private func animateSearchButton()
    {
        self.view.updateConstraintsIfNeeded()
        constraintButtonTopSpace.constant = 44.0
        constraintButtonLeading.constant = 20.0
        constraintButtonTrailing.constant = 20.0
        UIView.animate(withDuration: 1.6, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    @IBAction func actionSearchTweets(_ sender : Any)
    {
        self.view.updateConstraintsIfNeeded()
        constraintButtonTopSpace.constant = 8
        constraintButtonLeading.constant = 50.0
        constraintButtonTrailing.constant = 50.0
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }) { (isFinished) in
            let searchTweetVC = self.storyboard!.instantiateViewController(withIdentifier: "TweetSearchViewController") as! TweetSearchViewController
            self.navigationController?.pushViewController(searchTweetVC, animated: false)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}


