//  Tab.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24

import Foundation
import SwiftUI

enum Tab: String {
    case wallet = "Wallet"
    case search = "Search"
    case graphs = "Graphs"
    case settings = "Settings"

    @ViewBuilder var tabContent: some View {
        switch self {
        case .wallet:
            Image(systemName: "calendar.badge.checkmark")
            Text(self.rawValue)
        case .search:
            Image(systemName: "magnifyingglass")
            Text(self.rawValue)
        case .graphs:
            Image(systemName: "chart.bar.xaxis")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gearshape")
            Text(self.rawValue)
        }
    }

}
