//
//  NetworkManager.swift
//  GIPHY PRY
//
//  Created by Dim Mcrevi on 10/17/17.
//  Copyright © 2017 Dim Mcrevi. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class NetworkManager {
    
    var gifsData : [JSON] = []
    
    
    func formRequest(searchController: UISearchController?, rating: String, isNotSearching: Bool) -> String {
        
        let apiKey = "api_key=NUW4GGmip9WU5AUwAYwGnXrDpu640MBS"
        var request = "https://api.giphy.com/v1/gifs/"
        
        if isNotSearching {
            request += "trending?\(apiKey)"
        }
        else {
            let searchBar = searchController!.searchBar
            let convertedSearchString = String(searchBar.text!.characters.map {
                $0 == " " ? "+" : $0
            })
            
            request += "search?q=\(convertedSearchString)&\(apiKey)"
            
            switch rating {
            case "All":     break
            default:        request += "&rating=\(rating)"
            }
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
    
    func prepareJson(rawResponse: Any) {
        let json = JSON(rawResponse)
        self.gifsData = json["data"].arrayValue
    }
    
}
