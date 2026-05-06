<?php include 'header.php'; ?>

<style>
.help-wrap { max-width: 860px; margin: 0 auto; padding: 30px 16px 60px; }
.help-wrap h1 { font-size: 26px; margin: 0 0 8px; }
.help-wrap .subtitle { color: #555; font-size: 15px; margin: 0 0 32px; }

.scenario {
    border: 1px solid #eee;
    border-radius: 8px;
    padding: 20px 22px;
    margin-bottom: 16px;
    background: #fff;
}
.scenario-header {
    display: flex;
    align-items: baseline;
    gap: 12px;
    margin-bottom: 8px;
}
.scenario-code {
    font-family: "Courier New", monospace;
    font-size: 11px;
    font-weight: 700;
    color: #fff;
    background: #404f7c;
    border-radius: 4px;
    padding: 2px 7px;
    white-space: nowrap;
}
.scenario-title {
    font-size: 15px;
    font-weight: 700;
    color: #222;
}
.scenario-intent {
    font-size: 13px;
    color: #555;
    margin: 0 0 10px;
    line-height: 1.55;
}
.scenario-row {
    display: flex;
    gap: 24px;
    font-size: 13px;
    color: #444;
    flex-wrap: wrap;
}
.scenario-field { min-width: 140px; }
.scenario-field strong { display: block; font-size: 11px; text-transform: uppercase;
    letter-spacing: 0.05em; color: #888; margin-bottom: 2px; }
.scenario-example {
    margin-top: 10px;
    background: #f5f6fa;
    border-radius: 6px;
    padding: 10px 14px;
    font-size: 13px;
    color: #444;
    line-height: 1.6;
}
.scenario-example strong { color: #404f7c; }

.help-section-title {
    font-family: "Montserrat", sans-serif;
    font-size: 12px;
    font-weight: 800;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: #404f7c;
    border-bottom: 2px solid #404f7c;
    padding-bottom: 5px;
    margin: 32px 0 16px;
    display: inline-block;
}

.note-box {
    background: #f0f4ff;
    border: 1px solid #d0d8f0;
    border-radius: 8px;
    padding: 14px 18px;
    font-size: 13px;
    color: #404f7c;
    margin-bottom: 24px;
    line-height: 1.6;
}
</style>

<div class="help-wrap">

    <div class="logo-container" style="margin-bottom: 20px;">
        <a href="index.php" style="display: inline-block;">
            <img src="./images/logo.png" class="logo-main" alt="MCA Logo" style="cursor: pointer;">
        </a>
    </div>

    <h1>Advanced Search — Help</h1>
    <p class="subtitle">MCA supports six pathway query scenarios using KEGG BRITE and KEGG flat-file annotations.</p>

    <div class="help-section-title">How Pathway Links Work</div>

    <p style="font-size:13px;color:#444;line-height:1.7;margin:0 0 16px;">
        MCA passports are annotated with three types of KEGG IDs — each of which creates a different kind of pathway link.
        Understanding these links helps interpret search results correctly, since they differ in specificity and clinical relevance.
    </p>

    <!-- Via Disease -->
    <div class="scenario" style="border-color:#f9a8d4;">
        <div class="scenario-header">
            <span class="scenario-code" style="background:#9d174d;">Via Disease</span>
            <span class="scenario-title">KEGG Disease ID → Pathway</span>
        </div>
        <p class="scenario-intent">
            Clinical associations in MCA are annotated with <strong>KEGG Disease IDs (H numbers)</strong> where applicable.
            Each disease entry in the KEGG flat file carries a <code>PATHWAY</code> field listing the molecular pathways
            implicated in that disease (e.g., <em>Clostridioides difficile infection</em> → <code>hsa05111</code>
            Biofilm formation). Additionally, KEGG BRITE (br08402) organises diseases into broader network pathway
            categories (nt-pathways such as <code>nt06160 Hepatitis C</code>).
        </p>
        <p class="scenario-intent" style="margin-bottom:0;">
            <strong>Specificity: high.</strong> This link is curated — the disease ID was deliberately assigned to a
            clinical association by the MCA curation pipeline, and the disease-to-pathway annotation is maintained
            by KEGG. A taxon appearing "via disease" in a pathway result has a direct, evidence-graded clinical
            association that implicates that pathway.
        </p>
    </div>

    <!-- Via Compound -->
    <div class="scenario" style="border-color:#6ee7b7;">
        <div class="scenario-header">
            <span class="scenario-code" style="background:#065f46;">Via Compound</span>
            <span class="scenario-title">KEGG Compound ID → Pathway</span>
        </div>
        <p class="scenario-intent">
            Metabolites in MCA passports are annotated with <strong>KEGG Compound IDs (C numbers)</strong>.
            Each compound entry in the KEGG flat file lists the metabolic pathways it participates in
            (e.g., butyrate <code>C00246</code> → <em>Butanoate metabolism</em>, <em>Microbial metabolism in diverse environments</em>).
            A taxon appears "via compound" in a pathway result when one of its metabolites biochemically participates in that pathway.
        </p>
        <p class="scenario-intent" style="margin-bottom:0;">
            <strong>Specificity: moderate to low.</strong> Many metabolites — particularly short-chain fatty acids,
            bile acids, and cofactors — participate in a large number of pathways. A taxon producing acetate or pyruvate
            will appear under Glycolysis, TCA cycle, Butanoate metabolism, and others simultaneously, even if the
            clinical relevance to a specific pathway is incidental. Interpret compound-based links as biochemical
            participation, not as disease-pathway causal evidence. Use the compound name shown in the chip to
            judge whether the connection is meaningful for your context.
        </p>
    </div>

    <!-- Via Drug Target -->
    <div class="scenario" style="border-color:#fdba74;">
        <div class="scenario-header">
            <span class="scenario-code" style="background:#9a3412;">Drug Target Class</span>
            <span class="scenario-title">KEGG Drug ID → Target Class</span>
        </div>
        <p class="scenario-intent">
            Bloom triggers in MCA passports are annotated with <strong>KEGG Drug IDs (D numbers)</strong> where a
            specific drug is named (e.g., vancomycin → <code>D08679</code>). KEGG Drug entries do not carry a
            <code>PATHWAY</code> field. Instead, KEGG BRITE (br08310) classifies drugs by their molecular
            <strong>target class</strong> — the receptor family, enzyme class, or transporter family the drug acts on
            (e.g., <em>G Protein-coupled receptors › Beta-adrenergic</em>).
        </p>
        <p class="scenario-intent" style="margin-bottom:0;">
            <strong>Note:</strong> Drug target classes are not KEGG pathway map IDs and do not appear in pathway search
            results. They are shown separately on the taxon panel (By Taxon mode) as a mechanistic annotation of
            which drug families can trigger blooms in that taxon. A taxon's presence under a drug target class
            means a drug in that class is a documented bloom trigger — not that the taxon is directly involved in
            the target pathway.
        </p>
    </div>

    <div class="help-section-title">Query Scenarios</div>

    <!-- Q1 -->
    <div class="scenario">
        <div class="scenario-header">
            <span class="scenario-code">Q1</span>
            <span class="scenario-title">Taxon → Pathways</span>
        </div>
        <p class="scenario-intent">Given a taxon, retrieve all KEGG pathways it is linked to — via its clinical association disease IDs, bloom trigger drug target classes, and metabolite compound IDs.</p>
        <div class="scenario-row">
            <div class="scenario-field"><strong>Input</strong>Taxon name or passport ID</div>
            <div class="scenario-field"><strong>Output</strong>Pathways grouped by source (via disease / via compound / via drug target)</div>
            <div class="scenario-field"><strong>Mode</strong>Search by Taxon</div>
        </div>
        <div class="scenario-example">
            <strong>Example:</strong> Searching <em>Clostridioides difficile</em> returns pathways such as
            <em>Pathways in cancer</em> (via disease H00048) and <em>Butanoate metabolism</em> (via compound C00246).
        </div>
    </div>

    <!-- Q2 -->
    <div class="scenario">
        <div class="scenario-header">
            <span class="scenario-code">Q2</span>
            <span class="scenario-title">Taxon + Pathway → Filtered Associations</span>
        </div>
        <p class="scenario-intent">For a given taxon and pathway combination, show only the clinical associations that are linked to that pathway — useful for narrowing a passport to a specific biological context.</p>
        <div class="scenario-row">
            <div class="scenario-field"><strong>Input</strong>Taxon name + pathway selection</div>
            <div class="scenario-field"><strong>Output</strong>Filtered list of clinical associations connected to that pathway</div>
            <div class="scenario-field"><strong>Mode</strong>Search by Taxon → click a pathway</div>
        </div>
        <div class="scenario-example">
            <strong>Example:</strong> <em>Clostridioides difficile</em> × <em>Infectious disease</em> pathway filters to associations whose KEGG Disease IDs fall within that pathway.
        </div>
    </div>

    <!-- Q3 -->
    <div class="scenario">
        <div class="scenario-header">
            <span class="scenario-code">Q3</span>
            <span class="scenario-title">Pathway → Taxa</span>
        </div>
        <p class="scenario-intent">The primary search direction: given a KEGG pathway, retrieve all MCA taxa linked to it, and see which KEGG IDs (diseases, compounds) create the connection.</p>
        <div class="scenario-row">
            <div class="scenario-field"><strong>Input</strong>Pathway name or ID (hsa#####, map#####, nt######)</div>
            <div class="scenario-field"><strong>Output</strong>Matching passports with the connecting KEGG IDs</div>
            <div class="scenario-field"><strong>Mode</strong>Search by Pathway</div>
        </div>
        <div class="scenario-example">
            <strong>Example:</strong> Searching <em>Epithelial cell signaling in Helicobacter pylori infection</em> (hsa05120)
            returns taxa whose clinical associations carry disease IDs in that pathway.
        </div>
    </div>

    <!-- Q4 -->
    <div class="scenario">
        <div class="scenario-header">
            <span class="scenario-code">Q4</span>
            <span class="scenario-title">Disease → Passports + Pathways</span>
        </div>
        <p class="scenario-intent">Given a disease condition (by name or KEGG Disease ID), find which MCA taxa are associated with it and which KEGG pathways that disease annotates.</p>
        <div class="scenario-row">
            <div class="scenario-field"><strong>Input</strong>Disease name or H number</div>
            <div class="scenario-field"><strong>Output</strong>Linked taxa + KEGG pathways for that disease</div>
            <div class="scenario-field"><strong>Mode</strong>Search by Disease</div>
        </div>
        <div class="scenario-example">
            <strong>Example:</strong> Searching <em>Clostridioides difficile infection</em> (H00272) returns associated taxa
            and links to the <em>Infectious diseases: Bacterial</em> pathway category.
        </div>
    </div>

    <!-- Q5 -->
    <div class="scenario">
        <div class="scenario-header">
            <span class="scenario-code">Q5</span>
            <span class="scenario-title">Browse Pathways by Taxon Count</span>
        </div>
        <p class="scenario-intent">A browseable index of all KEGG pathways that have at least one linked MCA taxon, sorted by the number of taxa linked to each pathway. Useful for identifying which biological processes are most represented in MCA.</p>
        <div class="scenario-row">
            <div class="scenario-field"><strong>Input</strong>None (browse mode)</div>
            <div class="scenario-field"><strong>Output</strong>Pathway list with taxon counts, grouped by KEGG category</div>
            <div class="scenario-field"><strong>Mode</strong>Browse Pathways tab</div>
        </div>
        <div class="scenario-example">
            <strong>Example:</strong> The <em>Infectious diseases: Bacterial</em> category appears at the top because
            the most MCA taxa have disease associations in that KEGG pathway group.
        </div>
    </div>

    <!-- Q6 -->
    <div class="scenario">
        <div class="scenario-header">
            <span class="scenario-code">Q6</span>
            <span class="scenario-title">Co-occurring Taxa via Shared Pathways</span>
        </div>
        <p class="scenario-intent">Given a taxon, find other MCA taxa that share at least one KEGG pathway — surfacing functional or disease-context overlap between taxa that may not be taxonomically related.</p>
        <div class="scenario-row">
            <div class="scenario-field"><strong>Input</strong>Taxon name or passport ID</div>
            <div class="scenario-field"><strong>Output</strong>Other taxa ranked by number of shared pathways</div>
            <div class="scenario-field"><strong>Mode</strong>Search by Taxon → Co-occurring Taxa panel</div>
        </div>
        <div class="scenario-example">
            <strong>Example:</strong> <em>Clostridioides difficile</em> and <em>Helicobacter pylori</em> may share
            pathways via overlapping gut infection disease annotations, even though they are phylogenetically distant.
        </div>
    </div>

    <div class="help-section-title">Data Sources</div>

    <table style="width:100%; border-collapse:collapse; font-size:13px;">
        <thead>
            <tr style="background:#f5f6fa;">
                <th style="text-align:left; padding:8px 10px; border-bottom:2px solid #eee;">KEGG source</th>
                <th style="text-align:left; padding:8px 10px; border-bottom:2px solid #eee;">ID type</th>
                <th style="text-align:left; padding:8px 10px; border-bottom:2px solid #eee;">Used on</th>
                <th style="text-align:left; padding:8px 10px; border-bottom:2px solid #eee;">Pathway link mechanism</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;">Disease flat file</td>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;"><code>H#####</code></td>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;">Clinical associations</td>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;"><code>PATHWAY hsa#####</code> field in each disease entry</td>
            </tr>
            <tr>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;">BRITE br08402</td>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;"><code>H#####</code></td>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;">Clinical associations</td>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;">Pathway-based disease classification; maps diseases to <code>nt######</code> network pathways</td>
            </tr>
            <tr>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;">Compound flat file</td>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;"><code>C#####</code></td>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;">Metabolites</td>
                <td style="padding:8px 10px; border-bottom:1px solid #f0f0f0;"><code>PATHWAY map#####</code> field in each compound entry</td>
            </tr>
            <tr>
                <td style="padding:8px 10px;">BRITE br08310</td>
                <td style="padding:8px 10px;"><code>D#####</code></td>
                <td style="padding:8px 10px;">Bloom triggers</td>
                <td style="padding:8px 10px;">Target-based drug classification; maps drugs to molecular target class — not a pathway map ID</td>
            </tr>
        </tbody>
    </table>

    <p style="margin-top: 20px; font-size: 13px; color: #888;">
        <a href="advanced_search.php" style="color: #007bff;">← Back to Advanced Search</a>
    </p>

</div>

<?php include 'footer.php'; ?>
