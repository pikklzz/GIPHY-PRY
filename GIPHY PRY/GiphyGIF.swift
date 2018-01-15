//
//  GiphyGIF.swift
//  GIPHY PRY
//
//  Created by Dim Mcrevi on 10/17/17.
//  Copyright © 2017 Dim Mcrevi. All rights reserved.
//

import Foundation
import SwiftyJSON

struct GiphyGIF {
    
    let url: String
    private let trendingDate: String
    
    private let neverTrendedDateAttribute = ["0001", "1970"]
    
    init(json: JSON) {
        self.url = json["images"]["fixed_width"]["url"].stringValue
        self.trendingDate = json["trending_datetime"].stringValue
    }
    
    func neverTrended() -> Bool {
        return trendingDate.contains(neverTrendedDateAttribute[0]) || trendingDate.contains(neverTrendedDateAttribute[1])
    }

}
