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
                    ContentsView(monthly: monthly)
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

fileprivate struct ContentsView: View {
    var monthly: Monthly
    
    fileprivate var body: some View {
        ZStack {
            AppColor.dark
            
            VStack {
                HStack {
                    HStack {
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(AppColor.red)
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(AppColor.yellow)
                        Circle()
                            .frame(width: 15, height: 15)
                            .foregroundStyle(AppColor.green)
                    }
                    
                    Spacer()
                }
                .padding()
                .background(AppColor.gray)
                
                
                
                Spacer()
                
                LinkListView(links: monthly.links)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 50)
    }
}

fileprivate struct LinkListView: View {
    var links: [Link]
    
    fileprivate var body: some View {
        TabView {
            
            ForEach(links.chunked(into: 3), id: \.self) { chunk in
                VStack {
                    ForEach(chunk, id: \.self) { link in
                        LinkListCellView(link: link)
                            
                    }
                }
                
            }
        }
    }
}

fileprivate struct LinkListCellView: View {
    var link: Link
    
    fileprivate var body: some View {
        
        VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text(link.title)
                        .lineLimit(1)
                        .font(.system(size: 18))
                        .padding(.leading, 20)
                    
                    Spacer()
                }
                .padding(.vertical)
                .padding(.horizontal, 30)
                .foregroundStyle(AppColor.dark)
                .background(AppColor.background)
                .clipShape(RoundedRectangle(cornerRadius: 50))
            
            
        }
    }
}

#Preview {
    HomeView()
}


