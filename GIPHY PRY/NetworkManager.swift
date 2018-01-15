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
    
    private func formAddress(searchQuery: String, rating: String, isNotSearching: Bool) -> String {
        
        let apiKey = "api_key=NUW4GGmip9WU5AUwAYwGnXrDpu640MBS"
        var request = "https://api.giphy.com/v1/gifs/"
        
        if isNotSearching {
            request += "trending?\(apiKey)"
        }
        else {
            let convertedSearchString = String(searchQuery.map {
                $0 == " " ? "+" : $0
            })
            
            request += "search?q=\(convertedSearchString)&\(apiKey)&rating=\(rating)"
        }
        
        return request
        
    }
    
    func searchGIF(searchQuery: String, rating: String, isNotSearchQuery: Bool, completionHandler: @escaping (Any?, Error?) -> ()) {
        
        let request = formAddress(searchQuery: searchQuery, rating: rating, isNotSearching: isNotSearchQuery)
        
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
