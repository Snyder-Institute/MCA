import Foundation
import SQLite3

final class DatabaseManager {
    static let shared = DatabaseManager()
    private var db: OpaquePointer?

    private init() {
        guard let bundlePath = Bundle.main.path(forResource: "MCA", ofType: "sqlite") else {
            print("DatabaseManager: MCA.sqlite not found in bundle")
            return
        }
        // Copy to Caches so SQLite has a stable file descriptor that survives app reinstalls
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let destURL = caches.appendingPathComponent("MCA.sqlite")
        let fm = FileManager.default
        if fm.fileExists(atPath: destURL.path) {
            try? fm.removeItem(at: destURL)
        }
        do {
            try fm.copyItem(atPath: bundlePath, toPath: destURL.path)
        } catch {
            print("DatabaseManager: failed to copy database — \(error)")
            return
        }
        if sqlite3_open_v2(destURL.path, &db, SQLITE_OPEN_READONLY, nil) != SQLITE_OK {
            print("DatabaseManager: failed to open database")
            db = nil
        }
    }

    deinit { if db != nil { sqlite3_close(db) } }

    var isLoaded: Bool { db != nil }

    // MARK: - Stats

    struct Stats {
        let passports: Int
        let associations: Int
        let pmids: Int
        let refs: Int
    }

    func fetchStats() -> Stats {
        func count(_ sql: String) -> Int {
            query(sql) { stmt in Int(sqlite3_column_int64(stmt, 0)) }.first ?? 0
        }
        return Stats(
            passports:    count("SELECT COUNT(*) FROM passport"),
            associations: count("SELECT COUNT(*) FROM association"),
            pmids:        count("SELECT COUNT(DISTINCT pmid) FROM (SELECT pmid FROM passport_pmid UNION SELECT pmid FROM assoc_pmid)"),
            refs:         count("SELECT COUNT(*) FROM assoc_ref")
        )
    }

    func fetchDbVersion() -> String {
        query("SELECT key_value FROM meta WHERE key_name = 'db_version'") { stmt in
            string(stmt, 0)
        }.first ?? "unknown"
    }

    func fetchRoles(passportId: Int64) -> [String] {
        let sql = "SELECT value FROM taxon_tag WHERE passport_id = ? AND category = 'role' ORDER BY value"
        return query(sql, bindings: [.int(passportId)]) { stmt in string(stmt, 0) }
    }

    func fetchTopEvidence(passportId: Int64) -> String? {
        let sql = "SELECT evidence_level FROM association WHERE passport_id = ? ORDER BY evidence_level DESC LIMIT 1"
        return query(sql, bindings: [.int(passportId)]) { stmt in string(stmt, 0) }.first
    }

    /// Look up a passport by taxon name (case-insensitive). Checks preferred_name and synonyms.
    func findPassport(byName name: String) -> Passport? {
        let lower = name.lowercased()
        // Check preferred_name first
        let sql1 = """
            SELECT id, passport_id, preferred_name, taxon_rank, domain,
                   COALESCE(lineage,''), ncbi_taxid, COALESCE(is_pathobiont,'unknown'),
                   last_reviewed
            FROM passport WHERE LOWER(preferred_name) = ?
            """
        if let found = query(sql1, bindings: [.text(lower)], map: mapPassport).first {
            return found
        }
        // Check synonyms
        let sql2 = """
            SELECT p.id, p.passport_id, p.preferred_name, p.taxon_rank, p.domain,
                   COALESCE(p.lineage,''), p.ncbi_taxid, COALESCE(p.is_pathobiont,'unknown'),
                   p.last_reviewed
            FROM passport p
            INNER JOIN taxon_tag t ON t.passport_id = p.id
            WHERE t.category = 'synonym' AND LOWER(t.value) = ?
            """
        return query(sql2, bindings: [.text(lower)], map: mapPassport).first
    }

    // MARK: - Public API

    func fetchAllPassports() -> [Passport] {
        let sql = """
            SELECT id, passport_id, preferred_name, taxon_rank, domain,
                   COALESCE(lineage,''), ncbi_taxid, COALESCE(is_pathobiont,'unknown'),
                   last_reviewed
            FROM passport ORDER BY preferred_name
            """
        return query(sql, map: mapPassport)
    }

    func searchPassports(_ query: String) -> [Passport] {
        let q = query.lowercased()
        return fetchAllPassports().filter {
            $0.preferredName.lowercased().contains(q) ||
            $0.passportId.lowercased().contains(q) ||
            $0.lineage.lowercased().contains(q) ||
            $0.domain.lowercased().contains(q)
        }
    }

