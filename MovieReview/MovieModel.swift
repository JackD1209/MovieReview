//
//  MovieModel.swift
//  MovieReview
//
//  Created by Đoàn Minh Hoàng on 6/24/17.
//  Copyright © 2017 Đoàn Minh Hoàng. All rights reserved.
//

import UIKit

struct Movie {
    var title: String!
    var review: String!
    var backgound: String!
}

protocol movieModelDelegate {
    func gotData(movies: [Movie])
}

class movieModel {
    
    var movies = [Movie]()
    var delegate: movieModelDelegate?
    
    func loadData(_ key: String) {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(key)?api_key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval:10)
        let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    let results = responseDictionary["results"] as? [NSDictionary]
                    for i in results! {
                        self.movies.append(Movie(title: i["title"] as! String, review: i["overview"] as! String, backgound: i["poster_path"] as! String))
                        if self.movies.count > 0 {
                            self.delegate?.gotData(movies: self.movies)
                        }
                    }
                }
            }
        })
        task.resume()
    }
}

