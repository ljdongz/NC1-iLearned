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
                SplashView()
            } else {
                MainView(viewModel: viewModel)
            }
            
        }
        .frame(width: 800, height: 800)
        .onAppear {
            viewModel.fetchAllLink()
        }
    }
}

// MARK: - 로딩 화면
fileprivate struct SplashView: View {
    
    fileprivate var body: some View {
        VStack {
            Text("Loading...")
        }
    }
}

// MARK: - 메인 화면
fileprivate struct MainView: View {
    @Bindable private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    fileprivate var body: some View {
        
        VStack {
            RefreshButton(viewModel: viewModel)
            
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

fileprivate struct RefreshButton: View {
    var viewModel: HomeViewModel
    
    fileprivate var body: some View {
        
        HStack {
            Text("최근 업데이트: \(Date().convertToString())")
            Button(
                action: {
                    viewModel.fetchAllLink()
                },
                label: {
                    Image(systemName: "arrow.clockwise")
            })
        }
        .font(.system(size: 14))
        .foregroundStyle(AppColor.gray)
    }
}

// MARK: - 월별 화면
fileprivate struct MonthlyView: View {
    @Bindable var viewModel: HomeViewModel
    
    fileprivate var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 30) {
                ForEach(Array(viewModel.monthlys.enumerated()), id: \.1) { idx, monthly in
                    ContentsView(viewModel: viewModel, monthly: monthly)
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

// MARK: - 월별 컨텐츠 화면
fileprivate struct ContentsView: View {
    var viewModel: HomeViewModel
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
                
                Text("\(monthly.date.currentMonth())월")
                    .font(.system(size: 20))
                    .foregroundStyle(AppColor.background)
                
                Spacer()
                
                LinkListView(viewModel: viewModel, links: monthly.links)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 50)
    }
}

// MARK: - 링크 리스트 화면
fileprivate struct LinkListView: View {
    var viewModel: HomeViewModel
    var links: [URLLink]
    
    fileprivate var body: some View {
        TabView {
            
            ForEach(links.chunked(into: 3), id: \.self) { chunk in
                VStack {
                    ForEach(chunk, id: \.self) { link in
                        LinkListCellView(viewModel: viewModel, link: link)
                            
                    }
                }
                
            }
        }
    }
}

// MARK: - 링크 리스트 셀 화면
fileprivate struct LinkListCellView: View {
    var viewModel: HomeViewModel
    var link: URLLink
    
    fileprivate var body: some View {
        
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(AppColor.dark)
                
                Link(destination: URL(string: link.url)!, label: {
                    Text(link.title)
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .padding(.leading, 20)
                        .foregroundStyle(AppColor.dark)
                })
                
                Spacer()
                
                Button(
                    action: {
                        viewModel.deleteLink(link)
                    },
                    label: {
                        Text("삭제")
                            .font(.system(size: 14))
                            .foregroundStyle(AppColor.red)
                })
                    
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 30)
            .background(AppColor.background)
            .clipShape(RoundedRectangle(cornerRadius: 50))
        }
        .padding(.horizontal, 50)
    }
}

#Preview {
        HomeView()
}


