create or replace table nat.dipcher as  
select t.trip_id, t.od_id, t.add_on_id, t.start_date, t.end_date, t.start_hour, t.n_users, t.place, t.item, t.detail,
ta.first_name, ta.last_name, ta.phone_number, ta.email, ta.food_restrictions, ta.partner_name
from  ops.report_payments ta 
left join nat.middle_procs_dipcher tra on tra.email = ta.email 
left join ops.trips t on t.trip_id = tra.trip_id and t.add_on_id = tra.add_on_id
where t.add_on_id is not null 
  and t.start_date between DATE_SUB(CURRENT_DATE(), INTERVAL 2 MONTH)
                      and DATE_ADD(CURRENT_DATE(), INTERVAL 7 MONTH)
union all
select 
  t.trip_id, t.od_id, t.add_on_id, t.start_date, t.end_date, 
  t.start_hour, t.n_users, t.place, t.item, t.detail,
  ta.first_name, ta.last_name, ta.phone_number, ta.email, 
  ta.food_restrictions, ta.partner_name
from ops.trips t
left join ops.report_payments ta on t.trip_id = ta.trip_id
--left join ops.partners_procs p on p.od_id = SAFE_CAST(t.od_id AS INT64)
where 
  t.add_on_id is null
  and t.start_date between DATE_SUB(CURRENT_DATE(), INTERVAL 2 MONTH)
                      and DATE_ADD(CURRENT_DATE(), INTERVAL 7 MONTH)
