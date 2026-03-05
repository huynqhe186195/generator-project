-- 1) Xóa event TERMINATED trùng (giữ bản mới nhất theo created_at, id)
DELETE ce_old
FROM contract_events ce_old
JOIN contract_events ce_new
  ON ce_old.contract_id = ce_new.contract_id
 AND ce_old.event_type = 'TERMINATED'
 AND ce_new.event_type = 'TERMINATED'
 AND (
      ce_old.created_at < ce_new.created_at
      OR (ce_old.created_at = ce_new.created_at AND ce_old.id < ce_new.id)
 );

-- 2) Làm sạch meta rỗng/bẩn kiểu chỉ chứa decision_doc + terminated_reason trống
UPDATE contract_events
SET meta = NULL
WHERE event_type = 'TERMINATED'
  AND meta IS NOT NULL
  AND JSON_VALID(meta) = 1
  AND COALESCE(JSON_UNQUOTE(JSON_EXTRACT(meta, '$.decision_doc')), '') = ''
  AND COALESCE(JSON_UNQUOTE(JSON_EXTRACT(meta, '$.terminated_reason')), '') = '';
