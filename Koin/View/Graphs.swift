//  Graphs.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24

import SwiftUI
import SwiftData
import Charts

struct Graphs: View {
    /// View Properties
    @Query(animation: .snappy) private var transactions: [Transaction]
    @State private var chartGroups: [ChartGroup] = []

    var body: some View {
        GeometryReader {
            let size = $0.size
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 10, pinnedViews: [.sectionHeaders]) {
                        Section {
                            ChartView()
                                .frame(height: 200)
                                .padding(10)
                                .padding(.top, 10)
                                .background(.background, in: .rect(cornerRadius: 14))
                            HStack {
                                Text("Wallets").font(.title).bold()
                                Spacer(minLength: 0)
                            }
                            if chartGroups.isEmpty {
                                VStack {
                                    Spacer()
                                    ContentUnavailableView("There are no income or\nexpenses yet.\nOnce you enter them,\nthey will appear here!", systemImage: "calendar.day.timeline.left")
                                }
                            } else {
                                ForEach(chartGroups) { group in
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(format(date: group.date, format: "MMMM yyyy"))
                                            .font(.caption)
                                            .foregroundStyle(.gray)
                                            .hSpacing(.leading)
                                        NavigationLink {
                                            ListOfExpenses(month: group.date)
                                        } label: {
                                            CardView(income: group.totalIncome, expense: group.totalExpense)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                            }
                        } header: {
                            HeaderView(size)
                        }
                    }
                    .padding(14)
                    .scrollIndicators(.hidden)
                    .onAppear {
                        createChartGroup()
                    }
                }
                .background(.gray.opacity(0.16))
            }
        }
    }

    /// Header view
    @ViewBuilder func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Graphs & Charts").font(.title).bold()
                Text("Tracking your payments").font(.callout).fontWeight(.light)
                    .foregroundStyle(.secondary)
            }
            .visualEffect { content, geometryProxy in
                content
                    .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
            }
            Spacer(minLength: 0)

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

    @ViewBuilder func ChartView() -> some View {
        Chart {
            ForEach(chartGroups) { group in
                ForEach(group.categories) { chart in
                    BarMark(
                        x: .value("Month", format(date: group.date, format: "MMM yy")),
                        y: .value(chart.category.rawValue, chart.totalValue),
                        width: 20
                    )
                    .position(by: .value("Category", chart.category.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Category", chart.category.rawValue))
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis(content: {
            AxisMarks(position: .leading) { value in
                let doubleValue = value.as(Double.self) ?? 0
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    Text(axisLabel(doubleValue))
                }
            }
        })
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient])
    }

    func createChartGroup() {
        Task.detached(priority: .high) {
            let calendar = Calendar.current
            let groupedByDate = Dictionary(grouping: transactions) { transactions in
                let components = calendar.dateComponents([.month, .year], from: transactions.dateAdded)
                return components
            }

            let sortedGroups = groupedByDate.sorted {
                let date1 = calendar.date(from: $0.key) ?? .init()
                let date2 = calendar.date(from: $1.key) ?? .init()
                return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedDescending
            }

            let chartGroups = sortedGroups.compactMap { dict -> ChartGroup? in
                let date = calendar.date(from: dict.key) ?? .init()
                let income = dict.value.filter({ $0.category == Category.income.rawValue })
                let expense = dict.value.filter({ $0.category == Category.expense.rawValue })

                let incomeTotalValue = total(income, category: .income)
                let expenseTotalValue = total(expense, category: .expense)

                return .init(
                    date: date,
                    categories: [
                        .init(totalValue: incomeTotalValue, category: .income),
                        .init(totalValue: expenseTotalValue, category: .expense)
                    ],
                    totalIncome: incomeTotalValue,
                    totalExpense: expenseTotalValue
                )
            }
            await MainActor.run {
                self.chartGroups = chartGroups
            }
        }
    }

    func axisLabel(_ value: Double) -> String {
        let intValue = Int(value)
        let kValue = Int(value) / 100
        return intValue < 1000 ? "\(intValue)" : "\(kValue) K"
    }
}

struct ListOfExpenses: View {
    let month: Date
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 14) {
                Section {
                    FilterTransactionView(startDate: month.startOfMonth, endDate: month.endOfMonth) { transactions in
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
                    Text("Spending this month")
                        .font(.caption)
                        .foregroundStyle(.gray)
                        .hSpacing(.leading)
                }
            }
            .padding(14)
        }
        .background(.gray.opacity(0.16))
        .navigationTitle(format(date: month, format: "MMMM yyyy"))
        .navigationDestination(for: Transaction.self) { transaction in
            TransactionView(editTransaction: transaction)
        }
    }
}

#Preview {
    Graphs()
}
