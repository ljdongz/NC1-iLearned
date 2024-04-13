//
//  Link.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/11/24.
//

import Foundation

struct TILData {
    var date: Date
    var days: Int
    var links: [Link]
}

struct Link {
    var title: String
    var url: String
    var date: Date
}


