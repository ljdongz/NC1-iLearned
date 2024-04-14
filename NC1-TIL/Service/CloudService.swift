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
    
    func saveLink(_ link: URLLink) {
        let record = CKRecord(recordType: recordType)
        record["title"] = link.title
        record["url"] = link.url
        record["date"] = link.date.convertUTCTimeFromNow() as NSDate
        
        let publicDatabase = container.publicCloudDatabase
        publicDatabase.save(record) { _, error in
            if let error = error {
                print("Error saving record: \(error)")
                return
            }
            print("Record saved successfully")
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
    
    func convertLinkFromRecord(from record: CKRecord) -> URLLink? {
        guard let title = record.value(forKey: "title") as? String,
              let url = record.value(forKey: "url") as? String,
              let date = record.value(forKey: "date") as? Date else {
            return nil
        }
        
        return URLLink(title: title, url: url, date: date)
    }
    
        
}
