-- this is the itinerary per traveler with their specific add_on, that we use to feed dipcher
with dipcher as (
select t.id_viaje, SAFE_CAST(t.od_id AS INT64) as od_id, t.add_on_id,  t.Fecha_Inicio, t.Fecha_Termino, t.Hora_Inicio, t.Cantidad_Usuarios,
REGEXP_REPLACE(NORMALIZE(t.Lugar, NFD), r'\p{M}', '') AS Lugar, t.Item,
REGEXP_REPLACE(NORMALIZE(t.Detalle, NFD), r'\p{M}', '') AS Detalle,
ta.first_name, ta.last_name, ta.phone_number, ta.email, ta.food_restrictions, ta.partner, ta.partner_name 
from  ops.travelers2 ta 
left join ops.middle_procs_dipcher tra on tra.email = ta.email 
 left join ops.trips t on t.id_viaje = tra.trip_id and t.add_on_id = tra.add_on_id
where t.add_on_id is not null 
union all
select t.id_viaje, SAFE_CAST(t.od_id AS INT64) as od_id, t.add_on_id,  t.Fecha_Inicio, t.Fecha_Termino, t.Hora_Inicio, t.Cantidad_Usuarios,
REGEXP_REPLACE(NORMALIZE(t.Lugar, NFD), r'\p{M}', '') AS Lugar, t.Item,
REGEXP_REPLACE(NORMALIZE(t.Detalle, NFD), r'\p{M}', '') AS Detalle,
ta.first_name, ta.last_name, ta.phone_number, ta.email, ta.food_restrictions, ta.partner, ta.partner_name --,
-- p.lugar, p.item, p.detalle, p.n_dias_default, p.contacto, p.telefono, p.comentarios
from ops.trips t
left join ops.travelers2 ta on t.id_viaje = ta.trip_id
--left join ops.partners_procs p on p.od_id = SAFE_CAST(t.od_id AS INT64)
where t.add_on_id is null
)
select *
from dipcher
