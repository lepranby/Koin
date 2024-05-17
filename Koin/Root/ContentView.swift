//  ContentView.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24

import SwiftUI

struct ContentView: View {
    /// Visibility status:
    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    /// App Lock properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesToBackground") private var lockWhenAppGoesToBackground: Bool = false
    ///Active Tab:
    @State private var activeTab: Tab = .wallet
    /// Appearance properties
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false
    @AppStorage("title") private var isTitleBig: Bool = false

    var body: some View {
        LockView(lockType: .both, lockPin: "1010", isEnabled: isAppLockEnabled, lockWhenAppGoesToBackground: lockWhenAppGoesToBackground) {
            TabView(selection: $activeTab)  {
                Recents()
                    .tag(Tab.wallet)
                    .tabItem { Tab.wallet.tabContent }
                Graphs()
                    .tag(Tab.graphs)
                    .tabItem { Tab.graphs.tabContent }
                Search()
                    .tag(Tab.search)
                    .tabItem { Tab.search.tabContent }
                Settings()
                    .tag(Tab.settings)
                    .tabItem { Tab.settings.tabContent }
            }
            .tint(appTint)
            .sheet(isPresented: $isFirstTime, content: {
                IntroScreen()
                    .interactiveDismissDisabled()
            })
        }
        .preferredColorScheme(isDarkModeOn ? .dark : .light)
        .navigationBarTitleDisplayMode(isTitleBig ? .inline : .automatic)
    }
}

#Preview {
    ContentView()
}
