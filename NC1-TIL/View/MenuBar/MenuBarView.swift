//
//  MenuBarView.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/11/24.
//

import Foundation
import SwiftUI

struct MenuBarView: View {
    @State private var viewModel = MenuBarViewModel()
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .input:
                InputView(viewModel: viewModel)
            case .loading:
                ProgressView()
            case .complete(let message):
                CompleteView(viewModel: viewModel, message: message)
            }
        }
        .frame(width: 300, height: 300)
    }
}

fileprivate struct InputView: View {
    @State private var titleText = ""
    @State private var urlText = ""
    @FocusState private var isFocused: Bool
    
    var viewModel: MenuBarViewModel
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            
            Text("Today I Learned!")
                .font(.system(size: 30, weight: .bold))
            
            Spacer()
            
            VStack(alignment: .leading) {
                
                Text("Title")
                    .font(.system(size: 16, weight: .semibold))
                TextField("", text: $titleText)
                    .focused($isFocused)
                
                Spacer()
                    .frame(height: 20)
                
                Text("URL")
                    .font(.system(size: 16, weight: .semibold))
                TextField("", text: $urlText)
                
                Spacer()
                    .frame(height: 20)
            }
            
            Button(
                action: {
                    viewModel.saveButtonTapped(title: titleText, url: urlText) { result in
                        switch result {
                        case .success(let success):
                            self.viewModel.changeState(.complete(message: success))
                        case .failure(let failure):
                            self.viewModel.changeState(.complete(message: failure.localizedDescription))
                        }
                    }
                },
                label: {
                    Text("Save")
                        .font(.system(size: 20))
                        .frame(width: 270, height: 40)
                })
            .buttonStyle(CustomButtonStyle())
        }
        .padding()
    }
}

fileprivate struct CompleteView: View {
    var viewModel: MenuBarViewModel
    let message: String
    
    fileprivate var body: some View {
        VStack {
            Text("\(message)")
                .font(.system(size: 20))
            
            Button(
                action: { viewModel.changeState(.input) },
                label: {
                    Text("확인")
                })
        }
    }
}

fileprivate struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.green : Color.white)
            .background(configuration.isPressed ? Color.white : Color.green)
            .cornerRadius(6.0)
            .padding()
    }
}


#Preview {
    MenuBarView()
}
