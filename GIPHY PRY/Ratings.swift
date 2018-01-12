//
//  Ratings.swift
//  GIPHY PRY
//
//  Created by Makarevich, Dmitry on 1/11/18.
//  Copyright © 2018 Dim Mcrevi. All rights reserved.
//

import Foundation

struct Ratings {
    
    enum ratings: String {case All, Y, G, PG, PG13, R}
    
    let ratingsArray = [
        ratings.All,
        ratings.Y,
        ratings.G,
        ratings.PG,
        ratings.PG13,
        ratings.R
    ]
    
    var selectedItemIndex = 0
    
    func returnAsArray() -> [Ratings.ratings] {
        return ratingsArray
    }
    
    func returnSelected() -> Ratings.ratings {
        return ratingsArray[selectedItemIndex]
    }
    
}
