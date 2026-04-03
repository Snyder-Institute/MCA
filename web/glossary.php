<?php
$is_popup = isset($_GET['popup']) && $_GET['popup'] == '1';

if (!$is_popup) {
    include 'header.php';
} else {
    echo '<!DOCTYPE html><html><head><style>body { font-family: sans-serif; padding: 20px; }</style></head><body>';
}
?>

<style>
    .glossary-container { max-width: 900px; margin: 40px auto; padding: 0 20px; font-family: sans-serif; }
    .glossary-header { border-bottom: 2px solid #000; padding-bottom: 20px; margin-bottom: 40px; }
    .glossary-section { margin-bottom: 50px; }
    .glossary-section h2 { font-size: 20px; color: #000; border-bottom: 1px solid #eee; padding-bottom: 10px; margin-bottom: 20px; }

    .glossary-item { margin-bottom: 25px; padding-left: 15px; }
    .glossary-term { font-weight: 800; font-size: 15px; color: #000; margin-bottom: 5px; display: inline-block; background: #f9f9f9; padding: 5px 10px; border-radius: 3px; }
    .glossary-text { font-size: 14px; color: #333; line-height: 1.6; }
    .glossary-list { margin-top: 5px; padding-left: 20px; line-height: 1.6; font-size: 14px; color: #333; }
    .code-span { font-family: monospace; background: #eee; padding: 2px 4px; border-radius: 3px; font-weight: bold; }

    .nested-level { margin-top: 15px; padding-left: 20px; border-left: 3px solid #eee; }
</style>

<div class="glossary-container">
    <div class="glossary-header">
        <h1 style="margin: 0; font-size: 32px; font-weight: 900;">Understanding the Passport</h1><br />
        <p style="color: #666; margin-top: 10px;">This guide explains the data fields and nomenclature used within the <strong>Microbial Clinical Atlas (MCA)</strong> Taxon Passports.</p>
    </div>

    <div class="glossary-section">
        <h2>Identity</h2>
        <div class="glossary-item">
            <span class="glossary-term">Passport ID</span>
            <div class="glossary-text">
                A stable, unique identifier for each taxon entry following the format <span class="code-span">MCA-[DOMAIN]-[NNNNNN]</span>.
                <p><strong>[DOMAIN]</strong> prefixes indicate the organism type:</p>
                <ul class="glossary-list">
                    <li><span class="code-span">BAC</span>: Bacteria</li>
                    <li><span class="code-span">FUN</span>: Fungi</li>
                    <li><span class="code-span">VIR</span>: Viruses</li>
                    <li><span class="code-span">ARC</span>: Archaea</li>
                </ul>
                <p><strong>[NNNNNN]</strong> is a unique six-digit numeric identifier that ensures permanent reference regardless of taxonomic updates.</p>
            </div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">TaxID</span>
            <div class="glossary-text">The official NCBI Taxonomy database identifier, linking each entry to a globally recognised taxonomic record. Clicking the TaxID opens the corresponding NCBI Taxonomy page.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">BacDive ID</span>
            <div class="glossary-text">Identifier linking to the BacDive entry for this taxon's type strain. BacDive is a standardised microbiological culture collection database maintained by DSMZ, providing curated microbiological metadata including culture conditions, physiology, and isolation sources. Available at species level and below.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Rank</span>
            <div class="glossary-text">The taxonomic level of the entry, such as family, genus, species, or strain.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Lineage</span>
            <div class="glossary-text">The full taxonomic hierarchy from domain down to the specific rank of the entry.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Synonyms</span>
            <div class="glossary-text">Alternative scientific names and historical nomenclature sourced from NCBI Taxonomy.</div>
        </div>
    </div>

    <div class="glossary-section">
        <h2>Biology</h2>
        <div class="glossary-item">
            <span class="glossary-term">Gram Status</span>
            <div class="glossary-text">Gram stain classification (positive, negative, or variable) for bacterial taxa. Sourced from BacDive.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Oxygen Tolerance</span>
            <div class="glossary-text">Classification of metabolic oxygen requirements (e.g., aerobe, obligate anaerobe, facultative anaerobe). Sourced from BacDive.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Morphology</span>
            <div class="glossary-text">Typical physical cell structure and shape (e.g., rod, coccus, spiral). Sourced from BacDive.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Key Traits</span>
            <div class="glossary-text">Biologically relevant features such as spore formation, biofilm production, or toxin production. Sourced from BacDive.</div>
        </div>
    </div>

    <div class="glossary-section">
        <h2>Ecology</h2>
        <div class="glossary-item">
            <span class="glossary-term">Primary Niches</span>
            <div class="glossary-text">The specific body sites or environments where the organism is most commonly found (e.g., gut, oral cavity, skin). Sourced from BacDive.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Reservoir</span>
            <div class="glossary-text">The natural hosts or environments where the taxon persists: <em>human</em>, <em>animal</em>, or <em>environment</em>. Sourced from BacDive.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Transmission</span>
            <div class="glossary-text">The routes through which the organism is typically acquired (e.g., contact, foodborne, waterborne). Sourced from the curated literature.</div>
        </div>
    </div>

    <div class="glossary-section">
        <h2>Clinical Profile</h2>
        <div class="glossary-item">
            <span class="glossary-term">Pathobiont</span>
            <div class="glossary-text">
                Whether this taxon is considered a pathobiont — a resident commensal that can cause disease under specific conditions. Values:
                <ul class="glossary-list">
                    <li><strong>Yes</strong> — organism is a recognised pathobiont</li>
                    <li><strong>Context dependent</strong> — pathobiont status depends on host factors, clinical setting, or taxonomic level</li>
                    <li><strong>No</strong> — organism is not considered a pathobiont</li>
                    <li><strong>Unknown</strong> — insufficient evidence to classify</li>
                </ul>
            </div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Clinical Roles</span>
            <div class="glossary-text">The clinical characterisation of this taxon, such as opportunistic pathogen, protective commensal, or commensal. Extracted from curated literature.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Typical Specimen</span>
            <div class="glossary-text">Common specimen types in which the organism is identified in a clinical context (e.g., stool, blood, respiratory). Extracted from curated literature.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Risk Contexts</span>
            <div class="glossary-text">Clinical settings or patient populations where this taxon is most likely to cause harm (e.g., ICU, post-antibiotic, immunocompromised). Extracted from curated literature.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Antimicrobial Resistance</span>
            <div class="glossary-text">Notable resistance phenotypes that impact clinical management (e.g., ESBL, CRE, VRE). Extracted from curated literature. Where available, linked to the CARD Antibiotic Resistance Ontology (ARO):
                <div style="margin-top:8px;">multidrug-resistant (MDR) <span style="display:inline-block; padding:1px 5px; border-radius:3px; font-size:10px; font-weight:700; background:#fee2e2; color:#991b1b; border:1px solid #fca5a5; font-family:monospace;">3004305</span></div>
            </div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Bloom Triggers</span>
            <div class="glossary-text">Conditions that enable this taxon to expand to clinically relevant abundance (e.g., antibiotic exposure, immunosuppression). Extracted from curated literature. Specific drugs are linked to KEGG Drug (D numbers):
                <div style="margin-top:8px;">proton pump inhibitor (PPI) use <span style="display:inline-block; padding:1px 5px; border-radius:3px; font-size:10px; font-weight:700; background:#ffedd5; color:#9a3412; border:1px solid #fdba74; font-family:monospace;">D00455</span></div>
            </div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Virulence Factors</span>
            <div class="glossary-text">Molecular factors that contribute to pathogenicity (e.g., toxins, adhesins, capsule). Linked to the Virulence Factor Database (VFDB) where available:
                <div style="margin-top:8px;">Toxin A <span style="display:inline-block; padding:1px 5px; border-radius:3px; font-size:10px; font-weight:700; background:#fce7f3; color:#9d174d; border:1px solid #f9a8d4; font-family:monospace;">VF0592</span></div>
            </div>
        </div>
    </div>

    <div class="glossary-section">
        <h2>Metabolites</h2>
        <div class="glossary-item">
            <span class="glossary-term">Metabolite Relationships</span>
            <div class="glossary-text">
                Documented metabolic interactions between this taxon and specific compounds. Each entry describes the relationship type:
                <ul class="glossary-list">
                    <li><strong>Produces</strong> — taxon synthesises this metabolite</li>
                    <li><strong>Consumes</strong> — taxon degrades or consumes this metabolite</li>
                    <li><strong>Modifies</strong> — taxon chemically transforms this metabolite</li>
                </ul>
                Compounds are linked to KEGG Compound (C numbers) and ChEBI IDs (CHEBI:XXXXXX) where available. IDs are displayed as clickable badges linking to their respective databases.
            </div>
        </div>
    </div>

    <div class="glossary-section">
        <h2>Clinical Associations</h2>
        <div class="glossary-item">
            <span class="glossary-term">Association</span>
            <div class="glossary-text">An individual, evidence-graded claim linking this taxon to a specific clinical condition or outcome, extracted from a peer-reviewed publication. Each association is supported by at least one PMID and assigned an evidence grade:</div>

            <div class="nested-level">
                <div style="margin-bottom: 15px;">
                    <span class="glossary-term" style="background: #dbeafe; color: #1e40af;">E3 — Strong human clinical evidence</span>
                    <div class="glossary-text">Supported by systematic reviews, meta-analyses, clinical guidelines, or multiple independent human cohorts reported in a single paper.</div>
                </div>
                <div style="margin-bottom: 15px;">
                    <span class="glossary-term" style="background: #fef3c7; color: #92400e;">E2 — Moderate human evidence</span>
                    <div class="glossary-text">Supported by a single human cohort, RCT, case-control, or cross-sectional study.</div>
                </div>
                <div>
                    <span class="glossary-term" style="background: #f3f4f6; color: #6b7280;">E1 — Limited / preliminary</span>
                    <div class="glossary-text">Supported by animal models, in vitro studies, case reports, or mechanistic work only.</div>
                </div>
            </div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">MeSH</span>
            <div class="glossary-text">Standardised Medical Subject Headings (MeSH) terms assigned by NLM to the source paper, filtered to those directly relevant to the association. Clicking a badge opens the NLM MeSH Browser entry.
                <div style="margin-top:8px;">Cross Infection <span style="display:inline-block; padding:1px 5px; border-radius:3px; font-size:10px; font-weight:700; background:#d1fae5; color:#065f46; border:1px solid #6ee7b7; font-family:monospace;">D003428</span></div>
            </div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">KEGG</span>
            <div class="glossary-text">KEGG Disease identifiers mapping the associated clinical condition to KEGG's disease classification. Clicking a badge opens the corresponding KEGG Disease entry.
                <div style="margin-top:8px;">Enterococcal infection <span style="display:inline-block; padding:1px 5px; border-radius:3px; font-size:10px; font-weight:700; background:#ffedd5; color:#9a3412; border:1px solid #fdba74; font-family:monospace;">H01444</span></div>
            </div>
        </div>
    </div>

    <div class="glossary-section">
        <h2>Evidence Timeline</h2>
        <div class="glossary-item">
            <span class="glossary-term">Timeline</span>
            <div class="glossary-text">A chronological summary of the papers that contributed clinical associations to this passport. Each card shows the publication year and study design. Clicking a card opens the source paper on PubMed.</div>
        </div>
    </div>

    <div class="glossary-section">
        <h2>Related Taxa</h2>
        <div class="glossary-item">
            <span class="glossary-term">Related Taxa</span>
            <div class="glossary-text">
                Other taxa in the MCA database that share at least one annotated attribute with this entry. Two match types are shown:
                <ul class="glossary-list">
                    <li><strong>Shared Niche</strong> — both taxa occupy the same primary body site or environment</li>
                    <li><strong>Shared Risk</strong> — both taxa are associated with the same clinical risk context or vulnerable population</li>
                </ul>
                Clicking a related taxon card opens its passport in a new tab.
            </div>
        </div>
    </div>

</div>

<?php
if (!$is_popup) {
    include 'footer.php';
} else {
    echo '</body></html>';
}
?>
