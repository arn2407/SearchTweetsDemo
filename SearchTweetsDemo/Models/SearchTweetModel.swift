//
//  SearchTweetModel.swift
//  SearchTweetsDemo
//
//  Created by Arun Kumar on 23/09/17.
//  Copyright © 2017 NEO. All rights reserved.
//

import Foundation
import UIKit

enum DownloadingState
{
    case new, downloading , downloaded , failed
}
struct SearchTweetModel {
    let tweetTime : String
    let tweet : String
    let tweetImages : [TweetImages]
    class TweetImages : NSObject {
        let imagePath : String
        var state = DownloadingState.new
        var image : UIImage = #imageLiteral(resourceName: "placeholder")
        init(_ dict : [String : Any]) {
            self.imagePath = dict["media_url_https"] as? String ?? ""
        }
    }
    
    init(_ dict : [String : Any]) {
        self.tweetTime = (dict["created_at"] as? String ?? "").dateFromZZZDateString
        self.tweet = dict["text"] as? String ?? ""
        
        guard let entities = dict["extended_entities"] as? [String : Any] , let media = entities["media"] as? [[String : Any]]
            else {
            self.tweetImages = [TweetImages]()
                return
        }
       
        self.tweetImages = media.map{TweetImages($0)}
    }
    
    
    
}
extension String
{
    var dateFromZZZDateString : String
    {
        let format = "EEE MMM dd HH:mm:ss ZZZ yyyy"
        let df = DateFormatter()
        df.dateFormat = format
        guard let date = df.date(from: self) else {return ""}
        df.dateFormat = "EEE MMM dd hh:mm: a"
        
        return df.string(from: date)
    }
}
