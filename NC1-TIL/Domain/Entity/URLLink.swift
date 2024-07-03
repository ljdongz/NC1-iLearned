//
//  Link.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/11/24.
//

import Foundation
import CloudKit

struct URLLink: Equatable, Hashable {
    var recordID: CKRecord.ID
    var id: Int
    var title: String
    var url: String
    var date: Date
}


