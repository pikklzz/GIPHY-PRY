//
//  RatingConverter.swift
//  GIPHY PRY
//
//  Created by Makarevich, Dmitry on 1/12/18.
//  Copyright © 2018 Dim Mcrevi. All rights reserved.
//

import Foundation

struct RatingConverter: RatingConvertible {
    public func convert(rating: Ratings.ratings) -> String {
        switch rating {
            case .All:   return "";
            case .Y:     return "Y";
            case .G:     return "G";
            case .PG:    return "PG";
            case .PG13:  return "PG-13";
            case .R:     return "R"
        }
    }
}
