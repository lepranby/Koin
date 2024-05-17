//  Haptic.swift
//  Koin
//
//  Created by Aleksej Shapran on 12.05.24

import Foundation
import SwiftUI

func hapticSoft () {
    let hapticAction = UIImpactFeedbackGenerator(style: .soft)
        hapticAction.impactOccurred()
}

func hapticMedium () {
    let hapticAction = UIImpactFeedbackGenerator(style: .medium)
        hapticAction.impactOccurred()
}
