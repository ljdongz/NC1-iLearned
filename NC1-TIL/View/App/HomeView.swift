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
            
            VStack {
                HStack {
                    Spacer()
                    RefreshButton(viewModel: viewModel)
                }
                .padding(15)
                
                MainScrollView(viewModel: viewModel)
                
                CommandInputView(viewModel: viewModel)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
            }
            
        }
        .frame(width: 600, height: 450)
        .onAppear {
            viewModel.fetchAllLink()
        }
    }
}

// MARK: - 새로고침 버튼
fileprivate struct RefreshButton: View {
    var viewModel: HomeViewModel
    
    fileprivate var body: some View {
        
        HStack {
            Text("최근 업데이트: \(Date().convertToString())")
                .foregroundStyle(AppColor.textGray)
            Button(
                action: {
                    viewModel.fetchAllLink()
                },
                label: {
                    Image(systemName: "arrow.clockwise")
                }
            )
            .buttonStyle(CustomButtonStyle())
            
        }
        .font(.system(size: 12))
    }
}

// MARK: - 메인 스크롤 화면
fileprivate struct MainScrollView: View {
    let viewModel: HomeViewModel
    
    fileprivate var body: some View {
        ScrollView {
            ForEach(viewModel.monthlys, id: \.self) { monthly in
                MonthlyView(viewModel: viewModel, monthly: monthly)
            }
        }
    }
}

// MARK: - 월별 화면
fileprivate struct MonthlyView: View {
    let viewModel: HomeViewModel
    let monthly: Monthly
    
    fileprivate var body: some View {
        VStack {
            HStack(spacing: 0) {
                Rectangle()
                    .frame(width: 100, height: 20)
                    .foregroundStyle(AppColor.blue)
                    .overlay {
                        Text("\(monthly.date.currentYear())년")
                            .font(.system(size: 12, weight: .semibold))
                    }
                Rectangle()
                    .frame(width: 100, height: 20)
                    .foregroundStyle(AppColor.green)
                    .overlay {
                        Text("\(monthly.date.currentMonth())월")
                            .font(.system(size: 12, weight: .semibold))
                    }
                Rectangle()
                    .frame(width: 100, height: 20)
                    .foregroundStyle(AppColor.yellow)
                    .overlay {
                        Text("+3 Days")
                            .font(.system(size: 12, weight: .semibold))
                    }
                Rectangle()
                    .frame(width: 100, height: 20)
                    .foregroundStyle(AppColor.red)
                    .overlay {
                        Text("+\(monthly.links.count) Learned")
                            .font(.system(size: 12, weight: .semibold))
                    }
                Spacer()
            }

            ForEach(monthly.links, id: \.self) { link in
                LinkView(viewModel: viewModel, link: link)
                    .padding(.horizontal, 5)
            }
        }
    }
}

// MARK: - 링크 화면
fileprivate struct LinkView: View {
    let viewModel: HomeViewModel
    let link: URLLink
    
    @State private var isLinkButtonHover: Bool = false
    @State private var isDeleteButtonHover: Bool = false
    @State private var isEditButtonHover: Bool = false
    
    fileprivate var body: some View {
        HStack {
            HStack {
                Link(destination: URL(string: link.url)!, label: {
                    Text("\(link.id).")
                        .frame(width: 30, alignment: .leading)
                    Text(link.title)
                        .underline(isLinkButtonHover)
                        .tint(AppColor.textGray)
                })
                
                
                if isLinkButtonHover {
                    HStack {
                        Button(action: {
                            
                        }, label: {
                            Image(systemName: "pencil")
                                .resizable()
                                .frame(width: 10, height: 10)
                        })
                        .onHover { isEditButtonHover = $0 }

                        
                        Button(action: {
                            viewModel.deleteLink(link)
                        }, label: {
                            Image(systemName: "trash")
                                .resizable()
                                .frame(width: 10, height: 10)
                        })
                        .onHover { isDeleteButtonHover = $0 }
                        
                        
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Spacer()
            }
            .onHover { isLinkButtonHover = $0 }
            
            
            Rectangle()
                .frame(width: 100, height: 16)
                .foregroundStyle(AppColor.gray)
                .overlay {
                    Text("\(link.date.convertToString())")
                }
        }
        .font(.system(size: 12))
        .foregroundStyle(AppColor.textGray)
    }
}


fileprivate struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? AppColor.gray : AppColor.textGray)
    }
}

// MARK: - 커멘트 입력 창
fileprivate struct CommandInputView: View {
    let viewModel: HomeViewModel
    @State private var text: String = ""
    @FocusState private var isFocused: Bool
    
    fileprivate var body: some View {
        HStack {
            if viewModel.isLoading {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Loading...")
                        
                        ProgressView()
                            .frame(width: 12, height: 12)
                            .scaleEffect(0.4, anchor: .center)
                    }
                }
            } else {
                TextField("명령어 입력 창", text: $text)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        print(text)
                        text = ""
                    }
                    .focused($isFocused)
            }
        }
        .font(.system(size: 12, weight: .medium))
        
    }
}

struct TestView: View {
    
    var body: some View {
        VStack {
            
        }
        
    }
}

#Preview {
    HomeView()
//    TestView()
}



