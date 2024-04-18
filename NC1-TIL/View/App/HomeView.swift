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
                RefreshButton(viewModel: viewModel)
                    .padding(.horizontal, 15)
                    .padding(.top, 15)
                
                MainScrollView(viewModel: viewModel)
                
                CommandInputView(viewModel: viewModel)
                    .padding(.horizontal)
                    .padding(.vertical, 5)
            }
            
        }
        .frame(minWidth: 600, minHeight: 450)
        .onAppear {
            viewModel.setTerminalState(.load)
        }
    }
}

// MARK: - 새로고침 버튼
fileprivate struct RefreshButton: View {
    var viewModel: HomeViewModel
    
    fileprivate var body: some View {
        
        HStack {
            Text("\(viewModel.totalContributions) contributions so far.")
                .font(.custom(AppFont.main, size: 20))
                .fontWeight(.semibold)
            Spacer()
            
            Text("최근 업데이트: \(Date().convertToString())")
                .foregroundStyle(AppColor.textGray)
                .font(.custom(AppFont.main, size: 12))
            Button(
                action: {
                    viewModel.setTerminalState(.load)
                },
                label: {
                    Image(.refreshPx)
                        .resizable()
                        .frame(width: 12, height: 14)
                }
            )
            .buttonStyle(CustomButtonStyle())
            
        }
        
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
                    .frame(width: 95, height: 20)
                    .overlay {
                        Text("\(String(monthly.date.currentYear())) YEAR")
                            .foregroundStyle(AppColor.red)
                    }
                Rectangle()
                    .frame(width: 95, height: 20)
                    .overlay {
                        Text("\(Month(rawValue: monthly.date.currentMonth())!.description)")
                            .foregroundStyle(AppColor.yellow)
                    }
                Rectangle()
                    .frame(width: 95, height: 20)
                    .overlay {
                        Text("+\(monthly.days.filter { $0 != 0 }.count) Days")
                            .foregroundStyle(AppColor.green)
                    }
                Rectangle()
                    .frame(width: 95, height: 20)
                    .overlay {
                        Text("+\(monthly.links.count) Learned")
                            .foregroundStyle(AppColor.blue)
                    }
                Spacer()
            }
            .foregroundStyle(AppColor.backgroundSub)
            .font(.custom(AppFont.main, size: 15))
            .fontWeight(.bold)
            
            HStack(spacing: 1.5) {
                ForEach(Array(monthly.days.enumerated()), id: \.0) { idx, count in
                    Image(.blockPx)
                        .resizable()
                        .frame(width: 11, height: 11)
                        .foregroundStyle(count != 0 ? AppColor.green : AppColor.dark)
                    
                    if (idx + 1) % 7 == 0 {
                        Spacer().frame(width: 3)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 5)

            LazyVStack(spacing: 2) {
                ForEach(monthly.links, id: \.self) { link in
                    LinkView(viewModel: viewModel, link: link)
                        .padding(.horizontal, 5)
                }
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
    
    fileprivate var body: some View {
        HStack {
            HStack {
                Link(destination: URL(string: link.url)!, label: {
                    Text("[\(link.id)\t]")

                    Text(link.title)
                        .underline(isLinkButtonHover)
                        .tint(AppColor.textGray)
                })
                
                
                if isLinkButtonHover {
                    Button(action: {
                        viewModel.setTerminalState(.delete(id: link.id))
                    }, label: {
                        Image(systemName: "trash")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .fontWeight(isDeleteButtonHover ? .semibold : .medium)
                    })
                    .onHover { isDeleteButtonHover = $0 }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                
                Spacer()
            }
            .onHover { isLinkButtonHover = $0 }
            
            
//            Rectangle()
//                .frame(width: 100, height: 16)
//                .foregroundStyle(AppColor.gray)
//                .overlay {
//                    Text("\(link.date.convertToString())")
//                }
            Text("\(link.date.convertToString())")
                .frame(width: 120)
                .padding(.vertical, 2)
                .background(AppColor.dark)
        }
        .font(.custom(AppFont.main, size: 13))
        .foregroundStyle(AppColor.textGray)
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
                        Text(viewModel.terminalText)
                        
                        ProgressView()
                            .frame(width: 12, height: 12)
                            .scaleEffect(0.4, anchor: .center)
                    }
                }
            } else {
                TextField(viewModel.terminalText, text: $text)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        let state = TerminalCommandManager.shared.inputCommand(text)
                        viewModel.setTerminalState(state)
                        text = ""
                    }
                    .focused($isFocused)
            }
            
            Spacer()
        }
        .font(.custom(AppFont.main, size: 13))
        .fontWeight(.medium)
    }
}

fileprivate struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? AppColor.gray : AppColor.textGray)
    }
}

#Preview {
    HomeView()
}



