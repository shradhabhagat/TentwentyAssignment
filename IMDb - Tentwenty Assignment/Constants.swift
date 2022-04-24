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

let genreColors: [UIColor] = [.brown, .purple , .gray, .orange]
