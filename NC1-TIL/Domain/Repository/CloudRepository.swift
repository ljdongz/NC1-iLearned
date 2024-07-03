//
//  CloudRepository.swift
//  NC1-TIL
//
//  Created by 이정동 on 7/3/24.
//

import Foundation
import CloudKit

protocol CloudRepository {
    func saveLink(
        title: String, 
        url: String,
        completion: @escaping (Result<String, Error>) -> Void
    )
    
    func fetchLinks(completion: @escaping (Result<[URLLink], Error>) -> Void)
    
    func deleteLink(
        _ recordID: CKRecord.ID,
        completion: @escaping (Result<String, Error>) -> Void
    )
}
