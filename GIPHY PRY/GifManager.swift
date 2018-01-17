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
    private var networkManager = NetworkManager()
    
    mutating func gifs(searchQuery: String, rating: String, isTrending: Bool, completionHandler: @escaping ([GiphyGIF]?, Error?) -> ()) {
        
        var gifsData : [JSON] = []
        var gifs: [GiphyGIF] = []
        
        networkManager.searchGIF(searchQuery: searchQuery, rating: rating, isTrending: isTrending) {response, error in
            if let rawResponse = response {
                let json = JSON(rawResponse)
                gifsData = json["data"].arrayValue
            }
            
            for gifData in gifsData {
                gifs.append(GiphyGIF(json: gifData))
            }
            
            completionHandler(gifs, nil)
        }
    }
}
