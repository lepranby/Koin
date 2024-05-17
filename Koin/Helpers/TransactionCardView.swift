//  TransactionCardView.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24

import SwiftUI

struct TransactionCardView: View {
    @Environment(\.modelContext) private var context
    var transaction: Transaction
    var showCategory: Bool = false
    var body: some View {
        SwipeAction(cornerRadius: 10, direction: .trailing) {
            HStack(spacing: 12) {
                Text("\(String(transaction.title.prefix(1)))")
                    .font(.title2).fontWeight(.light)
                    .foregroundStyle(.white)
                    .frame(width: 52, height: 52)
                    .background(transaction.color.gradient, in: .rect(cornerRadius: 12))
                VStack(alignment: .leading, spacing: 2, content: {
                    Text(transaction.title)
                        .font(.callout).fontWeight(.semibold)
                        .foregroundStyle(Color.primary)
                    Text(transaction.remarks)
                        .font(.caption)
                        .foregroundStyle(Color.primary.secondary)
                    Text(format(date: transaction.dateAdded, format: "d MMMM YYYY"))
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    if showCategory {
                        Text(transaction.category)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .foregroundStyle(.white)
                            .background(transaction.category == Category.income.rawValue ? Color.green.gradient : Color.red.gradient, in: .capsule)
                    }
                })
                .lineLimit(1)
                .hSpacing(.leading)
                Text(currencyString(transaction.amount, allowedDigits: 1))
                    .font(.footnote).fontWeight(.semibold)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.background, in: .rect(cornerRadius: 10))
        } actions: {
            Action(tint: .red, icon: "trash") {
                context.delete(transaction)
            }
        }
    }
}

#Preview {
    ContentView()
}
