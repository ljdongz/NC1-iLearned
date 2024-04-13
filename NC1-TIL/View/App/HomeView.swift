//
//  ContentView.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/11/24.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea(.all)
            
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
        }
        .frame(width: 600, height: 700)
    }
}

#Preview {
    HomeView()
}
