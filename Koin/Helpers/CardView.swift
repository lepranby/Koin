//
//  CardView.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24.
//

import SwiftUI

struct CardView: View {
    var income: Double
    var expense: Double
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(.background)
            VStack(alignment: .leading , spacing: 8) {
                        Text("Wallet").font(.title2).fontWeight(.bold)
                        HStack {
                            Text("\(currencyString(income - expense))")
                                .font(.title2).fontWeight(.light)
                                .foregroundStyle(Color.primary)
                                .padding(.horizontal, 2)
                            Divider().frame(height: 20)
                            Image(systemName: expense > income ? "arrow.down.forward" : "arrow.up.right")
                                .font(.title3)
                                .foregroundStyle(expense > income ? .red : appTint)
                        }
                        .padding(.bottom, 20)
                HStack(spacing: 0) {
                    ForEach(Category.allCases, id: \.rawValue) { category in
                        let symbolImage = category == .income ? "arrow.down" : "arrow.up"
                        let tint = category == .income ? appTint : Color.red
                        HStack(spacing: 10) {
                            Image(systemName: symbolImage)
                                .font(.callout.bold())
                                .foregroundStyle(.white)
                                .frame(width: 34, height: 34)
                                .background {
                                        Circle()
                                            .fill(tint.opacity(0.8).gradient)
                                            .shadow(color: tint, radius: 2, x: 0, y: 0)
                                }
                            VStack(alignment: .leading, spacing: 4, content: {
                                Text(category.rawValue)
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                                Text(currencyString(category == .income ? income : expense, allowedDigits: 0))
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.primary)
                            })
                            if category == .income {
                                Spacer(minLength: 10)
                            }
                        }
                    }
                }
            }
            .padding([.horizontal, .bottom], 24)
            .padding(.top, 16)
        }
    }
}

#Preview {
    CardView(income: 8000, expense: 32100)
}
