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
                    <li><span class="code-span">MIC</span>: Mixed or unknown domains</li>
                </ul>
                <p><strong>[NNNNNN]</strong> is a unique six-digit numeric identifier that ensures permanent reference regardless of taxonomic updates.</p>
            </div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">TaxID</span>
            <div class="glossary-text">The official NCBI Taxonomy database identifier, linking the entry to global genomic records.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Rank</span>
            <div class="glossary-text">The taxonomic level of the entry, such as family, genus, species, or strain.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Lineage</span>
            <div class="glossary-text">The full taxonomic hierarchy, from kingdom down to the specific rank of the entry.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Synonyms</span>
            <div class="glossary-text">Alternative scientific names, historical nomenclature, or common aliases for the taxon.</div>
        </div>
    </div>

    <div class="glossary-section">
        <h2>Biology</h2>
        <div class="glossary-item">
            <span class="glossary-term">Gram Status</span>
            <div class="glossary-text">Gram stain classification (positive, negative, or variable) for bacterial taxa.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Oxygen Tolerance</span>
            <div class="glossary-text">Classification of metabolic oxygen requirements (e.g., aerobe, obligate anaerobe, facultative).</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Morphology</span>
            <div class="glossary-text">Typical physical cell structure and shape (e.g., rod-shaped, coccus).</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Key Traits</span>
            <div class="glossary-text">Biological features relevant to ecology, such as spore formation, biofilm production, or stress tolerance.</div>
        </div>
    </div>

    <div class="glossary-section">
        <h2>Ecology</h2>
        <div class="glossary-item">
            <span class="glossary-term">Primary Niches</span>
            <div class="glossary-text">The specific body sites or environments where the organism is most frequently found.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Reservoir</span>
            <div class="glossary-text">The natural hosts or environments (e.g., human, animal, environment) where the taxon persists.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Transmission</span>
            <div class="glossary-text">The routes through which the organism is typically acquired (e.g., contact, foodborne, waterborne).</div>
        </div>
    </div>

    <div class="glossary-section">
        <h2>Clinical profile</h2>
        <div class="glossary-item">
            <span class="glossary-term">Pathobiont</span>
            <div class="glossary-text">
                A resident commensal that is typically benign but can cause disease under specific conditions (e.g., antibiotic-driven dysbiosis or host immunosuppression).
            </div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Clinical Roles</span>
            <div class="glossary-text">The medical status of the taxon, such as opportunistic pathogen or protective association.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Typical Specimen</span>
            <div class="glossary-text">Common specimen sources (e.g., blood, urine, respiratory) where the organism is identified in a clinical context.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Antimicrobial Resistance</span>
            <div class="glossary-text">Notable resistance phenotypes (e.g., ESBL, CRE) that impact clinical management.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Bloom Triggers</span>
            <div class="glossary-text">Specific conditions (e.g., antibiotic exposure, inflammation) that enable the taxon to expand rapidly.</div>
        </div>
        <div class="glossary-item">
            <span class="glossary-term">Risk Contexts</span>
            <div class="glossary-text">Settings or populations (e.g., ICU, post-antibiotics) where the taxon is most likely to cause complications.</div>
        </div>
        
        <div class="glossary-item">
            <span class="glossary-term">Clinical Associations</span>
            <div class="glossary-text">Specific conditions or outcomes linked to the taxon. These are graded by the following evidence levels:</div>
            
            <div class="nested-level">
                <div style="margin-bottom: 15px;">
                    <span class="glossary-term" style="background: #fee2e2; color: #b91c1c;">E3 — Strong human clinical evidence</span>
                    <div class="glossary-text">Broadly accepted in clinical practice. Supported by official guidelines, systematic reviews, or meta-analyses.</div>
                </div>
                
                <div style="margin-bottom: 15px;">
                    <span class="glossary-term" style="background: #fef3c7; color: #92400e;">E2 — Moderate human evidence</span>
                    <div class="glossary-text">Direct evidence in humans exists but may be context-dependent. Supported by well-designed observational studies.</div>
                </div>
                
                <div>
                    <span class="glossary-term" style="background: #f0fdf4; color: #166534;">E1 — Limited / preliminary</span>
                    <div class="glossary-text">Suggestive but not yet established. Supported by animal models, isolated case reports, or mechanistic work.</div>
                </div>
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