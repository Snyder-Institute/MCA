import SwiftUI

struct PassportListView: View {
    @State private var allPassports: [Passport] = []
    @State private var searchText = ""
    @State private var bookmarks: Set<Int64> = BookmarkStore.load()
    @State private var roles: [Int64: [String]] = [:]
    @State private var topEvidence: [Int64: String] = [:]

    private var filtered: [Passport] {
        let base = searchText.isEmpty ? allPassports : DatabaseManager.shared.searchPassports(searchText)
        return base.sorted { a, b in
            let aBookmarked = bookmarks.contains(a.id)
            let bBookmarked = bookmarks.contains(b.id)
            if aBookmarked != bBookmarked { return aBookmarked }
            return a.preferredName < b.preferredName
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if allPassports.isEmpty && !DatabaseManager.shared.isLoaded {
                    ContentUnavailableView(
                        "Database not found",
                        systemImage: "externaldrive.badge.exclamationmark",
                        description: Text("MCA.sqlite is not included in the app bundle.")
                    )
                } else if filtered.isEmpty && !searchText.isEmpty {
                    ContentUnavailableView.search(text: searchText)
                } else {
                    List(filtered) { passport in
                        NavigationLink(destination: PassportDetailView(passportId: passport.id)) {
                            PassportCardRow(
                                passport: passport,
                                isBookmarked: bookmarks.contains(passport.id),
                                roles: roles[passport.id] ?? [],
                                topEvidence: topEvidence[passport.id],
                                onToggleBookmark: { toggleBookmark(passport.id) }
                            )
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Microbial Clinical Atlas")
            .searchable(text: $searchText, prompt: "Search taxon or MCA ID")
            .task {
                allPassports = DatabaseManager.shared.fetchAllPassports()
                for p in allPassports {
                    roles[p.id] = DatabaseManager.shared.fetchRoles(passportId: p.id)
                    if let ev = DatabaseManager.shared.fetchTopEvidence(passportId: p.id) {
                        topEvidence[p.id] = ev
                    }
                }
            }
        }
    }

    private func toggleBookmark(_ id: Int64) {
        if bookmarks.contains(id) {
            bookmarks.remove(id)
        } else {
            bookmarks.insert(id)
        }
        BookmarkStore.save(bookmarks)
    }
}

// MARK: - Bookmark Persistence

private enum BookmarkStore {
    private static let key = "bookmarkedPassportIds"

    static func load() -> Set<Int64> {
        let array = UserDefaults.standard.array(forKey: key) as? [Int64] ?? []
        return Set(array)
    }

    static func save(_ ids: Set<Int64>) {
        UserDefaults.standard.set(Array(ids), forKey: key)
    }
}

// MARK: - Card Row

private struct PassportCardRow: View {
    let passport: Passport
    let isBookmarked: Bool
    let roles: [String]
    let topEvidence: String?
    let onToggleBookmark: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            // Bookmark star
            Button {
                onToggleBookmark()
            } label: {
                Image(systemName: isBookmarked ? "star.fill" : "star")
                    .foregroundColor(isBookmarked ? .yellow : Color(.tertiaryLabel))
                    .font(.callout)
            }
            .buttonStyle(.plain)
            .padding(.top, 2)

            // Card content
            VStack(alignment: .leading, spacing: 4) {
                // Row 1: Passport ID
                Text(passport.passportId)
                    .font(.caption2.monospaced())
                    .foregroundColor(Color(.tertiaryLabel))

                // Row 2: Name + Rank
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(passport.preferredName)
                        .font(.subheadline).bold().italic()
                    Text(passport.taxonRank)
                        .font(.caption2)
                        .padding(.horizontal, 6).padding(.vertical, 2)
                        .background(Color(hex: "#f0f0f0"))
                        .clipShape(RoundedRectangle(cornerRadius: 3))
                }
            }
        }
        .padding(.vertical, 6)
    }
}


