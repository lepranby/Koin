//  Search.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24

import SwiftUI
import Combine

struct Search: View {
    /// View properties
    @State private var searchText: String = ""
    @State private var filterText: String = ""
    @State private var selectedCategory: Category? = nil
    let searchPublisher = PassthroughSubject<String, Never>()
    /// Appearance properties
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false
    var body: some View {
        GeometryReader {
            let size = $0.size
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 12, pinnedViews: [.sectionHeaders]) {
                        Section {
                            CustomSearchField()
                            FilterTransactionView(category: selectedCategory, searchText: filterText) { transactions in
                                ForEach(transactions) { transaction in
                                    NavigationLink {
                                        TransactionView(editTransaction: transaction)
                                    } label: {
                                        TransactionCardView(transaction: transaction)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        } header: {
                            HeaderView(size)
                        }
                    }
                    .padding(14)
                    .scrollIndicators(.hidden)
                }
                .overlay {
                    ContentUnavailableView("Use the Filter to easily\nSearch for Transactions", systemImage: "doc.text.magnifyingglass")
                        .opacity(filterText.isEmpty ? 1 : 0)
                }
                .onChange(of: searchText) { oldValue, newValue in
                    if newValue.isEmpty {
                        filterText = ""
                    }
                    searchPublisher.send(newValue)
                }
                .onReceive(searchPublisher.debounce(for: .seconds(0.3), scheduler: DispatchQueue.main), perform: { text in
                    filterText = text
                })
                .scrollIndicators(.hidden)
                .preferredColorScheme(isDarkModeOn ? .dark : .light)
                .background(.gray.opacity(0.16))
            }
        }
    }

    @ViewBuilder func ToolBarContent() -> some View {
        Menu {
            Button(action: {
                selectedCategory = nil
            }, label: {
                HStack {
                    Text("Both")
                    if selectedCategory == nil {
                        Image(systemName: "checkmark")
                    }
                }
            })
            ForEach(Category.allCases, id: \.rawValue) { category in
                Button(action: {
                    selectedCategory = category
                }, label: {
                    HStack {
                        Text(category.rawValue)
                        if selectedCategory == category {
                            Image(systemName: "checkmark")
                        }
                    }
                })
            }
        } label: {
            Image(systemName: "slider.vertical.3")
        }
    }

    /// Custom Search view

    @ViewBuilder func CustomSearchField() -> some View {
        RoundedRectangle(cornerRadius: 14)
            .fill(.background)
            .frame(height: 38)
            .overlay {
                HStack(spacing: 6, content: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(appTint)
                    TextField("Search", text: $searchText)
                        .scrollDismissesKeyboard(.immediately)
                    Spacer(minLength: 0)
                    Button(action: {
                        searchText = ""
                        filterText = ""
                    }, label: {
                        Image(systemName: "xmark.circle")
                    })
                    .padding(.trailing, 16)
                }).padding(.leading, 16)
            }
    }

    /// Header view
    @ViewBuilder func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Search").font(.title).bold()
                Text("Payments, transactions").font(.callout).fontWeight(.light)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            Menu {
                Button(action: {
                    selectedCategory = nil
                }, label: {
                    HStack {
                        Text("Both")
                        if selectedCategory == nil {
                            Image(systemName: "checkmark")
                        }
                    }
                })
                ForEach(Category.allCases, id: \.rawValue) { category in
                    Button(action: {
                        selectedCategory = category
                    }, label: {
                        HStack {
                            Text(category.rawValue)
                            if selectedCategory == category {
                                Image(systemName: "checkmark")
                            }
                        }
                    })
                }
            } label: {
                Image(systemName: "slider.vertical.3")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(appTint.gradient, in: .circle)
                    .contentShape(Circle())
            }
            .visualEffect { content, geometryProxy in
                content
                    .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 10)
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
    Search()
}
