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
                .font(.custom(AppFont.main, size: 30))
                .fontWeight(.bold)
            Spacer()
            
            VStack(alignment: .leading) {
                
                Text("Title")
                    .font(.custom(AppFont.main, size: 16))
                    .fontWeight(.semibold)
                TextField("", text: $titleText)
                    .font(.custom(AppFont.main, size: 16))
                    .fontWeight(.semibold)
                    .focused($isFocused)
                
                Spacer()
                    .frame(height: 20)
                
                Text("URL")
                    .font(.custom(AppFont.main, size: 16))
                    .fontWeight(.semibold)
                TextField("", text: $urlText)
                    .font(.custom(AppFont.main, size: 16))
                    .fontWeight(.semibold)
                
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
                        .font(.custom(AppFont.main, size: 20))
                        .fontWeight(.medium)
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
                .font(.custom(AppFont.main, size: 20))
                .fontWeight(.medium)
            
            Button(
                action: { viewModel.changeState(.input) },
                label: {
                    Text("확인")
                        .font(.custom(AppFont.main, size: 20))
                        .fontWeight(.medium)
                })
            .buttonStyle(CustomButtonStyle())
        }
    }
}

fileprivate struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.greenMain : Color.textWhite)
            .background(configuration.isPressed ? Color.textWhite : Color.greenMain)
            .cornerRadius(6.0)
            .padding()
    }
}


#Preview {
    MenuBarView()
}
