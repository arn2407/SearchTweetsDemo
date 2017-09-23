//
//  TwitterAPIClient.swift
//  SearchTweetsDemo
//
//  Created by Arun Kumar on 23/09/17.
//  Copyright © 2017 NEO. All rights reserved.
//

import Foundation

class TwitterAPIClient: NSObject {
    
    static let shared  = TwitterAPIClient()
    
    func fetchSearchResults(forQuery query : String, sinceDate : String , geoCode : String, completion : @escaping (Bool , Any?)->()) {
        
        let client = TWTRAPIClient()
        
        guard   let searchQuery = "https://api.twitter.com/1.1/search/tweets.json?q=\(query) filter:images since:\(sinceDate)&geocode=\(geoCode)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        var clientError : NSError?
        let request = client.urlRequest(withMethod: "GET", url: searchQuery, parameters: nil, error: &clientError)
        client.sendTwitterRequest(request) {(response, data, error) in
            
            if let recievedError = error {
                
                DispatchQueue.main.async {
                    completion(false , recievedError.localizedDescription)
                }
            }
            else
            {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! [String : Any]
                    guard let tweets = dict["statuses"] as? [[String : Any]] else {
                        DispatchQueue.main.async {
                            completion(true , nil)
                        }
                        return
                    }
                    let results = tweets.map{SearchTweetModel($0)}
                    DispatchQueue.main.async {
                        completion(true , results)
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        completion(true , nil)
                    }
                }
            }
            
        }
    }
    
}
