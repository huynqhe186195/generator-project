-- Add signed date for contract header
ALTER TABLE contracts
    ADD COLUMN signed_date DATE NULL AFTER customer_id;

-- Staging table for AI extracted items before manager review/apply
CREATE TABLE IF NOT EXISTS contract_ai_extracted_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    contract_id BIGINT NOT NULL,
    source_file_path VARCHAR(500) NULL,
    raw_model_name VARCHAR(255) NULL,
    raw_brand VARCHAR(100) NULL,
    raw_power VARCHAR(100) NULL,
    quantity INT NOT NULL DEFAULT 1,
    raw_serial_number VARCHAR(255) NULL,
    manufacture_year INT NULL,
    current_location VARCHAR(255) NULL,
    matched_model_id BIGINT NULL,
    confidence_score DOUBLE NULL,
    review_status VARCHAR(50) NOT NULL DEFAULT 'EXTRACTED',
    is_user_edited TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_contract_ai_items_contract FOREIGN KEY (contract_id) REFERENCES contracts(id),
    CONSTRAINT fk_contract_ai_items_model FOREIGN KEY (matched_model_id) REFERENCES product_models(id)
);
