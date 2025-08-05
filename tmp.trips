create table tmp.trips as 
select t.trip_id, t.od_id, t.add_on_id, cast(t.start_date as string) as start_date, cast(t.end_date as string) as end_date, -- cast dates so webhook works
t.start_hour, t.n_users, t.place, t.item, t.detail
from ops.trips t
where t.add_on_id is null and Tipo_gasto in ('viaje', 'add_on')
  and t.start_date between DATE_SUB(CURRENT_DATE(), INTERVAL 2 MONTH)
                      and DATE_ADD(CURRENT_DATE(), INTERVAL 7 MONTH)
union all
select t.trip_id, t.od_id, t.add_on_id, cast(t.start_date as string) as start_date, cast(t.end_date as string) as end_date, -- cast dates so webhook works
t.start_hour, t.n_users, t.place, t.item, t.detail
from ops.trips t
where t.add_on_id is not null and Tipo_gasto in ('viaje', 'add_on')
  and t.start_date between DATE_SUB(CURRENT_DATE(), INTERVAL 2 MONTH)
                      and DATE_ADD(CURRENT_DATE(), INTERVAL 7 MONTH)
