//
//  MenuBarViewModel.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/14/24.
//

import Foundation

@Observable
class MenuBarViewModel {
    enum State {
        case input
        case creating(title: String, url: String)
        case complete(message: String)
    }
    
    private(set) var state: State = .input
    
    func changeState(_ state: State) {
        self.state = state
        
        switch state {
        case .input, .complete:
            break
        case let .creating(title, url):
            self.saveLink(title: title, url: url)
        }
    }
    
    private func saveLink(title: String, url: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            CloudService.shared.saveLink(title: title, url: url) { result in
                switch result {
                case .success(let success):
                    self.changeState(.complete(message: success))
                case .failure(let failure):
                    self.changeState(.complete(message: failure.localizedDescription))
                }
            }
        }
    }
}
