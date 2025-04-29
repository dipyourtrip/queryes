
-- ganancia add_ons
create view  ops.finance_report as
with revenue_add_ons as
(
  select tt.id_viaje as trip_id, count(distinct mpd.email) as n_travelers, sum(tt.precio_viaje) as price_add_on
 FROM ops.tripstest tt
 left join ops.middle_procs_dipcher mpd on mpd.add_on_id = tt.add_on_id and tt.id_viaje = mpd.trip_id
 where tt.add_on_id is not null
group by tt.id_viaje
),
 trips_price as (
    select tt.id_viaje as trip_id, count(distinct t2.email) as n_travelers, max(tt.precio_viaje) as price_trip,
    count(distinct t2.email)*max(tt.precio_viaje) as revenue_trip
  FROM ops.tripstest tt
  left join ops.travelers2 t2 on t2.trip_id = tt.id_viaje
  where tt.add_on_id is null and tt.id_viaje is not null
  group by tt.id_viaje
),
operative_cost as (
SELECT 
  id_viaje as trip_id,
  SUM(CAST(REGEXP_REPLACE(Costo_Total, r'[^0-9.]', '') AS FLOAT64)) AS total_cost
FROM 
  ops.tripstest
WHERE 
  id_viaje IN (
    'Wharton_W_Trail_Grey',
    'Wharton_W_Trail_Frances',
    'Whalasa_2025',
    'WhartonW_Shadow',
    'Abhimanyu_HBS_Trip',
    'Sky_Tsoi_Patagonia'
  )
  AND SAFE_CAST(REGEXP_REPLACE(Costo_Total, r'[^0-9.]', '') AS FLOAT64) IS NOT NULL
GROUP BY 
  id_viaje
)
  select tp.trip_id , tp.n_travelers, tp.price_trip, tp.revenue_trip,
rao.n_travelers as n_travelers_add_on, rao.price_add_on,
round(oc.total_cost/960) as total_cost, 
100*round(oc.total_cost/960)/(tp.revenue_trip + rao.price_add_on) as percentage_cost,
100*rao.price_add_on/(tp.revenue_trip + rao.price_add_on) as percentage_add_on
from trips_price tp
left join revenue_add_ons rao on tp.trip_id = rao.trip_id
left join operative_cost oc on oc.trip_id = tp.trip_id
