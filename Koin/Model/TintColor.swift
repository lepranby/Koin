//  TintColor.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24

import Foundation
import SwiftUI

struct TintColor: Identifiable {
    let id: UUID = .init()
    var color: String
    var value: Color
}

var tints: [TintColor] = [
    .init(color: "Red", value: .red),
    .init(color: "Teal", value: .teal),
    .init(color: "Green", value: .green),
    .init(color: "Orange", value: .orange)
]
