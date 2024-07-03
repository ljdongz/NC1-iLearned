//
//  MenuBarView.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/11/24.
//

import Foundation
import SwiftUI

struct MenuBarView: View {
    @State private var viewModel = MenuBarViewModel(
        menuBarUseCase:
            MenuBarUseCase(
                cloudService: CloudService()
            )
    )
    
    var body: some View {
        VStack {
            switch viewModel.state.viewState {
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
                TextField("", text: $titleText)
                    .focused($isFocused)
                
                Spacer()
                    .frame(height: 20)
                
                Text("URL")
                TextField("", text: $urlText)
                
                Spacer()
                    .frame(height: 20)
            }
            .font(.custom(AppFont.main, size: 16))
            .fontWeight(.semibold)
            
            Button(
                action: {
                    viewModel.effect(.didCreate(title: titleText, url: urlText))
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
    let viewModel: MenuBarViewModel
    let message: String
    
    fileprivate var body: some View {
        VStack {
            Spacer()
            Text("\(message)")
                
            Spacer()
            Button(
                action: { viewModel.effect(.didDone) },
                label: {
                    Text("확인")
                        .frame(width: 270, height: 40)
                })
            .buttonStyle(CustomButtonStyle())
        }
        .font(.custom(AppFont.main, size: 20))
        .fontWeight(.medium)
        .padding()
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
