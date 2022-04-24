//
//  Constants.swift
//  IMDb - Tentwenty Assignment
//
//  Created by Shradha Bhagat on 23/04/22.
//

import Foundation
import UIKit

enum ErrorCodes{
    case APIFailure
    
    var description :String {
        switch self {
        case .APIFailure:
            return "Something went wrong, please try again later"
        }
    }
}

let genreColors: [UIColor] = [UIColor(red: 0.083, green: 0.825, blue: 0.736, alpha: 1), UIColor(red: 0.886, green: 0.424, blue: 0.647, alpha: 1) , UIColor(red: 0.337, green: 0.298, blue: 0.639, alpha: 1), UIColor(red: 0.804, green: 0.616, blue: 0.06, alpha: 1)]