    func fetchPassportDetail(id: Int64) -> PassportDetail? {
        guard let passport = fetchPassport(id: id) else { return nil }
        let biology      = fetchBiology(passportId: id)
        let tags         = fetchTags(passportId: id)
        let metabolites  = fetchMetabolites(passportId: id)
        let associations = fetchAssociations(passportId: id)
        let pmids        = fetchPassportPmids(passportId: id)
        let papers       = fetchPapers(passportId: id)
        let relatedTaxa  = fetchRelatedTaxa(passportId: id)
        return PassportDetail(passport: passport, biology: biology,
                              tags: tags, metabolites: metabolites,
                              associations: associations, evidencePmids: pmids,
                              papers: papers, relatedTaxa: relatedTaxa)
    }

    // MARK: - Private helpers

    private func mapPassport(_ stmt: OpaquePointer) -> Passport {
        Passport(
            id:            sqlite3_column_int64(stmt, 0),
            passportId:    string(stmt, 1),
            preferredName: string(stmt, 2),
            taxonRank:     string(stmt, 3),
            domain:        string(stmt, 4),
            lineage:       string(stmt, 5),
            ncbiTaxid:     int(stmt, 6),
            isPathobiont:  string(stmt, 7),
            lastReviewed:  optString(stmt, 8)
        )
    }

    private func fetchPassport(id: Int64) -> Passport? {
        let sql = """
            SELECT id, passport_id, preferred_name, taxon_rank, domain,
                   COALESCE(lineage,''), ncbi_taxid, COALESCE(is_pathobiont,'unknown'),
                   last_reviewed
            FROM passport WHERE id = ?
            """
        return query(sql, bindings: [.int(id)], map: mapPassport).first
    }

    private func fetchBiology(passportId: Int64) -> Biology? {
        let sql = "SELECT gram_status, oxygen_tolerance, morphology, bacdive_url FROM biology WHERE passport_id = ?"
        return query(sql, bindings: [.int(passportId)]) { stmt in
            Biology(gramStatus:       optString(stmt, 0),
                    oxygenTolerance:  optString(stmt, 1),
                    morphology:       optString(stmt, 2),
                    bacdiveUrl:       optString(stmt, 3))
        }.first
    }

    private func fetchTags(passportId: Int64) -> [TaxonTag] {
        let sql = "SELECT id, category, value, ext_id FROM taxon_tag WHERE passport_id = ? ORDER BY category, value"
        return query(sql, bindings: [.int(passportId)]) { stmt in
            TaxonTag(id:       sqlite3_column_int64(stmt, 0),
                     category: string(stmt, 1),
                     value:    string(stmt, 2),
                     extId:    optString(stmt, 3))
        }
    }

    private func fetchMetabolites(passportId: Int64) -> [Metabolite] {
        let sql = "SELECT id, metabolite_name, relationship, kegg_compound_id, chebi_id FROM metabolite WHERE passport_id = ?"
        return query(sql, bindings: [.int(passportId)]) { stmt in
            Metabolite(id:             sqlite3_column_int64(stmt, 0),
                       name:           string(stmt, 1),
                       relationship:   string(stmt, 2),
                       keggCompoundId: optString(stmt, 3),
                       chebiId:        optString(stmt, 4))
        }
    }

    private func fetchAssociations(passportId: Int64) -> [Association] {
        // 1. Fetch all associations
        let sql = """
            SELECT id, association_text, evidence_level FROM association
            WHERE passport_id = ? ORDER BY evidence_level DESC, id
            """
        let assocs: [(Int64, String, String)] = query(sql, bindings: [.int(passportId)]) { stmt in
            (sqlite3_column_int64(stmt, 0), string(stmt, 1), string(stmt, 2))
        }
        guard !assocs.isEmpty else { return [] }

        // 2. Batch-load all PMIDs for this passport's associations
        let assocIds = assocs.map(\.0)
        let ph = assocIds.map { _ in "?" }.joined(separator: ",")
        let binds = assocIds.map { BindValue.int($0) }

        let pmidSql = "SELECT association_id, pmid FROM assoc_pmid WHERE association_id IN (\(ph))"
        var pmidMap: [Int64: [String]] = [:]
        for row in query(pmidSql, bindings: binds, map: { stmt in
            (sqlite3_column_int64(stmt, 0), string(stmt, 1))
        }) {
            pmidMap[row.0, default: []].append(row.1)
        }

        // 3. Batch-load all refs for this passport's associations
        let refSql = "SELECT association_id, id, ref_type, ref_id, ref_label FROM assoc_ref WHERE association_id IN (\(ph))"
        var refMap: [Int64: [AssocRef]] = [:]
        for row in query(refSql, bindings: binds, map: { stmt in
            (sqlite3_column_int64(stmt, 0),
             AssocRef(id:       sqlite3_column_int64(stmt, 1),
                      refType:  string(stmt, 2),
                      refId:    string(stmt, 3),
                      refLabel: string(stmt, 4)))
        }) {
            refMap[row.0, default: []].append(row.1)
        }

        // 4. Assemble
        return assocs.map { (aid, text, grade) in
            Association(id:            aid,
                        text:          text,
                        evidenceGrade: grade,
                        pmids:         pmidMap[aid] ?? [],
                        refs:          refMap[aid] ?? [])
        }
    }

