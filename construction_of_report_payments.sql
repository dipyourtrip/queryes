-- pagos y ver quien no se ha suscrito
select  participant_email , t.email as typeform_email, first_name, last_name-- buyer_email, trip_id, sum(amount) as total_amount
from  nat.wetravel_participants wp
left join nat.travelers2 t on t.email = wp.participant_email and wp.trip_id = t.trip_id
where wp.trip_id = 'Haas2025'
order by wp.participant_email  asc

-- se ha suscrito y no ha pagado, podría ser invitado
select  participant_email , t.email as typeform_email, first_name, last_name-- buyer_email, trip_id, sum(amount) as total_amount
from  nat.travelers2 t
left join nat.wetravel_participants wp on t.email = wp.participant_email and wp.trip_id = t.trip_id
where t.trip_id = 'Haas2025'
order by wp.participant_email  asc
