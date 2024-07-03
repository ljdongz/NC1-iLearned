//
//  MenuBarUseCase.swift
//  NC1-TIL
//
//  Created by 이정동 on 7/3/24.
//

import Foundation

final class MenuBarUseCase {
    
    private let cloudService: CloudRepository
    
    init(cloudService: CloudRepository) {
        self.cloudService = cloudService
    }
    
    func saveLink(title: String, url: String, completion: @escaping (String) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.cloudService.saveLink(title: title, url: url) { result in
                switch result {
                case .success(let success):
                    completion(success)
                case .failure(let failure):
                    completion(failure.localizedDescription)
                }
            }
        }
    }
}
