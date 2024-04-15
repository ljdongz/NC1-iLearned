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
            
            MainView(viewModel: viewModel)
        }
        .frame(width: 800, height: 800)
        .onAppear {
            viewModel.fetchAllLink()
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
        ZStack {
            if !viewModel.monthlys.isEmpty {
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
                    
                    //            Text(String(viewModel.monthlys[viewModel.currentIndex ?? 0].date.currentYear()))
                    
                    HStack {
                        Text(String(viewModel.currentMonthly?.date.currentYear() ?? 0) + "년")
                        
                        Text("\(viewModel.currentMonthly?.date.currentMonth() ?? 0)월")
                    }
                    .font(.system(size: 40, weight: .semibold, design: .monospaced))
                    .foregroundStyle(AppColor.dark)
                    
                    
                    MonthlyView(viewModel: viewModel)
                }
                .onAppear {
                    viewModel.scrollToCurrentDate()
                }
                
            }
            
            if viewModel.isLoading {
                LoadingView()
            }
        }
        
    }
}

fileprivate struct LoadingView: View {
    fileprivate var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            Spacer()
        }
        .background(AppColor.dark.opacity(0.5))
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
                    //.id(idx)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $viewModel.currentMonthly, anchor: .center)
        .scrollTargetBehavior(.viewAligned)
        
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
                    ZStack {
                        HStack {
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(AppColor.red)
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(AppColor.yellow)
                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(AppColor.green)
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(AppColor.gray)
                
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
        //        TabView {
        //            ForEach(Array(links.reversed().chunked(into: 3).enumerated()), id: \.1) { idx, chunk in
        //                VStack {
        //                    ForEach(chunk, id: \.self) { link in
        //                        LinkListCellView(viewModel: viewModel, link: link)
        //
        //                    }
        //                }
        //                .tabItem {
        //                    Text("\(idx + 1) page")
        //                }
        //            }
        //        }
        ScrollView {
            ForEach(Array(links.reversed().enumerated()), id: \.1) { idx, link in
                LinkListCellView(viewModel: viewModel, link: link)
            }
        }
    }
}

// MARK: - 링크 리스트 셀 화면
fileprivate struct LinkListCellView: View {
    @State private var isOnHover: Bool = false
    
    var viewModel: HomeViewModel
    var link: URLLink
    
    fileprivate var body: some View {
        
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundStyle(AppColor.gray)
                
                Link(destination: URL(string: link.url)!, label: {
                    Text(link.title)
                        .lineLimit(1)
                        .font(.system(size: 15))
                        .padding(.leading, 20)
                        .foregroundStyle(isOnHover ? .blue : AppColor.dark)
                        .underline(isOnHover ? true : false)
                })
                .onHover { bool in
                    self.isOnHover = bool
                }
                
                Spacer()

                Button {
                    viewModel.deleteLink(link)
                } label: {
                    Text("삭제")
                }

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


