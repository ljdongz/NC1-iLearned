//
//  CloudService.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/13/24.
//

import Foundation
import CloudKit

class CloudService {
    
    enum RecordType: String {
        case monthlyGoal = "MonthlyGoal"
        case link = "Link"
    }
    
    static let shared = CloudService()

    private let container = CKContainer(identifier: "iCloud.NC1-TIL")
    
    func saveLink(_ link: Link) {
        let record = CKRecord(recordType: RecordType.link.rawValue)
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
    
    func fetchLinks() {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.weekOfYear = -1
        let lastWeekDate = calendar.date(byAdding: dateComponents, to: Date())!
//        let predicate = NSPredicate(value: true)
        let predicate = NSPredicate(format: "date > %@", Date() as NSDate)
        
        let query = CKQuery(recordType: RecordType.link.rawValue, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        
        operation.database = container.publicCloudDatabase
        operation.recordMatchedBlock = { recordID, result in
            switch result {
            case .success(let record):
                let link = self.convertLinkFromRecord(from: record)
                print(link)
            case .failure(let error):
                print(error)
            }
        }
        
        operation.start()
    }
    
    func convertLinkFromRecord(from record: CKRecord) -> Link? {
        guard let title = record.value(forKey: "title") as? String,
              let url = record.value(forKey: "url") as? String,
              let date = record.value(forKey: "date") as? Date else {
            return nil
        }
        
        return Link(title: title, url: url, date: date)
    }
    
        
}
