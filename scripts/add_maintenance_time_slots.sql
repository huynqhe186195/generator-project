USE generator_cms;

ALTER TABLE maintenances
    ADD COLUMN start_time TIME NULL AFTER maintenance_date,
    ADD COLUMN end_time TIME NULL AFTER start_time;

CREATE INDEX idx_maintenances_technician_date
    ON maintenances (technician_id, maintenance_date);

ALTER TABLE maintenances
    ADD CONSTRAINT chk_maintenances_time_range
    CHECK (
        start_time IS NULL
            OR end_time IS NULL
            OR end_time > start_time
        );
