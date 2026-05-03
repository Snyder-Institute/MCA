-- ============================================================
-- MCA_review migration 001 — initial schema
--
-- Creates the MCA_review database and its tables. The MCA
-- database is intentionally NOT modified; paper metadata
-- needed by the review pages (including the abstract) is
-- snapshotted into MCA_review.paper_snapshot at ingest time.
--
-- Token-only anonymity: the token <-> reviewer mapping lives
-- offline with the curator and never enters this DB.
--
-- Apply (server-side, run as a user with CREATE DATABASE):
--   mysql < database/migrations/MCA_review/001_init.sql
-- Idempotent (CREATE TABLE IF NOT EXISTS, INSERT IGNORE).
-- ============================================================

CREATE DATABASE IF NOT EXISTS MCA_review
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE MCA_review;

-- ── migrations: matches the same shape used by MCA ──────────
CREATE TABLE IF NOT EXISTS migrations (
  version     INT          NOT NULL,
  applied_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  description VARCHAR(255) NOT NULL,
  PRIMARY KEY (version)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── paper_snapshot: denormalized paper metadata for review ──
-- Captured at ingest time from MCA.paper + extracted abstract.
-- Insulates the review cycle from any concurrent MCA changes.
CREATE TABLE IF NOT EXISTS paper_snapshot (
  pmid          INT UNSIGNED  NOT NULL,
  title         TEXT          NULL,
  authors       TEXT          NULL,
  journal       VARCHAR(500)  NULL,
  year          SMALLINT UNSIGNED NULL,
  study_design  VARCHAR(255)  NULL,
  sample_size   INT UNSIGNED  NULL,
  abstract      TEXT          NULL,
  keywords      TEXT          NULL,    -- comma-separated MeSH descriptors from PubMed
  ingested_at   TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (pmid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── association_snapshot: denormalized association metadata ─
-- Captured at ingest time from staging JSONs. Holds everything
-- review_paper.php needs to render a card without joining MCA.
CREATE TABLE IF NOT EXISTS association_snapshot (
  association_uid    VARCHAR(120) NOT NULL,
  pmid               INT UNSIGNED NOT NULL,
  taxon_passport_id  VARCHAR(20)  NOT NULL,
  taxon_name         VARCHAR(255) NOT NULL,
  taxon_rank         VARCHAR(50)  NULL,
  association_text   TEXT         NOT NULL,
  -- UNCERTAIN is excluded from the SQL dump in production but is preserved
  -- here so reviewers can adjudicate ambiguous claims to a definitive grade.
  evidence_level     ENUM('E1','E2','E3','UNCERTAIN') NOT NULL,
  supporting_pmids   TEXT         NULL,    -- comma-separated
  assoc_refs_json    TEXT         NULL,    -- ontology refs (mesh / kegg_disease) JSON array
  context_json       MEDIUMTEXT   NULL,    -- read-only context section payload
  ingested_at        TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (association_uid),
  KEY idx_pmid (pmid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── review_token: opaque tokens issued to reviewers ─────────
CREATE TABLE IF NOT EXISTS review_token (
  token       VARCHAR(64)  NOT NULL,
  created_at  DATETIME     NOT NULL,
  revoked_at  DATETIME     NULL,
  PRIMARY KEY (token)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── review_paper: per-(token, paper) review state ───────────
-- Every token sees all papers in paper_snapshot — there are no
-- per-reviewer assignments. A row is created lazily on first
-- visit, OR pre-populated by mint_tokens.py as token x N papers.
CREATE TABLE IF NOT EXISTS review_paper (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  token           VARCHAR(64)  NOT NULL,
  pmid            INT UNSIGNED NOT NULL,
  status          ENUM('in_progress','submitted','frozen') NOT NULL DEFAULT 'in_progress',
  submitted_at    DATETIME     NULL,
  frozen_at       DATETIME     NULL,
  context_comment TEXT         NULL,
  UNIQUE KEY u_token_pmid (token, pmid),
  KEY idx_pmid (pmid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ── review_vote: per-(token, association) votes ─────────────
CREATE TABLE IF NOT EXISTS review_vote (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  token            VARCHAR(64)  NOT NULL,
  association_uid  VARCHAR(120) NOT NULL,
  pmid             INT UNSIGNED NOT NULL,
  evidence_vote    ENUM('E1','E2','E3','UNDETERMINED') NULL,
  text_vote        ENUM('accurate','overstated','understated','unsure') NULL,
  comment          TEXT         NULL,
  updated_at       DATETIME     NOT NULL,
  UNIQUE KEY u_token_assoc (token, association_uid),
  KEY idx_assoc (association_uid),
  KEY idx_pmid (pmid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT IGNORE INTO migrations (version, applied_at, description)
VALUES (1, NOW(), 'initial review schema: paper_snapshot, association_snapshot, review_token, review_paper, review_vote');
