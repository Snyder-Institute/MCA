-- MCA database dump
-- Source XML : MCA_DB_v1_7_20260402.xml
-- Generated  : 2026-04-02
-- Import     : mysql MCA < MCA_DB_v1_7_20260402.sql

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
INSERT INTO meta (key_name, key_value) VALUES ('db_version', 'v1_7_20260402')
  ON DUPLICATE KEY UPDATE key_value = VALUES(key_value);

-- papers
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (36894652, 'Dysbiosis of a microbiota–immune metasystem in critical illness is associated with nosocomial infections', 'Schlechte J, Willing B, Lowes D, West ML, Mager DR, Fuhr JE, Gold MR, Bhatt M', 'Nature Medicine', 2023, 'prospective longitudinal cohort', 'Adult ICU patients, University of Calgary, Canada', 51) ON DUPLICATE KEY UPDATE title=VALUES(title), authors=VALUES(authors), journal=VALUES(journal), year=VALUES(year), study_design=VALUES(study_design), population=VALUES(population), sample_size=VALUES(sample_size);
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (41641127, 'Clostridioides difficile infection in pediatric inflammatory bowel disease: current understanding and clinical challenges', 'Rogalidou M', 'Frontiers in Pediatrics', 2026, 'narrative review', 'Pediatric patients with inflammatory bowel disease (IBD), including Crohn\'s disease, ulcerative colitis, and IBD-unclassified; review also covers general pediatric CDI populations', NULL) ON DUPLICATE KEY UPDATE title=VALUES(title), authors=VALUES(authors), journal=VALUES(journal), year=VALUES(year), study_design=VALUES(study_design), population=VALUES(population), sample_size=VALUES(sample_size);
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (41814006, 'Antibiotic use and gut microbiome composition links from individual-level prescription data of 14,979 individuals', 'Baldanzi G et al.', 'Nature Medicine', 2026, 'multi-cohort observational study', 'Swedish adults from three independent cohorts: SCAPIS, SIMPLER, and MOS', 14979) ON DUPLICATE KEY UPDATE title=VALUES(title), authors=VALUES(authors), journal=VALUES(journal), year=VALUES(year), study_design=VALUES(study_design), population=VALUES(population), sample_size=VALUES(sample_size);
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (40544256, 'Bloodstream infection by Lactobacillus rhamnosus in a haematology patient: why metagenomics can make the difference', 'Mannavola CM; De Maio F; Marra J; Fiori B; Santarelli G; Posteraro B; Sica S; D\'Inzeo T; Sanguinetti M', 'Gut Pathogens', 2025, 'case report', 'Single 20-year-old female with relapsed/refractory Philadelphia-negative B-cell ALL post-allogeneic HSCT', 1) ON DUPLICATE KEY UPDATE title=VALUES(title), authors=VALUES(authors), journal=VALUES(journal), year=VALUES(year), study_design=VALUES(study_design), population=VALUES(population), sample_size=VALUES(sample_size);
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (41039149, 'Clostridioides difficile pathogenesis and control', 'Chilton CH, Viprey V, Normington C, Moura IB, Buckley AM, Freeman J, Davies K, Wilcox MH', 'Nature Reviews Microbiology', 2026, 'Narrative review', 'Not applicable (review article)', NULL) ON DUPLICATE KEY UPDATE title=VALUES(title), authors=VALUES(authors), journal=VALUES(journal), year=VALUES(year), study_design=VALUES(study_design), population=VALUES(population), sample_size=VALUES(sample_size);
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (39456922, 'Oral Pathobiont-Derived Outer Membrane Vesicles in the Oral–Gut Axis', 'Catalan EA, Seguel-Fuentes E, Fuentes B, Aranguiz-Varela F, Castillo-Godoy DP, Rivera-Asin E, Bocaz E, Fuentes JA, Bravo D, Schinnerling K, Melo-Gonzalez F', 'International Journal of Molecular Sciences', 2024, 'narrative review', 'N/A', NULL) ON DUPLICATE KEY UPDATE title=VALUES(title), authors=VALUES(authors), journal=VALUES(journal), year=VALUES(year), study_design=VALUES(study_design), population=VALUES(population), sample_size=VALUES(sample_size);
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (38786164, 'A Comparison of Currently Available and Investigational Fecal Microbiota Transplant Products for Recurrent Clostridioides difficile Infection', 'Wang Y, Hunt A, Danziger L, Drwiega EN', 'Antibiotics', 2024, 'narrative review', 'Adults with recurrent CDI (rCDI) treated with live biotherapeutic products (LBPs) or fecal microbiota transplantation', NULL) ON DUPLICATE KEY UPDATE title=VALUES(title), authors=VALUES(authors), journal=VALUES(journal), year=VALUES(year), study_design=VALUES(study_design), population=VALUES(population), sample_size=VALUES(sample_size);
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (38584858, 'Microbiota-Based Therapeutics as New Standard-of-Care Treatment for Recurrent Clostridioides difficile Infection', 'Stallhofer J, Steube A, Katzer K, Stallmach A', 'Visceral Medicine', 2024, 'narrative review', 'adults with recurrent Clostridioides difficile infection (rCDI)', NULL) ON DUPLICATE KEY UPDATE title=VALUES(title), authors=VALUES(authors), journal=VALUES(journal), year=VALUES(year), study_design=VALUES(study_design), population=VALUES(population), sample_size=VALUES(sample_size);
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (34941392, 'Dietary fiber and probiotics influence the gut microbiome and melanoma immunotherapy response', 'Spencer CN, McQuade JL, Gopalakrishnan V, McCulloch JA, Vetizou M, Cogdill AP, et al.', 'Science', 2021, 'mixed: single observational cohort (primary) + parallel preclinical murine models', 'Germ-free C57BL/6 mice colonized with complete responder (CR) donor stool via FMT, then gavaged with B. longum 35624–based probiotic (probiotic 1), implanted with BRAF V600E/PTEN-null melanoma cells, and treated with anti-PD-L1 (n=4–5 per group for tumor growth; n=6 per group for immune profiling; n=7–8 per group for microbiome analysis)', NULL) ON DUPLICATE KEY UPDATE title=VALUES(title), authors=VALUES(authors), journal=VALUES(journal), year=VALUES(year), study_design=VALUES(study_design), population=VALUES(population), sample_size=VALUES(sample_size);
INSERT INTO paper (pmid, title, authors, journal, year, study_design, population, sample_size) VALUES (35831502, 'Within-host evolution of a gut pathobiont facilitates liver translocation', 'Yang Y, Nguyen M, Khetrapal V, Sonnert ND, Martin AL, Chen H, Kriegel MA, Palm NW', 'Nature', 2022, 'animal model', 'Germ-free (GF) and specific-pathogen-free (SPF) C57BL/6 mice monocolonised with individual bacterial isolates; autoimmune-prone (NZW×BXSB)F1 mice; in vitro BMDM phagocytosis and antimicrobial peptide assays', 153) ON DUPLICATE KEY UPDATE title=VALUES(title), authors=VALUES(authors), journal=VALUES(journal), year=VALUES(year), study_design=VALUES(study_design), population=VALUES(population), sample_size=VALUES(sample_size);

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
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (3, 'MCA-BAC-000003', 'Ruminococcaceae', 'family', 'Bacteria', 'Bacteria; Bacillota; Clostridia; Eubacteriales; Ruminococcaceae', 541000, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (3, 'gram-positive', 'obligate anaerobe', NULL, 'https://bacdive.dsmz.de/advsearch?fg[0][gc]=OR&fg[0][fl][1][fd]=Family&fg[0][fl][1][fo]=contains&fg[0][fl][1][fv]=Ruminococcaceae&fg[0][fl][1][fvd]=strains-family-1', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (3, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (3, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (3, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (3, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (3, 36894652, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (3, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (6, 3, 'Ruminococcaceae relative abundance was significantly reduced in critically ill ICU patients compared to healthy controls (ANCOM-II p-adj<0.1), representing a key anaerobic fermenter family lost during critical illness-associated gut dysbiosis in a prospective cohort of 51 patients.', '703c7994e7ed2337ac5f6f6de5b7f611f8e32aa4b936f9d01f12e4f2de6fe409', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (6, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (6, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (6, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (7, 3, 'Ruminococcaceae depletion preceded Enterobacteriaceae expansion in critically ill ICU patients, consistent with its role in colonization resistance against pathobiont expansion during critical illness-associated gut dysbiosis.', 'd17c19491203bf1ededd2c64d5710175a5604bf6f4adf8d6298813a64ab316ef', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (7, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (7, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (7, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (8, 3, 'In an independent newly recruited cohort of 132 anti-PD-1–treated metastatic melanoma patients (n=87 responders, n=45 non-responders), Ruminococcaceae relative abundance was significantly higher in responders versus non-responders (p=0.036 by Wilcoxon rank sum test), replicating the response-associated enrichment pattern identified in a prior cohort.', 'd414dedc7dae1f6907bd12be514c8ae32047ef5d28a2ab52599b57197f95a7c9', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (8, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (8, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (8, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (8, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (9, 3, 'Across an expanded cohort of 293 metastatic melanoma patients treated with anti-PD-1 or other systemic therapies, Ruminococcaceae was the most significantly enriched taxon in gut microbiota of responders versus non-responders (FDR q<0.1 by Wilcoxon rank sum test), with enrichment persisting after multivariable adjustment for age, sex, BMI, prior treatment, and antibiotic use.', 'fbd0a2cf1741f92d211b2dc975fb8ff4d8a0357ebf0f90d4ed423a217bfa9b03', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (9, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (9, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (9, 'mesh', 'D000077982', 'Progression-Free Survival', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (9, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (9, 34941392, '2026-04-01');

-- ── MCA-BAC-000004  Lachnospiraceae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (4, 'MCA-BAC-000004', 'Lachnospiraceae', 'family', 'Bacteria', 'Bacteria; Bacillota; Clostridia; Eubacteriales; Lachnospiraceae', 186803, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (4, 'gram-positive', 'obligate anaerobe', NULL, NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (4, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (4, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (4, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (4, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (4, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (10, 4, 'Lachnospiraceae relative abundance was significantly depleted in critically ill ICU patients compared to healthy controls (ANCOM-II p-adj<0.1), contributing to the loss of colonization resistance and gut dysbiosis during critical illness in a prospective cohort of 51 patients.', '5b76587bc8fddd053b1307f1573a52363bfdb6c29a93e42de06bcefad2c45acd', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (10, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (10, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (10, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (11, 4, 'Penalized ridge regression identified Lachnospiraceae as one of the most important families negatively associated with progressive Enterobacteriaceae enrichment between ICU days 1 and 3, consistent with a colonization resistance role against pathobiont expansion during critical illness.', '6249def6d948e00bcc550872b2020be6074efc4ebc9ab205b96e07068472d4f5', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (11, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (11, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (11, 36894652, '2026-04-01');

-- ── MCA-BAC-000005  Bifidobacteriaceae
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (5, 'MCA-BAC-000005', 'Bifidobacteriaceae', 'family', 'Bacteria', 'Bacteria; Actinomycetota; Actinomycetes; Bifidobacteriales; Bifidobacteriaceae', 31953, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (5, 'gram-positive', 'obligate anaerobe', NULL, NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (5, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (5, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (5, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (5, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (5, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (12, 5, 'Bifidobacteriaceae relative abundance was depleted in critically ill ICU patients compared to healthy controls (ANCOM-II p-adj<0.1), representing a commensal family lost during critical illness-associated gut dysbiosis in a prospective cohort of 51 patients.', 'b4a78a6d8d36ab16999237239b4729e84da58a1c6eb555579a40afa8888822e9', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (12, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (12, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (12, 36894652, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (13, 5, 'Penalized ridge regression identified Bifidobacteriaceae as one of the most important families negatively associated with progressive Enterobacteriaceae enrichment between ICU days 1 and 3, consistent with a colonization resistance role against pathobiont expansion during critical illness.', '49ade5e93baabe15c48038e1dd12d4e21473c41c53326e49e99b180e6f6c3090', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (13, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (13, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (13, 36894652, '2026-04-01');

-- ── MCA-BAC-000006  Clostridioides difficile
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (6, 'MCA-BAC-000006', 'Clostridioides difficile', 'species', 'Bacteria', 'cellular organisms; Bacteria; Bacillati; Bacillota; Clostridia; Peptostreptococcales; Peptostreptococcaceae; Clostridioides', 1496, 'yes', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (6, 'gram-positive', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/2582', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'synonym', 'Clostridium difficile', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'synonym', 'Peptoclostridium difficile', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'key_trait', 'spore-forming', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'key_trait', 'toxin-producing', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'key_trait', 'biofilm-forming', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'reservoir', 'environment', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'reservoir', 'animal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'transmission_route', 'fecal-oral', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'transmission_route', 'healthcare-associated', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'role', 'primary pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'ICU / critical care', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'post-antibiotic', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'inflammatory bowel disease (IBD)', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'immunocompromised patients', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'risk_context', 'elderly', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'dysbiosis', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'immunosuppression', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'inflammation', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'hospitalization', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'bloom_trigger', 'dietary change', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'amr_highlight', 'multidrug-resistant (MDR)', 'ARO:3004305', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CbpA', 'VF0592', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CD0873', 'VF0593', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CD2831', 'VF0598', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CD3246', 'VF0599', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CDT', 'VF0385', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'Cwp66', 'VF0591', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'Cwp84', 'VF0590', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'CwpV', 'VF0596', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'FbpA/Fbp68', 'VF0595', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'GroEL', 'VF0594', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'SlpA', 'VF0589', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'TcdA', 'VF0376', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'TcdB', 'VF0377', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (6, 'virulence_factor', 'Zmp1', 'VF0600', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 36894652, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 41641127, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 41039149, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 38786164, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (6, 38584858, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (14, 6, 'Clostridioides difficile was identified as the causative pathogen of diarrhea/colitis in one critically ill ICU patient (Patient 43) who had concurrent progressive fecal Enterobacteriaceae enrichment, representing an incidental CDI case within a 51-patient prospective cohort studying ICU-associated gut dysbiosis.', 'c07400f319e7ef54e0e2f9b1e24e79d0859dc102c804e78562fb83ed812991bd', 'E1', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (14, 'mesh', 'D003428', 'Cross Infection', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (14, 'kegg_disease', 'H00338', 'Pseudomembranous colitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (14, 36894652, '2026-04-01');

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

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (15, 7, 'Eggerthella lenta relative abundance was significantly higher in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with disruptions persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', '8fb737ee5a6a62e506735928c0fa0ad2fc6a9ce30ece09e24cdc5f7cb3d11e55', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (15, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (15, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (15, 'mesh', 'D064307', 'Microbiota', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (15, 'mesh', 'D004755', 'Enterobacteriaceae', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (15, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (16, 7, 'Higher Eggerthella lenta relative abundance was positively associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), consistent with a cardiometabolic risk profile.', '47333f0b5e33bd680e405af85421acd0ea70f7248fbf29619a2569b2fb70c0cd', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (16, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (16, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (16, 41814006, '2026-04-01');

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

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (17, 8, 'Flavonifractor plautii relative abundance was significantly higher in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with disruptions persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', '9193be9d2e5c815a69b9e77ceaf3d7bb7d94b1a235f852e0348e9a38b34ffe97', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (17, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (17, 'mesh', 'D003428', 'Cross Infection', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (17, 'mesh', 'D004755', 'Enterobacteriaceae', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (17, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (18, 8, 'Higher Flavonifractor plautii relative abundance was positively associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), consistent with a cardiometabolic risk profile.', '55ef8e61354fad9f5f12f175691307df9b26b0483b050070121efdd09b0693c9', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (18, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (18, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (18, 41814006, '2026-04-01');

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

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (19, 9, 'Mediterraneibacter gnavus relative abundance was significantly higher in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with disruptions persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', 'edb757f5ff4fd75c714e4aef587929d16e739321155c19c3501c6e62629b498a', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (19, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (19, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (19, 'mesh', 'D004755', 'Enterobacteriaceae', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (19, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (20, 9, 'Higher Mediterraneibacter gnavus relative abundance was positively associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), consistent with a cardiometabolic risk profile.', '17f605b6cccb48cda02fcd7323ff41a9cee828df7117e353b12fdf8e58141b9d', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (20, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (20, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (20, 41814006, '2026-04-01');

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

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (21, 10, 'Enterocloster bolteae relative abundance was significantly higher in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with disruptions persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', 'dc2396e7e042d319f867ccba491bd3904b183626f1c5ec36fd56dec57119d9bc', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (21, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (21, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (21, 'mesh', 'D064307', 'Microbiota', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (21, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (22, 10, 'Higher Enterocloster bolteae relative abundance was positively associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), consistent with a cardiometabolic risk profile.', '1666042deaece84c238bd9b852ee8d2c011acde66246f9b1174266c208e84080', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (22, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (22, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (22, 41814006, '2026-04-01');

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

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (23, 11, 'Sellimonas intestinalis relative abundance was significantly higher in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with disruptions persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', '69d794b9a77aae57ac0fff28bed55e88052d439e0e27725f277e0490ba89d95c', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (23, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (23, 'mesh', 'D003428', 'Cross Infection', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (23, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (24, 11, 'Higher Sellimonas intestinalis relative abundance was positively associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), consistent with a cardiometabolic risk profile.', '39d0188b195e47bff60923098807a12a1d51016dfe0dc3ed489a475a36682d78', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (24, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (24, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (24, 41814006, '2026-04-01');

-- ── MCA-BAC-000012  Alistipes communis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (12, 'MCA-BAC-000012', 'Alistipes communis', 'species', 'Bacteria', 'Bacteria; Bacteroidota; Bacteroidia; Bacteroidales; Rikenellaceae; Alistipes', 2585118, 'unknown', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (12, 'unknown', 'obligate anaerobe', 'bacillus (rod)', NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (12, 'synonym', 'Alistipes obesi', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (12, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (12, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (12, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (12, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (12, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (25, 12, 'Alistipes communis relative abundance was significantly lower in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with depletion effects persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', 'b3f3d272f6e2499e41523c8b6c5070d3ed6d66220199f6d79dc5c3567ac8b032', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (25, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (25, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (25, 'mesh', 'D064307', 'Microbiota', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (25, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (26, 12, 'Lower Alistipes communis relative abundance was inversely associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), with the species showing an inverse relationship to cardiometabolic risk markers.', 'aedeb52462215d83d8e336d3a0017f2e098d06c82220c3add0f48850f4a04b94', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (26, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (26, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (26, 41814006, '2026-04-01');

-- ── MCA-BAC-000013  Odoribacter splanchnicus
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (13, 'MCA-BAC-000013', 'Odoribacter splanchnicus', 'species', 'Bacteria', 'Bacteria; Bacteroidota; Bacteroidia; Bacteroidales; Odoribacteraceae; Odoribacter', 28118, 'unknown', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (13, 'unknown', 'obligate anaerobe', NULL, NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (13, 'synonym', 'Bacteroides splanchnicus', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (13, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (13, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (13, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (13, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (27, 13, 'Odoribacter splanchnicus relative abundance was significantly lower in individuals with prior exposure to clindamycin, fluoroquinolones, or flucloxacillin, with depletion effects persisting for 4–8 years post-prescription, in a multi-cohort observational study of 14,979 Swedish adults (SCAPIS, SIMPLER, MOS cohorts).', '88f8205ac5b7159490336632432bdf0491191b150abc71ba886bf235677dfbf0', 'E3', 'multi-cohort observational study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (27, 'mesh', 'D016638', 'Critical Illness', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (27, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (27, 41814006, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (28, 13, 'Lower Odoribacter splanchnicus relative abundance was inversely associated with elevated BMI, waist-hip ratio, serum triglycerides, and C-reactive protein in the SCAPIS cohort (n≈10,456), with the species showing an inverse relationship to cardiometabolic risk markers.', 'aa13ee78db9b0bce5100d04e816a7b84bf3f76795d25de6d9da335d7ed526c83', 'E3', 'cross-sectional cohort study', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (28, 'kegg_disease', 'H01637', 'Hypertriglyceridemia', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (28, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (28, 41814006, '2026-04-01');

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
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (15, 'MCA-BAC-000015', 'Akkermansia muciniphila', 'species', 'Bacteria', 'Bacteria|Verrucomicrobiota|Verrucomicrobiia|Verrucomicrobiales|Akkermansiaceae|Akkermansia', 239935, 'unknown', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (15, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/17849', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (15, 'amr_highlight', 'intrinsic glycopeptide resistance (glycopeptides)', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (15, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (29, 15, 'Akkermansia muciniphila displays intrinsic resistance to glycopeptide antibiotics, indicating that antimicrobial resistance profiles of novel probiotic organisms may have clinical implications for gut microbiota management in susceptible patient populations.', 'daefafbe17e0d1fa7e1296faea25d05daa273eb794ef0e820adf6c5221bbc13b', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (29, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (30, 15, 'Akkermansia muciniphila abundance is reduced in Porphyromonas gingivalis OMV-induced gut dysbiosis in murine models, alongside reductions in Firmicutes and Lactobacillus spp., accompanied by systemic inflammation and insulin resistance.', '5fca0fe0cc91454926a03add703d1044f65aff96515890f43c2a65dfa353a0f9', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (30, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (30, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (31, 15, 'Akkermansia muciniphila abundance is inversely associated with type 2 diabetes mellitus; its depletion is linked to impaired gut barrier function, increased intestinal permeability, and systemic metabolic dysfunction.', '0a82cf9dadd22970817f81a663351f264af939fd21aecb0a1df30d3dcd031773', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (31, 'kegg_disease', 'H00409', 'Type 2 diabetes mellitus', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (31, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (32, 15, 'Akkermansia muciniphila is protective against periodontitis; its abundance is inversely associated with periodontal disease severity, suggesting a gut–oral axis role for this commensal in modulating oral inflammation.', 'f160d5e4302e963bd864073cd8023bae5f7a6c64de66addb2628e49f594892c9', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (32, 'mesh', 'D010518', 'Periodontitis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (32, 'kegg_disease', 'H01408', 'Periodontal disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (32, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (33, 15, 'Akkermansia muciniphila ameliorates experimental colitis in murine models by reinforcing gut epithelial barrier integrity, reducing mucosal permeability, and attenuating intestinal inflammatory responses.', '6a12081db057cabe2a26516d7a8d24bfd4bf867f1da86d0304dc7a33cda2bb9c', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (33, 'kegg_disease', 'H01466', 'Ulcerative colitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (33, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (34, 15, 'Akkermansia muciniphila enhances antitumor immunity in colorectal cancer patients receiving immune checkpoint inhibitor therapy; higher pre-treatment Am abundance correlates with improved immunotherapy response.', 'fdcf34374ee503cf2fd4a8851956cceee93eee1c620dd4a798dd7ab13b56fe1f', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (34, 'kegg_disease', 'H00020', 'Colorectal cancer', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (34, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (35, 15, 'Akkermansia muciniphila is associated with enhanced antitumor immunity in prostate cancer; its abundance supports immune checkpoint inhibitor efficacy in preclinical and observational contexts.', '1efe7295551bb06a4898cdbfce7e4ba0b972665db7019051b58dd7fd6ec1a105', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (35, 'kegg_disease', 'H00024', 'Prostate cancer', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (35, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (36, 15, 'Akkermansia muciniphila protects intestinal epithelial barrier integrity by degrading the mucin layer in a regulated manner, reducing gut permeability and limiting translocation of microbial products that drive systemic inflammation.', 'ccf9a30c465bda7d4df7617af3a7f74dd063dd0885a5b737ac8d070592e53f59', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (36, 39456922, '2026-04-01');

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
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (16, 'bloom_trigger', 'immunosuppression', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (16, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (37, 16, 'Aspergillus terreus was isolated from bronchoalveolar lavage in a post-allogeneic HSCT patient with B-cell ALL, causing invasive pulmonary aspergillosis that required combination antifungal therapy with isavuconazole and caspofungin.', '1a632710f0a6fa8c02d3e109e150c047566cdfd832b540f78a6d6b5ea1bfdcad', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (37, 'kegg_disease', 'H01328', 'Aspergillosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (37, 40544256, '2026-04-01');

-- ── MCA-BAC-000016  Bifidobacterium
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (17, 'MCA-BAC-000016', 'Bifidobacterium', 'genus', 'Bacteria', 'Bacteria|Actinomycetota|Actinomycetes|Bifidobacteriales|Bifidobacteriaceae', 1678, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (17, 'unknown', 'unknown', NULL, 'https://bacdive.dsmz.de/strain/1682', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (17, 'synonym', 'Bifidibacterium', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (17, 'synonym', 'Tissieria', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (17, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (17, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (17, 'amr_highlight', 'intrinsic glycopeptide resistance (vancomycin; lacks acquired vanA/vanB/vanC genes)', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (17, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (38, 17, 'Bifidobacterium species display intrinsic vancomycin resistance but lack acquired resistance genes (vanA, vanB, vanC) and have fewer reported associations with bloodstream infections compared to Lacticaseibacillus spp., suggesting a relatively lower BSI risk profile for immunocompromised patients receiving Bifidobacterium-containing probiotics.', '7bd46fa2805f950ca14842f55f2b932cb1763248a3ddcd552fd51e9b1d271abb', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (38, 40544256, '2026-04-01');

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
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (19, 'MCA-BAC-000018', 'Enterococcus faecalis', 'species', 'Bacteria', 'Bacteria|Bacillota|Bacilli|Lactobacillales|Enterococcaceae|Enterococcus', 1351, 'context dependent', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (19, 'gram-positive', 'facultative anaerobe', 'coccus', 'https://bacdive.dsmz.de/strain/5279', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Enterococcus proteiformis', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Enterocoque', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Micrococcus ovalis', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Micrococcus zymogenes', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Streptococcus faecalis', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Streptococcus glycerinaceus', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'synonym', 'Streptococcus liquefaciens', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'primary_niche', 'urinary tract', 'D014551', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'reservoir', 'animal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'typical_specimen', 'wound swab', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'risk_context', 'immunocompromised patients', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Ace', 'VF0355', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'AS', 'VF0352', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'BopD', 'VF0362', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Capsule', 'VF0361', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Cytolysin', 'VF0356', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Ebp pili', 'VF0538', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'EfaA', 'VF0354', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Esp', 'VF0353', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Fsr', 'VF0360', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Gelatinase', 'VF0357', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'Hyaluronidase', 'VF0359', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (19, 'virulence_factor', 'SprE', 'VF0358', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (19, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (39, 19, 'Enterococcus faecalis was isolated from a wound swab in a post-HSCT immunocompromised patient with B-cell ALL; treatment with cefepime was initiated but discontinued due to cefepime-induced neurotoxicity.', '20f4d782fe6c10dc2eec8bba94b3b0bb26b21e0922ae4dd0dea129cfa77ceb6d', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (39, 40544256, '2026-04-01');

-- ── MCA-BAC-000019  Fusobacterium nucleatum
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (20, 'MCA-BAC-000019', 'Fusobacterium nucleatum', 'species', 'Bacteria', 'Bacteria|Fusobacteriota|Fusobacteriia|Fusobacteriales|Fusobacteriaceae|Fusobacterium', 851, 'yes', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (20, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', NULL, '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'synonym', 'Fusobacterium fusiforme', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'synonym', 'Fusobacterium plauti-vincenti', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'key_trait', 'biofilm-forming', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'primary_niche', 'oral cavity', 'D009055', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'transmission_route', 'oral-gut translocation (oral-to-gut; facilitated by Fn resistance to acidic pH and OMV-mediated systemic dissemination)', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'role', 'primary pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'role', 'biofilm former', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'role', 'coloniser', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'typical_specimen', 'biopsy', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'typical_specimen', 'unknown', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'risk_context', 'colorectal cancer', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'risk_context', 'inflammatory bowel disease (IBD)', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'risk_context', 'periodontitis patients', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'risk_context', 'rheumatoid arthritis', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (20, 'amr_highlight', 'unknown', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (20, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (40, 20, 'Fusobacterium nucleatum acts as a bridging colonizer in periodontal biofilm and contributes to the progression of periodontitis through immune dysregulation and polymicrobial community assembly at the periodontal niche.', '5c5957c70b1d1c51eef6feb67af78761c8577c57c1f3f3f5e148a881d856ac8c', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (40, 'mesh', 'D010518', 'Periodontitis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (40, 'kegg_disease', 'H01408', 'Periodontal disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (40, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (41, 20, 'Fusobacterium nucleatum OMVs deliver FadA adhesin to colorectal epithelial cells, activating Wnt/β-catenin signaling and promoting tumor invasion, immune evasion, and chemotherapy resistance in colorectal cancer.', '29d7f0fca1ac1799a265bcce49672acee99f650aac13167b23294722fc197719', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (41, 'kegg_disease', 'H00020', 'Colorectal cancer', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (41, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (42, 20, 'Fusobacterium nucleatum is enriched in the gut mucosa of patients with inflammatory bowel disease, and its OMVs exacerbate mucosal inflammation and intestinal barrier disruption in murine models of ulcerative colitis and Crohn\'s disease.', 'b9fcb63a3a8862a2ef861c1c7d22b724b5f67b35f0e286ef9284e381ee0eff5f', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (42, 'kegg_disease', 'H01466', 'Ulcerative colitis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (42, 'kegg_disease', 'H00286', 'Crohn disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (42, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (43, 20, 'Fusobacterium nucleatum is associated with rheumatoid arthritis pathogenesis; Fn OMVs activate pro-inflammatory TLR-mediated pathways relevant to synovial inflammation.', '82cd87b9deacd8b3748f5fbfc20bfe7167a2d60e92091779c8986bf3724c063f', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (43, 'kegg_disease', 'H00630', 'Rheumatoid arthritis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (43, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (44, 20, 'Fusobacterium nucleatum OMVs induce acute hepatotoxicity and liver injury in murine models via the gut–liver axis, involving TLR4-dependent signaling and NLRP3 inflammasome activation in hepatocytes.', '5c0dfd41a1be3b134682ba84a2ff215510822caed9a715c78390db5663d91aaf', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (44, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (45, 20, 'Fusobacterium nucleatum has been detected in human atherosclerotic plaques and promotes platelet aggregation and systemic pro-inflammatory signaling, suggesting a potential role in atherosclerosis pathogenesis.', 'dca363784a775bceefb2650dbe6e7f49f024615cf17c839be307f1466b62320e', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (45, 'kegg_disease', 'H02505', 'Atherosclerosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (45, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (46, 20, 'Fusobacterium nucleatum is associated with lung cancer; Fn OMVs may facilitate pulmonary immune evasion and metastatic seeding via systemic dissemination from the oral-gut axis.', 'd4c7e4aafab44abc7005551fbf6ab8ff41ee28e4699b9ea496377fbbd08f969d', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (46, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (47, 20, 'Fusobacterium nucleatum has been detected in breast cancer tissue and is associated with tumor progression and immune evasion in breast cancer patients.', 'aa0e0eb36f11035b5f666d3a2fa457aa2db174e79cea4ba78468350c3109e130', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (47, 'kegg_disease', 'H00031', 'Breast cancer', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (47, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (48, 20, 'Fusobacterium nucleatum induces gut microbiota dysbiosis characterized by loss of protective commensals and intestinal barrier disruption, contributing to systemic inflammatory burden.', '43f09dc0f0c658a878e23b866c820c77a6b3ed65be95311a29e6958a09cc2600', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (48, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (48, 39456922, '2026-04-01');

-- ── MCA-BAC-000020  Lacticaseibacillus rhamnosus
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (21, 'MCA-BAC-000020', 'Lacticaseibacillus rhamnosus', 'species', 'Bacteria', 'Bacteria|Bacillota|Bacilli|Lactobacillales|Lactobacillaceae|Lacticaseibacillus', 47715, 'yes', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (21, 'gram-positive', 'facultative anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/6423', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'synonym', 'Lactobacillus rhamnosus', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'synonym', 'Lactobacillus casei subsp. rhamnosus', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'synonym', 'Lactobacillus casei rhamnosus', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'primary_niche', 'oral cavity', 'D009055', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'primary_niche', 'vagina', 'D014621', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'reservoir', 'food', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'typical_specimen', 'blood', 'D001769', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'risk_context', 'immunocompromised patients', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'risk_context', 'hematopoietic cell transplant recipients', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'bloom_trigger', 'antibiotic exposure', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'bloom_trigger', 'immunosuppression', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'bloom_trigger', 'chemotherapy', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (21, 'amr_highlight', 'intrinsic glycopeptide resistance (teicoplanin and vancomycin)', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (21, 40544256, '2026-04-01');
INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (21, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (49, 21, 'Gut intestinal domination by Lacticaseibacillus rhamnosus (71.6% relative abundance by shotgun metagenomics) was temporally associated with bloodstream infection in a post-allogeneic HSCT patient with B-cell ALL; genomic comparison between the gut-dominant strain and the blood culture isolate revealed only 18 SNP differences, supporting direct gut-to-bloodstream translocation as the mechanism of bacteremia.', 'a9d5b9c30cd4078445d42d3ac1c40636921257f830a97781518f6c48f5e04419', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (49, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (50, 21, 'Lacticaseibacillus rhamnosus was isolated from multiple concurrent blood culture sites (PICC, CVC, peripheral vein) in a severely immunocompromised post-HSCT patient during the final week of life, with markedly elevated sepsis markers (procalcitonin 2.4 ± 1.87 ng/L; D-dimer 7518 ± 2801.7 ng/mL), contributing to a fatal multi-organ toxicity outcome.', 'adb6a07e58e8cd545e160263ee29c3569e87f3215383e88af41cb87b6e20e56c', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (50, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (51, 21, 'Lacticaseibacillus rhamnosus demonstrates intrinsic resistance to glycopeptides (teicoplanin and vancomycin) with no established EUCAST breakpoints, complicating antimicrobial management of Lactobacillus bloodstream infections in immunocompromised patients.', 'eb347ce8f63e7ca7d40f75d8e98502e5b4c597229d0dbfbad5ef67e558b23f46', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (51, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (52, 21, 'Lactobacillus rhamnosus GG (LGG)–based probiotic administration to germ-free mice colonized with an ICB complete responder\'s microbiota significantly impaired antitumor response to anti-PD-L1 therapy, resulting in significantly larger tumors compared to sterile water control (P=0.01 by likelihood ratio test in linear mixed model; n=4–5 per group), with concomitant reduction in gut microbiome alpha diversity (inverse Simpson index, P=0.38 vs. control — non-significant trend).', 'edb0361ca93b768811890b7a3f68b878d1fdbb32a730ce274fa451b179f1867e', 'E1', 'preclinical murine model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (52, 'mesh', 'D008546', 'Melanoma, Experimental', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (52, 'mesh', 'D019936', 'Probiotics', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (52, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (52, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (52, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (53, 21, 'LGG-based probiotic administration significantly reduced the frequency of IFN-γ–positive CD8+ cytotoxic T cells in the tumor microenvironment of anti-PD-L1–treated melanoma-bearing germ-free mice (P=0.03 by supervised flow cytometry analysis; n=6 per group), indicating suppression of intratumoral cytotoxic T cell responses as a mechanism of impaired ICB efficacy.', '7df76d823b1b9a0eeeb9720641044c821966ab1c9479e365e7b68643124bd27e', 'E1', 'preclinical murine model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (53, 'mesh', 'D008546', 'Melanoma, Experimental', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (53, 'mesh', 'D013601', 'T-Lymphocytes', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (53, 'mesh', 'D019936', 'Probiotics', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (53, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (53, 34941392, '2026-04-01');

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

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (54, 22, 'Pediococcus acidilactici was the second most abundant species in the gut microbiome (17.4% by shotgun metagenomics) at the time of Lacticaseibacillus rhamnosus bloodstream infection in a post-HSCT patient with B-cell ALL, co-dominating a markedly dysbiotic Bacillota-predominant microbiome (98.5% Bacillota total).', '1cf0f1934039383a94ea777a63fba0b4fc0726253e01c67aca6422f005955cf9', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (54, 40544256, '2026-04-01');

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

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (55, 23, 'Porphyromonas gingivalis acts as a keystone pathobiont in periodontitis, orchestrating immune dysregulation and promoting polymicrobial community virulence in the periodontal niche.', '3f3fc1d79ad4f22a18c324c81fdd009850fd2a9d642bcb148c42a9247fd03da1', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (55, 'mesh', 'D010518', 'Periodontitis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (55, 'kegg_disease', 'H01408', 'Periodontal disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (55, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (56, 23, 'Porphyromonas gingivalis is associated with rheumatoid arthritis (RA) pathogenesis via PPAD-mediated citrullination of host proteins; anti-PPAD and anti-RgpA antibodies demonstrate positive predictive values of 82.5% and 93.7% for RA diagnosis, respectively.', '847a7d34c7201157d6b0371d5c87170233d2ab1e0610042cff9d82b03af42ffd', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (56, 'kegg_disease', 'H00630', 'Rheumatoid arthritis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (56, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (57, 23, 'Porphyromonas gingivalis OMVs are associated with Alzheimer\'s disease-like pathology in mice, inducing neuroinflammation via microglial NLRP3 inflammasome activation, tau phosphorylation, and cognitive impairment following oral administration.', 'b9e7e8145db35411208be3e91727eba7f8abea8becdf888f37ac27c396cf9e61', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (57, 'kegg_disease', 'H00056', 'Alzheimer disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (57, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (58, 23, 'Porphyromonas gingivalis is associated with type 1 diabetes mellitus.', 'cb1d5ce0e48331250f39d2bfb49e2cb3756be119a418265d3a1c356f20d68377', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (58, 'kegg_disease', 'H00408', 'Type 1 diabetes mellitus', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (58, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (59, 23, 'Porphyromonas gingivalis and its OMVs are associated with cardiovascular disease risk, including platelet aggregation and potential contribution to atherosclerosis and myocardial infarction via systemic inflammation.', 'dd499c375a3566aca1a75b9fe4d743b0a85b53b636d070cdb830e040f65ed6e3', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (59, 'kegg_disease', 'H01742', 'Coronary artery disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (59, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (60, 23, 'Porphyromonas gingivalis is associated with non-alcoholic fatty liver disease (NAFLD) progression, inducing gut dysbiosis with reduced SCFA producers, gingipain-mediated ferroptosis in hepatocytes, and elevated hepatic lipid accumulation and glucose intolerance in murine models.', '637b9a5672072f266c160b9ba406ca0cecae82086c734b0d907c043223145738', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (60, 'kegg_disease', 'H01333', 'Non-alcoholic fatty liver disease', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (60, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (61, 23, 'Porphyromonas gingivalis is associated with colorectal cancer.', '1ec1e48961cf718ace4886da08dff040d63cc945b22a7932c68ab34520513fc7', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (61, 'kegg_disease', 'H00020', 'Colorectal cancer', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (61, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (62, 23, 'Porphyromonas gingivalis is associated with esophageal cancer.', 'b396cc50093537966f9ecaeb435ff8d40446b5169114a7a8be626f364f5720fe', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (62, 'kegg_disease', 'H00017', 'Esophageal cancer', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (62, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (63, 23, 'Porphyromonas gingivalis is associated with pancreatic cancer.', '70f4094963ed871cee011676f39903f0673f5deee935e247f7ec85c7b442e42f', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (63, 'kegg_disease', 'H00019', 'Pancreatic cancer', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (63, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (64, 23, 'Porphyromonas gingivalis is associated with hepatocellular carcinoma.', '98eb3a3a63b1c76df5d0fd09f338ccbfb47dfcbd02fd1cf8f2524d13e443ab1d', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (64, 'kegg_disease', 'H00048', 'Hepatocellular carcinoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (64, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (65, 23, 'Porphyromonas gingivalis OMVs exacerbate diabetic retinopathy, increasing blood-retinal barrier permeability and pathological microvasculature alterations in a streptozotocin-induced mouse model.', '9b5af69f08b245a93e6ca452467e12c584f336fc41379ef06f69e01d3dc1a7b9', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (65, 'kegg_disease', 'H01457', 'Diabetic retinopathy', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (65, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (66, 23, 'Porphyromonas gingivalis induces gut microbiota dysbiosis characterized by reduced Firmicutes, Lactobacillus spp., and Akkermansia muciniphila and increased Bacteroidales, accompanied by systemic inflammation and insulin resistance.', '56ef71c7951b651cddc2878be8be6595a9cc53af3c438bbc01524132ec1510be', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (66, 'mesh', 'D064806', 'Dysbiosis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (66, 39456922, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (67, 23, 'Porphyromonas gingivalis OMVs disrupt trophoblast interactions with vascular and immune cells in an in vitro early placentation model, suggesting a potential contribution to pregnancy complications.', '6e9faf3fda6839f64225e3edede1ff3388d093a1edcf13ede3b8709db4bf29c7', 'E1', 'narrative review', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (67, 39456922, '2026-04-01');

-- ── MCA-BAC-000023  Staphylococcus epidermidis
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (24, 'MCA-BAC-000023', 'Staphylococcus epidermidis', 'species', 'Bacteria', 'Bacteria|Bacillota|Bacilli|Bacillales|Staphylococcaceae|Staphylococcus', 1282, 'context dependent', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (24, 'gram-positive', 'facultative anaerobe', 'coccus', 'https://bacdive.dsmz.de/strain/14522', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'synonym', 'Albococcus epidermidis', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'synonym', 'Micrococcus epidermidis', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'synonym', 'Staphylococcus epidermidis albus', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'primary_niche', 'skin', 'D012867', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'typical_specimen', 'blood', 'D001769', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (24, 'risk_context', 'immunocompromised patients', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (24, 40544256, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (68, 24, 'Staphylococcus epidermidis caused a catheter-related bloodstream infection during conditioning chemotherapy in a 20-year-old immunocompromised patient undergoing allogeneic HSCT for B-cell ALL, treated empirically with meropenem, vancomycin, and liposomal amphotericin B.', '743fed55fc4a5263dc1329822925c55eba2f48e5706a17642404589be5bdb4eb', 'E1', 'case report', '2026-04-01', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (68, 40544256, '2026-04-01');

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
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (26, 'MCA-BAC-000025', 'Bifidobacterium longum', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Actinomycetota|Actinomycetes|Bifidobacteriales|Bifidobacteriaceae|Bifidobacterium', 216816, 'context dependent', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (26, 'unknown', 'obligate anaerobe', NULL, 'https://bacdive.dsmz.de/strain/1708', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'reservoir', 'food', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'role', 'commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'role', 'probiotic candidate', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (26, 'risk_context', 'melanoma patients receiving immune checkpoint inhibitor therapy (ICB)', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (26, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (69, 26, 'Bifidobacterium longum 35624–based probiotic administration to germ-free mice colonized with an ICB complete responder\'s microbiota significantly impaired antitumor response to anti-PD-L1 therapy, resulting in significantly larger tumors compared to sterile water control (P=0.04 by likelihood ratio test in linear mixed model; n=4–5 per group), with concomitant reduction in gut microbiome alpha diversity (inverse Simpson index).', 'bae3fcbb9f0752c33974e4c8be2ca391b5fd2f419a2feaa579fc5ba1a8674337', 'E1', 'preclinical murine model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (69, 'mesh', 'D008546', 'Melanoma, Experimental', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (69, 'mesh', 'D019936', 'Probiotics', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (69, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (69, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (69, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (70, 26, 'B. longum 35624–based probiotic administration significantly reduced the frequency of IFN-γ–positive CD8+ cytotoxic T cells in the tumor microenvironment of anti-PD-L1–treated melanoma-bearing germ-free mice (P=0.03 by supervised flow cytometry analysis; n=6 per group), indicating suppression of intratumoral cytotoxic T cell responses as a mechanism of impaired ICB efficacy.', 'd723d75d48041374df92b26d9995be224f8247d82441728070304daad45d69e5', 'E1', 'preclinical murine model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (70, 'mesh', 'D008546', 'Melanoma, Experimental', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (70, 'mesh', 'D013601', 'T-Lymphocytes', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (70, 'mesh', 'D019936', 'Probiotics', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (70, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (70, 34941392, '2026-04-01');

-- ── MCA-BAC-000026  Enterococcus gallinarum
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (27, 'MCA-BAC-000026', 'Enterococcus gallinarum', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Bacilli|Lactobacillales|Enterococcaceae|Enterococcus', 1353, 'yes', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (27, 'unknown', 'microaerophile', NULL, 'https://bacdive.dsmz.de/strain/5310', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'primary_niche', 'gut', 'D041981', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'reservoir', 'animal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'role', 'opportunistic pathogen', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'role', 'coloniser', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'typical_specimen', 'biopsy', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'risk_context', 'immunocompromised patients', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (27, 'bloom_trigger', 'inflammation', NULL, '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (27, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (71, 27, 'Enterococcus gallinarum undergoes within-host evolution into mucosally-adapted lineages that exhibit significantly increased translocation to the mesenteric lymph nodes and liver compared to luminal lineages in germ-free monocolonised mice.', '35492a317f412c60dd6fdda302b45bbae35aa94bb6a184caa8ad31fbc10f00e3', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (71, 'mesh', 'D018988', 'Bacterial Translocation', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (71, 'mesh', 'D008099', 'Liver', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (71, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (72, 27, 'Enterococcus gallinarum mucosally-adapted liver isolates exhibit significantly increased resistance to lysozyme-mediated growth inhibition, cathelicidin-related antimicrobial peptide (mCRAMP) killing, and macrophage phagocytosis compared to luminal faecal isolates in vitro.', 'ec5001724ce58cdd42ee76ecfda34d67ded1fc57347279af966801de42321a7d', 'E1', 'in vitro', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (72, 'mesh', 'D054884', 'Host-Pathogen Interactions', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (72, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (73, 27, 'Enterococcus gallinarum liver-adapted isolates induce increased intestinal permeability and reduced epithelial barrier defences, including decreased mucus production, reduced intraepithelial lymphocyte recruitment, and altered tight junction protein expression, in germ-free monocolonised mice.', '5e4026c1143d665f8a6259c4c771c4f96ae890e9b8e9a51379a60a9a13f63d7c', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (73, 'mesh', 'D007413', 'Intestinal Mucosa', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (73, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (74, 27, 'Enterococcus gallinarum liver-adapted isolates induce increased hepatic inflammatory gene expression, including upregulation of pro-inflammatory cytokines, interferon-stimulated genes, serum amyloid A proteins, and collagen, compared to faecal isolates in germ-free monocolonised mice.', '4ca1c31461ae33d3c8bd80eea059bfcde66a4f11aa1a8a971766a8d1dc6a3f09', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (74, 'mesh', 'D008099', 'Liver', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (74, 'mesh', 'D007249', 'Inflammation', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (74, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (75, 27, 'Enterococcus gallinarum translocation to the liver exacerbates lupus-like autoimmune manifestations including hepatosplenomegaly, proteinuria, and elevated anti-dsDNA autoantibodies in a TLR7 agonist (imiquimod)-induced autoimmunity mouse model.', 'cf365abb895359749a8faf70725c4ef8318f4380dce2926687767e964ccf3bce', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (75, 'mesh', 'D008180', 'Lupus Erythematosus, Systemic', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (75, 'kegg_disease', 'H00080', 'Systemic lupus erythematosus', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (75, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (76, 27, 'Enterococcus gallinarum mucosally-adapted isolates produce an enhanced capsular polysaccharide layer that facilitates evasion of innate immune recognition and is associated with increased liver translocation in germ-free monocolonised mice.', '739b3002124cc77d311f38fcced3e3ea15e5072d05853c19cf11fc0e962e59a2', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (76, 'mesh', 'D054884', 'Host-Pathogen Interactions', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (76, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (77, 27, 'Enterococcus gallinarum has been detected in liver biopsies from patients with autoimmune hepatitis and primary sclerosing cholangitis, as reported in prior studies cited by the authors; this finding motivated the in vivo translocation experiments in this paper.', '47ee33231a2bd563309b16ad68ad03953c2aa72e058ca53e86f39431ef2a6acc', 'E1', 'cited clinical observation', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (77, 'mesh', 'D019693', 'Hepatitis, Autoimmune', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (77, 'mesh', 'D015209', 'Cholangitis, Sclerosing', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (77, 'kegg_disease', 'H01685', 'Autoimmune hepatitis', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (77, 'kegg_disease', 'H01684', 'Primary sclerosing cholangitis', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (77, 35831502, '2026-04-01');

-- ── MCA-BAC-000027  Faecalibacterium prausnitzii
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (28, 'MCA-BAC-000027', 'Faecalibacterium prausnitzii', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Clostridia|Eubacteriales|Oscillospiraceae|Faecalibacterium', 853, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (28, 'unknown', 'obligate anaerobe', NULL, 'https://bacdive.dsmz.de/strain/159475', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (28, 'key_trait', 'butyrate-producing', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (28, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (28, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (28, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (28, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (28, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (78, 28, 'Faecalibacterium prausnitzii relative abundance was enriched in anti-PD-1 responders versus non-responders in the shotgun metagenomic subset of 111 metastatic melanoma patients (n=71 responders, n=40 non-responders; fig. S2A), providing species-level confirmation of its association with immunotherapy response.', '4d3e85a8bd6602f95fe77d994eeccf4b2505b8a7eb8cd14875302b8a90d6ec93', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (78, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (78, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (78, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (78, 34941392, '2026-04-01');

-- ── MCA-BAC-000028  Faecalibacterium
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (29, 'MCA-BAC-000028', 'Faecalibacterium', 'genus', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Clostridia|Eubacteriales|Oscillospiraceae', 216851, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (29, 'unknown', 'obligate anaerobe', NULL, 'https://bacdive.dsmz.de/strain/159475', '2026-04-01', '2026-04-01');

INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (29, 'key_trait', 'butyrate-producing', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (29, 'primary_niche', 'gut', 'D007422', '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (29, 'reservoir', 'human', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (29, 'role', 'protective commensal', NULL, '2026-04-01', '2026-04-01');
INSERT INTO taxon_tag (passport_id, category, value, ext_id, created_at, updated_at) VALUES (29, 'typical_specimen', 'stool', 'D005243', '2026-04-01', '2026-04-01');

INSERT INTO passport_pmid (passport_id, pmid, created_at) VALUES (29, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (79, 29, 'Faecalibacterium genus relative abundance was significantly higher in anti-PD-1 responders versus non-responders in a newly recruited independent cohort of 132 metastatic melanoma patients (n=87 responders, n=45 non-responders; p=0.018 by Wilcoxon rank sum test), supporting its role as a gut microbiota marker of immunotherapy response.', '2aefe1f783dc1eb57926b2c0eddeface72790a1680ac6b0dda5a1bb11ef4f6c9', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (79, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (79, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (79, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (79, 34941392, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (80, 29, 'In melanoma patients treated with ICB (n=123), Faecalibacterium genus abundance was numerically higher in patients reporting sufficient dietary fiber intake (≥20 g/day) and no probiotic use — the subgroup with significantly longer progression-free survival (median PFS not reached versus 13 months, P=0.015 vs. all other groups) — though the Faecalibacterium difference per se did not reach statistical significance due to small group size (n=22 in optimal group).', '402d260529584830fad673654d1631e9cd69a07f7ac6dd05213619075788cd9b', 'E2', 'prospective cohort', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (80, 'mesh', 'D008545', 'Melanoma', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (80, 'mesh', 'D000082082', 'Immune Checkpoint Inhibitors', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (80, 'mesh', 'D004043', 'Dietary Fiber', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (80, 'kegg_disease', 'H00038', 'Melanoma', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (80, 34941392, '2026-04-01');

-- ── MCA-BAC-000029  Lacticaseibacillus paracasei
INSERT INTO passport (id, passport_id, preferred_name, taxon_rank, domain, lineage, ncbi_taxid, is_pathobiont, last_reviewed, created_at, updated_at) VALUES (30, 'MCA-BAC-000029', 'Lacticaseibacillus paracasei', 'species', 'Bacteria', 'cellular organisms|Bacteria|Bacillati|Bacillota|Bacilli|Lactobacillales|Lactobacillaceae|Lacticaseibacillus', 1597, 'no', '2026-04-01', '2026-04-01', '2026-04-01');

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (30, 'gram-positive', 'facultative anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/6433', '2026-04-01', '2026-04-01');

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

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (81, 33, 'Limosilactobacillus reuteri exhibited liver translocation in a subset of germ-free mice following three-month monocolonization, demonstrating capacity for bacterial translocation from gut to liver in an animal model.', 'cc94b4a68bdd8e9fb8e35b2a4e6d7f6d23d863422cc409755c88fe79466e0e13', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (81, 'mesh', 'D018988', 'Bacterial Translocation', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (81, 'mesh', 'D008099', 'Liver', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (81, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (82, 33, 'Limosilactobacillus reuteri exhibits divergent within-host evolution with mucosal and luminal lineage diversification and enhanced immune evasion capacity in a germ-free mouse monocolonization model, with a pattern broadly similar to Enterococcus gallinarum.', '870980faa1ee90599a95a83eba546cd5b539e927eb48e851ada616063293ffbd', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (82, 'mesh', 'D054884', 'Host-Pathogen Interactions', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (82, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (83, 33, 'Limosilactobacillus reuteri liver-adapted isolates demonstrate enhanced liver persistence in vivo, with liver populations enriched for a triple mutant genotype (lacS/greA/ccpA) compared to faecal isolates in germ-free monocolonized mice.', 'ce2bb0b0012c9dbe4e14a9ba3d7034caabb4938826fc4f2fb263687f6f4c2901', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (83, 'mesh', 'D008099', 'Liver', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (83, 35831502, '2026-04-01');

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (84, 33, 'Limosilactobacillus reuteri has been previously reported to translocate to the liver in a mouse model of lupus, as cited in this study as prior evidence motivating its use as a comparative organism.', '75161b8b21df2a1d31226b75488dd575a2cf41918d483800073ec187892a8502', 'E1', 'cited animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (84, 'mesh', 'D008180', 'Lupus Erythematosus, Systemic', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (84, 'kegg_disease', 'H00080', 'Systemic lupus erythematosus', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (84, 35831502, '2026-04-01');

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

INSERT INTO biology (passport_id, gram_status, oxygen_tolerance, morphology, bacdive_url, created_at, updated_at) VALUES (35, 'gram-negative', 'obligate anaerobe', 'bacillus (rod)', 'https://bacdive.dsmz.de/strain/3072', '2026-04-01', '2026-04-01');

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

INSERT INTO association (id, passport_id, association_text, content_hash, evidence_level, evidence_type, created_at, updated_at) VALUES (85, 35, 'Bacteroides fragilis exhibits mucosal/luminal lineage divergence (within-host evolution) in germ-free monocolonised mice but did not translocate to the liver, unlike Enterococcus gallinarum, suggesting that within-host evolutionary diversification is a broad property of gut bacteria but that liver translocation capacity is taxon-specific.', '0b5e999cda03bf2f275dda16ee9b95ff13f6192aec59cf064218033ed07a366d', 'E1', 'animal model', '2026-04-01', '2026-04-01');
INSERT INTO assoc_ref (association_id, ref_type, ref_id, ref_label, created_at) VALUES (85, 'mesh', 'D018988', 'Bacterial Translocation', '2026-04-01');
INSERT INTO assoc_pmid (association_id, pmid, created_at) VALUES (85, 35831502, '2026-04-01');

SET FOREIGN_KEY_CHECKS = 1;

-- 35 passport(s), 85 association(s) written
-- 42 association(s) skipped (UNCERTAIN grade — not in SQL ENUM)
