//  Recents.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24

import SwiftUI
import SwiftData

struct Recents: View {
    /// User properties
    @AppStorage("userName") private var userName: String = ""
    /// View properties
    @State private var startDate: Date = .now.startOfMonth
    @State private var endDate: Date = .now.endOfMonth
    @State private var showFilter: Bool = false
    @State private var selectedCategory: Category = .expense
    /// Animation
    @Namespace private var animation
    /// Appearance properties
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false
    @AppStorage("title") private var isTitleBig: Bool = false

    var body: some View {
        GeometryReader {
            let size = $0.size
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        Section {
                            FilterTransactionView(startDate: startDate, endDate: endDate) { transactions in
                                CardView(income: total(transactions, category: .income), expense: total(transactions, category: .expense))
                                Button(action: {
                                    showFilter = true
                                }, label: {
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(.background)
                                        .frame(height: 38)
                                        .overlay {
                                            HStack(spacing: 6) {
                                                Text("From").font(.callout).foregroundStyle(Color.primary)
                                                Text("\(format(date: startDate, format: "d MMM, YYYY"))")
                                                    .font(.callout)
                                                    .foregroundStyle(.gray)
                                                Text("to").font(.callout).foregroundStyle(Color.primary)
                                                Text("\(format(date: endDate, format: "d MMM, YYYY"))")
                                                    .font(.callout)
                                                    .foregroundStyle(.gray)
                                                Spacer()
                                                Image(systemName: "calendar").font(.callout)
                                            }
                                            .padding(.leading, 16)
                                            .padding(.trailing, 16)
                                        }
                                })
                                .padding(.top, 4)
                                .hSpacing(.leading)
                                CustomSegmentedControl()
                                    .padding(.bottom, 10)
                                if transactions.isEmpty {
                                    VStack {
                                        Spacer(minLength: 60)
                                        ContentUnavailableView("There are no income or expenses yet.", systemImage: "calendar.day.timeline.left")

                                    }
                                } else {
                                    ForEach(transactions.filter({ $0.category == selectedCategory.rawValue })) { transaction in
                                        NavigationLink (value: transaction) {
                                            TransactionCardView(transaction: transaction)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        } header: {
                            HeaderView(size)
                        }
                    }
                    .padding(16)
                    .scrollIndicators(.hidden)
                }
                .background(.gray.opacity(0.16))
                .blur(radius: showFilter ? 6 : 0)
                .disabled(showFilter)
                .navigationDestination(for: Transaction.self) { transaction in
                    TransactionView(editTransaction: transaction)
                }
            }
            .scrollIndicators(.hidden)
            .preferredColorScheme(isDarkModeOn ? .dark : .light)
            .navigationBarTitleDisplayMode(isTitleBig ? .inline : .automatic)
            .overlay {
                if showFilter {
                    DateFilterView(start: startDate, end: endDate, onSubmit: { start, end in
                        startDate = start
                        endDate = end
                        showFilter = false
                    }, onClose: {
                        showFilter = false
                    })
                    .transition(.move(edge: .leading))
                }
            }
            .animation(.snappy, value: showFilter)
        }
    }

    /// Header view
    @ViewBuilder func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Dashboard").font(.title).bold()
                if !userName.isEmpty {
                    Text("Welcome, \(userName)!").font(.callout).fontWeight(.light)
                        .foregroundStyle(.secondary)
                }
            }
            .visualEffect { content, geometryProxy in
                content
                    .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
            }
            Spacer(minLength: 0)
            NavigationLink {
                TransactionView()
            } label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(appTint.gradient, in: .circle)
                    .contentShape(Circle())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, userName.isEmpty ? 10 : 6)
        .background {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(.ultraThinMaterial)
                Divider()
            }
            .visualEffect { content, geometryProxy in
                content
                    .opacity(headerBGOpacity(geometryProxy))
            }
            .padding(.horizontal, -16)
            .padding(.top, -(safeArea.top + 16))
        }
    }

    /// Custom Segmented Control
    @ViewBuilder func CustomSegmentedControl() -> some View {
        HStack(spacing: 0) {
            ForEach(Category.allCases, id: \.rawValue) { category in
                Text(category.rawValue)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background {
                        if category == selectedCategory {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(.background)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .contentShape(Capsule())
                    .onTapGesture {
                        withAnimation(.snappy) {
                            selectedCategory = category
                        }
                    }
            }
        }
        .background(.gray.opacity(0.16), in: .rect(cornerRadius: 14))
        .padding(.top, 4)
    }

    func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        return minY > 0 ? 0 : (-minY / 16)
    }

    func headerScale(_ size: CGSize, proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height
        let progress = minY / screenHeight
        let scale = (min(max(progress, 0), 1)) * 0.8
        return 1 + scale
    }

}

#Preview {
    Recents()
}
