//
//  NetworkManager.swift
//  GIPHY PRY
//
//  Created by Dim Mcrevi on 10/17/17.
//  Copyright © 2017 Dim Mcrevi. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkManager {
    
    let ratingConverter = RatingConverter()
    
    func formRequest(searchQuery: String, rating: Ratings.ratings, isNotSearching: Bool) -> String {
        
        let apiKey = "api_key=NUW4GGmip9WU5AUwAYwGnXrDpu640MBS"
        var request = "https://api.giphy.com/v1/gifs/"
        
        if isNotSearching {
            request += "trending?\(apiKey)"
        }
        else {
            let convertedSearchString = String(searchQuery.map {
                $0 == " " ? "+" : $0
            })
            let convertedRating = ratingConverter.convert(rating: rating)
            
            request += "search?q=\(convertedSearchString)&\(apiKey)&rating=\(convertedRating)"
        }
        
        return request
        
    }
    
    func makeRequest(request: String, completionHandler: @escaping (Any?, Error?) -> ()) {
        
        Alamofire.request(request).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    completionHandler(value as Any, nil)
                }
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
        
    }
    
}
