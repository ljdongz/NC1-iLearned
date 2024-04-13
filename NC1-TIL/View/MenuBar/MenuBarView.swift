//
//  MenuBarView.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/11/24.
//

import Foundation
import SwiftUI

struct MenuBarView: View {
    
    @State private var titleText = ""
    @State private var urlText = ""
    
    @FocusState private var isFocused: Bool
    @State private var isCompleted = false
    
    var body: some View {
        VStack {
            if isCompleted {
                CompleteView(isCompleted: $isCompleted)
            } else {
                InputView(isCompleted: $isCompleted)
            }
        }
        .frame(width: 300, height: 300)
    }
}

fileprivate struct InputView: View {
    @State private var titleText = ""
    @State private var urlText = ""
    @Binding var isCompleted: Bool
    @FocusState private var isFocused: Bool
    
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
                    CloudService.shared.saveLink(Link(title: titleText, url: urlText, date: .now))
                    isCompleted = true
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
    @Binding var isCompleted: Bool
    
    fileprivate var body: some View {
        VStack {
            Button(
                action: { isCompleted = false },
                label: {
                    Text("Done")
                })
        }
    }
}

struct CustomButtonStyle: ButtonStyle {
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
