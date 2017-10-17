//
//  GiphyGIF.swift
//  GIPHY PRY
//
//  Created by Dim Mcrevi on 10/17/17.
//  Copyright © 2017 Dim Mcrevi. All rights reserved.
//

import Foundation
import SwiftyJSON

class GiphyGIF {
    
    let url: String
    let trendingDate: String
    
    init(json: JSON) {
        self.url = json["images"]["fixed_width"]["url"].stringValue
        self.trendingDate = json["trending_datetime"].stringValue
    }
    
}
