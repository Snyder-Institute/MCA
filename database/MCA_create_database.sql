-- ============================================================
-- MCA (Microbial Clinical Atlas) — MySQL schema
-- Version:  1.0
-- Engine:   InnoDB
-- Charset:  utf8mb4 / utf8mb4_unicode_ci
-- Tables:   10
-- ============================================================

CREATE DATABASE IF NOT EXISTS MCA
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE MCA;

-- ============================================================
-- 0) Database metadata & schema migrations
-- ============================================================

CREATE TABLE meta (
  key_name  VARCHAR(64)  NOT NULL,
  key_value VARCHAR(255) NOT NULL,
  PRIMARY KEY (key_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO meta (key_name, key_value) VALUES
  ('db_version',     'v1_0_20260401'),
  ('schema_version', '1');

-- ----

CREATE TABLE migrations (
  version     INT          NOT NULL,
  applied_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  description VARCHAR(255) NOT NULL,
  PRIMARY KEY (version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO migrations (version, description) VALUES
  (1, 'Initial schema v1.0');

-- ============================================================
-- 1) Core passport
-- ============================================================

CREATE TABLE passport (
  id             INT UNSIGNED  NOT NULL AUTO_INCREMENT,
  passport_id    VARCHAR(20)   NOT NULL,                        -- MCA-BAC-000001 (stable external ID)
  preferred_name VARCHAR(255)  NOT NULL,
  taxon_rank     ENUM('family','genus','species','strain','clade') NOT NULL,
  domain         ENUM('Bacteria','Archaea','Fungi','Virus','Eukaryote') NOT NULL,
  lineage        TEXT          NOT NULL,                        -- pipe-separated; kept for display
  ncbi_taxid     INT UNSIGNED  NULL,

  is_pathobiont  ENUM('yes','no','context dependent','unknown') NOT NULL DEFAULT 'unknown',
  last_reviewed  DATE          NOT NULL,

  created_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at     TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE INDEX uq_passport_id (passport_id),
  INDEX idx_preferred_name    (preferred_name),
  INDEX idx_taxon_rank        (taxon_rank),
  INDEX idx_domain            (domain),
  INDEX idx_ncbi_taxid        (ncbi_taxid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 2) Biology (0..1 per passport)
-- ============================================================

CREATE TABLE biology (
  passport_id      INT UNSIGNED NOT NULL,
  gram_status      ENUM('gram-positive','gram-negative','gram-variable','not applicable','unknown')                                                    NOT NULL DEFAULT 'unknown',
  morphology       VARCHAR(255) NULL,
  oxygen_tolerance ENUM('aerobe','facultative anaerobe','obligate anaerobe','microaerophile','aerotolerant anaerobe','not applicable','unknown') NOT NULL DEFAULT 'unknown',

  created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (passport_id),
  CONSTRAINT fk_biology_passport
    FOREIGN KEY (passport_id) REFERENCES passport(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 3) Taxon tags — consolidated satellite lists
--
--  category            ext_id meaning
--  ------------------  ----------------------------
--  synonym             (none)
--  key_trait           (none)
--  primary_niche       MeSH anatomy ID  e.g. D007408
--  reservoir           (none)
--  transmission_route  (none)
--  role                (none)
--  typical_specimen    MeSH anatomy ID  e.g. D001769
--  risk_context        (none)
--  bloom_trigger       KEGG Drug ID     e.g. D00645
--  amr_highlight       CARD ARO ID      e.g. ARO:3000026
-- ============================================================

CREATE TABLE taxon_tag (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  passport_id INT UNSIGNED NOT NULL,
  category    ENUM(
                'synonym',
                'key_trait',
                'primary_niche',
                'reservoir',
                'transmission_route',
                'role',
                'typical_specimen',
                'risk_context',
                'bloom_trigger',
                'amr_highlight'
              ) NOT NULL,
  value       VARCHAR(255) NOT NULL,
  ext_id      VARCHAR(20)  NULL,                                -- category-specific external ID

  created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE INDEX uq_passport_cat_value (passport_id, category, value),
  INDEX idx_tag_category             (category),
  INDEX idx_tag_ext_id               (ext_id),
  CONSTRAINT fk_tag_passport
    FOREIGN KEY (passport_id) REFERENCES passport(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 4) Metabolites (0..N per passport)
--    Kept separate — has relationship type and two external IDs
-- ============================================================

CREATE TABLE metabolite (
  id               INT UNSIGNED NOT NULL AUTO_INCREMENT,
  passport_id      INT UNSIGNED NOT NULL,
  metabolite_name  VARCHAR(255) NOT NULL,
  relationship     ENUM('produces','consumes','modifies') NOT NULL DEFAULT 'produces',
  kegg_compound_id VARCHAR(16)  NULL,                           -- e.g. C00246 (butyric acid)
  chebi_id         VARCHAR(16)  NULL,                           -- e.g. CHEBI:17968

  created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE INDEX uq_passport_metabolite (passport_id, metabolite_name, relationship),
  CONSTRAINT fk_metabolite_passport
    FOREIGN KEY (passport_id) REFERENCES passport(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 5) Taxon-level evidence PMIDs (0..N per passport)
-- ============================================================

CREATE TABLE passport_pmid (
  id          INT UNSIGNED NOT NULL AUTO_INCREMENT,
  passport_id INT UNSIGNED NOT NULL,
  pmid        INT UNSIGNED NOT NULL,

  created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE INDEX uq_passport_pmid (passport_id, pmid),
  INDEX idx_pmid                (pmid),
  CONSTRAINT fk_passport_pmid
    FOREIGN KEY (passport_id) REFERENCES passport(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- 6) Clinical associations
-- ============================================================

CREATE TABLE association (
  id               INT UNSIGNED NOT NULL AUTO_INCREMENT,
  passport_id      INT UNSIGNED NOT NULL,
  association_text TEXT         NOT NULL,
  content_hash     CHAR(64)     NOT NULL,                       -- SHA-256 of normalised association_text
  evidence_level   ENUM('E1','E2','E3') NOT NULL,
  evidence_type    VARCHAR(255) NOT NULL,

  created_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE INDEX uq_passport_hash  (passport_id, content_hash),
  INDEX idx_assoc_passport       (passport_id),
  INDEX idx_assoc_evidence_level (evidence_level),
  CONSTRAINT fk_assoc_passport
    FOREIGN KEY (passport_id) REFERENCES passport(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----

-- External reference IDs per association — MeSH terms and KEGG Disease IDs
CREATE TABLE assoc_ref (
  id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
  association_id INT UNSIGNED NOT NULL,
  ref_type       ENUM('mesh','kegg_disease') NOT NULL,
  ref_id         VARCHAR(16)  NOT NULL,                         -- e.g. D009765 or H00409
  ref_label      VARCHAR(255) NULL,                             -- human-readable label (MeSH term name)

  created_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE INDEX uq_assoc_ref (association_id, ref_type, ref_id),
  CONSTRAINT fk_ref_assoc
    FOREIGN KEY (association_id) REFERENCES association(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ----

-- PMIDs per association
CREATE TABLE assoc_pmid (
  id             INT UNSIGNED NOT NULL AUTO_INCREMENT,
  association_id INT UNSIGNED NOT NULL,
  pmid           INT UNSIGNED NOT NULL,

  created_at     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

  PRIMARY KEY (id),
  UNIQUE INDEX uq_assoc_pmid (association_id, pmid),
  INDEX idx_assoc_pmid_pmid  (pmid),
  CONSTRAINT fk_assoc_pmid
    FOREIGN KEY (association_id) REFERENCES association(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
