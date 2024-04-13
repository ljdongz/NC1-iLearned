//
//  ContentView.swift
//  NC1-TIL
//
//  Created by 이정동 on 4/11/24.
//

import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    
    var body: some View {
        ZStack {
            AppColor.background.ignoresSafeArea(.all)
            
            if viewModel.isLoading {
                LoadingView()
            } else {
                MainView(viewModel: viewModel)
            }
            
        }
        .frame(width: 800, height: 700)
        .onAppear {
            viewModel.fetchAllLink()
        }
    }
}

fileprivate struct LoadingView: View {
    
    fileprivate var body: some View {
        VStack {
            Text("Loading...")
        }
    }
}

fileprivate struct MainView: View {
    @Bindable private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        VStack {
            Text("Today I Learned!")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(AppColor.dark)
                .padding(.top, 30)
            
            Text("\(viewModel.totalContributions) contributions in the last year")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColor.gray)
                .padding(.top, 5)
            
            Spacer()
                .frame(height: 50)
            
            Text(String(viewModel.monthlys[viewModel.currentIndex ?? 0].date.currentYear()))
                .font(.system(size: 40, weight: .semibold))
                .foregroundStyle(AppColor.dark)
            
            MonthlyView(viewModel: viewModel)
            
            Spacer()
        }
        .onAppear {
            viewModel.scrollToCurrentDate()
        }
    }
}

fileprivate struct MonthlyView: View {
    @Bindable var viewModel: HomeViewModel
    
    fileprivate var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 30) {
                ForEach(Array(viewModel.monthlys.enumerated()), id: \.1) { idx, monthly in
                    LinkListView(viewModel: viewModel)
                        .containerRelativeFrame(.horizontal)
                        .id(idx)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollPosition(id: $viewModel.currentIndex, anchor: .center)
    }
}

fileprivate struct LinkListView: View {
    var viewModel: HomeViewModel
    
    fileprivate var body: some View {
        ZStack {
            AppColor.dark
            
            
            
            VStack {
                HStack {
                    HStack {
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(AppColor.red)
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(AppColor.yellow)
                        Circle()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(AppColor.green)
                    }
                    
                    Spacer()
                }
                .padding()
                
                Text("[SwiftUI] Observation으로 SwiftUI 데이터 모델을 간소화하자")
                    .font(.system(size: 16))
                
                Spacer()
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 50)
    }
}

#Preview {
    HomeView()
}
