//
//  Ratings.swift
//  GIPHY PRY
//
//  Created by Makarevich, Dmitry on 1/11/18.
//  Copyright © 2018 Dim Mcrevi. All rights reserved.
//

import Foundation

enum Ratings: String {
    case All = ""
    case Y = "Y"
    case G = "G"
    case PG = "PG"
    case PG13 = "PG-13"
    case R = "R"
    
    static func asArray() -> [Ratings] {
        return [
            Ratings.All,
            Ratings.Y,
            Ratings.G,
            Ratings.PG,
            Ratings.PG13,
            Ratings.R
        ]
    }
}

struct RatingsSegmentControlDataSource {
    var selectedItemIndex = 0
    var selectedRating: Ratings {
        return ratings[selectedItemIndex]
    }
    
    private(set) var ratings = Ratings.asArray()
}

