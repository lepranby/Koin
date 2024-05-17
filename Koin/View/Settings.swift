//  Settings.swift
//  Koin
//
//  Created by Aleksej Shapran on 11.05.24

import SwiftUI

struct Settings: View {
    /// User Properties
    @AppStorage("userName") private var userName: String = ""
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    /// App Lock properties
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("lockWhenAppGoesToBackground") private var lockWhenAppGoesToBackground: Bool = false
    /// Appearance properties
    @AppStorage("isDarkModeOn") private var isDarkModeOn: Bool = false

    var body: some View {
        GeometryReader {
            let size = $0.size
            NavigationStack {
                ScrollView(.vertical) {
                    LazyVStack(spacing: 26, pinnedViews: [.sectionHeaders]) {
                        Section {
                            VStack (alignment: .leading) {
                                Text("Your Name").font(.callout).foregroundStyle(Color.primary.secondary).padding(.leading, 16)
                                RoundedRectangle(cornerRadius: 14).fill(.background).frame(height: 48)
                                    .overlay {
                                        HStack(spacing: 4) {
                                            Image(systemName: "person")
                                            TextField("What is your name?", text: $userName)
                                        }
                                        .padding()
                                    }
                            }
                            VStack (alignment: .leading) {
                                Text("Appearance").font(.callout).foregroundStyle(Color.primary.secondary).padding(.leading, 16)
                                RoundedRectangle(cornerRadius: 14).fill(.background).frame(height: 48)
                                    .overlay {
                                        VStack(spacing: 4) {
                                            AnimatedToggle(isOn: $isDarkModeOn, text: "Dark mode")
                                        }
                                        .padding()
                                    }
                            }
                            VStack (alignment: .leading) {
                                Text("Security").font(.callout).foregroundStyle(Color.primary.secondary).padding(.leading, 16)
                                RoundedRectangle(cornerRadius: 14).fill(.background).frame(height: 48)
                                    .overlay {
                                        VStack(spacing: 4) {
                                            AnimatedToggle(isOn: $isAppLockEnabled, text: "Lock by biometric")
                                        }
                                        .padding()
                                    }
                            }
                            VStack (alignment: .leading) {
                                Text("App & Credits").font(.callout).foregroundStyle(Color.primary.secondary).padding(.leading, 16)
                                RoundedRectangle(cornerRadius: 14).fill(.background).frame(height: 48)
                                    .overlay {
                                        VStack(spacing: 14) {
                                            HStack {
                                                Text("Version : Build")
                                                Spacer(minLength: 0)
                                                Text("\(version!) : \(build!)")
                                            }
                                        }
                                        .padding()
                                    }
                            }
                        } header: {
                            HeaderView(size)
                        }
                    }
                    .padding(14)
                    .scrollIndicators(.hidden)

                }
                .background(.gray.opacity(0.16))
                .scrollIndicators(.hidden)
                .preferredColorScheme(isDarkModeOn ? .dark : .light)
            }
        }
    }

    /// Header view
    @ViewBuilder func HeaderView(_ size: CGSize) -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Settings").font(.title).bold()
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


}

#Preview {
    Settings()
}
