//
//  MenuBarViewModel.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/14/24.
//

import Foundation

@Observable
class MenuBarViewModel {
    
    enum Action {
        case didCreate(title: String, url: String)
        case didDone
    }
    
    struct State {
        enum ViewState {
            case input, loading
            case complete(message: String)
        }
        
        var viewState: ViewState = .input
    }
    
    private let menuBarUseCase: MenuBarUseCase
    
    private(set) var state: State = .init()
    
    init(menuBarUseCase: MenuBarUseCase) {
        self.menuBarUseCase = menuBarUseCase
    }
    
    func effect(_ action: Action) {
        switch action {
        case .didCreate(let title, let url):
            self.state = .init(viewState: .loading)
            
            self.menuBarUseCase.saveLink(title: title, url: url) { message in
                self.state = .init(viewState: .complete(message: message))
            }
        case .didDone:
            self.state = .init(viewState: .input)
        }
    }
}
