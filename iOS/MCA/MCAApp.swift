//
//  MCAApp.swift
//  MCA
//
//  Created by Heewon Seo on 2026-04-03.
//

import SwiftUI

@main
struct MCAApp: App {
    @State private var showLaunch = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                if showLaunch {
                    LaunchScreenView()
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
            .task {
                try? await Task.sleep(for: .seconds(1.5))
                withAnimation(.easeOut(duration: 0.4)) {
                    showLaunch = false
                }
            }
        }
    }
}

struct LaunchScreenView: View {
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            VStack(spacing: 16) {
                Image("MCALogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 240, height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 40))
                Text("Microbiome Knowledge Base")
                    .font(.title3.bold())
                    .foregroundColor(Color(hex: "#404f7c"))
            }
        }
    }
}
