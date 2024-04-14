//
//  Array+Ext.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/14/24.
//

import Foundation

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
