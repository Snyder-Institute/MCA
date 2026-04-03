-- MCA database dump
-- Source XML : MCA_DB_v1_10_20260403.xml
-- Generated  : 2026-04-03
-- Import     : mysql MCA < MCA_DB_v1_10_20260403.sql

USE MCA;

SET FOREIGN_KEY_CHECKS = 0;

-- truncate all data tables before reload
TRUNCATE TABLE assoc_pmid;
TRUNCATE TABLE assoc_ref;
TRUNCATE TABLE association;
TRUNCATE TABLE passport_pmid;
TRUNCATE TABLE metabolite;
TRUNCATE TABLE taxon_tag;
TRUNCATE TABLE biology;
TRUNCATE TABLE passport;
TRUNCATE TABLE paper;

-- meta
INSERT INTO meta (key_name, key_value) VALUES ('db_version', 'v1_10_20260403')
  ON DUPLICATE KEY UPDATE key_value = 'v1_10_20260403';

-- papers
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (36894652, 'Dysbiosis of a microbiota–immune metasystem in critical illness is associated with nosocomial infections', 'Schlechte J, Willing B, Lowes D, West ML, Mager DR, Fuhr JE, Gold MR, Bhatt M', 'Nature Medicine', 2023, 'prospective longitudinal cohort', 'Adult ICU patients, University of Calgary, Canada', 51) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (41641127, 'Clostridioides difficile infection in pediatric inflammatory bowel disease: current understanding and clinical challenges', 'Rogalidou M', 'Frontiers in Pediatrics', 2026, 'narrative review', 'Pediatric patients with inflammatory bowel disease (IBD), including Crohn\'s disease, ulcerative colitis, and IBD-unclassified; review also covers general pediatric CDI populations', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (40544256, 'Bloodstream infection by Lactobacillus rhamnosus in a haematology patient: why metagenomics can make the difference', 'Mannavola CM; De Maio F; Marra J; Fiori B; Santarelli G; Posteraro B; Sica S; D\'Inzeo T; Sanguinetti M', 'Gut Pathogens', 2025, 'case report', 'Single 20-year-old female with relapsed/refractory Philadelphia-negative B-cell ALL post-allogeneic HSCT', 1) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (24503131, 'Role of the Intestinal Microbiota in Resistance to Colonization by Clostridium difficile', 'Britton RA, Young VB', 'Gastroenterology', 2014, 'narrative review — no original data; reviews animal model studies (murine and hamster CDI models), in vitro mechanistic studies, and human observational findings on the role of the gut microbiota in CDI colonization resistance', 'Not applicable (review article); cited studies use hamster/mouse models and human patients with CDI', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (41039149, 'Clostridioides difficile pathogenesis and control', 'Chilton CH, Viprey V, Normington C, Moura IB, Buckley AM, Freeman J, Davies K, Wilcox MH', 'Nature Reviews Microbiology', 2026, 'Narrative review', 'Not applicable (review article)', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (39456922, 'Oral Pathobiont-Derived Outer Membrane Vesicles in the Oral–Gut Axis', 'Catalan EA, Seguel-Fuentes E, Fuentes B, Aranguiz-Varela F, Castillo-Godoy DP, Rivera-Asin E, Bocaz E, Fuentes JA, Bravo D, Schinnerling K, Melo-Gonzalez F', 'International Journal of Molecular Sciences', 2024, 'narrative review', 'N/A', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (38786164, 'A Comparison of Currently Available and Investigational Fecal Microbiota Transplant Products for Recurrent Clostridioides difficile Infection', 'Wang Y, Hunt A, Danziger L, Drwiega EN', 'Antibiotics', 2024, 'narrative review', 'Adults with recurrent CDI (rCDI) treated with live biotherapeutic products (LBPs) or fecal microbiota transplantation', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (38584858, 'Microbiota-Based Therapeutics as New Standard-of-Care Treatment for Recurrent Clostridioides difficile Infection', 'Stallhofer J, Steube A, Katzer K, Stallmach A', 'Visceral Medicine', 2024, 'narrative review', 'adults with recurrent Clostridioides difficile infection (rCDI)', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (34941392, 'Dietary fiber and probiotics influence the gut microbiome and melanoma immunotherapy response', 'Spencer CN, McQuade JL, Gopalakrishnan V, McCulloch JA, Vetizou M, Cogdill AP, et al.', 'Science', 2021, 'mixed: single observational cohort (primary) + parallel preclinical murine models', 'Germ-free C57BL/6 mice colonized with complete responder (CR) donor stool via FMT, then gavaged with B. longum 35624–based probiotic (probiotic 1), implanted with BRAF V600E/PTEN-null melanoma cells, and treated with anti-PD-L1 (n=4–5 per group for tumor growth; n=6 per group for immune profiling; n=7–8 per group for microbiome analysis)', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (35831502, 'Within-host evolution of a gut pathobiont facilitates liver translocation', 'Yang Y, Nguyen M, Khetrapal V, Sonnert ND, Martin AL, Chen H, Kriegel MA, Palm NW', 'Nature', 2022, 'animal model', 'Germ-free (GF) and specific-pathogen-free (SPF) C57BL/6 mice monocolonised with individual bacterial isolates; autoimmune-prone (NZW×BXSB)F1 mice; in vitro BMDM phagocytosis and antimicrobial peptide assays', 153) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (32129694, 'Microbiota Insights in Clostridium difficile Infection and Inflammatory Bowel Disease', 'Rodríguez C, Romero E, Garrido-Sanchez L, Alcaín-Martínez G, Andrade RJ, Taminiau B, Daube G, García-Fuentes E', 'Gut Microbes', 2020, 'narrative review', 'Review of human microbiome studies in CDI and IBD patients (adult and pediatric)', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (33542131, 'Fecal microbiota transplant overcomes resistance to anti-PD-1 therapy in melanoma patients', 'Davar D, Dzutsev AK, McCulloch JA, Rodrigues RR, Chauvin JM, Morrison RM et al.', 'Science', 2021, 'phase 2 single-arm clinical trial', 'Advanced melanoma patients, primary refractory to anti-PD-1 therapy (NCT03341143)', 15) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (29590047, 'Translocation of a gut pathobiont drives autoimmunity in mice and humans', 'Manfredo Vieira S, Hiltensperger M, Kumar V, et al.', 'Science', 2018, 'mixed: animal model (germ-free mouse monocolonization) + human case-control', 'GF C57BL/6 mice (n=6–10 per group); human SLE (n=15), AIH (n=17), healthy controls (n=9)', 41) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (33432149, 'Bifidobacterium bifidum strains synergize with immune checkpoint inhibitors to reduce tumour burden in mice', 'Lee SH, Cho SY, Yoon Y, Park C, et al.', 'Nature Microbiology', 2021, 'cohort', '96 NSCLC patients (stage IIIB/IV) and 139 healthy controls in Korea; syngeneic mouse tumour models (MC38, LLC1, 4T1); in vitro bacterial characterization', 235) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (32758418, 'The Intermucosal Connection between the Mouth and Gut in Commensal Pathobiont-Driven Colitis', 'Kitamoto S, Nagao-Kitamoto H, Jiao Y, Gillilland MG III, Hayashi A, Imai J, Sugihara K, Miyoshi M, Brazil JC, Kuffa P, Hill BD, Rizvi SM, Wen F, Bishu S, Inohara N, Eaton KA, Nusrat A, Lei YL, Giannobile WV, Kamada N', 'Cell', 2020, 'Multi-model mouse experimental (ligature-induced periodontitis + DSS colitis, germ-free Il10−/− and Rag1−/− colonization, Kaede transgenic photoconversion, parabiosis)', 'SPF C57BL/6 mice, germ-free Il10−/− mice, germ-free Rag1−/− mice, multiple KO strains — no human subjects', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (33303685, 'Fecal microbiota transplant promotes response in immunotherapy-refractory melanoma patients', 'Baruch EN, Youngster I, Ben-Betzalel G, et al.', 'Science', 2021, 'phase 1 clinical trial', 'Adult anti-PD-1-refractory metastatic melanoma patients (n=10 FMT recipients; 2 FMT donors who achieved complete response)', 10) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (29546356, 'Clonal Emergence of Invasive Multidrug-Resistant Staphylococcus epidermidis Deconvoluted via a Combination of Whole-Genome Sequencing and Microbiome Analyses', 'Li X, Arias CA, Aitken SL, Galloway Peña J, Panesso D, Chang M, Diaz L, Rios R, Numan Y, Ghaoui S, DebRoy S, Bhatti MM, Simmons DE, Raad I, Hachem R, Folan SA, Sahasarabhojane P, Kalia A, Shelburne SA', 'Clinical Infectious Diseases', 2018, 'Retrospective single-center cohort with whole-genome sequencing (WGS) phylogenomics and 16S rRNA microbiome analysis (MD Anderson Cancer Center, Houston, TX, 2013–2016)', 'Cancer patients at MD Anderson Cancer Center with invasive S. epidermidis bloodstream isolates; separately, 98 acute myelogenous leukemia patients with serial stool samples — all human subjects', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (29097493, 'Gut microbiome modulates response to anti-PD-1 immunotherapy in melanoma patients', 'Gopalakrishnan V, Spencer CN, Nezi L, et al. (Wargo JA)', 'Science', 2018, 'prospective cohort', 'Metastatic melanoma patients undergoing anti-PD-1 immunotherapy (n=112 total; fecal microbiome analyzed in n=43: 30 responders, 13 non-responders; WGS subset n=25: 14R, 11NR)', 43) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (29097494, 'Gut microbiome influences efficacy of PD-1-based immunotherapy against epithelial tumors', 'Routy B, Le Chatelier E, Derosa L, Duong CPM, Tidjani Alou M, Daillère R, et al.', 'Science', 2018, 'Multi-cohort observational metagenomics study with preclinical mouse FMT experiments', 'Advanced NSCLC (n=140), RCC (n=67), and urothelial carcinoma (n=42) patients receiving PD-1/PD-L1 blockade; metagenomics subset n=100; two validation cohorts (n=53 NSCLC+RCC and n=239 NSCLC)', 249) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (29302014, 'The commensal microbiome is associated with anti-PD-1 efficacy in metastatic melanoma patients', 'Matson V, Fessler J, Bao R, Chongsuwat T, Zha Y, Alegre ML, Luke JJ, Gajewski TF', 'Science', 2018, 'prospective observational cohort', 'Metastatic melanoma patients before anti-PD-1 immunotherapy', 42) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (25385792, 'Gastrointestinal Dissemination and Transmission of Staphylococcus aureus following Bacteremia', 'Kernbauer E, Ding Y, Cadwell K', 'Infection and Immunity', 2015, 'animal model', 'C57BL/6 mice; intravenous bacteremia model with wild-type, agr mutant, sae mutant, and agr+sae double-mutant S. aureus strains; n=5–10 mice per group; transmission experiments n=6 recipient mice', 10) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (29414937, 'c-Maf-dependent regulatory T cells mediate immunological tolerance to a gut pathobiont', 'Xu M, Pokrovskii M, Ding Y, Yi R, Au C, Harrison OJ, Galan C, Belkaid Y, Bonneau R, Littman DR', 'Nature', 2018, 'murine experimental study — TCR transgenic mice, conditional knockout models (Maf^ΔTreg, Rorc^ΔTreg, Gata3^ΔTreg, Il10^-/-), adoptive T cell transfer, flow cytometry, RNA-seq', 'Mouse (C57Bl/6 background), colonized with H. hepaticus ± SFB; 4–21 animals per group across multiple independent experiments', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (33766858, 'The microbiome and human cancer', 'Sepich-Poore GD, Zitvogel L, Straussman R, Hasty J, Wargo JA, Knight R', 'Science', 2021, 'Narrative review / critical perspective — no primary data; synthesizes established literature on microbiome-cancer relationships', 'Not applicable (review article; references human and animal studies from published literature)', NULL) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (31548871, 'First bloodstream infection caused by Prevotella copri in a heart failure elderly patient with Prevotella-dominated gut microbiota: a case report', 'Posteraro P, De Maio F, Menchinelli G, Palucci I, Errico FM, Carbone M, Sanguinetti M, Gasbarrini A, Posteraro B', 'Gut Pathogens', 2019, 'case report', 'Single 90-year-old male with heart failure (dilated cardiomyopathy) and acute cardiac decompensation; gut microbiota characterised by 16S rRNA sequencing (V3/V4/V6 regions)', 1) AS _new ON DUPLICATE KEY UPDATE title=_new.title, authors=_new.authors, journal=_new.journal, year=_new.year, study_design=_new.study_design, population=_new.population, sample_size=_new.sample_size;

-- ── MCA-BAC-000001  Enterobacteriaceae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (1, 'MCA-BAC-000001', 'Enterobacteriaceae', 'family', 'Bacteria', 'Bacteria; Pseudomonadota; Gammaproteobacteria; Enterobacterales; Enterobacteriaceae', 543, 'yes', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (1, 'gram-negative', 'facultative anaerobe', NULL, NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (1, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (1, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (1, 'reservoir', 'environment', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (1, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (1, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (1, 'risk_context', 'ICU / critical care', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (1, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (1, 'bloom_trigger', 'hospitalization', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (1, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (1, 1, 'Enterobacteriaceae relative abundance was elevated approximately 10-fold in critically ill ICU patients compared to healthy controls during the first week of ICU admission, as measured by 16S rRNA sequencing of rectal swabs in a prospective cohort of 51 patients, representing the dominant compositional shift in ICU-associated gut dysbiosis.', 'b25aaf7f4a8143874bda147e79ca3d5ac5e9b9805e7af61bd0dcdf959ca40fb6', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (1, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (1, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (1, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (2, 1, 'Progressive Enterobacteriaceae enrichment (≥2-fold increase between consecutive ICU time points) was independently associated with significantly increased odds of nosocomial infection (OR 6.8, 95% CI 1.7–25.3, p=0.01) compared to ICU patients without progressive enrichment, in a prospective cohort of 51 critically ill adults.', '144b0a1f054c702b0ad0094180300ffc8d61c953e299777952d4dc42d8b2dd88', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (2, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (2, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (2, 'mesh', 'D064307', 'Microbiota', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (2, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (3, 1, 'Enterobacteriaceae relative abundance positively correlated with systemic inflammatory mediators (IL-8, IL-15, TNF-α, MIP-1α, IL-10) and immature neutrophils in ICU patients, indicating coupling of gut Enterobacteriaceae expansion to innate immune dysregulation during critical illness.', 'a2142886efb7ebe3c3807ef6a9e46d388e40f391e26f8abb714605bdb0c4e5b7', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (3, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (3, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (3, 36894652, '2026-04-01');

-- ── MCA-BAC-000002  Enterococcaceae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (2, 'MCA-BAC-000002', 'Enterococcaceae', 'family', 'Bacteria', 'Bacteria; Bacillota; Bacilli; Lactobacillales; Enterococcaceae', 81852, 'yes', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (2, 'gram-positive', 'facultative anaerobe', NULL, NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (2, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (2, 'primary_niche', 'urinary tract', 'D014551', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (2, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (2, 'reservoir', 'environment', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (2, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (2, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (2, 'typical_specimen', 'urine', 'D014556', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (2, 'typical_specimen', 'blood', 'D001769', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (2, 'risk_context', 'ICU / critical care', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (2, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (2, 'bloom_trigger', 'hospitalization', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (2, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (4, 2, 'Enterococcaceae was one of two dominant pathobiont families that significantly expanded in the gut microbiota of critically ill ICU patients compared to healthy controls (p=0.0334), representing a key feature of ICU-associated dysbiosis in a prospective cohort of 51 patients.', '0320a79273b190cfa350e46504ae095b45991520f3f82aa6b999c977b480ea2b', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (4, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (4, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (4, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (5, 2, 'Enterococcaceae gut bloom in an ICU patient was associated with a nosocomial urinary tract infection caused by Enterococcus faecalis that progressed to secondary bloodstream infection, representing a direct clinical consequence of gut Enterococcaceae expansion documented in a single case within a 51-patient prospective cohort.', '3d464e07746842e45d66caebb351a7902375c84163ad9b95d9fdca28ec3e6bca', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (5, 'mesh', 'D003428', 'Cross Infection', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (5, 'kegg_disease', 'H01444', 'Enterococcal infection', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (5, 36894652, '2026-04-01');

-- ── MCA-BAC-000003  Ruminococcaceae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (3, 'MCA-BAC-000003', 'Ruminococcaceae', 'family', 'Bacteria', 'Bacteria; Bacillota; Clostridia; Eubacteriales; Ruminococcaceae', 541000, 'no', '2026-04-03', '2026-04-01', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (3, 'gram-positive', 'obligate anaerobe', NULL, NULL, '2026-04-01', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (3, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (3, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (3, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (3, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (3, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-01', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (3, 36894652, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (3, 34941392, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (3, 32129694, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (3, 33303685, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (3, 29097493, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (6, 3, 'Ruminococcaceae relative abundance was significantly reduced in critically ill ICU patients compared to healthy controls (ANCOM-II p-adj<0.1), representing a key anaerobic fermenter family lost during critical illness-associated gut dysbiosis in a prospective cohort of 51 patients.', '703c7994e7ed2337ac5f6f6de5b7f611f8e32aa4b936f9d01f12e4f2de6fe409', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (6, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (6, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (6, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (7, 3, 'Ruminococcaceae depletion preceded Enterobacteriaceae expansion in critically ill ICU patients, consistent with its role in colonization resistance against pathobiont expansion during critical illness-associated gut dysbiosis.', 'd17c19491203bf1ededd2c64d5710175a5604bf6f4adf8d6298813a64ab316ef', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (7, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (7, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (7, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (8, 3, 'In an independent newly recruited cohort of 132 anti-PD-1–treated metastatic melanoma patients (n=87 responders, n=45 non-responders), Ruminococcaceae relative abundance was significantly higher in responders versus non-responders (p=0.036 by Wilcoxon rank sum test), replicating the response-associated enrichment pattern identified in a prior cohort.', 'd414dedc7dae1f6907bd12be514c8ae32047ef5d28a2ab52599b57197f95a7c9', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (8, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (8, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (8, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (8, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (9, 3, 'Across an expanded cohort of 293 metastatic melanoma patients treated with anti-PD-1 or other systemic therapies, Ruminococcaceae was the most significantly enriched taxon in gut microbiota of responders versus non-responders (FDR q<0.1 by Wilcoxon rank sum test), with enrichment persisting after multivariable adjustment for age, sex, BMI, prior treatment, and antibiotic use.', 'fbd0a2cf1741f92d211b2dc975fb8ff4d8a0357ebf0f90d4ed423a217bfa9b03', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (9, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (9, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (9, 'mesh', 'D000077982', 'Progression-Free Survival', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (9, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (9, 34941392, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): d7f125800bca019e1b933ed5cf9acdf3b13fc6fed0b5f15a2fc1f60c0eceb410
INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (10, 3, 'In a phase 1 FMT trial (n=10 anti-PD-1-refractory metastatic melanoma patients), FMT Donor 2 (a melanoma complete responder) was characterized by high Ruminococcaceae relative abundance in stool microbiota; the paper explicitly characterizes this as a previously reported \'immunotherapy-favorable feature\' associated with anti-PD-1 response, though Donor 2 recipients produced no clinical responses in this trial.', '943ac9e4e9e89cdd6262c1a1f9f0e719c0a9b2489b63f5ddad308d3ddfe3a554', 'E1', 'phase 1 clinical trial', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (10, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (10, 'mesh', 'D000069467', 'Fecal Microbiota Transplantation', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (10, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (10, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (10, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (10, 33303685, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (11, 3, 'Ruminococcaceae relative abundance was significantly higher in anti-PD-1 responders versus non-responders in a prospective cohort of 43 metastatic melanoma patients (30R, 13NR; p<0.01 by LEfSe and FDR-adjusted pairwise comparisons), establishing the original human evidence for Ruminococcaceae enrichment as a gut microbiome marker of immunotherapy response.', 'aa996ad1f29290120b48676243cff8a8920d40e9eafb55cb495e8cab05767e10', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (11, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (11, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (11, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (11, 29097493, '2026-04-01');

-- ── MCA-BAC-000004  Lachnospiraceae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (4, 'MCA-BAC-000004', 'Lachnospiraceae', 'family', 'Bacteria', 'Bacteria; Bacillota; Clostridia; Eubacteriales; Lachnospiraceae', 186803, 'no', '2026-04-03', '2026-04-01', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (4, 'gram-positive', 'obligate anaerobe', NULL, NULL, '2026-04-01', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (4, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (4, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (4, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (4, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (4, 36894652, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (4, 33303685, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (4, 24503131, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (12, 4, 'Lachnospiraceae relative abundance was significantly depleted in critically ill ICU patients compared to healthy controls (ANCOM-II p-adj<0.1), contributing to the loss of colonization resistance and gut dysbiosis during critical illness in a prospective cohort of 51 patients.', '5b76587bc8fddd053b1307f1573a52363bfdb6c29a93e42de06bcefad2c45acd', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (12, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (12, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (12, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (13, 4, 'Penalized ridge regression identified Lachnospiraceae as one of the most important families negatively associated with progressive Enterobacteriaceae enrichment between ICU days 1 and 3, consistent with a colonization resistance role against pathobiont expansion during critical illness.', '6249def6d948e00bcc550872b2020be6074efc4ebc9ab205b96e07068472d4f5', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (13, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (13, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (13, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (14, 4, 'In a phase 1 FMT trial (n=10 anti-PD-1-refractory metastatic melanoma patients), both FMT donors who had achieved complete response to anti-PD-1 therapy were characterized by high Lachnospiraceae relative abundance in their stool microbiota; the paper explicitly characterizes this as a previously reported \'immunotherapy-favorable feature\' of the gut microbiome associated with response to anti-PD-1 therapy.', '958b85b303082fdeda31d15938bbeb45f49c27c41dc80d544625f4532b2e4280', 'E1', 'phase 1 clinical trial', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (14, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (14, 'mesh', 'D000069467', 'Fecal Microbiota Transplantation', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (14, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (14, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (14, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (14, 33303685, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (15, 4, 'In a murine CDI model, susceptibility to C. difficile colonization following antibiotic treatment was associated with loss of the normal cecal microbial community (mainly Lachnospiraceae) and a relative increase in Enterobacteriaceae; disease severity was related to the recovery dynamics of these families, with more severe outcomes in mice where Lachnospiraceae failed to return post-antibiotic and Enterobacteriaceae continued to dominate.', 'c0e6fe1fb270c1ac7710564a86268327d29c4981d7e6b3bf9c8a293177b6fbd9', 'E1', 'narrative review of murine experimental studies', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (15, 'mesh', 'D004761', 'Enterocolitis Pseudomembranous', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (15, 'kegg_disease', 'H00338', 'Pseudomembranous colitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (15, 24503131, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (16, 4, 'Monocolonization of germ-free mice with a murine Lachnospiraceae isolate significantly reduced levels of C. difficile colonization and severity of colitis compared to mice monocolonized with a murine E. coli isolate, which had no protective effect, formally demonstrating a colonization resistance function for Lachnospiraceae family members against C. difficile intestinal invasion.', '7d9119d00dac88b59f1ec51721f5cda756b035c1c822c377c341826e242d8624', 'E1', 'narrative review of murine experimental studies', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (16, 'mesh', 'D004761', 'Enterocolitis Pseudomembranous', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (16, 'kegg_disease', 'H00338', 'Pseudomembranous colitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (16, 24503131, '2026-04-01');

-- ── MCA-BAC-000005  Bifidobacteriaceae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (5, 'MCA-BAC-000005', 'Bifidobacteriaceae', 'family', 'Bacteria', 'Bacteria; Actinomycetota; Actinomycetes; Bifidobacteriales; Bifidobacteriaceae', 31953, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (5, 'gram-positive', 'obligate anaerobe', NULL, NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (5, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (5, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (5, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (5, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (5, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (17, 5, 'Bifidobacteriaceae relative abundance was depleted in critically ill ICU patients compared to healthy controls (ANCOM-II p-adj<0.1), representing a commensal family lost during critical illness-associated gut dysbiosis in a prospective cohort of 51 patients.', 'b4a78a6d8d36ab16999237239b4729e84da58a1c6eb555579a40afa8888822e9', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (17, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (17, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (17, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (18, 5, 'Penalized ridge regression identified Bifidobacteriaceae as one of the most important families negatively associated with progressive Enterobacteriaceae enrichment between ICU days 1 and 3, consistent with a colonization resistance role against pathobiont expansion during critical illness.', '49ade5e93baabe15c48038e1dd12d4e21473c41c53326e49e99b180e6f6c3090', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (18, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (18, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (18, 36894652, '2026-04-01');

-- ── MCA-BAC-000006  Clostridioides difficile
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (6, 'MCA-BAC-000006', 'Clostridioides difficile', 'species', 'Bacteria', 'cellular organisms; Bacteria; Bacillati; Bacillota; Clostridia; Peptostreptococcales; Peptostreptococcaceae; Clostridioides', 1496, 'yes', '2026-04-03', '2026-04-01', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (6, 'gram-positive', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/2582', '2026-04-01', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'synonym', 'Clostridium difficile', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'synonym', 'Peptoclostridium difficile', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'key_trait', 'spore-forming', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'key_trait', 'toxin-producing', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'key_trait', 'biofilm-forming', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'reservoir', 'environment', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'reservoir', 'animal', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'transmission_route', 'fecal-oral', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'transmission_route', 'healthcare-associated', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'role', 'primary pathogen', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'typical_specimen', 'colon tissue', 'D003106', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'ICU / critical care', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'post-antibiotic', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'inflammatory bowel disease (IBD)', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'immunocompromised patients', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'elderly', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'renal insufficiency', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'oncological disease', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'prior CDI episode', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'ongoing antibiotic treatment', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'dysbiosis', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'immunosuppression', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'inflammation', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'hospitalization', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'dietary change', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'clindamycin', 'D00277', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'fluoroquinolones', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'broad-spectrum beta-lactams', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'amr_highlight', 'multidrug-resistant (MDR)', 'ARO:3004305', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CbpA', 'VF0592', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CD0873', 'VF0593', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CD2831', 'VF0598', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CD3246', 'VF0599', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CDT', 'VF0385', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'Cwp66', 'VF0591', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'Cwp84', 'VF0590', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CwpV', 'VF0596', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'FbpA/Fbp68', 'VF0595', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'GroEL', 'VF0594', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'SlpA', 'VF0589', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'TcdA', 'VF0376', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'TcdB', 'VF0377', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'Zmp1', 'VF0600', '2026-04-01', '2026-04-03');

INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (6, 'p-cresol', 'produces', 'C01468', 'CHEBI:17847', '2026-04-01', '2026-04-03');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (6, 'ethanolamine', 'consumes', 'C00189', 'CHEBI:16000', '2026-04-01', '2026-04-03');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (6, 'N-acetylneuraminic acid (sialic acid)', 'consumes', 'C00270', 'CHEBI:17012', '2026-04-01', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 36894652, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 41641127, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 41039149, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 38786164, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 38584858, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 32129694, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 24503131, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (19, 6, 'Clostridioides difficile was identified as the causative pathogen of diarrhea/colitis in one critically ill ICU patient (Patient 43) who had concurrent progressive fecal Enterobacteriaceae enrichment, representing an incidental CDI case within a 51-patient prospective cohort studying ICU-associated gut dysbiosis.', 'c07400f319e7ef54e0e2f9b1e24e79d0859dc102c804e78562fb83ed812991bd', 'E1', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (19, 'mesh', 'D003428', 'Cross Infection', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (19, 'kegg_disease', 'H00338', 'Pseudomembranous colitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (19, 36894652, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): 481fb29f4366e2985b2b7bb9749a95d38c27b2453ffd7befc93c73cc9ecc6269
-- SKIPPED association (UNCERTAIN grade): 53ab570de2190b3d7ae76a9a78866b0921458369f22205aa7d5d9c1476c8e406
-- SKIPPED association (UNCERTAIN grade): 42811353314537b09e89c6f584d5f2ed13330b4bf6407121139aa044e980c6a2
-- SKIPPED association (UNCERTAIN grade): 2948ef13bef98fd71fca04aa7b3cbd22287714cc5b239278f90cc8b1ab8933d1
-- SKIPPED association (UNCERTAIN grade): e42ee0f3505a01808c37a838630f31ff4b8c3daac4d01f9d957291a280c71b92
-- SKIPPED association (UNCERTAIN grade): 7adf2190fb2881365fd8c2ff531a6b1797147db6b92a2ddb055a6ac1f042cf8b
-- SKIPPED association (UNCERTAIN grade): f7f1fad8026e6113d8041fc82827ba2c9cf01c2cbb055e57178e823986d3b93d
-- SKIPPED association (UNCERTAIN grade): 618dbeef9bca35b51ab61477f41aaf72b2381afcb3780ea6ef9170cb20f6803f
-- SKIPPED association (UNCERTAIN grade): 6dc7720ecf7b42cb6a86b3e5512f74f599c57c51c8b4f32747cd1219caf8764d
-- SKIPPED association (UNCERTAIN grade): 4c5f207d2f90ab6850dd0ab626ed08beff9b6da03534019feef3f7d64c345d9e
-- SKIPPED association (UNCERTAIN grade): b3cc24ce26c59e29e7fa4c5287e46116e51d86ccc220453fba35efa79d6f41f8
-- SKIPPED association (UNCERTAIN grade): 526272340a1319d268a24498ce28a7d94da16b22501d8f57790ea17311a98631
-- SKIPPED association (UNCERTAIN grade): d64a8dbf916dfe2da1f1ffe18865f255c6c3c7bc8d702f9c058ab369809448ae
-- SKIPPED association (UNCERTAIN grade): 03460249e89ad11bc99602a02f247c1b92e013fee7e7caba502212fa16578326
-- SKIPPED association (UNCERTAIN grade): aecc9efa11f1d7f17e33b29050b88f8691e2f1858c8fa146787b0a379dca8f7a
-- SKIPPED association (UNCERTAIN grade): 84f3ff3bdf1fb4da710892f1059cc70256e0f61fa9e044c7b101af1eba7105fc
-- SKIPPED association (UNCERTAIN grade): b2e62c07cc76ae0698742d632050e999c6fad509550acce29e90cbaec7c35c28
-- SKIPPED association (UNCERTAIN grade): c199f315e6b46daca7546b267c6762ee462b613df39882e87ec45c651f7e8d2e
-- SKIPPED association (UNCERTAIN grade): 75519e4b5030d3f5830b3289519b1a2400e1c2d7f881141e33885399d8b7b8fb
-- SKIPPED association (UNCERTAIN grade): a2922228d3d2414254e900f7b296e1657072ce765fff3bf53dbe88a8a6eba019
-- SKIPPED association (UNCERTAIN grade): 00a991e691b0b28be80f0fb720605d865109cfe120aa9a66a157de08ba17752e
-- SKIPPED association (UNCERTAIN grade): ba1eb121598dbad1a924750a92f0abf07dc43e57b6a013ab8fb885818bb5fe73
-- SKIPPED association (UNCERTAIN grade): db32a1ef701352298543161ec8eef97b8d3b8005478d5d27bf35faf6636c4132
-- SKIPPED association (UNCERTAIN grade): 05b171d75c2b6c8cf345f9f6b5079c2c73af1f51410758fe0a1efb47f619c659
-- SKIPPED association (UNCERTAIN grade): 7117676650b8e61a826ba0618f7b5b7b59f86e90abb8c7635dd2ee3f58a8712d
-- SKIPPED association (UNCERTAIN grade): 9752127fc6c0ba5b98f87a35f0fee1fbf06da14edf8038905c5956a3051c673d
-- SKIPPED association (UNCERTAIN grade): 318d2dd4a861c145ab2e08fbd0dab3daf76a58087dc699878291c11f235b1431
-- SKIPPED association (UNCERTAIN grade): 68f393b0c8ed1df1c97e733231c6834dfa8f5d6ff630047ef7c8e887fdf9f686
-- SKIPPED association (UNCERTAIN grade): d66fbcce583a77d757a188c551b00e05a638dbee5f3e5d2fd1be977c0a189d14
-- SKIPPED association (UNCERTAIN grade): 681aed652221537a7d2939b15ceb8c44de7c03ae06570c54585cf6af214350e5
-- SKIPPED association (UNCERTAIN grade): 75a3d36d7114b175512a96a65a292762434093e626f625a707844093d20019e6
-- SKIPPED association (UNCERTAIN grade): d70218adc546f6e43b60f8664e85a15614c9ce2ec51d29576a2377b286c9bb1e
-- SKIPPED association (UNCERTAIN grade): b929bcfbde959fa907773d2e0f0f49e9b744e1921b7a62a607ea016a45eff23e
-- SKIPPED association (UNCERTAIN grade): 255b5fe599ff5378bab7330c911859373d591ef7172dc7713f777ad3d8271cd6
-- SKIPPED association (UNCERTAIN grade): 0675f8845cfa3c23a6d0968f0fdbc04730c89df1752931c28fb095dfd09081d5
-- SKIPPED association (UNCERTAIN grade): cff3bd832be18b8fb60ab0cae1619ddd3a845875985a394c105c98ddd7f24f4f
-- SKIPPED association (UNCERTAIN grade): 1377e34d3e2cefe6d881d34ed71044c2e0fc26a5fa7e8f269f12fc67085fb644
-- SKIPPED association (UNCERTAIN grade): 3f38579f1cbc3d0b5567e2a6164ff9402d5735d46bf1da7fe07211f8fb2bbd15
-- SKIPPED association (UNCERTAIN grade): 2da706c722ee560b1185266ac743cba389e0e96ae737cc88a44c728a6068bbca
-- SKIPPED association (UNCERTAIN grade): 66deb964f33a1a5cd67f1ddc35c4cbbdf1c75e0943dc8fd2d8d8206445288f9d
-- SKIPPED association (UNCERTAIN grade): cb067f81ac2f5e4c4dcda703f39fa7f78ccc351599629e74ad9dffae3e42a113
INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (20, 6, 'Clostridioides difficile is the primary cause of nosocomial gastrointestinal infections in industrialized countries, with incidence, morbidity, and mortality increasing over recent decades.', 'f6d264ec21f3712b95a22bc3c81cf6634b4bb904be81a99410e468781f3d7e55', 'E3', 'narrative review', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (20, 'mesh', 'D003015', 'Clostridium Infections', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (20, 'mesh', 'D003428', 'Cross Infection', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (20, 'kegg_disease', 'H00338', 'Pseudomembranous colitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (20, 38584858, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (21, 6, 'Clostridioides difficile causes pseudomembranous colitis and, when left untreated, can progress to toxic megacolon, a potentially life-threatening complication.', '79c32ba56ce5ee25012484b70592586eced5755d072efde7deca5989b87217c9', 'E3', 'narrative review', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (21, 'mesh', 'D003015', 'Clostridium Infections', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (21, 'mesh', 'D003551', 'Enterocolitis, Pseudomembranous', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (21, 'kegg_disease', 'H00338', 'Pseudomembranous colitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (21, 38584858, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (22, 6, 'Clostridioides difficile colonization is highly prevalent in infants, while fewer than 5% of adults are asymptomatic carriers.', '3d21d22c04c333669b790caaf771231fa8bfb59e35f7a879bc50697c0406bbd2', 'E3', 'narrative review', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (22, 'mesh', 'D003015', 'Clostridium Infections', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (22, 38584858, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (23, 6, 'Antibiotic-induced disruption of the gut microbiome triggers germination of C. difficile spores into vegetative cells that produce enterotoxins, causing watery diarrhea and colonic inflammation.', '6e6790b1852fdffd9e2efd041ca7b1f5006af598ffa542b493d873c6842053eb', 'E3', 'narrative review', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (23, 'mesh', 'D000900', 'Anti-Bacterial Agents', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (23, 'mesh', 'D003015', 'Clostridium Infections', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (23, 'mesh', 'D003967', 'Diarrhea', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (23, 'kegg_disease', 'H00338', 'Pseudomembranous colitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (23, 38584858, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): e0e726a2246722c2619f1bcc65701f2f98712c8d22e3cac775482b17743336b0
-- SKIPPED association (UNCERTAIN grade): ccaec9b650d69972d77df5e97d2d5cf46887ccc623d743fb03869740cb37d886
INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (24, 6, 'In antibiotic-treated mice, cecal cholate levels become elevated while bacterial transformation to secondary bile acids (deoxycholate, lithocholate) is greatly suppressed; this antibiotic-induced shift in the bile acid pool promotes C. difficile spore germination by providing the cholate co-stimulant while removing the inhibitory secondary bile acids that are normally produced by commensal microbiota from primary bile acids.', '676c7bc27aebabbed8754034c6c96006cd0711708bc53f304ef35151f9b55a23', 'E1', 'narrative review of murine experimental and in vitro studies', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (24, 'mesh', 'D001647', 'Bile Acids and Salts', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (24, 'kegg_disease', 'H00338', 'Pseudomembranous colitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (24, 24503131, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): 0c49bd0a3aabe516dc1dbb3c4670602303b18e5d612bf28e49b87beac25b94b2
-- ── MCA-BAC-000007  Eggerthella lenta
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (7, 'MCA-BAC-000007', 'Eggerthella lenta', 'species', 'Bacteria', 'Bacteria; Actinomycetota; Coriobacteriia; Eggerthellales; Eggerthellaceae; Eggerthella', 84112, 'unknown', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (7, 'unknown', 'obligate anaerobe', NULL, NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (7, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (7, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (7, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (7, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (7, 'risk_context', 'post-antibiotic', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (7, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (7, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (25, 7, 'Eggerthella lenta relative abundance was significantly higher in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with disruptions persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', '8fb737ee5a6a62e506735928c0fa0ad2fc6a9ce30ece09e24cdc5f7cb3d11e55', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (25, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (25, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (25, 'mesh', 'D064307', 'Microbiota', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (25, 'mesh', 'D004755', 'Enterobacteriaceae', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (25, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (26, 7, 'Higher Eggerthella lenta relative abundance was positively associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), consistent with a cardiometabolic risk profile.', '47333f0b5e33bd680e405af85421acd0ea70f7248fbf29619a2569b2fb70c0cd', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (26, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (26, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (26, 41814006, '2026-04-01');

-- ── MCA-BAC-000008  Flavonifractor plautii
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (8, 'MCA-BAC-000008', 'Flavonifractor plautii', 'species', 'Bacteria', 'Bacteria; Bacillota; Clostridia; Eubacteriales; Oscillospiraceae; Flavonifractor', 292800, 'unknown', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (8, 'unknown', 'obligate anaerobe', NULL, NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (8, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (8, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (8, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (8, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (8, 'risk_context', 'post-antibiotic', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (8, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (8, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (27, 8, 'Flavonifractor plautii relative abundance was significantly higher in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with disruptions persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', '9193be9d2e5c815a69b9e77ceaf3d7bb7d94b1a235f852e0348e9a38b34ffe97', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (27, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (27, 'mesh', 'D003428', 'Cross Infection', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (27, 'mesh', 'D004755', 'Enterobacteriaceae', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (27, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (28, 8, 'Higher Flavonifractor plautii relative abundance was positively associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), consistent with a cardiometabolic risk profile.', '55ef8e61354fad9f5f12f175691307df9b26b0483b050070121efdd09b0693c9', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (28, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (28, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (28, 41814006, '2026-04-01');

-- ── MCA-BAC-000009  Mediterraneibacter gnavus
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (9, 'MCA-BAC-000009', 'Mediterraneibacter gnavus', 'species', 'Bacteria', 'Bacteria; Bacillota; Clostridia; Lachnospirales; Lachnospiraceae; Mediterraneibacter', 33038, 'unknown', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (9, 'unknown', 'obligate anaerobe', NULL, NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (9, 'synonym', 'Ruminococcus gnavus', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (9, 'synonym', 'Hominicoccus gnavus', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (9, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (9, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (9, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (9, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (9, 'risk_context', 'post-antibiotic', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (9, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (9, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (29, 9, 'Mediterraneibacter gnavus relative abundance was significantly higher in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with disruptions persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', 'edb757f5ff4fd75c714e4aef587929d16e739321155c19c3501c6e62629b498a', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (29, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (29, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (29, 'mesh', 'D004755', 'Enterobacteriaceae', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (29, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (30, 9, 'Higher Mediterraneibacter gnavus relative abundance was positively associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), consistent with a cardiometabolic risk profile.', '17f605b6cccb48cda02fcd7323ff41a9cee828df7117e353b12fdf8e58141b9d', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (30, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (30, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (30, 41814006, '2026-04-01');

-- ── MCA-BAC-000010  Enterocloster bolteae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (10, 'MCA-BAC-000010', 'Enterocloster bolteae', 'species', 'Bacteria', 'Bacteria; Bacillota; Clostridia; Lachnospirales; Lachnospiraceae; Enterocloster', 208479, 'unknown', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (10, 'synonym', 'Clostridium bolteae', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (10, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (10, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (10, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (10, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (10, 'risk_context', 'post-antibiotic', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (10, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (10, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (31, 10, 'Enterocloster bolteae relative abundance was significantly higher in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with disruptions persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', 'dc2396e7e042d319f867ccba491bd3904b183626f1c5ec36fd56dec57119d9bc', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (31, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (31, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (31, 'mesh', 'D064307', 'Microbiota', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (31, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (32, 10, 'Higher Enterocloster bolteae relative abundance was positively associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), consistent with a cardiometabolic risk profile.', '1666042deaece84c238bd9b852ee8d2c011acde66246f9b1174266c208e84080', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (32, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (32, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (32, 41814006, '2026-04-01');

-- ── MCA-BAC-000011  Sellimonas intestinalis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (11, 'MCA-BAC-000011', 'Sellimonas intestinalis', 'species', 'Bacteria', 'Bacteria; Bacillota; Clostridia; Lachnospirales; Lachnospiraceae; Sellimonas', 1653434, 'unknown', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (11, 'gram-positive', 'obligate anaerobe', 'bacillus (rod)', NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (11, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (11, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (11, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (11, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (11, 'risk_context', 'post-antibiotic', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (11, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (11, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (33, 11, 'Sellimonas intestinalis relative abundance was significantly higher in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with disruptions persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', '69d794b9a77aae57ac0fff28bed55e88052d439e0e27725f277e0490ba89d95c', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (33, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (33, 'mesh', 'D003428', 'Cross Infection', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (33, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (34, 11, 'Higher Sellimonas intestinalis relative abundance was positively associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), consistent with a cardiometabolic risk profile.', '39d0188b195e47bff60923098807a12a1d51016dfe0dc3ed489a475a36682d78', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (34, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (34, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (34, 41814006, '2026-04-01');

-- ── MCA-BAC-000012  Alistipes communis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (12, 'MCA-BAC-000012', 'Alistipes communis', 'species', 'Bacteria', 'Bacteria; Bacteroidota; Bacteroidia; Bacteroidales; Rikenellaceae; Alistipes', 2585118, 'unknown', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (12, 'unknown', 'obligate anaerobe', 'bacillus (rod)', NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (12, 'synonym', 'Alistipes obesi', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (12, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (12, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (12, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (12, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (12, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (35, 12, 'Alistipes communis relative abundance was significantly lower in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with depletion effects persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', 'b3f3d272f6e2499e41523c8b6c5070d3ed6d66220199f6d79dc5c3567ac8b032', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (35, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (35, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (35, 'mesh', 'D064307', 'Microbiota', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (35, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (36, 12, 'Lower Alistipes communis relative abundance was inversely associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), with the species showing an inverse relationship to cardiometabolic risk markers.', 'aedeb52462215d83d8e336d3a0017f2e098d06c82220c3add0f48850f4a04b94', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (36, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (36, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (36, 41814006, '2026-04-01');

-- ── MCA-BAC-000013  Odoribacter splanchnicus
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (13, 'MCA-BAC-000013', 'Odoribacter splanchnicus', 'species', 'Bacteria', 'Bacteria; Bacteroidota; Bacteroidia; Bacteroidales; Odoribacteraceae; Odoribacter', 28118, 'unknown', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (13, 'unknown', 'obligate anaerobe', NULL, NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (13, 'synonym', 'Bacteroides splanchnicus', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (13, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (13, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (13, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (13, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (37, 13, 'Odoribacter splanchnicus relative abundance was significantly lower in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with depletion effects persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', '88f8205ac5b7159490336632432bdf0491191b150abc71ba886bf235677dfbf0', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (37, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (37, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (37, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (38, 13, 'Lower Odoribacter splanchnicus relative abundance was inversely associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), with the species showing an inverse relationship to cardiometabolic risk markers.', 'aa13ee78db9b0bce5100d04e816a7b84bf3f76795d25de6d9da335d7ed526c83', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (38, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (38, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (38, 41814006, '2026-04-01');

-- ── MCA-BAC-000014  Clostridium butyricum
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (14, 'MCA-BAC-000014', 'Clostridium butyricum', 'species', 'Bacteria', 'cellular organisms; Bacteria; Bacillati; Bacillota; Clostridia; Eubacteriales; Clostridiaceae; Clostridium', 1492, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (14, 'unknown', 'obligate anaerobe', NULL, 'https://bacdive.dsmz.de/strain/2547', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (14, 'primary_niche', 'environment', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (14, 'reservoir', 'environment', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (14, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-01');

INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (14, 'butyrate', 'produces', 'C00246', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (14, 41641127, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): b8120efc164aef10f2c04ce11137f0d842c52b8f3a8afa46b8bd0b1b645b775d
-- SKIPPED association (UNCERTAIN grade): 9774f0b31b4c4133963403813f022268a2c49f6d0d597dc168178737aca941ff
-- ── MCA-BAC-000015  Akkermansia muciniphila
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (15, 'MCA-BAC-000015', 'Akkermansia muciniphila', 'species', 'Bacteria', 'Bacteria|Verrucomicrobiota|Verrucomicrobiia|Verrucomicrobiales|Akkermansiaceae|Akkermansia', 239935, 'no', '2026-04-03', '2026-04-01', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (15, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/17849', '2026-04-01', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'typical_specimen', 'stool', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'risk_context', 'cancer patients', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'risk_context', 'NSCLC patients receiving PD-1/PD-L1 blockade', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'risk_context', 'RCC patients receiving PD-1/PD-L1 blockade', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'amr_highlight', 'intrinsic glycopeptide resistance (glycopeptides)', NULL, '2026-04-01', '2026-04-03');

INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (15, 'acetate', 'produces', 'C00033', 'CHEBI:30089', '2026-04-01', '2026-04-03');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (15, 'propionate', 'produces', 'C00163', 'CHEBI:17272', '2026-04-01', '2026-04-03');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (15, 'succinate', 'produces', 'C00042', 'CHEBI:26806', '2026-04-01', '2026-04-03');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (15, '1,2-propanediol', 'produces', 'C00583', 'CHEBI:16997', '2026-04-01', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (15, 40544256, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (15, 33542131, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (15, 32129694, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (15, 29097494, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (39, 15, 'Akkermansia muciniphila displays intrinsic resistance to glycopeptide antibiotics, indicating that antimicrobial resistance profiles of novel probiotic organisms may have clinical implications for gut microbiota management in susceptible patient populations.', 'daefafbe17e0d1fa7e1296faea25d05daa273eb794ef0e820adf6c5221bbc13b', 'E1', 'case report', '2026-04-01', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (39, 40544256, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): 5fca0fe0cc91454926a03add703d1044f65aff96515890f43c2a65dfa353a0f9
-- SKIPPED association (UNCERTAIN grade): 0a82cf9dadd22970817f81a663351f264af939fd21aecb0a1df30d3dcd031773
-- SKIPPED association (UNCERTAIN grade): f160d5e4302e963bd864073cd8023bae5f7a6c64de66addb2628e49f594892c9
-- SKIPPED association (UNCERTAIN grade): 6a12081db057cabe2a26516d7a8d24bfd4bf867f1da86d0304dc7a33cda2bb9c
-- SKIPPED association (UNCERTAIN grade): fdcf34374ee503cf2fd4a8851956cceee93eee1c620dd4a798dd7ab13b56fe1f
-- SKIPPED association (UNCERTAIN grade): 1efe7295551bb06a4898cdbfce7e4ba0b972665db7019051b58dd7fd6ec1a105
-- SKIPPED association (UNCERTAIN grade): ccf9a30c465bda7d4df7617af3a7f74dd063dd0885a5b737ac8d070592e53f59
INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (40, 15, 'Akkermansia muciniphila was among organisms enriched in responders (objective response or stable disease >12 months) to FMT plus pembrolizumab in a Phase 2 trial of 15 PD-1-refractory advanced melanoma patients; transkingdom network analysis identified it as negatively correlated with circulating CXCL8 (IL-8), an immunosuppressive cytokine elevated in non-responders and associated with immune checkpoint blockade resistance.', '3d0ac5a41be10ac3d04f10e7de015cd65cd335e2c6abf34c44a30e54f4d6511a', 'E2', 'phase 2 clinical trial', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (40, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (40, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (40, 33542131, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): 65b663a481e532be0154ef680655e2dc7034b0df538979b13a564cfa151b0d4c
INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (41, 15, 'Akkermansia muciniphila was enriched in the gut microbiome of non-responders to cancer therapeutics (immune checkpoint blockade, platinum-based chemotherapy, EGFR TKI) compared with responders among patients with advanced NSCLC (stage IIIB/IV), identified by LEfSe analysis of 16S rRNA gut metagenomics; the authors note that immunomodulatory effects of gut microbiota on cancer therapy may differ by cancer type, race, and geography.', '62e1471a4ef0db9c8989ca5489c020ac86887c9c3b4025f999354b73a5af7583', 'E2', 'cohort study', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (41, 'mesh', 'D002289', 'Carcinoma, Non-Small-Cell Lung', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (41, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (41, 'kegg_disease', 'H00014', 'Non-small cell lung cancer', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (41, 33432149, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (42, 15, 'Higher pre-treatment stool abundance of A. muciniphila was significantly associated with clinical response and longer progression-free survival in NSCLC and RCC patients receiving PD-1/PD-L1 blockade; A. muciniphila was detectable in 69% (11/16) of partial responders vs. 34% (15/44) of progressors (P=0.007) in the discovery metagenomics cohort (n=100), with findings replicated in two independent validation cohorts (n=53 NSCLC+RCC and n=239 NSCLC).', '8303fed7b10f1d99f132bd40fbfb257a7d13a11393409165144195c7321781a2', 'E3', 'multi-cohort metagenomics study', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (42, 'mesh', 'D002289', 'Carcinoma, Non-Small-Cell Lung', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (42, 'mesh', 'D002292', 'Carcinoma, Renal Cell', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (42, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (42, 'kegg_disease', 'H00014', 'Non-small cell lung cancer', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (42, 'kegg_disease', 'H00021', 'Renal cell carcinoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (42, 29097494, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (43, 15, 'Antibiotic use (β-lactams, fluoroquinolones, or macrolides) within 2 months before or 1 month after initiation of PD-1/PD-L1 mAb was independently associated with significantly shorter progression-free survival and overall survival in 249 patients with NSCLC, RCC, and urothelial carcinoma (median OS: 15.3 vs. 8.3 months; P<0.001), confirmed in 239 additional NSCLC patients, implicating antibiotic-mediated gut dysbiosis — including depletion of A. muciniphila — as a driver of primary ICI resistance.', '5cb9c8c5e1a15146d6791ba5091985143a46305dd2fd8bdfc1e580aa679c1807', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (43, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (43, 'mesh', 'D000900', 'Anti-Bacterial Agents', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (43, 'mesh', 'D002289', 'Carcinoma, Non-Small-Cell Lung', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (43, 'kegg_disease', 'H00014', 'Non-small cell lung cancer', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (43, 'kegg_disease', 'H00021', 'Renal cell carcinoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (43, 'kegg_disease', 'H00022', 'Bladder cancer', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (43, 29097494, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (44, 15, 'Fecal microbiota transplantation from ICI-responding NSCLC/RCC patients into germ-free or antibiotic-treated mice conferred sensitivity to PD-1 blockade, increasing CXCR3+CD4+ tumor-infiltrating lymphocytes and PD-L1 expression on splenic T cells; FMT from non-responders conveyed resistance to PD-1 blockade, establishing a causal role for gut microbiome composition — including A. muciniphila — in determining ICI efficacy.', '4462bca0bd7954b00175483740a258b648fea65abb693e4a848e72d6b828e802', 'E1', 'mouse model (FMT)', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (44, 'mesh', 'D000069467', 'Fecal Microbiota Transplantation', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (44, 'mesh', 'D009369', 'Neoplasms', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (44, 29097494, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (45, 15, 'Oral supplementation with A. muciniphila in antibiotic-dysbiotic mice restored PD-1 blockade antitumor efficacy against RET melanoma, MCA-205 sarcoma, and orthotopic LLC lung cancers in an IL-12-dependent manner, increasing CCR9+CXCR3+CD4+ central memory T cell recruitment into mesenteric lymph nodes and tumor beds, and elevating intratumoral CD4+/FoxP3+ ratios.', '7d2caedf7f3a120a3f897817fd27bc92326b4058fe5cfa3629aa0fe0149fd32e', 'E1', 'mouse model (oral gavage)', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (45, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (45, 'mesh', 'D009369', 'Neoplasms', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (45, 29097494, '2026-04-01');

-- ── MCA-FUN-000001  Aspergillus terreus
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (16, 'MCA-FUN-000001', 'Aspergillus terreus', 'species', 'Fungi', 'Eukaryota|Fungi|Ascomycota|Eurotiomycetes|Eurotiales|Aspergillaceae|Aspergillus', 33178, 'context dependent', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (16, 'not applicable', 'aerobe', 'mold', NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (16, 'synonym', 'Aspergillus terrestris', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (16, 'primary_niche', 'environment', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (16, 'primary_niche', 'lung', 'D008168', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (16, 'reservoir', 'environment', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (16, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (16, 'typical_specimen', 'bronchoalveolar lavage (BAL)', 'D018893', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (16, 'risk_context', 'immunocompromised patients', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (16, 'risk_context', 'solid organ transplant recipients', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (16, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (46, 16, 'Aspergillus terreus was isolated from bronchoalveolar lavage in a post-allogeneic HSCT patient with B-cell ALL, causing invasive pulmonary aspergillosis that required combination antifungal therapy with isavuconazole and caspofungin.', '1a632710f0a6fa8c02d3e109e150c047566cdfd832b540f78a6d6b5ea1bfdcad', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (46, 'kegg_disease', 'H01328', 'Aspergillosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (46, 40544256, '2026-04-01');

-- ── MCA-BAC-000016  Bifidobacterium
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (17, 'MCA-BAC-000016', 'Bifidobacterium', 'genus', 'Bacteria', 'Bacteria|Actinomycetota|Actinomycetes|Bifidobacteriales|Bifidobacteriaceae', 1678, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (17, 'unknown', 'unknown', NULL, NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (17, 'synonym', 'Bifidibacterium', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (17, 'synonym', 'Tissieria', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (17, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (17, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (17, 'amr_highlight', 'intrinsic glycopeptide resistance (vancomycin; lacks acquired vanA/vanB/vanC genes)', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (17, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (47, 17, 'Bifidobacterium species display intrinsic vancomycin resistance but lack acquired resistance genes (vanA, vanB, vanC) and have fewer reported associations with bloodstream infections compared to Lacticaseibacillus spp., suggesting a relatively lower BSI risk profile for immunocompromised patients receiving Bifidobacterium-containing probiotics.', '7bd46fa2805f950ca14842f55f2b932cb1763248a3ddcd552fd51e9b1d271abb', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (47, 40544256, '2026-04-01');

-- ── MCA-BAC-000017  Clostridium scindens
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (18, 'MCA-BAC-000017', 'Clostridium scindens', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Clostridia|Lachnospirales|Lachnospiraceae|Clostridium', 28264, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (18, 'gram-positive', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/2748', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (18, 'synonym', 'Eubacterium scindens', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (18, 'key_trait', 'secondary bile acid producer (7α-dehydroxylating)', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (18, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (18, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (18, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (18, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (18, 'deoxycholic acid', 'produces', 'C04483', NULL, '2026-04-01', '2026-04-01');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (18, 'lithocholic acid', 'produces', 'C03990', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (18, 41039149, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): 3f6de8091d1b75c42bf98e9d3d0a3a0aef312ed472d95f86bd490b4c11971267
-- SKIPPED association (UNCERTAIN grade): ce68a115fb46d426db5bb6b01c603a5a0696f568fffbde6312e2daaea9e24e20
-- ── MCA-BAC-000018  Enterococcus faecalis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (19, 'MCA-BAC-000018', 'Enterococcus faecalis', 'species', 'Bacteria', 'Bacteria|Bacillota|Bacilli|Lactobacillales|Enterococcaceae|Enterococcus', 1351, 'context dependent', '2026-04-02', '2026-04-01', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (19, 'gram-positive', 'facultative anaerobe', 'coccus', 'https://bacdive.dsmz.de/strain/5279', '2026-04-01', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Enterococcus proteiformis', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Enterocoque', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Micrococcus ovalis', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Micrococcus zymogenes', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Streptococcus faecalis', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Streptococcus glycerinaceus', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Streptococcus liquefaciens', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'primary_niche', 'urinary tract', 'D014551', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'reservoir', 'animal', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'role', 'commensal', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'typical_specimen', 'wound swab', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'risk_context', 'immunocompromised patients', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Ace', 'VF0355', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'AS', 'VF0352', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'BopD', 'VF0362', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Capsule', 'VF0361', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Cytolysin', 'VF0356', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Ebp pili', 'VF0538', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'EfaA', 'VF0354', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Esp', 'VF0353', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Fsr', 'VF0360', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Gelatinase', 'VF0357', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Hyaluronidase', 'VF0359', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'SprE', 'VF0358', '2026-04-01', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (19, 40544256, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (19, 29590047, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (48, 19, 'Enterococcus faecalis was isolated from a wound swab in a post-HSCT immunocompromised patient with B-cell ALL; treatment with cefepime was initiated but discontinued due to cefepime-induced neurotoxicity.', '20f4d782fe6c10dc2eec8bba94b3b0bb26b21e0922ae4dd0dea129cfa77ceb6d', 'E1', 'case report', '2026-04-01', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (48, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (49, 19, 'GF C57BL/6 mice monocolonized with E. faecalis (n=6–10) showed translocation to mesenteric veins, MLNs, and liver but did NOT develop gut barrier leakage (FITC-dextran not elevated), anti-RNA IgG, or anti-dsDNA IgG autoantibodies at 8 weeks post-colonization, in contrast to E. gallinarum-monocolonized mice; Th17 cells were not expanded in small intestinal lamina propria or MLNs (n=5 per group).', 'fedfc396fbf0bbf60e7df3178279d695353ef7d2d7a1a7560af22ee035d8880f', 'E2', 'animal model', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (49, 'mesh', 'D018988', 'Bacterial Translocation', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (49, 'mesh', 'D001323', 'Autoantibodies', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (49, 'mesh', 'D015551', 'Autoimmunity', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (49, 29590047, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (50, 19, 'E. faecalis lysate or RNA induced significantly lower expression of ERV gp70, β2-glycoprotein I, type I IFN-α, and AhR/CYP1A1 in murine and human hepatocytes compared to E. gallinarum (ANOVA, p<0.05 to p<0.0001, n=3 each); serum anti-E. faecalis RNA IgG was not elevated in SLE (n=15) or AIH (n=17) patients relative to healthy controls (n=9), distinguishing it from E. gallinarum.', 'bfa32e7dfa088d21075ed9e423b74308ba3bc677cbd1d7774cbdf3510527b679', 'E2', 'mixed: in vitro + case-control', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (50, 'mesh', 'D022781', 'Hepatocytes', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (50, 'mesh', 'D008180', 'Lupus Erythematosus, Systemic', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (50, 'mesh', 'D019693', 'Hepatitis, Autoimmune', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (50, 29590047, '2026-04-01');

-- ── MCA-BAC-000019  Fusobacterium nucleatum
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (20, 'MCA-BAC-000019', 'Fusobacterium nucleatum', 'species', 'Bacteria', 'Bacteria|Fusobacteriota|Fusobacteriia|Fusobacteriales|Fusobacteriaceae|Fusobacterium', 851, 'context dependent', '2026-04-01', '2026-04-01', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (20, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', NULL, '2026-04-01', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'synonym', 'Fusobacterium fusiforme', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'synonym', 'Fusobacterium plauti-vincenti', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'key_trait', 'biofilm-forming', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'primary_niche', 'oral cavity', 'D009055', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'transmission_route', 'oral-gut translocation (oral-to-gut; facilitated by Fn resistance to acidic pH and OMV-mediated systemic dissemination)', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'role', 'primary pathogen', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'role', 'commensal', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'role', 'biofilm former', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'role', 'coloniser', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'typical_specimen', 'biopsy', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'typical_specimen', 'unknown', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'risk_context', 'colorectal cancer', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'risk_context', 'inflammatory bowel disease (IBD)', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'risk_context', 'periodontitis patients', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'risk_context', 'rheumatoid arthritis', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'amr_highlight', 'unknown', NULL, '2026-04-01', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (20, 39456922, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): 5c5957c70b1d1c51eef6feb67af78761c8577c57c1f3f3f5e148a881d856ac8c
-- SKIPPED association (UNCERTAIN grade): 29d7f0fca1ac1799a265bcce49672acee99f650aac13167b23294722fc197719
-- SKIPPED association (UNCERTAIN grade): b9fcb63a3a8862a2ef861c1c7d22b724b5f67b35f0e286ef9284e381ee0eff5f
-- SKIPPED association (UNCERTAIN grade): 82cd87b9deacd8b3748f5fbfc20bfe7167a2d60e92091779c8986bf3724c063f
-- SKIPPED association (UNCERTAIN grade): 5c0dfd41a1be3b134682ba84a2ff215510822caed9a715c78390db5663d91aaf
-- SKIPPED association (UNCERTAIN grade): dca363784a775bceefb2650dbe6e7f49f024615cf17c839be307f1466b62320e
-- SKIPPED association (UNCERTAIN grade): d4c7e4aafab44abc7005551fbf6ab8ff41ee28e4699b9ea496377fbbd08f969d
-- SKIPPED association (UNCERTAIN grade): aa0e0eb36f11035b5f666d3a2fa457aa2db174e79cea4ba78468350c3109e130
-- SKIPPED association (UNCERTAIN grade): 43f09dc0f0c658a878e23b866c820c77a6b3ed65be95311a29e6958a09cc2600
-- ── MCA-BAC-000020  Lacticaseibacillus rhamnosus
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (21, 'MCA-BAC-000020', 'Lacticaseibacillus rhamnosus', 'species', 'Bacteria', 'Bacteria|Bacillota|Bacilli|Lactobacillales|Lactobacillaceae|Lacticaseibacillus', 47715, 'context dependent', '2026-04-01', '2026-04-01', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (21, 'gram-positive', 'facultative anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/6423', '2026-04-01', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'synonym', 'Lactobacillus rhamnosus', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'synonym', 'Lactobacillus casei subsp. rhamnosus', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'synonym', 'Lactobacillus casei rhamnosus', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'primary_niche', 'oral cavity', 'D009055', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'primary_niche', 'vagina', 'D014621', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'reservoir', 'food', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'role', 'commensal', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'typical_specimen', 'blood', 'D001769', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'risk_context', 'immunocompromised patients', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'risk_context', 'hematopoietic cell transplant recipients', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'bloom_trigger', 'immunosuppression', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'bloom_trigger', 'chemotherapy', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'amr_highlight', 'intrinsic glycopeptide resistance (teicoplanin and vancomycin)', NULL, '2026-04-01', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (21, 40544256, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (21, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (51, 21, 'Gut intestinal domination by Lacticaseibacillus rhamnosus (71.6% relative abundance by shotgun metagenomics) was temporally associated with bloodstream infection in a post-allogeneic HSCT patient with B-cell ALL; genomic comparison between the gut-dominant strain and the blood culture isolate revealed only 18 SNP differences, supporting direct gut-to-bloodstream translocation as the mechanism of bacteremia.', 'a9d5b9c30cd4078445d42d3ac1c40636921257f830a97781518f6c48f5e04419', 'E1', 'case report', '2026-04-01', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (51, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (52, 21, 'Lacticaseibacillus rhamnosus was isolated from multiple concurrent blood culture sites (PICC, CVC, peripheral vein) in a severely immunocompromised post-HSCT patient during the final week of life, with markedly elevated sepsis markers (procalcitonin 2.4 ± 1.87 ng/L; D-dimer 7518 ± 2801.7 ng/mL), contributing to a fatal multi-organ toxicity outcome.', 'adb6a07e58e8cd545e160263ee29c3569e87f3215383e88af41cb87b6e20e56c', 'E1', 'case report', '2026-04-01', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (52, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (53, 21, 'Lacticaseibacillus rhamnosus demonstrates intrinsic resistance to glycopeptides (teicoplanin and vancomycin) with no established EUCAST breakpoints, complicating antimicrobial management of Lactobacillus bloodstream infections in immunocompromised patients.', 'eb347ce8f63e7ca7d40f75d8e98502e5b4c597229d0dbfbad5ef67e558b23f46', 'E1', 'case report', '2026-04-01', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (53, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (54, 21, 'Lactobacillus rhamnosus GG (LGG)–based probiotic administration to germ-free mice colonized with an ICB complete responder\'s microbiota significantly impaired antitumor response to anti-PD-L1 therapy, resulting in significantly larger tumors compared to sterile water control (P=0.01 by likelihood ratio test in linear mixed model; n=4–5 per group), with concomitant reduction in gut microbiome alpha diversity (inverse Simpson index, P=0.38 vs. control — non-significant trend).', 'edb0361ca93b768811890b7a3f68b878d1fdbb32a730ce274fa451b179f1867e', 'E1', 'preclinical murine model', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (54, 'mesh', 'D008546', 'Melanoma, Experimental', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (54, 'mesh', 'D019936', 'Probiotics', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (54, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (54, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (54, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (55, 21, 'LGG-based probiotic administration significantly reduced the frequency of IFN-γ–positive CD8+ cytotoxic T cells in the tumor microenvironment of anti-PD-L1–treated melanoma-bearing germ-free mice (P=0.03 by supervised flow cytometry analysis; n=6 per group), indicating suppression of intratumoral cytotoxic T cell responses as a mechanism of impaired ICB efficacy.', '7df76d823b1b9a0eeeb9720641044c821966ab1c9479e365e7b68643124bd27e', 'E1', 'preclinical murine model', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (55, 'mesh', 'D008546', 'Melanoma, Experimental', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (55, 'mesh', 'D013601', 'T-Lymphocytes', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (55, 'mesh', 'D019936', 'Probiotics', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (55, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (55, 34941392, '2026-04-01');

-- ── MCA-BAC-000021  Pediococcus acidilactici
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (22, 'MCA-BAC-000021', 'Pediococcus acidilactici', 'species', 'Bacteria', 'Bacteria|Bacillota|Bacilli|Lactobacillales|Lactobacillaceae|Pediococcus', 1254, 'unknown', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (22, 'gram-positive', 'facultative anaerobe', 'coccus', 'https://bacdive.dsmz.de/strain/6379', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (22, 'synonym', 'Pediococcus lindneri', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (22, 'synonym', 'Pediococcus lolii', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (22, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (22, 'primary_niche', 'oral cavity', 'D009055', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (22, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (22, 'reservoir', 'food', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (22, 'reservoir', 'environment', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (22, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (22, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (56, 22, 'Pediococcus acidilactici was the second most abundant species in the gut microbiome (17.4% by shotgun metagenomics) at the time of Lacticaseibacillus rhamnosus bloodstream infection in a post-HSCT patient with B-cell ALL, co-dominating a markedly dysbiotic Bacillota-predominant microbiome (98.5% Bacillota total).', '1cf0f1934039383a94ea777a63fba0b4fc0726253e01c67aca6422f005955cf9', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (56, 40544256, '2026-04-01');

-- ── MCA-BAC-000022  Porphyromonas gingivalis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (23, 'MCA-BAC-000022', 'Porphyromonas gingivalis', 'species', 'Bacteria', 'Bacteria|Bacteroidota|Bacteroidia|Bacteroidales|Porphyromonadaceae|Porphyromonas', 837, 'yes', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (23, 'gram-negative', 'obligate anaerobe', 'coccobacillus', NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'synonym', 'Bacteroides gingivalis', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'key_trait', 'biofilm-forming', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'primary_niche', 'oral cavity', 'D009055', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'transmission_route', 'oral-gut translocation (oral-to-gut; facilitated by Pg resistance to acidic pH)', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'role', 'primary pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'role', 'biofilm former', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'typical_specimen', 'blood', 'D001769', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'typical_specimen', 'unknown', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'risk_context', 'periodontitis patients', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'risk_context', 'rheumatoid arthritis', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'risk_context', 'type 1 diabetes', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'risk_context', 'non-alcoholic fatty liver disease (NAFLD) patients', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'risk_context', 'diabetic retinopathy patients', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'risk_context', 'pregnancy complications', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'bloom_trigger', 'proton pump inhibitor (PPI) use', 'D00455', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'bloom_trigger', 'dietary change (high-fat Western diet)', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (23, 'amr_highlight', 'unknown', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (23, 39456922, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): 3f3fc1d79ad4f22a18c324c81fdd009850fd2a9d642bcb148c42a9247fd03da1
-- SKIPPED association (UNCERTAIN grade): 847a7d34c7201157d6b0371d5c87170233d2ab1e0610042cff9d82b03af42ffd
-- SKIPPED association (UNCERTAIN grade): b9e7e8145db35411208be3e91727eba7f8abea8becdf888f37ac27c396cf9e61
-- SKIPPED association (UNCERTAIN grade): cb1d5ce0e48331250f39d2bfb49e2cb3756be119a418265d3a1c356f20d68377
-- SKIPPED association (UNCERTAIN grade): dd499c375a3566aca1a75b9fe4d743b0a85b53b636d070cdb830e040f65ed6e3
-- SKIPPED association (UNCERTAIN grade): 637b9a5672072f266c160b9ba406ca0cecae82086c734b0d907c043223145738
-- SKIPPED association (UNCERTAIN grade): 1ec1e48961cf718ace4886da08dff040d63cc945b22a7932c68ab34520513fc7
-- SKIPPED association (UNCERTAIN grade): b396cc50093537966f9ecaeb435ff8d40446b5169114a7a8be626f364f5720fe
-- SKIPPED association (UNCERTAIN grade): 70f4094963ed871cee011676f39903f0673f5deee935e247f7ec85c7b442e42f
-- SKIPPED association (UNCERTAIN grade): 98eb3a3a63b1c76df5d0fd09f338ccbfb47dfcbd02fd1cf8f2524d13e443ab1d
-- SKIPPED association (UNCERTAIN grade): 9b5af69f08b245a93e6ca452467e12c584f336fc41379ef06f69e01d3dc1a7b9
-- SKIPPED association (UNCERTAIN grade): 56ef71c7951b651cddc2878be8be6595a9cc53af3c438bbc01524132ec1510be
-- SKIPPED association (UNCERTAIN grade): 6e9faf3fda6839f64225e3edede1ff3388d093a1edcf13ede3b8709db4bf29c7
-- ── MCA-BAC-000023  Staphylococcus epidermidis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (24, 'MCA-BAC-000023', 'Staphylococcus epidermidis', 'species', 'Bacteria', 'Bacteria|Bacillota|Bacilli|Bacillales|Staphylococcaceae|Staphylococcus', 1282, 'context dependent', '2026-04-02', '2026-04-01', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (24, 'gram-positive', 'facultative anaerobe', 'coccus', 'https://bacdive.dsmz.de/strain/14522', '2026-04-01', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'synonym', 'Albococcus epidermidis', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'synonym', 'Micrococcus epidermidis', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'synonym', 'Staphylococcus epidermidis albus', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'primary_niche', 'skin', 'D012867', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'role', 'commensal', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'typical_specimen', 'blood', 'D001769', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'risk_context', 'immunocompromised patients', NULL, '2026-04-01', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (24, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (57, 24, 'Staphylococcus epidermidis caused a catheter-related bloodstream infection during conditioning chemotherapy in a 20-year-old immunocompromised patient undergoing allogeneic HSCT for B-cell ALL, treated empirically with meropenem, vancomycin, and liposomal amphotericin B.', '743fed55fc4a5263dc1329822925c55eba2f48e5706a17642404589be5bdb4eb', 'E1', 'case report', '2026-04-01', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (57, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (58, 24, 'A multidrug-resistant S. epidermidis clone (ST5R, cfr on plasmid pMB151a, also resistant to methicillin, levofloxacin, trimethoprim-sulfamethoxazole, and gentamicin) caused 31 of 39 (79%) linezolid-resistant bloodstream infections in leukemia patients at a major cancer center; prior linezolid use in the preceding 90 days was significantly more common in patients with linezolid-resistant vs linezolid-susceptible ST5 infections (79% vs 19%; P<0.001), and cumulative linezolid exposure was significantly higher (median 12 vs 0 days; P<0.001), indicating that both nosocomial clonal transmission and antibiotic selection pressure drove invasive multidrug-resistant S. epidermidis emergence.', '1de6313d5c8378226816ac8f2c65f602ca2b7f772fb4f120d65dacd3a06a6aec', 'E2', 'retrospective single-center cohort (WGS phylogenomics + pharmacy records, MD Anderson Cancer Center, 2013–2016, N=176 bloodstream isolates)', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (58, 'mesh', 'D024901', 'Drug Resistance, Multiple, Bacterial', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (58, 'mesh', 'D013203', 'Staphylococcal Infections', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (58, 'mesh', 'D000069349', 'Linezolid', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (58, 'mesh', 'D013212', 'Staphylococcus epidermidis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (58, 'mesh', 'D000073602', 'Antimicrobial Stewardship', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (58, 'kegg_disease', 'H01401', 'Methicillin-resistant Staphylococcus epidermidis (MRSE) infection', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (58, 29546356, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (59, 24, 'Prolonged linezolid use was associated with progressive domination of the gastrointestinal microbiome by cfr-containing S. epidermidis in leukemia patients undergoing induction chemotherapy: 10 of 98 patients developed staphylococcal GI emergence (≥30% consecutive 16S rRNA reads mapping to Staphylococcus from a ≤10% baseline), all 10 had received linezolid before staphylococcal proliferation (P<0.001 Mann-Whitney for linezolid duration in emergence vs non-emergence patients), and marked increases in cfr abundance in stool were confirmed by RT-qPCR during or following linezolid therapy in 5 of 6 confirmed S. epidermidis cases.', '48c56027c182e866e30e15b307ba81e1856bb97c31972167ddd74ea95f64c0d6', 'E2', 'retrospective cohort with serial 16S rRNA microbiome analysis and RT-qPCR (MD Anderson Cancer Center; N=98 acute myelogenous leukemia patients)', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (59, 'mesh', 'D064307', 'Microbiota', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (59, 'mesh', 'D005243', 'Feces', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (59, 'mesh', 'D000069349', 'Linezolid', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (59, 'mesh', 'D013212', 'Staphylococcus epidermidis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (59, 'mesh', 'D024901', 'Drug Resistance, Multiple, Bacterial', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (59, 'kegg_disease', 'H01401', 'Methicillin-resistant Staphylococcus epidermidis (MRSE) infection', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (59, 29546356, '2026-04-01');

-- ── MCA-BAC-000024  Bifidobacterium animalis subsp. lactis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (25, 'MCA-BAC-000024', 'Bifidobacterium animalis subsp. lactis', 'subspecies', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Actinomycetota|Actinomycetes|Bifidobacteriales|Bifidobacteriaceae|Bifidobacterium|Bifidobacterium animalis', 302911, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (25, 'gram-positive', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/1733', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (25, 'synonym', 'Bifidobacterium lactis', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (25, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (25, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (25, 'reservoir', 'animal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (25, 'reservoir', 'food', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (25, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (25, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (25, 38584858, '2026-04-01');

-- ── MCA-BAC-000025  Bifidobacterium longum
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (26, 'MCA-BAC-000025', 'Bifidobacterium longum', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Actinomycetota|Actinomycetes|Bifidobacteriales|Bifidobacteriaceae|Bifidobacterium', 216816, 'no', '2026-04-03', '2026-04-01', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (26, 'unknown', 'obligate anaerobe', NULL, 'https://bacdive.dsmz.de/strain/1709', '2026-04-01', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'reservoir', 'food', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'role', 'commensal', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-01', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (26, 34941392, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (26, 33542131, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (60, 26, 'Bifidobacterium longum 35624–based probiotic administration to germ-free mice colonized with an ICB complete responder\'s microbiota significantly impaired antitumor response to anti-PD-L1 therapy, resulting in significantly larger tumors compared to sterile water control (P=0.04 by likelihood ratio test in linear mixed model; n=4–5 per group), with concomitant reduction in gut microbiome alpha diversity (inverse Simpson index).', 'bae3fcbb9f0752c33974e4c8be2ca391b5fd2f419a2feaa579fc5ba1a8674337', 'E1', 'preclinical murine model', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (60, 'mesh', 'D008546', 'Melanoma, Experimental', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (60, 'mesh', 'D019936', 'Probiotics', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (60, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (60, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (60, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (61, 26, 'B. longum 35624–based probiotic administration significantly reduced the frequency of IFN-γ–positive CD8+ cytotoxic T cells in the tumor microenvironment of anti-PD-L1–treated melanoma-bearing germ-free mice (P=0.03 by supervised flow cytometry analysis; n=6 per group), indicating suppression of intratumoral cytotoxic T cell responses as a mechanism of impaired ICB efficacy.', 'd723d75d48041374df92b26d9995be224f8247d82441728070304daad45d69e5', 'E1', 'preclinical murine model', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (61, 'mesh', 'D008546', 'Melanoma, Experimental', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (61, 'mesh', 'D013601', 'T-Lymphocytes', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (61, 'mesh', 'D019936', 'Probiotics', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (61, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (61, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (62, 26, 'Bifidobacterium longum was among bacterial species enriched in responders (objective response or stable disease >12 months) to FMT plus pembrolizumab in a Phase 2 trial of 15 PD-1-refractory advanced melanoma patients (NCT03341143), confirming its previously reported association with favorable anti-PD-1 response in human melanoma.', 'dadec1b1d3d2533851659bbed679bfafd97b182586322ae78ce5a65fa81579a3', 'E2', 'phase 2 clinical trial', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (62, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (62, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (62, 33542131, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (63, 26, 'Bifidobacterium longum was among 8 commensal species significantly enriched in pre-treatment stool of metastatic melanoma anti-PD-1 responders (n=16) versus non-responders (n=26) by integrated 16S rRNA, shotgun metagenomic, and qPCR analysis (P<0.05, permutation test); fecal microbiota from responding patients conveyed improved tumor control and augmented CD8+ T cell infiltration in germ-free mouse recipients.', '0dee0ec734a6efb678192830b1a1e5def18c532dab9c2f5d0e861150076f0d0d', 'E2', 'prospective observational cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (63, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (63, 'mesh', 'D007167', 'Immunotherapy', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (63, 'mesh', 'D061026', 'Programmed Cell Death 1 Receptor', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (63, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (63, 29302014, '2026-04-01');

-- ── MCA-BAC-000026  Enterococcus gallinarum
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (27, 'MCA-BAC-000026', 'Enterococcus gallinarum', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Bacilli|Lactobacillales|Enterococcaceae|Enterococcus', 1353, 'yes', '2026-04-02', '2026-04-01', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (27, 'unknown', 'microaerophile', NULL, 'https://bacdive.dsmz.de/strain/5310', '2026-04-01', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'primary_niche', 'gut', 'D041981', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'reservoir', 'animal', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'role', 'coloniser', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'typical_specimen', 'biopsy', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'risk_context', 'immunocompromised patients', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'risk_context', 'systemic lupus erythematosus (SLE)', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'risk_context', 'autoimmune hepatitis (AIH)', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'risk_context', 'genetic predisposition to autoimmunity', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'risk_context', 'impaired gut barrier function', NULL, '2026-04-01', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'bloom_trigger', 'inflammation', NULL, '2026-04-01', '2026-04-02');

INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (27, 'tryptophan-derived AhR ligands (indoles)', 'produces', 'C00463', NULL, '2026-04-01', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (27, 35831502, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (27, 29590047, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (64, 27, 'Enterococcus gallinarum undergoes within-host evolution into mucosally-adapted lineages that exhibit significantly increased translocation to the mesenteric lymph nodes and liver compared to luminal lineages in germ-free monocolonised mice.', '35492a317f412c60dd6fdda302b45bbae35aa94bb6a184caa8ad31fbc10f00e3', 'E1', 'animal model', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (64, 'mesh', 'D018988', 'Bacterial Translocation', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (64, 'mesh', 'D008099', 'Liver', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (64, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (65, 27, 'Enterococcus gallinarum mucosally-adapted liver isolates exhibit significantly increased resistance to lysozyme-mediated growth inhibition, cathelicidin-related antimicrobial peptide (mCRAMP) killing, and macrophage phagocytosis compared to luminal faecal isolates in vitro.', 'ec5001724ce58cdd42ee76ecfda34d67ded1fc57347279af966801de42321a7d', 'E1', 'in vitro', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (65, 'mesh', 'D054884', 'Host-Pathogen Interactions', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (65, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (66, 27, 'Enterococcus gallinarum liver-adapted isolates induce increased intestinal permeability and reduced epithelial barrier defences, including decreased mucus production, reduced intraepithelial lymphocyte recruitment, and altered tight junction protein expression, in germ-free monocolonised mice.', '5e4026c1143d665f8a6259c4c771c4f96ae890e9b8e9a51379a60a9a13f63d7c', 'E1', 'animal model', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (66, 'mesh', 'D007413', 'Intestinal Mucosa', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (66, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (67, 27, 'Enterococcus gallinarum liver-adapted isolates induce increased hepatic inflammatory gene expression, including upregulation of pro-inflammatory cytokines, interferon-stimulated genes, serum amyloid A proteins, and collagen, compared to faecal isolates in germ-free monocolonised mice.', '4ca1c31461ae33d3c8bd80eea059bfcde66a4f11aa1a8a971766a8d1dc6a3f09', 'E1', 'animal model', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (67, 'mesh', 'D008099', 'Liver', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (67, 'mesh', 'D007249', 'Inflammation', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (67, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (68, 27, 'Enterococcus gallinarum translocation to the liver exacerbates lupus-like autoimmune manifestations including hepatosplenomegaly, proteinuria, and elevated anti-dsDNA autoantibodies in a TLR7 agonist (imiquimod)-induced autoimmunity mouse model.', 'cf365abb895359749a8faf70725c4ef8318f4380dce2926687767e964ccf3bce', 'E1', 'animal model', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (68, 'mesh', 'D008180', 'Lupus Erythematosus, Systemic', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (68, 'kegg_disease', 'H00080', 'Systemic lupus erythematosus', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (68, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (69, 27, 'Enterococcus gallinarum mucosally-adapted isolates produce an enhanced capsular polysaccharide layer that facilitates evasion of innate immune recognition and is associated with increased liver translocation in germ-free monocolonised mice.', '739b3002124cc77d311f38fcced3e3ea15e5072d05853c19cf11fc0e962e59a2', 'E1', 'animal model', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (69, 'mesh', 'D054884', 'Host-Pathogen Interactions', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (69, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (70, 27, 'Enterococcus gallinarum has been detected in liver biopsies from patients with autoimmune hepatitis and primary sclerosing cholangitis, as reported in prior studies cited by the authors; this finding motivated the in vivo translocation experiments in this paper.', '47ee33231a2bd563309b16ad68ad03953c2aa72e058ca53e86f39431ef2a6acc', 'E1', 'cited clinical observation', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (70, 'mesh', 'D019693', 'Hepatitis, Autoimmune', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (70, 'mesh', 'D015209', 'Cholangitis, Sclerosing', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (70, 'kegg_disease', 'H01685', 'Autoimmune hepatitis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (70, 'kegg_disease', 'H01684', 'Primary sclerosing cholangitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (70, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (71, 27, 'E. gallinarum was detected by species-specific PCR and immunostaining in liver biopsies of 3/3 tested SLE patients and 5/6 tested AIH patients but in 0/6 healthy cadaveric liver donor controls; 16S rDNA sequencing showed Enterococcus spp. predominance in AIH and cirrhosis liver tissues relative to healthy controls (human case-control).', '32f0ba800580e679ab84e6d210c364f185e07f89e1a37a95c5a95041ef6d6ca7', 'E2', 'case-control', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (71, 'mesh', 'D008180', 'Lupus Erythematosus, Systemic', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (71, 'mesh', 'D019693', 'Hepatitis, Autoimmune', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (71, 'mesh', 'D018988', 'Bacterial Translocation', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (71, 'mesh', 'D008099', 'Liver', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (71, 'kegg_disease', 'H00080', 'Systemic lupus erythematosus', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (71, 'kegg_disease', 'H01685', 'Autoimmune hepatitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (71, 29590047, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (72, 27, 'Serum IgG antibody titers against E. gallinarum whole bacteria and its RNA were significantly elevated in the majority of SLE (n=15) and AIH (n=17) patients versus healthy controls (n=9); anti-E. gallinarum RNA IgG correlated with anti-human RNA autoantibody titers in SLE (R²=0.5132, p=0.0027) and AIH (R²=0.8245, p<0.0001) patients (human case-control).', 'bff86fbb8a48c67c6fd71e4821c0f9f9602a377fb705e60aa01fe625253f0ded', 'E2', 'case-control', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (72, 'mesh', 'D008180', 'Lupus Erythematosus, Systemic', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (72, 'mesh', 'D019693', 'Hepatitis, Autoimmune', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (72, 'mesh', 'D001323', 'Autoantibodies', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (72, 'kegg_disease', 'H00080', 'Systemic lupus erythematosus', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (72, 'kegg_disease', 'H01685', 'Autoimmune hepatitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (72, 29590047, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (73, 27, 'Monocolonization of germ-free C57BL/6 mice with E. gallinarum (n=4–10) induced gut barrier leakage, translocation to mesenteric veins, MLNs, and liver, and elevated anti-RNA IgG and anti-dsDNA IgG autoantibodies at 8 weeks (p<0.05 to p<0.001 vs. GF); neither E. faecalis nor B. thetaiotaomicron monocolonization induced autoantibodies under the same conditions.', '6f0476e9feb85f0cb7608939134b53ff7046ccf504f356ca878ef482f1f58b13', 'E2', 'animal model', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (73, 'mesh', 'D018988', 'Bacterial Translocation', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (73, 'mesh', 'D001323', 'Autoantibodies', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (73, 'mesh', 'D015551', 'Autoimmunity', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (73, 29590047, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (74, 27, 'E. gallinarum monocolonization of GF C57BL/6 mice induced marked Th17 expansion in the small intestinal lamina propria (20.1% IL-17A+ vs. 0.50% GF, p<0.0001) and mesenteric lymph nodes (15.1% vs. 0.035%, p<0.001); Th17 expansion was absent in E. faecalis- and B. thetaiotaomicron-monocolonized mice (n=5 per group).', '8bb77d4f65110fa0146be1b34c2f4a2a54faf40acf708300324594ab492ad511', 'E2', 'animal model', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (74, 'mesh', 'D058504', 'Th17 Cells', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (74, 'mesh', 'D015551', 'Autoimmunity', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (74, 29590047, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (75, 27, 'E. gallinarum lysate or RNA co-cultured with autoimmune-prone (NZW×BXSB)F1 hepatocytes induced expression of autoantigens ERV gp70 (~15-fold) and β2-glycoprotein I (~3-fold), type I IFN-α (~30-fold), and the AhR/CYP1A1 pathway significantly above induction by E. faecalis or B. thetaiotaomicron (ANOVA, p<0.05 to p<0.0001, n=3 each); the same pattern was replicated in primary human hepatocytes.', 'aed62d6006cab956110913bceead638a9436e7518fc61f88ab8ce531adf97c46', 'E2', 'in vitro', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (75, 'mesh', 'D022781', 'Hepatocytes', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (75, 'mesh', 'D018336', 'Receptors, Aryl Hydrocarbon', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (75, 'mesh', 'D015551', 'Autoimmunity', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (75, 29590047, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (76, 27, 'Administration of the AhR antagonist CH223191 to autoimmune-prone (NZW×BXSB)F1 mice gavaged with E. gallinarum significantly reduced serum anti-RNA IgG (p<0.001) and anti-dsDNA IgG (p<0.001) vs. untreated E. gallinarum-gavaged mice (n=4 per group), confirming that the AhR pathway mediates E. gallinarum-driven autoantibody induction.', 'c15258c70680c9ad3a8162b1df0c40fb8c899b237e445024c284f5075700b675', 'E2', 'animal model', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (76, 'mesh', 'D018336', 'Receptors, Aryl Hydrocarbon', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (76, 'mesh', 'D001323', 'Autoantibodies', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (76, 'mesh', 'D015551', 'Autoimmunity', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (76, 29590047, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (77, 27, 'Oral vancomycin or ampicillin treatment of autoimmune-prone (NZW×BXSB)F1 mice (n=15 per group) prevented mortality, suppressed E. gallinarum translocation to mesenteric veins, MLNs, and liver, and eliminated anti-dsDNA IgG, anti-RNA IgG, anti-β2GPI IgG autoantibodies and Th17/Tfh cell expansion vs. untreated controls (p<0.05 to p<0.0001); neomycin was less effective and metronidazole had no significant effect on survival.', '84cc51eb2edaf2e366150c82bb168d3d528f31d4bc4fe430074efe4ea9800661', 'E2', 'animal model', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (77, 'mesh', 'D018988', 'Bacterial Translocation', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (77, 'mesh', 'D001323', 'Autoantibodies', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (77, 'mesh', 'D000900', 'Anti-Bacterial Agents', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (77, 29590047, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (78, 27, 'Intramuscular vaccination with heat-killed E. gallinarum in autoimmune-prone (NZW×BXSB)F1 mice reduced serum autoantibody levels, prolonged survival, and prevented translocation to internal organs; vaccination against E. faecalis or B. thetaiotaomicron had no protective effect, indicating specificity of the E. gallinarum-driven autoimmune response.', '2ee7713c70737b4f2ecdeba6dd46a752d19cf4ca1df07a0aa0550750ef472711', 'E2', 'animal model', '2026-04-01', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (78, 'mesh', 'D001428', 'Bacterial Vaccines', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (78, 'mesh', 'D015551', 'Autoimmunity', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (78, 'mesh', 'D001327', 'Autoimmune Diseases', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (78, 29590047, '2026-04-01');

-- ── MCA-BAC-000027  Faecalibacterium prausnitzii
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (28, 'MCA-BAC-000027', 'Faecalibacterium prausnitzii', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Clostridia|Eubacteriales|Oscillospiraceae|Faecalibacterium', 853, 'no', '2026-04-03', '2026-04-01', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (28, 'unknown', 'obligate anaerobe', NULL, 'https://bacdive.dsmz.de/strain/159475', '2026-04-01', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (28, 'key_trait', 'butyrate-producing', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (28, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (28, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (28, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (28, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (28, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-01', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (28, 34941392, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (28, 33542131, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (28, 32129694, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (28, 29097493, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (79, 28, 'Faecalibacterium prausnitzii relative abundance was enriched in anti-PD-1 responders versus non-responders in the shotgun metagenomic subset of 111 metastatic melanoma patients (n=71 responders, n=40 non-responders; fig. S2A), providing species-level confirmation of its association with immunotherapy response.', '4d3e85a8bd6602f95fe77d994eeccf4b2505b8a7eb8cd14875302b8a90d6ec93', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (79, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (79, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (79, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (79, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (80, 28, 'Faecalibacterium prausnitzii was significantly enriched in anti-PD-1 responders versus non-responders in metagenomic WGS of fecal samples from 25 metastatic melanoma patients (14R, 11NR), establishing the original species-level human evidence of its enrichment in the gut microbiome of immunotherapy responders (Fig. 2F).', '529908e0dad99bbe506039df36486a010e381a69ff87a4530ce43725e26f6a5f', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (80, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (80, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (80, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (80, 29097493, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (81, 28, 'Faecalibacterium prausnitzii was among the bacterial species significantly enriched in responders (objective response or stable disease >12 months) to FMT plus pembrolizumab in a Phase 2 trial of 15 PD-1-refractory advanced melanoma patients, confirming prior reports; transkingdom network analysis further identified it as negatively correlated with circulating CXCL8 (IL-8), an immunosuppressive cytokine elevated in non-responders.', '0a9ae39be94595298bb209c9a715bf10f6bff93b60e8c01078b7523eebd0e206', 'E2', 'phase 2 clinical trial', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (81, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (81, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (81, 33542131, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (82, 28, 'Antibiotic-induced depletion of Faecalibacterium prausnitzii in one PD-1-refractory melanoma patient undergoing FMT plus pembrolizumab (PT-18-0018) was associated with pronounced disruption of the transplanted microbiome and clinical disease progression; re-transplantation from the same donor restored gut colonization and was followed by renewed disease stabilization.', 'a27913256aed6136dc49a61f6378ffbb030ccca4b0150a7a8de9c1e8878a34f1', 'E2', 'phase 2 clinical trial', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (82, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (82, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (82, 33542131, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): 013cda0dbf923359d89adff22a5a759de91e98ff4eb6f95fcfd586efe54420fc
-- SKIPPED association (UNCERTAIN grade): 1fda0c3746e77aa0468c25ae92cc30a04525f2a0806ff394987135184891302f
-- ── MCA-BAC-000028  Faecalibacterium
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (29, 'MCA-BAC-000028', 'Faecalibacterium', 'genus', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Clostridia|Eubacteriales|Oscillospiraceae', 216851, 'no', '2026-04-03', '2026-04-01', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (29, 'unknown', 'obligate anaerobe', NULL, NULL, '2026-04-01', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (29, 'key_trait', 'butyrate-producing', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (29, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (29, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (29, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (29, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (29, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-01', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (29, 34941392, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (29, 32129694, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (29, 29097493, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (83, 29, 'Faecalibacterium genus relative abundance was significantly higher in anti-PD-1 responders versus non-responders in a newly recruited independent cohort of 132 metastatic melanoma patients (n=87 responders, n=45 non-responders; p=0.018 by Wilcoxon rank sum test), supporting its role as a gut microbiota marker of immunotherapy response.', '2aefe1f783dc1eb57926b2c0eddeface72790a1680ac6b0dda5a1bb11ef4f6c9', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (83, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (83, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (83, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (83, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (84, 29, 'In melanoma patients treated with ICB (n=123), Faecalibacterium genus abundance was numerically higher in patients reporting sufficient dietary fiber intake (≥20 g/day) and no probiotic use — the subgroup with significantly longer progression-free survival (median PFS not reached versus 13 months, P=0.015 vs. all other groups) — though the Faecalibacterium difference per se did not reach statistical significance due to small group size (n=22 in optimal group).', '402d260529584830fad673654d1631e9cd69a07f7ac6dd05213619075788cd9b', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (84, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (84, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (84, 'mesh', 'D004043', 'Dietary Fiber', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (84, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (84, 34941392, '2026-04-01');

-- SKIPPED association (UNCERTAIN grade): c2a5267d26ca09816c44eca04b55f25e6fe3b0ba30979cd1322dc4202f1dfd28
INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (85, 29, 'Faecalibacterium genus was significantly enriched in anti-PD-1 responders versus non-responders in the gut microbiome of 43 metastatic melanoma patients (30R, 13NR; FDR-adjusted pairwise comparisons and LEfSe; p<0.01), establishing the original human evidence for genus-level enrichment as a marker of immunotherapy response.', '0238bafccb3fa8b8dd11fbbbed5a9eea82201f23fe2459a12b37df333e9c0412', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (85, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (85, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (85, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (85, 29097493, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (86, 29, 'High Faecalibacterium abundance (above median) was associated with significantly prolonged progression-free survival compared to low abundance in 39 anti-PD-1-treated metastatic melanoma patients (p=0.03; multivariate Cox HR=2.95, 95% CI 1.31–7.29), identifying it as an independent gut microbiome predictor of immunotherapy outcome.', 'e9d136857cc66a5a471dc07c325f9ba0c8b9384136926a1fa7b7035191809c91', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (86, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (86, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (86, 'mesh', 'D000077982', 'Progression-Free Survival', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (86, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (86, 29097493, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (87, 29, 'Faecalibacterium genus abundance was significantly positively correlated with CD8+ T cell density in pre-treatment tumors of melanoma patients on anti-PD-1 therapy (r²=0.42, p<0.01; n=15 matched tumor-microbiome samples), linking gut microbiome composition to intratumoral anti-tumor immunity.', '3b749e0ccba8c27a7a3896e9d30e40b3646db60156cb47516ac751e713046115', 'E2', 'prospective cohort', '2026-04-01', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (87, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (87, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (87, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (87, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (87, 29097493, '2026-04-01');

-- ── MCA-BAC-000029  Lacticaseibacillus paracasei
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (30, 'MCA-BAC-000029', 'Lacticaseibacillus paracasei', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Bacilli|Lactobacillales|Lactobacillaceae|Lacticaseibacillus', 1597, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (30, 'gram-positive', 'facultative anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/6548', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (30, 'synonym', 'Lactobacillus paracasei', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (30, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (30, 'primary_niche', 'oral cavity', 'D009055', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (30, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (30, 'reservoir', 'food', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (30, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (30, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (30, 38584858, '2026-04-01');

-- ── MCA-BAC-000030  Lactiplantibacillus plantarum
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (31, 'MCA-BAC-000030', 'Lactiplantibacillus plantarum', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Bacilli|Lactobacillales|Lactobacillaceae|Lactiplantibacillus', 1590, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (31, 'gram-positive', 'facultative anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/6493', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (31, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (31, 'primary_niche', 'oral cavity', 'D009055', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (31, 'primary_niche', 'environment', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (31, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (31, 'reservoir', 'environment', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (31, 'reservoir', 'food', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (31, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (31, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (31, 38584858, '2026-04-01');

-- ── MCA-BAC-000031  Lactobacillus acidophilus
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (32, 'MCA-BAC-000031', 'Lactobacillus acidophilus', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Bacilli|Lactobacillales|Lactobacillaceae|Lactobacillus', 1579, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (32, 'gram-positive', 'facultative anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/6403', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (32, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (32, 'primary_niche', 'small intestine', 'D007421', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (32, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (32, 'reservoir', 'food', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (32, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (32, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (32, 38584858, '2026-04-01');

-- ── MCA-BAC-000032  Limosilactobacillus reuteri
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (33, 'MCA-BAC-000032', 'Limosilactobacillus reuteri', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Bacilli|Lactobacillales|Lactobacillaceae|Limosilactobacillus', 1598, 'context dependent', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (33, 'unknown', 'unknown', NULL, 'https://bacdive.dsmz.de/strain/6502', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (33, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (33, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (33, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (33, 'typical_specimen', 'biopsy', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (33, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (88, 33, 'Limosilactobacillus reuteri exhibited liver translocation in a subset of germ-free mice following three-month monocolonization, demonstrating capacity for bacterial translocation from gut to liver in an animal model.', 'cc94b4a68bdd8e9fb8e35b2a4e6d7f6d23d863422cc409755c88fe79466e0e13', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (88, 'mesh', 'D018988', 'Bacterial Translocation', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (88, 'mesh', 'D008099', 'Liver', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (88, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (89, 33, 'Limosilactobacillus reuteri exhibits divergent within-host evolution with mucosal and luminal lineage diversification and enhanced immune evasion capacity in a germ-free mouse monocolonization model, with a pattern broadly similar to Enterococcus gallinarum.', '870980faa1ee90599a95a83eba546cd5b539e927eb48e851ada616063293ffbd', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (89, 'mesh', 'D054884', 'Host-Pathogen Interactions', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (89, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (90, 33, 'Limosilactobacillus reuteri liver-adapted isolates demonstrate enhanced liver persistence in vivo, with liver populations enriched for a triple mutant genotype (lacS/greA/ccpA) compared to faecal isolates in germ-free monocolonized mice.', 'ce2bb0b0012c9dbe4e14a9ba3d7034caabb4938826fc4f2fb263687f6f4c2901', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (90, 'mesh', 'D008099', 'Liver', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (90, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (91, 33, 'Limosilactobacillus reuteri has been previously reported to translocate to the liver in a mouse model of lupus, as cited in this study as prior evidence motivating its use as a comparative organism.', '75161b8b21df2a1d31226b75488dd575a2cf41918d483800073ec187892a8502', 'E1', 'cited animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (91, 'mesh', 'D008180', 'Lupus Erythematosus, Systemic', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (91, 'kegg_disease', 'H00080', 'Systemic lupus erythematosus', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (91, 35831502, '2026-04-01');

-- ── MCA-FUN-000002  Saccharomyces boulardii
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (34, 'MCA-FUN-000002', 'Saccharomyces boulardii', 'species', 'Fungi', 'cellular organisms|Eukaryota|Opisthokonta|Fungi|Dikarya|Ascomycota|saccharomyceta|Saccharomycotina|Saccharomycetes|Saccharomycetales|Saccharomycetaceae|Saccharomyces', 4932, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (34, 'not applicable', 'not applicable', 'yeast', NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (34, 'synonym', 'brewer\'s yeast', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (34, 'synonym', 'baker\'s yeast', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (34, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (34, 'reservoir', 'environment', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (34, 'reservoir', 'food', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (34, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (34, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (34, 38584858, '2026-04-01');

-- ── MCA-BAC-000033  Bacteroides fragilis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (35, 'MCA-BAC-000033', 'Bacteroides fragilis', 'species', 'Bacteria', 'Bacteria|Bacteroidota|Bacteroidia|Bacteroidales|Bacteroidaceae|Bacteroides|Bacteroides fragilis', 817, 'context dependent', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (35, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/1585', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'key_trait', 'capsule-producing', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'key_trait', 'polysaccharide A (PSA)-producing', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'risk_context', 'immunocompromised', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'risk_context', 'post-surgical / post-procedural', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'virulence_factor', 'Bfp1', 'VF1421', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'virulence_factor', 'BfUbb', 'VF1416', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'virulence_factor', 'GA1 T6SS', 'VF1418', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'virulence_factor', 'GA2 T6SS', 'VF1419', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'virulence_factor', 'GA3 T6SS', 'VF1417', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'virulence_factor', 'GA3 T6SS secreted effectors', 'VF1423', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'virulence_factor', 'NanH sialidase', 'VF1420', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'virulence_factor', 'PSA', 'VF1415', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (35, 'virulence_factor', 'BFT', 'VF1310', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (35, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (92, 35, 'Bacteroides fragilis exhibits mucosal/luminal lineage divergence (within-host evolution) in germ-free monocolonised mice but did not translocate to the liver, unlike Enterococcus gallinarum, suggesting that within-host evolutionary diversification is a broad property of gut bacteria but that liver translocation capacity is taxon-specific.', '0b5e999cda03bf2f275dda16ee9b95ff13f6192aec59cf064218033ed07a366d', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (92, 'mesh', 'D018988', 'Bacterial Translocation', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (92, 35831502, '2026-04-01');

-- ── MCA-BAC-000034  Alistipes
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (36, 'MCA-BAC-000034', 'Alistipes', 'genus', 'Bacteria', 'Bacteria; Bacteroidota; Bacteroidia; Bacteroidales; Rikenellaceae; Alistipes', 239759, 'no', '2026-04-02', '2026-04-02', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (36, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', NULL, '2026-04-02', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (36, 'key_trait', 'short-chain fatty acid (SCFA) producer', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (36, 'key_trait', 'non-spore-forming', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (36, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (36, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (36, 'role', 'protective commensal', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (36, 'typical_specimen', 'stool', 'D005243', '2026-04-02', '2026-04-03');

INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (36, 'acetate', 'produces', 'C00033', 'CHEBI:30089', '2026-04-02', '2026-04-03');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (36, 'propionate', 'produces', 'C00163', 'CHEBI:17272', '2026-04-02', '2026-04-03');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (36, 'succinate', 'produces', 'C00042', 'CHEBI:26806', '2026-04-02', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (36, 32129694, '2026-04-02');

-- SKIPPED association (UNCERTAIN grade): cc8f84de3cb659fc558a05dfddfc1dc56c9706ba938835d8b98820595487ebcc
-- ── MCA-BAC-000035  Bacteroides nordii
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (37, 'MCA-BAC-000035', 'Bacteroides nordii', 'species', 'Bacteria', 'cellular organisms|Bacteria|Pseudomonadati|FCB group|Bacteroidota|Bacteroidia|Bacteroidales|Bacteroidaceae|Bacteroides', 291645, 'unknown', '2026-04-02', '2026-04-02', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (37, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/139989', '2026-04-02', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (37, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (37, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (37, 'role', 'commensal', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (37, 'typical_specimen', 'stool', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (37, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-02', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (37, 33542131, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (93, 37, 'Bacteroides nordii was enriched in non-responders before FMT in a Phase 2 trial of FMT plus pembrolizumab in 15 PD-1-refractory advanced melanoma patients; transkingdom network analysis identified it as positively correlated with circulating CXCL8 (IL-8), IL-10, and CCL3 — immunosuppressive cytokines associated with poor anti-PD-1 clinical outcomes.', '99c745ff7f4f0402cd2376c55378a81baba8ab0bffc401a190661bd2c080086b', 'E2', 'phase 2 clinical trial', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (93, 'mesh', 'D008545', 'Melanoma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (93, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (93, 33542131, '2026-04-02');

-- ── MCA-BAC-000036  Bacteroides thetaiotaomicron
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (38, 'MCA-BAC-000036', 'Bacteroides thetaiotaomicron', 'species', 'Bacteria', 'Bacteria; Pseudomonadati; Bacteroidota; Bacteroidia; Bacteroidales; Bacteroidaceae; Bacteroides; Bacteroides thetaiotaomicron', 818, 'no', '2026-04-03', '2026-04-02', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (38, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/1599', '2026-04-02', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (38, 'synonym', 'Bacillus thetaiotaomicron', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (38, 'synonym', 'Bacteroides fragilis subsp. thetaiotaomicron', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (38, 'synonym', 'Pseudobacterium thetaiotaomicron', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (38, 'synonym', 'Sphaerocillus thetaiotaomicron', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (38, 'key_trait', 'mucin-degrading', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (38, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (38, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (38, 'role', 'commensal', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (38, 'typical_specimen', 'stool', 'D005243', '2026-04-02', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (38, 29590047, '2026-04-02');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (38, 29097493, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (94, 38, 'GF C57BL/6 mice monocolonized with B. thetaiotaomicron (n=6–10) showed no detectable translocation to mesenteric veins, MLNs, or liver (CFU=0 at all extra-intestinal sites), no gut barrier leakage, and no induction of anti-RNA IgG or anti-dsDNA IgG autoantibodies at 8 weeks post-colonization; Th17 cells were not expanded in small intestinal lamina propria or MLNs (n=5 per group), in contrast to E. gallinarum monocolonization.', 'c01f35b67b531c09ff6fd23084446d3db8b7afdc68c6d834e4f83b7b34ca5459', 'E2', 'animal model', '2026-04-02', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (94, 'mesh', 'D018988', 'Bacterial Translocation', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (94, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (94, 29590047, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (95, 38, 'B. thetaiotaomicron lysate or RNA co-cultured with murine and human hepatocytes did not significantly induce ERV gp70, β2-glycoprotein I, type I IFN-α, or AhR/CYP1A1 expression above medium control (n=3 each); serum anti-B. thetaiotaomicron RNA IgG was not elevated in SLE (n=15) or AIH (n=17) patients versus healthy controls (n=9), confirming immunological quiescence relative to E. gallinarum.', '113238486fbb5eefbcbf21011b53f80be459228cb1e19cf7326947f2610a3ddb', 'E2', 'mixed: in vitro + case-control', '2026-04-02', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (95, 'mesh', 'D022781', 'Hepatocytes', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (95, 'mesh', 'D008180', 'Lupus Erythematosus, Systemic', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (95, 'mesh', 'D019693', 'Hepatitis, Autoimmune', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (95, 29590047, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (96, 38, 'Intramuscular vaccination against B. thetaiotaomicron in autoimmune-prone (NZW×BXSB)F1 mice had no effect on serum autoantibody levels or survival, confirming that B. thetaiotaomicron does not drive autoimmune pathology and that the autoimmune response is specific to E. gallinarum.', '482590da43f0fc88918224f459edb0b362edb6802874fdaa57fb3134ed146a4d', 'E2', 'animal model', '2026-04-02', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (96, 'mesh', 'D001428', 'Bacterial Vaccines', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (96, 'mesh', 'D015551', 'Autoimmunity', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (96, 29590047, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (97, 38, 'Bacteroides thetaiotaomicron was significantly enriched in anti-PD-1 non-responders versus responders by metagenomic WGS in fecal samples from 25 metastatic melanoma patients (14R, 11NR), identifying it as part of a gut microbiome signature associated with immunotherapy non-response (Fig. 2F).', 'abe853f3ec079d2085df1bef11e3d48c540c65e86c34e6f4b83591c39c117619', 'E2', 'prospective cohort', '2026-04-02', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (97, 'mesh', 'D008545', 'Melanoma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (97, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (97, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (97, 29097493, '2026-04-02');

-- ── MCA-BAC-000037  Bacteroides uniformis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (39, 'MCA-BAC-000037', 'Bacteroides uniformis', 'species', 'Bacteria', 'cellular organisms|Bacteria|Pseudomonadati|FCB group|Bacteroidota|Bacteroidia|Bacteroidales|Bacteroidaceae|Bacteroides', 820, 'unknown', '2026-04-02', '2026-04-02', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (39, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/1604', '2026-04-02', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (39, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (39, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (39, 'role', 'commensal', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (39, 'typical_specimen', 'stool', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (39, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (39, 'amr_highlight', 'none documented', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (39, 'virulence_factor', 'none documented', NULL, '2026-04-02', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (39, 33542131, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (98, 39, 'Bacteroides uniformis was enriched in non-responders before FMT in a Phase 2 trial of FMT plus pembrolizumab in 15 PD-1-refractory advanced melanoma patients; transkingdom network analysis identified it as positively correlated with circulating CXCL8 (IL-8), IL-10, and CCL3 — immunosuppressive cytokines associated with poor anti-PD-1 clinical outcomes.', '2ce8f8c544cb1e9c872d699f5ddc25e6bc3b5c6214f9c8c4b6de2174e2b34120', 'E2', 'phase 2 clinical trial', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (98, 'mesh', 'D008545', 'Melanoma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (98, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (98, 33542131, '2026-04-02');

-- ── MCA-BAC-000038  Bifidobacterium bifidum
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (40, 'MCA-BAC-000038', 'Bifidobacterium bifidum', 'species', 'Bacteria', 'Bacteria; Actinomycetota; Actinomycetes; Bifidobacteriales; Bifidobacteriaceae; Bifidobacterium; Bifidobacterium bifidum', 1681, 'no', '2026-04-02', '2026-04-02', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (40, 'gram-positive', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/1693', '2026-04-02', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'synonym', 'Actinobacterium bifidum', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'synonym', 'Actinomyces bifidus', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'synonym', 'Bacillus bifidus', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'synonym', 'Bacterium bifidum', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'synonym', 'Bacteroides bifidus', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'synonym', 'Lactobacillus bifidus type II', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'synonym', 'Nocardia bifida', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'synonym', 'Tissieria bifida', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'key_trait', 'acid-producing', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'key_trait', 'short-chain fatty acid (SCFA) producer', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'primary_niche', 'gut', 'D041981', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'role', 'immunomodulator', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'role', 'probiotic organism', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'role', 'biomarker organism', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'role', 'commensal', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'typical_specimen', 'stool', 'D005243', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (40, 'risk_context', 'cancer patients', NULL, '2026-04-02', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (40, 33432149, '2026-04-02');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (40, 33303685, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (99, 40, 'B. bifidum was significantly enriched in stool samples of patients with non-small-cell lung cancer (NSCLC) who responded to cancer therapeutics (partial response) compared to non-responders, as determined by 16S rRNA LEfSe analysis and confirmed by quantitative PCR (P=0.0022).', 'cbdd0ae20a21e76b38f42de605e3c528fd1b5b5c1fb55d1bfe9574ef2534cd0e', 'E2', 'cohort study', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (99, 'mesh', 'D002289', 'Carcinoma, Non-Small-Cell Lung', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (99, 'kegg_disease', 'H00014', 'Non-small cell lung cancer', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (99, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (100, 40, 'B. bifidum abundance remained significantly higher in NSCLC responders compared to non-responders even after excluding EGFR TKI-treated patients (P=0.0128), supporting a treatment-agnostic association between B. bifidum enrichment and therapeutic response.', '4406b10985c77817b6703458c9cfda044f937db9873bb4fc1ef1dd61539c057c', 'E2', 'cohort study', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (100, 'mesh', 'D002289', 'Carcinoma, Non-Small-Cell Lung', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (100, 'kegg_disease', 'H00014', 'Non-small cell lung cancer', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (100, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (101, 40, 'Oral administration of B. bifidum strains K57 and K18 in combination with anti-PD-1 antibody significantly reduced tumour burden in syngeneic MC38 colon cancer mouse models compared to anti-PD-1 alone (P<0.0001 for both strains).', '385b382f33e0ab1999002ce42ff8f8299519ec08dcdc858490e1ba9252f3cb9b', 'E2', 'animal model', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (101, 'mesh', 'D047368', 'Tumor Burden', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (101, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (101, 'mesh', 'D009374', 'Neoplasms, Experimental', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (101, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (102, 40, 'Oral administration of B. bifidum strains K57 and K18 in combination with oxaliplatin significantly reduced tumour growth in syngeneic MC38 mouse models compared to oxaliplatin alone (P=0.0004 for K57, P=0.0001 for K18).', 'd0302127cc7b129f059af34887598aeea0bc5b1961545f4bd5fc432cdaf9fa9f', 'E2', 'animal model', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (102, 'mesh', 'D047368', 'Tumor Burden', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (102, 'mesh', 'D009374', 'Neoplasms, Experimental', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (102, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (103, 40, 'B. bifidum K57 combined with anti-PD-1 reduced tumour burden in orthotopic and subcutaneous Lewis lung carcinoma (LLC1) syngeneic mouse models, including in anti-PD-1-resistant settings (P=0.038 for orthotopic model).', '26edfcc88a33ec4e5e964cbc9fa026199c41d2dd883b19902ac58a5f619cd620', 'E2', 'animal model', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (103, 'mesh', 'D047368', 'Tumor Burden', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (103, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (103, 'mesh', 'D008175', 'Lung Neoplasms', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (103, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (104, 40, 'B. bifidum K57 combined with anti-PD-1 significantly reduced tumour growth in anti-PD-1-resistant 4T1 breast cancer syngeneic mouse models, whereas anti-PD-1 or B. bifidum K57 alone showed little antitumour effect (P<0.0001).', '2f668afca1ac2138b7b42d32f0068202d99b2d77538e33bb2063e4dcf404ffc2', 'E2', 'animal model', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (104, 'mesh', 'D047368', 'Tumor Burden', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (104, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (104, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (105, 40, 'Synergistic B. bifidum strains K57 and K18 induced significantly more IFN-γ secretion from human CD8+ T cells in autologous monocyte co-culture assays compared to non-synergistic strains; IFN-γ induction was abrogated by TLR2-blocking antibody, implicating peptidoglycan-TLR2 signalling as the mechanism.', '0edbcc92f668beb7d2167550f36e5cba4ce86c0326f469036b124a7112c4a496', 'E2', 'in vitro', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (105, 'mesh', 'D007371', 'Interferon-gamma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (105, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (106, 40, 'In syngeneic mouse tumour models, B. bifidum K57 combined with anti-PD-1 significantly increased intratumoral CD8+ T cell and effector CD8+ T cell populations and CD8+/Treg ratios in tumour and spleen, and elevated IFN-γ and IL-2 while reducing TNF-α and IL-10 expression in tumours.', '73fded683092f2c80fd8cd6b08246b3e7b8b6f72d217d2dd7a31dc6ec6b53eea', 'E2', 'animal model', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (106, 'mesh', 'D007371', 'Interferon-gamma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (106, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (106, 'mesh', 'D047368', 'Tumor Burden', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (106, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (107, 40, 'Functional metagenome profiling (HUMAnN2) of stool WGS from NSCLC patients showed that the peptidoglycan biosynthesis pathway was significantly enriched in responders with B. bifidum compared to non-responders (P=0.012), linking B. bifidum peptidoglycan capacity to therapeutic response.', '7c034ec5bf4890b01797606b6dc119f4d31b2c961290cbdd28eb2dbc9aa6a5d2', 'E2', 'cohort study', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (107, 'mesh', 'D002289', 'Carcinoma, Non-Small-Cell Lung', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (107, 'kegg_disease', 'H00014', 'Non-small cell lung cancer', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (107, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (108, 40, 'Serum metabolomics in B. bifidum K57-treated mice showed elevated L-tryptophan levels; in vitro L-tryptophan treatment increased IFN-γ production from activated human CD8+ T cells (P=0.0082), suggesting a tryptophan-mediated immunostimulatory mechanism.', '7600bbe2a29f173f6ba01623212a3e1d8f675dbb4b599d8de34c12ec1f512a3a', 'E2', 'in vitro', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (108, 'mesh', 'D014364', 'Tryptophan', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (108, 'mesh', 'D007371', 'Interferon-gamma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (108, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (109, 40, 'Overall serum lipid levels were lower in B. bifidum-treated syngeneic tumour mice than in anti-PD-1-alone controls, with the greatest reduction in the anti-PD-1 plus B. bifidum K57 group, consistent with a lipid-lowering effect accompanying antitumour T cell activity.', '8c0e286c17c4e433eff751cc8e4a971c796afa816ae401996fdeb8185722ea51', 'E2', 'animal model', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (109, 'mesh', 'D055442', 'Metabolome', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (109, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (110, 40, 'In a phase 1 FMT trial (n=10 anti-PD-1-refractory metastatic melanoma patients), B. bifidum relative abundance was lower in recipient stool post-FMT plus nivolumab versus pretreatment (ANCOM); the paper contextualizes this decrease as potentially favorable for anti-tumor immune activation, citing B. bifidum\'s reported role in promoting immune tolerance via induction of regulatory T cells.', 'bbee03b24cf70bd99dc6af87be78733ce61be8189a5351f932ac5d3f23250e04', 'E2', 'phase 1 clinical trial', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (110, 'mesh', 'D008545', 'Melanoma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (110, 'mesh', 'D000069467', 'Fecal Microbiota Transplantation', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (110, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (110, 'mesh', 'D050378', 'T-Lymphocytes, Regulatory', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (110, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (110, 33303685, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (111, 40, 'In a phase 1 FMT trial (n=10 anti-PD-1-refractory metastatic melanoma patients), Bifidobacterium bifidum relative abundance was lower in recipient stool post-FMT plus nivolumab versus pretreatment (ANCOM); the paper notes that B. bifidum has been reported to promote immune tolerance via induction of regulatory T cells, framing its post-FMT decrease as potentially favorable for anti-tumor immune activation.', 'be7c294d6ed72242a25cbdaab48e62355049d16acd6643bca9f812ef3372fb4b', 'E1', 'phase 1 clinical trial', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (111, 'mesh', 'D008545', 'Melanoma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (111, 'mesh', 'D000069467', 'Fecal Microbiota Transplantation', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (111, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (111, 'mesh', 'D050378', 'T-Lymphocytes, Regulatory', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (111, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (111, 33303685, '2026-04-02');

-- ── MCA-BAC-000039  Blautia
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (41, 'MCA-BAC-000039', 'Blautia', 'genus', 'Bacteria', 'Bacteria; Bacillota; Clostridia; Eubacteriales; Lachnospiraceae; Blautia', 572511, 'no', '2026-04-02', '2026-04-02', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (41, 'gram-positive', 'obligate anaerobe', 'coccus', NULL, '2026-04-02', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (41, 'key_trait', 'butyrate-producing', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (41, 'key_trait', 'short-chain fatty acid (SCFA) producer', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (41, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (41, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (41, 'role', 'protective commensal', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (41, 'typical_specimen', 'stool', 'D005243', '2026-04-02', '2026-04-02');

INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (41, 'acetate', 'produces', 'C00033', 'CHEBI:30089', '2026-04-02', '2026-04-02');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (41, 'butyrate', 'produces', 'C00246', 'CHEBI:17968', '2026-04-02', '2026-04-02');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (41, 'succinate', 'produces', 'C00042', 'CHEBI:26806', '2026-04-02', '2026-04-02');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (41, 'ethanol', 'produces', 'C00469', 'CHEBI:16236', '2026-04-02', '2026-04-02');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (41, 'lactate', 'produces', 'C01432', 'CHEBI:24996', '2026-04-02', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (41, 32129694, '2026-04-02');

-- SKIPPED association (UNCERTAIN grade): 4f90433e866f170caef715a195626774808398e6e994f6e00513bbb6812290f8
-- SKIPPED association (UNCERTAIN grade): ca2127f9022bfb0651ec69a5d49532442d72eb79740a43fdd361418e99432590
-- SKIPPED association (UNCERTAIN grade): e9d2b6a1abc14f100eb0a1a96e58a4f56bd2eec226bb60e82e48501ca8c734b0
-- ── MCA-BAC-000040  Collinsella aerofaciens
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (42, 'MCA-BAC-000040', 'Collinsella aerofaciens', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Actinomycetota|Coriobacteriia|Coriobacteriales|Coriobacteriaceae|Collinsella', 74426, 'unknown', '2026-04-03', '2026-04-02', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (42, 'gram-positive', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/3044', '2026-04-02', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (42, 'synonym', 'Eggerthella aerofaciens', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (42, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (42, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (42, 'role', 'commensal', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (42, 'typical_specimen', 'stool', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (42, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (42, 'amr_highlight', 'none documented', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (42, 'virulence_factor', 'none documented', NULL, '2026-04-02', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (42, 33542131, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (112, 42, 'Collinsella aerofaciens was named among bacterial species enriched in responders (objective response or stable disease >12 months) to FMT plus pembrolizumab in a Phase 2 trial of 15 PD-1-refractory advanced melanoma patients (NCT03341143), confirming its previously reported association with favorable anti-PD-1 immunotherapy response in melanoma.', '4fdd789675a5098d2727e78e55443462f0a5cb7d41fba25c522ae48aeb73f2ca', 'E2', 'phase 2 clinical trial', '2026-04-02', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (112, 'mesh', 'D008545', 'Melanoma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (112, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (112, 33542131, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (113, 42, 'Collinsella aerofaciens was among 8 commensal species significantly enriched in pre-treatment stool of metastatic melanoma anti-PD-1 responders (n=16) versus non-responders (n=26) by integrated 16S rRNA, shotgun metagenomic, and qPCR analysis (P<0.05, permutation test); it was part of a 10-species composite qPCR score significantly higher in responders (P=0.004).', '3300caf1f79c5434976535fbde82f8b62a4461eb5ce6bb5fca059247adc9068b', 'E2', 'prospective observational cohort', '2026-04-02', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (113, 'mesh', 'D008545', 'Melanoma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (113, 'mesh', 'D007167', 'Immunotherapy', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (113, 'mesh', 'D061026', 'Programmed Cell Death 1 Receptor', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (113, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (113, 29302014, '2026-04-02');

-- ── MCA-BAC-000041  Dorea
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (43, 'MCA-BAC-000041', 'Dorea', 'genus', 'Bacteria', 'Bacteria; Bacillota; Clostridia; Eubacteriales; Lachnospiraceae; Dorea', 189330, 'no', '2026-04-02', '2026-04-02', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (43, 'gram-positive', 'obligate anaerobe', 'bacillus (rod)', NULL, '2026-04-02', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (43, 'key_trait', 'short-chain fatty acid (SCFA) producer', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (43, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (43, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (43, 'role', 'protective commensal', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (43, 'typical_specimen', 'stool', 'D005243', '2026-04-02', '2026-04-02');

INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (43, 'acetate', 'produces', 'C00033', 'CHEBI:30089', '2026-04-02', '2026-04-02');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (43, 'formate', 'produces', 'C00058', 'CHEBI:15740', '2026-04-02', '2026-04-02');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (43, 'ethanol', 'produces', 'C00469', 'CHEBI:16236', '2026-04-02', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (43, 32129694, '2026-04-02');

-- SKIPPED association (UNCERTAIN grade): a34a611e8a05f14c2c4e8a1593bcf6690c8900c3943e02804c0bb52061bdf940
-- ── MCA-BAC-000042  Enterobacter cloacae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (44, 'MCA-BAC-000042', 'Enterobacter cloacae', 'species', 'Bacteria', 'Bacteria; Pseudomonadota; Gammaproteobacteria; Enterobacterales; Enterobacteriaceae; Enterobacter cloacae complex; Enterobacter', 550, 'yes', '2026-04-02', '2026-04-02', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (44, 'gram-negative', 'facultative anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/4373', '2026-04-02', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'synonym', 'Aerobacter cloacae', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'synonym', 'Cloaca cloacae', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'key_trait', 'motile (peritrichous flagella)', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'key_trait', 'lactose fermenter', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'key_trait', 'member of Enterobacter cloacae complex', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'primary_niche', 'oral cavity', 'D000068956', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'primary_niche', 'environment', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'reservoir', 'environment', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'transmission_route', 'oral-gut', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'transmission_route', 'healthcare-associated', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'role', 'opportunistic pathogen', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'role', 'coloniser', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'typical_specimen', 'stool', 'D005243', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'typical_specimen', 'biopsy', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'risk_context', 'inflammatory bowel disease (IBD)', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'bloom_trigger', 'periodontitis', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (44, 'bloom_trigger', 'dysbiosis', NULL, '2026-04-02', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (44, 32758418, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (114, 44, 'Enterobacter cloacae (strain SK156) is a component of the synthetic ligature-associated oral microbiome (sLOM, comprising K. aerogenes, K. pneumoniae, K. variicola, E. cloacae, and E. hormaechei) that, upon ectopic gut colonization, drives colitis in germ-free Il10−/− and Rag1−/− mouse models (significantly elevated fecal Lcn2, increased colonic Th17/Th1 cells, and worsened histological scores vs. sHOM controls; p<0.05 to p<0.001).', '81684785d260028600599162acef0eae21bf7ddef70b11268acd205ba9d07a84', 'E1', 'mouse experimental (germ-free gnotobiotic colonization model, synthetic microbiome community)', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (114, 'mesh', 'D003092', 'Colitis', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (114, 'mesh', 'D010518', 'Periodontitis', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (114, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (114, 'mesh', 'D004754', 'Enterobacter', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (114, 'kegg_disease', 'H01227', 'Inflammatory bowel disease', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (114, 32758418, '2026-04-02');

-- ── MCA-BAC-000043  Enterocloster clostridioformis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (45, 'MCA-BAC-000043', 'Enterocloster clostridioformis', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Clostridia|Lachnospirales|Lachnospiraceae|Enterocloster', 1531, 'unknown', '2026-04-02', '2026-04-02', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (45, 'gram-positive', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/2569', '2026-04-02', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (45, 'synonym', 'Clostridium clostridiforme', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (45, 'synonym', 'Clostridium clostridioforme', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (45, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (45, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (45, 'role', 'commensal', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (45, 'typical_specimen', 'stool', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (45, 'typical_specimen', 'blood', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (45, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (45, 'bloom_trigger', 'immunosuppression', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (45, 'amr_highlight', 'none documented', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (45, 'virulence_factor', 'none documented', NULL, '2026-04-02', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (45, 33542131, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (115, 45, 'Enterocloster clostridioformis was among organisms enriched in responders (objective response or stable disease >12 months) to FMT plus pembrolizumab in a Phase 2 trial of 15 PD-1-refractory advanced melanoma patients, as identified by transkingdom multi-omic network analysis (Fig. 4E).', '268a3d1b7dfcc8f2a7d9a47e150e256495370f99d72842596391c53f69072054', 'E2', 'phase 2 clinical trial', '2026-04-02', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (115, 'mesh', 'D008545', 'Melanoma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (115, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (115, 33542131, '2026-04-02');

-- ── MCA-BAC-000044  Klebsiella aerogenes
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (46, 'MCA-BAC-000044', 'Klebsiella aerogenes', 'species', 'Bacteria', 'Bacteria; Pseudomonadota; Gammaproteobacteria; Enterobacterales; Enterobacteriaceae; Klebsiella', 548, 'yes', '2026-04-02', '2026-04-02', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (46, 'gram-negative', 'facultative anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/4358', '2026-04-02', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'synonym', 'Aerobacter aerogenes', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'synonym', 'Klebsiella mobilis', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'synonym', 'Enterobacter aerogenes', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'key_trait', 'encapsulated', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'key_trait', 'motile (peritrichous flagella)', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'key_trait', 'lactose fermenter', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'key_trait', 'urease positive', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'key_trait', 'mucoid colonies', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'primary_niche', 'oral cavity', 'D000068956', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'reservoir', 'environment', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'transmission_route', 'oral-gut', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'role', 'opportunistic pathogen', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'role', 'coloniser', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'typical_specimen', 'stool', 'D005243', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'typical_specimen', 'biopsy', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'risk_context', 'inflammatory bowel disease (IBD)', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'bloom_trigger', 'periodontitis', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'bloom_trigger', 'inflammation', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (46, 'bloom_trigger', 'dysbiosis', NULL, '2026-04-02', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (46, 32758418, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (116, 46, 'Klebsiella aerogenes expands in the oral cavity during periodontitis, translocates to the gut, and triggers colitis via NLRP3/caspase-11 inflammasome activation and IL-1β production by intestinal macrophages in multiple mouse models (DSS colitis in SPF mice; germ-free Il10−/− and Rag1−/− gnotobiotic colonization models).', '7208b0b7df012e187cbfe9b91be88354037d6afa9abe41684007f3da4eefd765', 'E1', 'mouse experimental (multiple models: DSS colitis, germ-free colonization)', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (116, 'mesh', 'D003092', 'Colitis', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (116, 'mesh', 'D010518', 'Periodontitis', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (116, 'mesh', 'D058847', 'Inflammasomes', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (116, 'mesh', 'D053583', 'Interleukin-1beta', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (116, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (116, 'mesh', 'D007709', 'Klebsiella', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (116, 'kegg_disease', 'H01227', 'Inflammatory bowel disease', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (116, 32758418, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (117, 46, 'Oral gavage of K. aerogenes (strain SK431) exacerbates DSS-induced colitis in SPF mice (worsened body weight loss, colon weight, histological scores); the colitogenic effect is fully reversed by IL-1 receptor antagonist anakinra, establishing a causal IL-1β-dependent mechanism for oral pathobiont-driven gut inflammation.', '3502f930d985ae0daaa3ad2a061d79c137036aadfc25ef7dd0c88069e64b9a8d', 'E1', 'mouse experimental (DSS colitis model, SPF C57BL/6 mice, pharmacological intervention with anakinra)', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (117, 'mesh', 'D003092', 'Colitis', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (117, 'mesh', 'D053583', 'Interleukin-1beta', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (117, 'mesh', 'D007709', 'Klebsiella', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (117, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (117, 'kegg_disease', 'H01227', 'Inflammatory bowel disease', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (117, 32758418, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (118, 46, 'K. aerogenes is the most abundant species in the synthetic ligature-associated oral microbiome (sLOM) that drives colitis in germ-free Il10−/− and Rag1−/− mice; sLOM-colonized mice show significantly elevated fecal Lcn2, worsened colonic histological scores, and increased colonic Th17/Th1 T cells compared to sHOM controls (p<0.05 to p<0.0001 across outcomes).', '661862c1fcdc654bf1bd803c2ad8c6589f23f8373a37c201b2d1bc50a7e996f5', 'E1', 'mouse experimental (germ-free gnotobiotic colonization model, synthetic microbiome community)', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (118, 'mesh', 'D003092', 'Colitis', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (118, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (118, 'mesh', 'D007709', 'Klebsiella', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (118, 'kegg_disease', 'H01227', 'Inflammatory bowel disease', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (118, 32758418, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (119, 46, 'Oral K. aerogenes and related Enterobacteriaceae prime RORγt+ Th17 effector memory T cells in cervical lymph nodes during periodontitis; these cells express gut-homing markers (α4β7, CCR9), migrate to the inflamed gut, and amplify colitis via antigen-specific expansion — an effect blocked by anakinra, suggesting IL-1β produced by ectopically colonized oral pathobionts further drives Th17 expansion.', '9bc85cd20324ec11adcf4ee8036bbe94de90ce09430a0468d71efce62585a875', 'E1', 'mouse experimental (Kaede transgenic photoconversion, adoptive T cell transfer, parabiosis models)', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (119, 'mesh', 'D003092', 'Colitis', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (119, 'mesh', 'D058504', 'Th17 Cells', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (119, 'mesh', 'D010518', 'Periodontitis', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (119, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (119, 'mesh', 'D007709', 'Klebsiella', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (119, 'kegg_disease', 'H01227', 'Inflammatory bowel disease', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (119, 32758418, '2026-04-02');

-- ── MCA-BAC-000045  Phascolarctobacterium faecium
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (47, 'MCA-BAC-000045', 'Phascolarctobacterium faecium', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Negativicutes|Acidaminococcales|Acidaminococcaceae|Phascolarctobacterium', 33025, 'unknown', '2026-04-02', '2026-04-02', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (47, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/100', '2026-04-02', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (47, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (47, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (47, 'reservoir', 'animal', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (47, 'role', 'commensal', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (47, 'typical_specimen', 'stool', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (47, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (47, 'amr_highlight', 'none documented', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (47, 'virulence_factor', 'none documented', NULL, '2026-04-02', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (47, 33542131, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (120, 47, 'Phascolarctobacterium faecium was enriched in non-responders before FMT in a Phase 2 trial of FMT plus pembrolizumab in 15 PD-1-refractory advanced melanoma patients; transkingdom network analysis identified it as positively correlated with circulating CXCL8 (IL-8), IL-10, and CCL3 — immunosuppressive cytokines associated with poor anti-PD-1 clinical outcomes.', 'ae4f8a1d5ff4c57d686952c710fb022878eef877abced4797ff078d9013bda63', 'E2', 'phase 2 clinical trial', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (120, 'mesh', 'D008545', 'Melanoma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (120, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (120, 33542131, '2026-04-02');

-- ── MCA-BAC-000046  Prevotella copri
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (48, 'MCA-BAC-000046', 'Prevotella copri', 'species', 'Bacteria', 'Bacteria; Pseudomonadati; FCB group; Bacteroidota/Chlorobiota group; Bacteroidota; Bacteroidia; Bacteroidales; Prevotellaceae; Segatella', 165179, 'yes', '2026-04-03', '2026-04-02', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (48, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/12547', '2026-04-02', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (48, 'synonym', 'Segatella copri', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (48, 'primary_niche', 'gut', 'D041981', '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (48, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (48, 'role', 'biomarker organism', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (48, 'role', 'opportunistic pathogen', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (48, 'typical_specimen', 'blood', 'D001769', '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (48, 'typical_specimen', 'stool', 'D005243', '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (48, 'risk_context', 'cancer patients', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (48, 'risk_context', 'elderly patients', NULL, '2026-04-02', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (48, 'risk_context', 'heart failure patients', NULL, '2026-04-02', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (48, 33432149, '2026-04-02');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (48, 31548871, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (121, 48, 'Prevotella copri is enriched in the gut microbiome of healthy controls compared to patients with non-small-cell lung cancer (NSCLC), as identified by LEfSe analysis of 16S rRNA stool sequencing from 96 NSCLC patients versus 139 healthy controls.', '5ab1491939e3cfb6378844bb1774ff7e11cabcd662d31152b1f7e270f3e71e6b', 'E2', 'cohort study', '2026-04-02', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (121, 'mesh', 'D002289', 'Carcinoma, Non-Small-Cell Lung', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (121, 'kegg_disease', 'H00014', 'Non-small cell lung cancer', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (121, 33432149, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (122, 48, 'Prevotella copri caused a clinically significant bloodstream infection (bacteremia) in a 90-year-old male patient with acute cardiac decompensation due to heart failure, representing the first reported case of BSI attributed to this organism; blood cultures grew P. copri as the sole pathogen and the patient recovered following treatment with metronidazole and piperacillin-tazobactam.', '3fe849921c7ee95cc9dede0241dfc584fd45ab5c3c99539742c83c4ced44d4c2', 'E1', 'case report', '2026-04-02', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (122, 'mesh', 'D001424', 'Bacteremia', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (122, 'mesh', 'D006333', 'Heart Failure', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (122, 'kegg_disease', 'H01410', 'Anaerobic infection', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (122, 'kegg_disease', 'H01631', 'Acute heart failure', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (122, 31548871, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (123, 48, 'Gut microbiota domination by Prevotella copri (6.1% relative abundance at species level; Prevotella genus 15.2% overall by 16S rRNA sequencing) was associated with subsequent P. copri bloodstream infection in the same patient, supporting a gut-to-blood translocation mechanism via intestinal barrier breach; the authors characterize P. copri as a pathobiont rather than a beneficial organism.', 'e4039d3f32f9d62f086c00e240b9053b48319118e8b660c1298362cd3ec51030', 'E1', 'case report', '2026-04-02', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (123, 'mesh', 'D001424', 'Bacteremia', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (123, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (123, 'kegg_disease', 'H01410', 'Anaerobic infection', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (123, 31548871, '2026-04-02');

-- ── MCA-BAC-000047  Roseburia
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (49, 'MCA-BAC-000047', 'Roseburia', 'genus', 'Bacteria', 'Bacteria; Bacillota; Clostridia; Eubacteriales; Lachnospiraceae; Roseburia', 841, 'no', '2026-04-02', '2026-04-02', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (49, 'gram-variable', 'obligate anaerobe', 'bacillus (rod)', NULL, '2026-04-02', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (49, 'key_trait', 'butyrate-producing', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (49, 'key_trait', 'short-chain fatty acid (SCFA) producer', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (49, 'key_trait', 'flagellated', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (49, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (49, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (49, 'role', 'protective commensal', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (49, 'typical_specimen', 'stool', 'D005243', '2026-04-02', '2026-04-02');

INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (49, 'butyrate', 'produces', 'C00246', 'CHEBI:17968', '2026-04-02', '2026-04-02');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (49, 'acetate', 'produces', 'C00033', 'CHEBI:30089', '2026-04-02', '2026-04-02');
INSERT INTO metabolite (passport_id, metabolite_name, relationship, kegg_compound_id, chebi_id, created_at, updated_at) VALUES (49, 'propionate', 'produces', 'C00163', 'CHEBI:17272', '2026-04-02', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (49, 32129694, '2026-04-02');

-- SKIPPED association (UNCERTAIN grade): 4660e84596c89e5732e0653cb053401c224aecc51789365e23c9117d925536d9
-- SKIPPED association (UNCERTAIN grade): a3403759b2f6fd3f00d05577d55daa582b966dcf1c3bb0b7b95ee99965b038f1
-- ── MCA-BAC-000048  Ruminococcus flavefaciens
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (50, 'MCA-BAC-000048', 'Ruminococcus flavefaciens', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Clostridia|Eubacteriales|Oscillospiraceae|Ruminococcus', 1265, 'no', '2026-04-02', '2026-04-02', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (50, 'gram-positive', 'obligate anaerobe', 'coccus', 'https://bacdive.dsmz.de/strain/166624', '2026-04-02', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (50, 'key_trait', 'cellulose-degrading', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (50, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (50, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (50, 'reservoir', 'animal', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (50, 'role', 'protective commensal', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (50, 'typical_specimen', 'stool', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (50, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (50, 'amr_highlight', 'none documented', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (50, 'virulence_factor', 'none documented', NULL, '2026-04-02', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (50, 33542131, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (124, 50, 'Ruminococcus flavefaciens was identified in transkingdom multi-omic network analysis as enriched in responders (objective response or stable disease >12 months) to FMT plus pembrolizumab in a Phase 2 trial of 15 PD-1-refractory advanced melanoma patients, and negatively correlated with circulating CXCL8 (IL-8), an immunosuppressive cytokine elevated in non-responders.', '97395dc6b6fea905bb357b31c23d1fb52d863cfc1c7d574739090b47c42ddb7b', 'E2', 'phase 2 clinical trial', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (124, 'mesh', 'D008545', 'Melanoma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (124, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (124, 33542131, '2026-04-02');

-- ── MCA-BAC-000049  Veillonellaceae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (51, 'MCA-BAC-000049', 'Veillonellaceae', 'family', 'Bacteria', 'Bacteria; Bacillota; Negativicutes; Veillonellales; Veillonellaceae', 31977, 'no', '2026-04-02', '2026-04-02', '2026-04-02');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (51, 'gram-negative', 'obligate anaerobe', 'not applicable', NULL, '2026-04-02', '2026-04-02');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (51, 'key_trait', 'short-chain fatty acid (SCFA) producer', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (51, 'primary_niche', 'gut', 'D007422', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (51, 'primary_niche', 'oral cavity', 'D009055', '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (51, 'reservoir', 'human', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (51, 'role', 'protective commensal', NULL, '2026-04-02', '2026-04-02');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (51, 'typical_specimen', 'stool', 'D005243', '2026-04-02', '2026-04-02');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (51, 33303685, '2026-04-02');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (125, 51, 'In a phase 1 FMT trial (n=10 anti-PD-1-refractory metastatic melanoma patients), Veillonellaceae relative abundance was higher in stool post-FMT plus nivolumab versus pretreatment (ANCOM); the responding FMT donor (Donor 1, whose recipients comprised all 3 clinical responders out of 5) was enriched for Veillonellaceae, and the paper explicitly characterizes the family as \'immunotherapy-favorable\' based on prior anti-PD-1 cohort studies.', 'ec1b7596dfef76cebbd19d66868da32a5730a211e3a9b0e049c63debb72a56fe', 'E1', 'phase 1 clinical trial', '2026-04-02', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (125, 'mesh', 'D008545', 'Melanoma', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (125, 'mesh', 'D000069467', 'Fecal Microbiota Transplantation', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (125, 'mesh', 'D000069196', 'Gastrointestinal Microbiome', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (125, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-02');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (125, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-02');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (125, 33303685, '2026-04-02');

-- ── MCA-BAC-000050  Alistipes indistinctus
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (52, 'MCA-BAC-000050', 'Alistipes indistinctus', 'species', 'Bacteria', 'Bacteria; Bacteroidota; Bacteroidia; Bacteroidales; Rikenellaceae; Alistipes', 626932, 'no', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (52, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', NULL, '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (52, 'primary_niche', 'gut', 'D007422', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (52, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (52, 'role', 'protective commensal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (52, 'typical_specimen', 'stool', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (52, 'risk_context', 'NSCLC patients receiving PD-1/PD-L1 blockade', NULL, '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (52, 29097494, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (126, 52, 'Alistipes indistinctus was significantly enriched in NSCLC and RCC patients with longer progression-free survival (>3 months) vs. shorter PFS after PD-1/PD-L1 blockade, identified by shotgun metagenomics of pre-treatment stool (n=100) as one of several commensals overrepresented in responders.', '9d4345df20a0b4f336679e42292bf8984c8d48819af660165bfcd9826d701ab3', 'E2', 'multi-cohort metagenomics study', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (126, 'mesh', 'D002289', 'Carcinoma, Non-Small-Cell Lung', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (126, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (126, 'kegg_disease', 'H00014', 'Non-small cell lung cancer', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (126, 'kegg_disease', 'H00021', 'Renal cell carcinoma', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (126, 29097494, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (127, 52, 'Oral gavage with Alistipes indistinctus reversed compromised PD-1 blockade efficacy in antibiotic-treated mice receiving NR-FMT-induced dysbiosis bearing MCA-205 sarcomas, restoring antitumor effects comparable to those of A. muciniphila supplementation (Fig. 4C).', '49f543f62ef421b4f7bfb4305758ad9814b3c411b88109d42f3689b5b543f0f3', 'E1', 'mouse model (oral gavage)', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (127, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (127, 'mesh', 'D009369', 'Neoplasms', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (127, 29097494, '2026-04-03');

-- ── MCA-BAC-000051  Staphylococcus aureus
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (53, 'MCA-BAC-000051', 'Staphylococcus aureus', 'species', 'Bacteria', 'Bacteria; Bacillota; Bacilli; Staphylococcales; Staphylococcaceae; Staphylococcus', 1280, 'yes', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (53, 'gram-positive', 'facultative anaerobe', 'coccus', 'https://bacdive.dsmz.de/strain/14487', '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'synonym', 'Micrococcus aureus', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'key_trait', 'non-motile', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'key_trait', 'non-spore-forming', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'key_trait', 'coagulase-positive', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'key_trait', 'catalase-positive', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'reservoir', 'animal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'transmission_route', 'fecal-oral', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'transmission_route', 'healthcare-associated', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'role', 'primary pathogen', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'typical_specimen', 'blood', 'D001769', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'typical_specimen', 'stool', 'D005243', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'risk_context', 'ICU / critical care', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'risk_context', 'bacteremia', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'bloom_trigger', 'antibiotic exposure', 'D00929', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'amr_highlight', 'MRSA', 'ARO:3004306', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'virulence_factor', 'alpha-hemolysin (Hla)', 'VF0001', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'virulence_factor', 'beta-hemolysin (Hlb)', 'VF0002', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'virulence_factor', 'delta-hemolysin (Hld)', 'VF0007', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'virulence_factor', 'gamma-hemolysin (Hlg)', 'VF0011', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'virulence_factor', 'Panton-Valentine leukocidin (PVL)', 'VF0018', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'virulence_factor', 'staphylococcal protein A (SpA)', 'VF0017', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (53, 'virulence_factor', 'staphylococcal enterotoxin (SE)', 'VF0020', '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (53, 25385792, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (128, 53, 'Staphylococcus aureus disseminates from the bloodstream to the gastrointestinal tract following bacteremia and is shed in feces at high titres, establishing a reservoir for fecal-oral transmission in a murine intravenous infection model.', '30c2d1081a54af128ce9093f4b6793b1016bc1d301b3867d67caf3c1ac24fa70', 'E1', 'animal model', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (128, 'mesh', 'D016470', 'Bacteremia', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (128, 'mesh', 'D013203', 'Staphylococcal Infections', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (128, 'mesh', 'D041981', 'Gastrointestinal Tract', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (128, 25385792, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (129, 53, 'Fecal-oral transmission of S. aureus from bacteremic donor mice to naive cage-mates requires intact agr quorum-sensing and sae two-component regulatory systems; agr+sae double-mutant strains show approximately 10³-fold reduction in transmission efficiency (n=6 recipient mice per group).', '3e9a5c984199ea10d5b591cf30b5fa04b1eeba4675cecb27fd08374bd441f088', 'E1', 'animal model', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (129, 'mesh', 'D013203', 'Staphylococcal Infections', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (129, 'mesh', 'D041981', 'Gastrointestinal Tract', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (129, 25385792, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (130, 53, 'In mixed MRSA/MSSA infections in oxacillin-treated mice, MRSA is selectively transmitted to antibiotic-naive recipient mice via the fecal-oral route, demonstrating that antibiotic exposure drives selective spread of resistant strains through the GI reservoir (n=6 recipients).', '2c2c883342aed090d5f5dd55d8fda919e95972aefd7ac5123210dc11497b3311', 'E1', 'animal model', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (130, 'mesh', 'D013203', 'Staphylococcal Infections', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (130, 'mesh', 'D024881', 'Drug Resistance, Bacterial', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (130, 'kegg_disease', 'H00330', 'MRSA infection', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (130, 25385792, '2026-04-03');

-- ── MCA-BAC-000052  Enterococcus faecium
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (54, 'MCA-BAC-000052', 'Enterococcus faecium', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Bacilli|Lactobacillales|Enterococcaceae|Enterococcus', 1352, 'unknown', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (54, 'gram-positive', 'facultative anaerobe', 'coccus', 'https://bacdive.dsmz.de/strain/5295', '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (54, 'synonym', 'Streptococcus faecium', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (54, 'primary_niche', 'gut', 'D041981', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (54, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (54, 'reservoir', 'food', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (54, 'role', 'commensal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (54, 'typical_specimen', 'stool', 'D005243', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (54, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (54, 29302014, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (131, 54, 'Enterococcus faecium was among 8 commensal species significantly enriched in pre-treatment stool of metastatic melanoma anti-PD-1 responders (n=16) versus non-responders (n=26) by integrated 16S rRNA, shotgun metagenomic, and qPCR analysis (P<0.05, permutation test); it was highlighted in the abstract as one of three key responder-enriched species and was part of a 10-species composite qPCR score significantly higher in responders (P=0.004).', '94890071f1b9069ed555143d8ec7245aa35199c316fdc5d79ecd526d99887678', 'E2', 'prospective observational cohort', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (131, 'mesh', 'D016984', 'Enterococcus faecium', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (131, 'mesh', 'D008545', 'Melanoma', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (131, 'mesh', 'D007167', 'Immunotherapy', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (131, 'mesh', 'D061026', 'Programmed Cell Death 1 Receptor', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (131, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (131, 29302014, '2026-04-03');

-- ── MCA-BAC-000053  Bifidobacterium adolescentis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (55, 'MCA-BAC-000053', 'Bifidobacterium adolescentis', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Actinomycetota|Actinomycetes|Bifidobacteriales|Bifidobacteriaceae|Bifidobacterium', 1680, 'unknown', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (55, 'gram-positive', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/1682', '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (55, 'synonym', 'Bifidobacterium faecale', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (55, 'synonym', 'Bifidobacterium stercoris', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (55, 'primary_niche', 'gut', 'D041981', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (55, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (55, 'role', 'commensal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (55, 'typical_specimen', 'stool', 'D005243', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (55, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (55, 29302014, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (132, 55, 'Bifidobacterium adolescentis was among 8 commensal species significantly enriched in pre-treatment stool of metastatic melanoma anti-PD-1 responders (n=16) versus non-responders (n=26) by integrated 16S rRNA, shotgun metagenomic, and qPCR analysis (P<0.05, permutation test); it was part of a 10-species composite qPCR score significantly higher in responders (P=0.004).', '7e46a429d66e84eeb6ae230345ef87e425588fb39d00f12e96a82cdd7fc7eb57', 'E2', 'prospective observational cohort', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (132, 'mesh', 'D008545', 'Melanoma', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (132, 'mesh', 'D007167', 'Immunotherapy', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (132, 'mesh', 'D061026', 'Programmed Cell Death 1 Receptor', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (132, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (132, 29302014, '2026-04-03');

-- ── MCA-BAC-000054  Klebsiella pneumoniae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (56, 'MCA-BAC-000054', 'Klebsiella pneumoniae', 'species', 'Bacteria', 'cellular organisms|Bacteria|Pseudomonadati|Pseudomonadota|Gammaproteobacteria|Enterobacterales|Enterobacteriaceae|Klebsiella', 573, 'unknown', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (56, 'gram-negative', 'facultative anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/4946', '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (56, 'synonym', 'Bacillus pneumoniae', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (56, 'synonym', 'Hyalococcus pneumoniae', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (56, 'primary_niche', 'gut', 'D041981', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (56, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (56, 'reservoir', 'environment', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (56, 'role', 'commensal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (56, 'typical_specimen', 'stool', 'D005243', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (56, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (56, 29302014, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (133, 56, 'Klebsiella pneumoniae was among 8 commensal species significantly enriched in pre-treatment stool of metastatic melanoma anti-PD-1 responders (n=16) versus non-responders (n=26) by integrated 16S rRNA, shotgun metagenomic, and qPCR analysis (P<0.05, permutation test); it was part of a 10-species composite qPCR score significantly higher in responders (P=0.004).', '070ed0df96aa01e44fca0c5b930f5372b36192f43dac70801bead854551012de', 'E2', 'prospective observational cohort', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (133, 'mesh', 'D008545', 'Melanoma', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (133, 'mesh', 'D007167', 'Immunotherapy', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (133, 'mesh', 'D061026', 'Programmed Cell Death 1 Receptor', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (133, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (133, 29302014, '2026-04-03');

-- ── MCA-BAC-000055  Parabacteroides merdae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (57, 'MCA-BAC-000055', 'Parabacteroides merdae', 'species', 'Bacteria', 'cellular organisms|Bacteria|Pseudomonadati|FCB group|Bacteroidota|Bacteroidia|Bacteroidales|Tannerellaceae|Parabacteroides', 46503, 'unknown', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (57, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/12499', '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (57, 'synonym', 'Bacteroides merdae', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (57, 'primary_niche', 'gut', 'D041981', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (57, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (57, 'role', 'commensal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (57, 'typical_specimen', 'stool', 'D005243', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (57, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (57, 29302014, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (134, 57, 'Parabacteroides merdae was among 8 commensal species significantly enriched in pre-treatment stool of metastatic melanoma anti-PD-1 responders (n=16) versus non-responders (n=26) by integrated 16S rRNA, shotgun metagenomic, and qPCR analysis (P<0.05, permutation test); it was part of a 10-species composite qPCR score significantly higher in responders (P=0.004).', '06d2cd0181a702478debefc79163ccea8c2a2c0a6cf8321e1356cde8edd186ee', 'E2', 'prospective observational cohort', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (134, 'mesh', 'D008545', 'Melanoma', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (134, 'mesh', 'D007167', 'Immunotherapy', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (134, 'mesh', 'D061026', 'Programmed Cell Death 1 Receptor', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (134, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (134, 29302014, '2026-04-03');

-- ── MCA-BAC-000056  Blautia obeum
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (58, 'MCA-BAC-000056', 'Blautia obeum', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Clostridia|Lachnospirales|Lachnospiraceae|Blautia', 40520, 'unknown', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (58, 'gram-positive', 'obligate anaerobe', 'unknown', 'https://bacdive.dsmz.de/strain/17684', '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (58, 'synonym', 'Ruminococcus obeum', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (58, 'primary_niche', 'gut', 'D041981', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (58, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (58, 'role', 'commensal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (58, 'typical_specimen', 'stool', 'D005243', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (58, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (58, 29302014, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (135, 58, 'Blautia obeum (syn. Ruminococcus obeum) was among 2 commensal species significantly enriched in pre-treatment stool of metastatic melanoma anti-PD-1 non-responders (n=26) versus responders (n=16) by integrated 16S rRNA, shotgun metagenomic, and qPCR analysis (P<0.05, permutation test); higher abundance was part of a \'non-beneficial\' OTU signature inversely correlated with anti-PD-1 response.', 'bdcdb1c8fc0ae3bc9f922276144728fc72a0f6e83358f270419b3a5b7605023a', 'E2', 'prospective observational cohort', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (135, 'mesh', 'D008545', 'Melanoma', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (135, 'mesh', 'D007167', 'Immunotherapy', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (135, 'mesh', 'D061026', 'Programmed Cell Death 1 Receptor', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (135, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (135, 29302014, '2026-04-03');

-- ── MCA-BAC-000057  Roseburia intestinalis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (59, 'MCA-BAC-000057', 'Roseburia intestinalis', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Clostridia|Lachnospirales|Lachnospiraceae|Roseburia', 166486, 'unknown', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (59, 'gram-positive', 'obligate anaerobe', 'unknown', 'https://bacdive.dsmz.de/strain/6366', '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (59, 'primary_niche', 'gut', 'D041981', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (59, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (59, 'role', 'commensal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (59, 'typical_specimen', 'stool', 'D005243', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (59, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (59, 29302014, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (136, 59, 'Roseburia intestinalis was among 2 commensal species significantly enriched in pre-treatment stool of metastatic melanoma anti-PD-1 non-responders (n=26) versus responders (n=16) by integrated 16S rRNA, shotgun metagenomic, and qPCR analysis (P<0.05, permutation test); higher abundance was part of a \'non-beneficial\' OTU signature inversely correlated with anti-PD-1 response (RECIST % change).', '19a407c7d517837e3b5aee231aae6f4af20099c369b992136dc2e3d19c0a69d1', 'E2', 'prospective observational cohort', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (136, 'mesh', 'D008545', 'Melanoma', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (136, 'mesh', 'D007167', 'Immunotherapy', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (136, 'mesh', 'D061026', 'Programmed Cell Death 1 Receptor', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (136, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (136, 29302014, '2026-04-03');

-- ── MCA-BAC-000058  Helicobacter hepaticus
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (60, 'MCA-BAC-000058', 'Helicobacter hepaticus', 'species', 'Bacteria', 'Bacteria; Pseudomonadati; Campylobacterota; Epsilonproteobacteria; Campylobacterales; Helicobacteraceae; Helicobacter; Helicobacter hepaticus', 32025, 'yes', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (60, 'gram-negative', 'microaerophile', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/6105', '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (60, 'primary_niche', 'gut', 'D003106', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (60, 'reservoir', 'animal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (60, 'role', 'opportunistic pathogen', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (60, 'risk_context', 'immunocompromised patients', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (60, 'risk_context', 'inflammatory bowel disease (IBD)', NULL, '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (60, 29414937, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (137, 60, 'H. hepaticus colonization drives colitogenic TH17 cell expansion and histopathologically confirmed colitis in mice with impaired immune tolerance (IL-10-deficient or c-Maf-deficient Treg compartment), with H. hepaticus-specific T effector transcriptomes matching disease-associated inflammatory signatures similar to those in IL-10RA blockade-induced colitis.', 'd5df45accc769d17bb7dcb05214730742f83729a90f87d16288b6f1780bf19e9', 'E1', 'murine experimental study (conditional knockout and adoptive transfer models)', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (137, 'mesh', 'D003092', 'Colitis', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (137, 'kegg_disease', 'H01227', 'Inflammatory bowel disease (IBD)', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (137, 29414937, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (138, 60, 'In immunocompetent hosts, H. hepaticus colonization induces c-Maf-dependent RORγt+Foxp3+ induced regulatory T cells (iTreg) in the large intestinal lamina propria that selectively restrain pathobiont-specific TH17 cells; disruption of this iTreg-TH17 homeostasis by c-Maf deficiency leads to spontaneous colitis even without H. hepaticus colonization in aged mice.', '7b854dd087fe858bdce28835971ab6085835943d318a44012ed209ab753e3474', 'E1', 'murine experimental study (TCR transgenic mice, MHCII tetramer tracking, conditional knockout, RNA-seq)', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (138, 'mesh', 'D007108', 'Immune Tolerance', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (138, 'kegg_disease', 'H01227', 'Inflammatory bowel disease (IBD)', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (138, 29414937, '2026-04-03');

-- ── MCA-BAC-000059  Veillonella parvula
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (61, 'MCA-BAC-000059', 'Veillonella parvula', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Negativicutes|Veillonellales|Veillonellaceae|Veillonella', 29466, 'unknown', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (61, 'gram-negative', 'obligate anaerobe', 'coccus', 'https://bacdive.dsmz.de/strain/17173', '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (61, 'synonym', 'Micrococcus gazogenes', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (61, 'synonym', 'Veillonella alcalescens', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (61, 'synonym', 'Veillonella gazogenes', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (61, 'synonym', 'Micrococcus lactilyticus', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (61, 'primary_niche', 'gut', 'D041981', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (61, 'primary_niche', 'oral cavity', 'D009055', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (61, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (61, 'role', 'commensal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (61, 'typical_specimen', 'stool', 'D005243', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (61, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (61, 29302014, '2026-04-03');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (139, 61, 'Veillonella parvula was among 8 commensal species significantly enriched in pre-treatment stool of metastatic melanoma anti-PD-1 responders (n=16) versus non-responders (n=26) by integrated 16S rRNA, shotgun metagenomic, and qPCR analysis (P<0.05, permutation test); it was part of a 10-species composite qPCR score significantly higher in responders (P=0.004).', 'f97f53bf71d3db61dfa88386a162c0740f5d7a5047ce431cd633888274963920', 'E2', 'prospective observational cohort', '2026-04-03', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (139, 'mesh', 'D008545', 'Melanoma', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (139, 'mesh', 'D007167', 'Immunotherapy', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (139, 'mesh', 'D061026', 'Programmed Cell Death 1 Receptor', '2026-04-03');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (139, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-03');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (139, 29302014, '2026-04-03');

-- ── MCA-BAC-000060  Helicobacter pylori
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (62, 'MCA-BAC-000060', 'Helicobacter pylori', 'species', 'Bacteria', 'Bacteria; Campylobacterota; Epsilonproteobacteria; Campylobacterales; Helicobacteraceae; Helicobacter', 210, 'yes', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (62, 'gram-negative', 'microaerophile', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/6102', '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (62, 'synonym', 'Campylobacter pylori', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (62, 'synonym', 'Campylobacter pyloridis', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (62, 'key_trait', 'toxin-producing', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (62, 'primary_niche', 'stomach', 'D013270', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (62, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (62, 'transmission_route', 'fecal-oral', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (62, 'transmission_route', 'oral-oral', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (62, 'role', 'primary pathogen', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (62, 'typical_specimen', 'biopsy', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (62, 'typical_specimen', 'stool', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (62, 'risk_context', 'chronic H. pylori infection in gastric mucosa', NULL, '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (62, 33766858, '2026-04-03');

-- SKIPPED association (UNCERTAIN grade): 19aa163441726e45477aa9a87dfb96cec3f5a2b2e8e331783e999d5ad8a08cc6
-- SKIPPED association (UNCERTAIN grade): ce41f2ee3953e06b6fd1269d30e386822faaee8f92340c02e56a53ee746774cd
-- ── MCA-BAC-000061  Streptococcus gallolyticus
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (63, 'MCA-BAC-000061', 'Streptococcus gallolyticus', 'species', 'Bacteria', 'Bacteria; Bacillota; Bacilli; Lactobacillales; Streptococcaceae; Streptococcus', 315405, 'yes', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (63, 'gram-positive', 'facultative anaerobe', 'coccus', 'https://bacdive.dsmz.de/strain/14718', '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (63, 'synonym', 'Streptococcus bovis biotype I', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (63, 'synonym', 'Streptococcus bovis', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (63, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (63, 'reservoir', 'animal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (63, 'risk_context', 'colorectal cancer patients (bacteremia as diagnostic indicator)', NULL, '2026-04-03', '2026-04-03');

-- SKIPPED association (UNCERTAIN grade): e90d20d426821383ddb6896c1bcba81fa76cf8dc0ef89551c4819aeb093549b3
-- ── MCA-BAC-000062  Mycobacterium bovis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (64, 'MCA-BAC-000062', 'Mycobacterium bovis', 'species', 'Bacteria', 'Bacteria; Actinomycetota; Actinomycetes; Mycobacteriales; Mycobacteriaceae; Mycobacterium', 1765, 'context dependent', '2026-04-03', '2026-04-03', '2026-04-03');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (64, 'gram-variable', 'aerobe', 'bacillus (rod)', NULL, '2026-04-03', '2026-04-03');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'synonym', 'Mycobacterium tuberculosis var. bovis', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'synonym', 'Mycobacterium bovis BCG', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'primary_niche', 'lung', 'D008168', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'primary_niche', 'urinary tract', 'D001743', '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'reservoir', 'animal', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'reservoir', 'human', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'transmission_route', 'airborne', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'role', 'primary pathogen', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'role', 'probiotic candidate', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'typical_specimen', 'sputum', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'typical_specimen', 'biopsy', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'typical_specimen', 'urine', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'risk_context', 'high-risk non-muscle-invasive bladder cancer (BCG intravesical therapy)', NULL, '2026-04-03', '2026-04-03');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (64, 'risk_context', 'immunocompromised patients (BCG dissemination risk)', NULL, '2026-04-03', '2026-04-03');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (64, 33766858, '2026-04-03');

-- SKIPPED association (UNCERTAIN grade): 200b99fedcb8a141cd4eeed584bbf2c7e08b7a8e9ee2ff655bcb129809136300
SET FOREIGN_KEY_CHECKS = 1;

-- 64 passport(s), 139 association(s) written
-- 93 association(s) skipped (UNCERTAIN grade — not in SQL ENUM)
