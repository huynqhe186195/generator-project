-- Add soft-delete support for contracts without changing status enum values.
ALTER TABLE contracts
ADD COLUMN deleted_at TIMESTAMP NULL DEFAULT NULL;

-- Optional index to keep list/search queries fast.
CREATE INDEX idx_contracts_deleted_at ON contracts(deleted_at);
