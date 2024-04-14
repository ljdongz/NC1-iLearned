//
//  CloudService.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/13/24.
//

import Foundation
import CloudKit

class CloudService {
    
    static let shared = CloudService()

    private let container = CKContainer(identifier: "iCloud.NC1-TIL")
    private let recordType = "Link"
    
    func saveLink(title: String, url: String, completion: @escaping (Result<String, Error>) -> Void) {
        let record = CKRecord(recordType: recordType)
        record["title"] = title
        record["url"] = url
        record["date"] = Date().convertUTCTimeFromNow() as NSDate
        
        let publicDatabase = container.publicCloudDatabase
        publicDatabase.save(record) { _, error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success("저장 완료"))
        }
    }
    
    func fetchLinks(completion: @escaping (Result<[URLLink], Error>) -> Void) {
        var links: [URLLink] = []
        let predicate = NSPredicate(value: true)
        //let predicate = NSPredicate(format: "date >= %@", date as NSDate)
        
        let query = CKQuery(recordType: recordType, predicate: predicate)
        query.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let operation = CKQueryOperation(query: query)
        
        operation.database = container.publicCloudDatabase
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                if let link = self.convertLinkFromRecord(from: record) {
                    links.append(link)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        operation.queryResultBlock = { result in
            switch result {
            case .success:
                completion(.success(links))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        operation.start()
    }
    
    func deleteLink(_ recordID: CKRecord.ID, completion: @escaping (Result<String, Error>) -> Void) {
        container.publicCloudDatabase.delete(withRecordID: recordID) { recordID, error in
            if let error = error {
                completion(.failure(error))
            }
            
            completion(.success("삭제 완료"))
        }
    }
    
    func convertLinkFromRecord(from record: CKRecord) -> URLLink? {
        
        guard let recordID = record.value(forKey: "recordID") as? CKRecord.ID,
              let title = record.value(forKey: "title") as? String,
              let url = record.value(forKey: "url") as? String,
              let date = record.value(forKey: "date") as? Date else {
            return nil
        }
        
        return URLLink(recordID: recordID, title: title, url: url, date: date)
    }
    
        
}