    private func fetchPassportPmids(passportId: Int64) -> [String] {
        let sql = "SELECT pmid FROM passport_pmid WHERE passport_id = ?"
        return query(sql, bindings: [.int(passportId)]) { stmt in string(stmt, 0) }
    }

    func fetchPapers(passportId: Int64) -> [Paper] {
        let sql = """
            SELECT DISTINCT pa.pmid, pa.title, pa.year, pa.study_design
            FROM paper pa
            WHERE pa.pmid IN (
                SELECT ap.pmid FROM assoc_pmid ap
                INNER JOIN association a ON a.id = ap.association_id
                WHERE a.passport_id = ?
                UNION
                SELECT pp.pmid FROM passport_pmid pp WHERE pp.passport_id = ?
            )
            ORDER BY pa.year ASC, pa.pmid ASC
            """
        return query(sql, bindings: [.int(passportId), .int(passportId)]) { stmt in
            Paper(pmid: string(stmt, 0),
                  title: string(stmt, 1),
                  year: int(stmt, 2),
                  studyDesign: optString(stmt, 3))
        }
    }

    func fetchRelatedTaxa(passportId: Int64) -> [RelatedTaxon] {
        let niches: [String] = query(
            "SELECT DISTINCT value FROM taxon_tag WHERE passport_id = ? AND category = 'primary_niche'",
            bindings: [.int(passportId)]
        ) { stmt in string(stmt, 0) }

        let risks: [String] = query(
            "SELECT DISTINCT value FROM taxon_tag WHERE passport_id = ? AND category = 'risk_context'",
            bindings: [.int(passportId)]
        ) { stmt in string(stmt, 0) }

        if niches.isEmpty && risks.isEmpty { return [] }

        var conditions: [String] = []
        var binds: [BindValue] = []

        if !niches.isEmpty {
            let ph = niches.map { _ in "?" }.joined(separator: ",")
            conditions.append("(t.category = 'primary_niche' AND t.value IN (\(ph)))")
            for n in niches { binds.append(.text(n)) }
        }
        if !risks.isEmpty {
            let ph = risks.map { _ in "?" }.joined(separator: ",")
            conditions.append("(t.category = 'risk_context' AND t.value IN (\(ph)))")
            for r in risks { binds.append(.text(r)) }
        }

        binds.append(.int(passportId))

        let sql = """
            SELECT p2.id, p2.passport_id, p2.preferred_name, COALESCE(p2.is_pathobiont,'unknown'),
                   GROUP_CONCAT(DISTINCT t.category) as match_cats
            FROM taxon_tag t
            INNER JOIN passport p2 ON p2.id = t.passport_id
            WHERE (\(conditions.joined(separator: " OR ")))
              AND p2.id != ?
            GROUP BY p2.id, p2.passport_id, p2.preferred_name, p2.is_pathobiont
            ORDER BY p2.passport_id ASC
            LIMIT 6
            """

        return query(sql, bindings: binds) { stmt in
            let cats = string(stmt, 4).components(separatedBy: ",")
            return RelatedTaxon(
                dbId: sqlite3_column_int64(stmt, 0),
                passportId: string(stmt, 1),
                preferredName: string(stmt, 2),
                isPathobiont: string(stmt, 3),
                matchCategories: Set(cats)
            )
        }
    }

    // MARK: - Generic query runner

    private enum BindValue { case int(Int64); case text(String) }

    private func query<T>(_ sql: String, bindings: [BindValue] = [], map: (OpaquePointer) -> T) -> [T] {
        guard let db else { return [] }
        var stmt: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &stmt, nil) == SQLITE_OK else {
            print("DatabaseManager prepare error: \(String(cString: sqlite3_errmsg(db)))")
            return []
        }
        defer { sqlite3_finalize(stmt) }
        for (i, b) in bindings.enumerated() {
            let col = Int32(i + 1)
            switch b {
            case .int(let v):  sqlite3_bind_int64(stmt, col, v)
            case .text(let v): sqlite3_bind_text(stmt, col, (v as NSString).utf8String, -1, nil)
            }
        }
        var results: [T] = []
        while sqlite3_step(stmt) == SQLITE_ROW { results.append(map(stmt!)) }
        return results
    }

    private func string(_ stmt: OpaquePointer?, _ col: Int32) -> String {
        guard let s = sqlite3_column_text(stmt, col) else { return "" }
        return String(cString: s)
    }
    private func optString(_ stmt: OpaquePointer?, _ col: Int32) -> String? {
        guard sqlite3_column_type(stmt, col) != SQLITE_NULL,
              let s = sqlite3_column_text(stmt, col) else { return nil }
        return String(cString: s)
    }
    private func int(_ stmt: OpaquePointer?, _ col: Int32) -> Int? {
        guard sqlite3_column_type(stmt, col) != SQLITE_NULL else { return nil }
        return Int(sqlite3_column_int64(stmt, col))
    }
}
