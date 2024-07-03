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
    
    // TODO: 각 케이스에 따른 ViewModel에 상태 변경 필요
    func saveLink(title: String, url: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.cloudService.saveLink(title: title, url: url) { result in
                switch result {
                case .success(let success):
                    //self.changeState(.complete(message: success))
                    print("Success")
                case .failure(let failure):
//                    self.changeState(.complete(message: failure.localizedDescription))
                    print("Failure")
                }
            }
        }
    }
}
