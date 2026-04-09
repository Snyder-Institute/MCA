import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PassportListView()
                .tabItem {
                    Label("Passports", systemImage: "list.bullet.rectangle")
                }
            AnalyzeView(onKeyCleared: {})
                .tabItem {
                    Label("Extractor", systemImage: "doc.text.magnifyingglass")
                }
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
    }
}
