//
//  Month.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/16/24.
//

import Foundation

enum Month: Int {
    case jan = 1
    case feb = 2
    case mar = 3
    case apr = 4
    case may = 5
    case jun = 6
    case jul = 7
    case aug = 8
    case sep = 9
    case oct = 10
    case nov = 11
    case dec = 12
    
    var description: String {
        switch self {
        case .jan:
            "January"
        case .feb:
            "February"
        case .mar:
            "March"
        case .apr:
            "April"
        case .may:
            "May"
        case .jun:
            "June"
        case .jul:
            "July"
        case .aug:
            "August"
        case .sep:
            "September"
        case .oct:
            "October"
        case .nov:
            "November"
        case .dec:
            "December"
        }
    }
}
