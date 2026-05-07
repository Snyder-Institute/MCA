<?php include 'header.php'; ?>

<style>
.lit-wrap { max-width: 900px; margin: 0 auto; padding: 30px 16px 60px; }

.lit-year-group { margin-bottom: 36px; }
.lit-year-label {
    font-family: "Montserrat", sans-serif;
    font-size: 13px;
    font-weight: 800;
    color: #404f7c;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    border-bottom: 2px solid #404f7c;
    padding-bottom: 6px;
    margin-bottom: 14px;
    display: inline-block;
}

.lit-entry {
    padding: 14px 16px;
    border: 1px solid #eee;
    border-radius: 8px;
    margin-bottom: 8px;
    background: #fff;
    transition: border-color 0.15s, box-shadow 0.15s;
}
.lit-entry:hover {
    border-color: #cdd4f0;
    box-shadow: 0 2px 8px rgba(64,79,124,0.07);
}

.lit-body { flex: 1; min-width: 0; }
.lit-citation {
    font-size: 13px;
    color: #444;
    line-height: 1.55;
}
.lit-title {
    font-size: 14px;
    font-weight: 700;
    color: #222;
    margin: 0 0 4px;
}
.lit-meta {
    font-size: 13px;
    color: #555;
}
.lit-meta .lit-journal {
    font-style: italic;
}
.lit-pmid-link {
    color: #007bff;
    text-decoration: none;
}
.lit-pmid-link:hover {
    text-decoration: underline;
}
</style>

