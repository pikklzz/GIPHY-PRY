//
//  gifManager.swift
//  GIPHY PRY
//
//  Created by Makarevich, Dmitry on 1/15/18.
//  Copyright © 2018 Dim Mcrevi. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GifManager {
    
    var gifsData : [JSON] = []
    private var networkManager = NetworkManager()
    
    mutating func getGifs(searchQuery: String, rating: String, isNotSearchQuery: Bool, completionHandler: @escaping (Bool, Error?) -> ()) {
        
        func parseJSON(rawResponse: Any) {
            let json = JSON(rawResponse)
            gifsData = json["data"].arrayValue
        }
        
        networkManager.searchGIF(searchQuery: searchQuery, rating: rating, isNotSearchQuery: isNotSearchQuery, completionHandler: {response, error in
            if let rawResponse = response {
                parseJSON(rawResponse: rawResponse)
            }
            completionHandler(true, nil)
        })
        
    }
    
}
