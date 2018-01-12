//
//  RatingConvertible.swift
//  GIPHY PRY
//
//  Created by Makarevich, Dmitry on 1/12/18.
//  Copyright © 2018 Dim Mcrevi. All rights reserved.
//

import Foundation

protocol RatingConvertible {
    init?()
    mutating func convert(rating: Ratings.ratings) -> String
}
