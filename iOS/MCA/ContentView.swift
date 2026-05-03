import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            PassportListView()
                .tabItem {
                    Label("Passports", systemImage: "list.bullet.rectangle")
                }
            PathwaySearchView()
                .tabItem {
                    Label("Search", systemImage: "arrow.triangle.branch")
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
