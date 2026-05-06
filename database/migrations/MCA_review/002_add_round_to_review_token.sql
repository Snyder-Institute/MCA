-- 002_add_round_to_review_token.sql
-- Bind each reviewer token to a review round so review.php can render
-- the correct paper subset per token. Default 1 keeps existing tokens
-- on round 1 with no application changes required.
--
-- Apply on prod: gunzip -c | mysql MCA_review (or via mca_review user
-- with ALTER privilege).

ALTER TABLE review_token
    ADD COLUMN round INT NOT NULL DEFAULT 1
    AFTER created_at;
