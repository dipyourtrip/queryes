create or replace view ops.report_payments as
WITH conciliated AS (
  SELECT participant_email
  FROM nat.wetravel_participants wp
  INNER JOIN nat.travelers2 t 
    ON wp.trip_id = t.trip_id AND wp.participant_email = t.email
  -- WHERE wp.trip_id = 'Columbia_Chile_Club'
  GROUP BY participant_email  -- required to maintain uniqueness per user input
),
reembolsos AS (
  SELECT buyer_email, trip_id, SUM(amount) AS total_amount, COUNT(*) AS n_pays
  FROM nat.wetravel_payments 
  GROUP BY buyer_email, trip_id
),
participants_data AS (
  SELECT 
    wp.participant_email,
    wp.participant_first_name,
    wp.participant_last_name,
    wp.trip_id,
    r.total_amount,
    wp.n_participants,
    SAFE_DIVIDE(r.total_amount, wp.n_participants) AS amount_per_participant,
    CASE WHEN c.participant_email IS NULL THEN 'not_conciliated' ELSE 'conciliated' END AS status
  FROM nat.wetravel_participants wp
  LEFT JOIN conciliated c 
    ON c.participant_email = wp.participant_email
  LEFT JOIN reembolsos r 
    ON r.trip_id = wp.trip_id AND r.buyer_email = wp.buyer_email
  -- WHERE wp.trip_id = 'Columbia_Chile_Club'
    where r.total_amount > 0
),
pays AS (
  SELECT 
    cp.typeform_email AS participant_email,
    pd.participant_first_name,
    pd.participant_last_name,
    pd.trip_id,
    pd.total_amount,
    pd.n_participants,
    pd.amount_per_participant
  FROM participants_data pd
  LEFT JOIN ops.conciliated_payments cp 
    ON cp.participant_email = pd.participant_email
  WHERE pd.status = 'not_conciliated' AND cp.state = 1 
  UNION ALL
  SELECT 
    pd.participant_email,
    pd.participant_first_name,
    pd.participant_last_name,
    pd.trip_id,
    pd.total_amount,
    pd.n_participants,
    pd.amount_per_participant
  FROM participants_data pd
  WHERE pd.status = 'conciliated'
  -- los not conciliated son los que se deben arreglar en el sheet conciliated_payments
)
SELECT r.*, p.total_amount, p.n_participants, p.amount_per_participant
FROM pays p
LEFT JOIN ops.report r 
  ON r.trip_id = p.trip_id AND r.email = p.participant_email
UNION ALL
select r.*, null as total_amount, null as n_participants, null as amount_per_participant
from ops.conciliated_payments ocp
LEFT JOIN ops.report r on r.email = ocp.typeform_email
where ocp.state = 2
