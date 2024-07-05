//
//  TerminalUseCase.swift
//  NC1-TIL
//
//  Created by 이정동 on 7/3/24.
//

import Foundation
import AppKit

final class TerminalUseCase {
    
    private let cloudService: CloudRepository
    
    init(cloudService: CloudRepository) {
        self.cloudService = cloudService
    }
    
    func saveLink(
        title: String,
        url: String,
        completion: @escaping (Result<String, Error>) -> Void
    ) {
        self.cloudService.saveLink(title: title, url: url) { result in
            completion(result)
        }
    }
    
    func openLink(_ link: URLLink) -> Bool {
        return openURL(urlString: link.url)
    }
    
    func fetchLinks(completion: @escaping (Result<[URLLink], Error>) -> Void) {
        self.cloudService.fetchLinks { result in
            completion(result)
        }
    }
    
    func deleteLink(_ url: URLLink, completion: @escaping (Result<String, Error>) -> Void) {
        self.cloudService.deleteLink(url.recordID) { result in
            completion(result)
        }
    }
}

extension TerminalUseCase {
    /// URL 주소로 브라우저를 엶
    /// - Parameter urlString: url 주소
    /// - Returns: URL 주소가 유효한지에 대한 여부
    private func openURL(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            return false
        }
        
        return NSWorkspace.shared.open(url)
    }
}
