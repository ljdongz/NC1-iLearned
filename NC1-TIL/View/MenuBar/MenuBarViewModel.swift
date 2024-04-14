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
        case loading
        case complete(message: String)
    }
    
    var state: State = .input
    
    func changeState(_ state: State) {
        self.state = state
    }
    
    func saveButtonTapped(title: String, url: String, completion: @escaping (Result<String, Error>) -> Void) {
        changeState(.loading)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            CloudService.shared.saveLink(title: title, url: url) { result in
                completion(result)
            }
        }
    }
}
