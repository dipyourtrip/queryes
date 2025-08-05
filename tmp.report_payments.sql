create or replace table tmp.report_payments as 
select *
from ops.report_payments
where trip_id in (select trip_id
from tmp.trips 
group by trip_id)
