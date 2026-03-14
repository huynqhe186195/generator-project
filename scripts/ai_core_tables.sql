CREATE TABLE IF NOT EXISTS ai_sessions (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  module_code VARCHAR(50) NOT NULL,
  context_entity_type VARCHAR(50) DEFAULT NULL,
  context_entity_id BIGINT DEFAULT NULL,
  title VARCHAR(255) DEFAULT NULL,
  status ENUM('OPEN','CLOSED','FAILED','ARCHIVED') NOT NULL DEFAULT 'OPEN',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY idx_ai_sessions_user (user_id),
  KEY idx_ai_sessions_module (module_code),
  KEY idx_ai_sessions_context (context_entity_type, context_entity_id),
  KEY idx_ai_sessions_status (status),
  CONSTRAINT fk_ai_sessions_user FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS ai_messages (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  session_id BIGINT NOT NULL,
  sender_type ENUM('USER','AI','SYSTEM') NOT NULL,
  message_text LONGTEXT,
  content_type ENUM('TEXT','JSON','MARKDOWN') NOT NULL DEFAULT 'TEXT',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_ai_messages_session (session_id),
  KEY idx_ai_messages_created (created_at),
  CONSTRAINT fk_ai_messages_session FOREIGN KEY (session_id) REFERENCES ai_sessions(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ai_attachments (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  session_id BIGINT NOT NULL,
  message_id BIGINT DEFAULT NULL,
  original_file_name VARCHAR(255) NOT NULL,
  stored_path VARCHAR(500) NOT NULL,
  mime_type VARCHAR(100) DEFAULT NULL,
  file_size BIGINT DEFAULT NULL,
  checksum_sha256 VARCHAR(64) DEFAULT NULL,
  attachment_kind ENUM('IMAGE','PDF','DOC','DOCX','XLS','XLSX','OTHER') NOT NULL DEFAULT 'OTHER',
  extracted_text LONGTEXT DEFAULT NULL,
  upload_status ENUM('UPLOADED','OCR_DONE','FAILED') NOT NULL DEFAULT 'UPLOADED',
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_ai_attachments_session (session_id),
  KEY idx_ai_attachments_message (message_id),
  KEY idx_ai_attachments_kind (attachment_kind),
  KEY idx_ai_attachments_checksum (checksum_sha256),
  CONSTRAINT fk_ai_attachments_session FOREIGN KEY (session_id) REFERENCES ai_sessions(id) ON DELETE CASCADE,
  CONSTRAINT fk_ai_attachments_message FOREIGN KEY (message_id) REFERENCES ai_messages(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS ai_runs (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  session_id BIGINT NOT NULL,
  trigger_message_id BIGINT DEFAULT NULL,
  run_type ENUM('CHAT','EXTRACT','SUMMARIZE','CLASSIFY','MATCH','DRAFT') NOT NULL,
  provider VARCHAR(100) DEFAULT NULL,
  model_name VARCHAR(100) DEFAULT NULL,
  status ENUM('QUEUED','RUNNING','SUCCESS','FAILED') NOT NULL DEFAULT 'QUEUED',
  started_at DATETIME DEFAULT NULL,
  finished_at DATETIME DEFAULT NULL,
  error_message TEXT DEFAULT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_ai_runs_session (session_id),
  KEY idx_ai_runs_status (status),
  KEY idx_ai_runs_type (run_type),
  CONSTRAINT fk_ai_runs_session FOREIGN KEY (session_id) REFERENCES ai_sessions(id) ON DELETE CASCADE,
  CONSTRAINT fk_ai_runs_trigger_message FOREIGN KEY (trigger_message_id) REFERENCES ai_messages(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS ai_outputs (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  run_id BIGINT NOT NULL,
  output_type ENUM('TEXT','STRUCTURED_JSON','TABLE','ACTION_PLAN') NOT NULL DEFAULT 'TEXT',
  content_text LONGTEXT DEFAULT NULL,
  content_json JSON DEFAULT NULL,
  confidence_score DECIMAL(5,2) DEFAULT NULL,
  is_applied TINYINT(1) NOT NULL DEFAULT 0,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_ai_outputs_run (run_id),
  KEY idx_ai_outputs_applied (is_applied),
  CONSTRAINT fk_ai_outputs_run FOREIGN KEY (run_id) REFERENCES ai_runs(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS ai_entity_links (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  session_id BIGINT NOT NULL,
  entity_type VARCHAR(50) NOT NULL,
  entity_id BIGINT NOT NULL,
  relation_type VARCHAR(50) DEFAULT NULL,
  created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  KEY idx_ai_entity_links_session (session_id),
  KEY idx_ai_entity_links_entity (entity_type, entity_id),
  CONSTRAINT fk_ai_entity_links_session FOREIGN KEY (session_id) REFERENCES ai_sessions(id) ON DELETE CASCADE
);
