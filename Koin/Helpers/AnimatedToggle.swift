//  AnimatedToggle.swift
//  Koin
//
//  Created by Aleksej Shapran on 12.05.24

import Foundation
import SwiftUI

struct AnimatedToggle: View {
    
    @Binding var isOn: Bool
    private var circleOffset: CGFloat { isOn ? 10 : -10 }
    let text: LocalizedStringKey
    
    var body: some View {
        HStack {
            Text(text)
            Spacer()
            RoundedRectangle(cornerRadius: 48)
                .foregroundColor(isOn ? Color.accentColor : .gray.opacity(0.4))
                .frame(width: 51, height: 31)
                .overlay(
                    Circle()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                        .padding(3)
                        .overlay(
                            Image(systemName: isOn ? "checkmark" : "xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(.title.weight(.bold))
                                .frame(width: 10, height: 10)
                                .foregroundColor(isOn ? Color.accentColor : .gray.opacity(0.4))
                        )
                        .offset(x: circleOffset)
                )
                .animation(.bouncy(duration: 0.2, extraBounce: 0.4), value: isOn)
                .onTapGesture {
                    hapticMedium()
                    isOn.toggle()
                }
        }
    }
}
