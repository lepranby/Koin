//  IntroScreen.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24

import SwiftUI

struct IntroScreen: View {

    @AppStorage("isFirstTime") private var isFirstTime: Bool = true

    var body: some View {
        VStack (spacing: 14) {
            Text("What's new in\nthe Koin?").font(.largeTitle).bold()
                .multilineTextAlignment(.leading)
                .padding(.top, 65)
                .padding(.bottom, 35)

            VStack(alignment: .leading, spacing: 26, content: {
                PointView(symbol: "dollarsign.circle", title: "Transactions", subTitle: "Keep track of your earnings and expenses.")
                PointView(symbol: "chart.pie.fill", title: "Visual Charts", subTitle: "View your transactions using eye-catching graphic representations.")
                PointView(symbol: "text.magnifyingglass", title: "Advance Filters", subTitle: "Find the expenses you want by advance search and filtering.")
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            Spacer(minLength: 10)
            Button(action: {
                isFirstTime = false
            }, label: {
                Text("Continue")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.vertical, 14)
                    .frame(maxWidth: .infinity)
                    .background(appTint.gradient, in: .rect(cornerRadius: 14))
                    .contentShape(.rect)
            })
        }
        .padding(22)
    }

    @ViewBuilder func PointView(symbol: String, title: String, subTitle: String) -> some View {
        HStack (spacing: 20) {
            Image(systemName: symbol)
                .font(.largeTitle)
                .foregroundStyle(appTint.gradient)
                .frame(width: 46)
            VStack(alignment: .leading, spacing: 6, content: {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(subTitle)
                    .foregroundStyle(.secondary)
            })
        }
    }
}

#Preview {
    IntroScreen()
}