<div class="lit-wrap">

    <div class="logo-container" style="margin-bottom: 20px;">
        <a href="index.php" style="display: inline-block;">
            <img src="./images/logo.png" class="logo-main" alt="MCA Logo" style="cursor: pointer;">
        </a>
    </div>

    <h1 style="font-size: 28px; margin: 0 0 10px;">Curated Literature</h1>
    <p style="color: #555; font-size: 15px; line-height: 1.65; margin: 0 0 24px;">
        All <?php echo 25; ?> papers curated into MCA, ordered by year of publication. Each entry links to the original record on PubMed.
    </p>

    <?php
    $papers = [
        // 2026
        ['pmid' => 41039149, 'authors' => 'Chilton et al.',      'title' => 'Clostridioides difficile pathogenesis and control',                                                                                                    'journal' => 'Nature Reviews Microbiology',          'year' => 2026],
        ['pmid' => 41641127, 'authors' => 'Rogalidou',           'title' => 'Clostridioides difficile infection in pediatric inflammatory bowel disease: current understanding and clinical challenges',                            'journal' => 'Frontiers in Pediatrics',              'year' => 2026],
        ['pmid' => 41814006, 'authors' => 'Baldanzi et al.',     'title' => 'Antibiotic use and gut microbiome composition links from individual-level prescription data of 14,979 individuals',                                     'journal' => 'Nature Medicine',                      'year' => 2026],
        // 2025
        ['pmid' => 40544256, 'authors' => 'Mannavola et al.',    'title' => 'Bloodstream infection by Lactobacillus rhamnosus in a haematology patient: why metagenomics can make the difference',                                  'journal' => 'Gut Pathogens',                        'year' => 2025],
        // 2024
        ['pmid' => 38584858, 'authors' => 'Stallhofer et al.',   'title' => 'Microbiota-Based Therapeutics as New Standard-of-Care Treatment for Recurrent Clostridioides difficile Infection',                                     'journal' => 'Visceral Medicine',                    'year' => 2024],
        ['pmid' => 38786164, 'authors' => 'Wang et al.',         'title' => 'A Comparison of Currently Available and Investigational Fecal Microbiota Transplant Products for Recurrent Clostridioides difficile Infection',        'journal' => 'Antibiotics',                          'year' => 2024],
        ['pmid' => 39456922, 'authors' => 'Catalan et al.',      'title' => 'Oral Pathobiont-Derived Outer Membrane Vesicles in the Oral–Gut Axis',                                                                                 'journal' => 'International Journal of Molecular Sciences', 'year' => 2024],
        // 2023
        ['pmid' => 36894652, 'authors' => 'Schlechte et al.',    'title' => 'Dysbiosis of a microbiota–immune metasystem in critical illness is associated with nosocomial infections',                                             'journal' => 'Nature Medicine',                      'year' => 2023],
        // 2022
        ['pmid' => 35831502, 'authors' => 'Yang et al.',         'title' => 'Within-host evolution of a gut pathobiont facilitates liver translocation',                                                                             'journal' => 'Nature',                               'year' => 2022],
        // 2021
        ['pmid' => 33303685, 'authors' => 'Baruch et al.',       'title' => 'Fecal microbiota transplant promotes response in immunotherapy-refractory melanoma patients',                                                           'journal' => 'Science',                              'year' => 2021],
        ['pmid' => 33432149, 'authors' => 'Lee et al.',          'title' => 'Bifidobacterium bifidum strains synergize with immune checkpoint inhibitors to reduce tumour burden in mice',                                           'journal' => 'Nature Microbiology',                  'year' => 2021],
        ['pmid' => 33542131, 'authors' => 'Davar et al.',        'title' => 'Fecal microbiota transplant overcomes resistance to anti-PD-1 therapy in melanoma patients',                                                           'journal' => 'Science',                              'year' => 2021],
        ['pmid' => 33766858, 'authors' => 'Sepich-Poore et al.','title' => 'The microbiome and human cancer',                                                                                                                        'journal' => 'Science',                              'year' => 2021],
        ['pmid' => 34941392, 'authors' => 'Spencer et al.',      'title' => 'Dietary fiber and probiotics influence the gut microbiome and melanoma immunotherapy response',                                                         'journal' => 'Science',                              'year' => 2021],
        // 2020
        ['pmid' => 32129694, 'authors' => 'Rodríguez et al.',   'title' => 'Microbiota Insights in Clostridium difficile Infection and Inflammatory Bowel Disease',                                                                  'journal' => 'Gut Microbes',                         'year' => 2020],
        ['pmid' => 32758418, 'authors' => 'Kitamoto et al.',     'title' => 'The Intermucosal Connection between the Mouth and Gut in Commensal Pathobiont-Driven Colitis',                                                         'journal' => 'Cell',                                 'year' => 2020],
        // 2019
        ['pmid' => 31548871, 'authors' => 'Posteraro et al.',    'title' => 'First bloodstream infection caused by Prevotella copri in a heart failure elderly patient with Prevotella-dominated gut microbiota: a case report',     'journal' => 'Gut Pathogens',                        'year' => 2019],
        // 2018
        ['pmid' => 29097493, 'authors' => 'Gopalakrishnan et al.','title' => 'Gut microbiome modulates response to anti-PD-1 immunotherapy in melanoma patients',                                                                   'journal' => 'Science',                              'year' => 2018],
        ['pmid' => 29097494, 'authors' => 'Routy et al.',        'title' => 'Gut microbiome influences efficacy of PD-1-based immunotherapy against epithelial tumors',                                                              'journal' => 'Science',                              'year' => 2018],
        ['pmid' => 29302014, 'authors' => 'Matson et al.',       'title' => 'The commensal microbiome is associated with anti-PD-1 efficacy in metastatic melanoma patients',                                                       'journal' => 'Science',                              'year' => 2018],
        ['pmid' => 29414937, 'authors' => 'Xu et al.',           'title' => 'c-Maf-dependent regulatory T cells mediate immunological tolerance to a gut pathobiont',                                                               'journal' => 'Nature',                               'year' => 2018],
        ['pmid' => 29546356, 'authors' => 'Li et al.',           'title' => 'Clonal Emergence of Invasive Multidrug-Resistant Staphylococcus epidermidis Deconvoluted via a Combination of Whole-Genome Sequencing and Microbiome Analyses', 'journal' => 'Clinical Infectious Diseases',    'year' => 2018],
        ['pmid' => 29590047, 'authors' => 'Manfredo Vieira et al.','title' => 'Translocation of a gut pathobiont drives autoimmunity in mice and humans',                                                                           'journal' => 'Science',                              'year' => 2018],
        // 2015
        ['pmid' => 25385792, 'authors' => 'Kernbauer et al.',    'title' => 'Gastrointestinal Dissemination and Transmission of Staphylococcus aureus following Bacteremia',                                                        'journal' => 'Infection and Immunity',               'year' => 2015],
        // 2014
        ['pmid' => 24503131, 'authors' => 'Britton et al.',      'title' => 'Role of the Intestinal Microbiota in Resistance to Colonization by Clostridium difficile',                                                             'journal' => 'Gastroenterology',                     'year' => 2014],
    ];

    $by_year = [];
    foreach ($papers as $p) {
        $by_year[$p['year']][] = $p;
    }
    krsort($by_year);

    foreach ($by_year as $year => $entries):
    ?>
    <div class="lit-year-group">
        <div class="lit-year-label"><?php echo $year; ?></div>
        <?php foreach ($entries as $p):
            $pmid_url = 'https://pubmed.ncbi.nlm.nih.gov/' . $p['pmid'] . '/';
        ?>
        <div class="lit-entry">
            <div class="lit-body">
                <div class="lit-title"><?php echo htmlspecialchars($p['title']); ?>.</div>
                <div class="lit-meta">
                    <?php if ($p['authors']): ?><?php echo htmlspecialchars($p['authors']); ?>, <?php endif; ?><span class="lit-journal"><?php echo htmlspecialchars($p['journal']); ?></span>, (<?php echo $p['year']; ?>), <a class="lit-pmid-link" href="<?php echo $pmid_url; ?>" target="_blank" rel="noopener">PMID <?php echo $p['pmid']; ?></a>
                </div>
            </div>
        </div>
        <?php endforeach; ?>
    </div>
    <?php endforeach; ?>

</div>

<?php include 'footer.php'; ?>
