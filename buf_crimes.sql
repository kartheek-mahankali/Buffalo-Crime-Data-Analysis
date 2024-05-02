-- Total incident count
select count(*) as incident_count
from buf_crimes

-- Remove incidents before 2006 and after 2023
delete
from buf_crimes
where extract(year from incident_datetime) not between 2006 and 2023

-- Incident count per year
select extract(year from incident_datetime) as years, count(1)
from buf_crimes
group by years
order by years










-- Incidents by council district
select council_dist, count(1)
from buf_crimes
group by council_dist
order by 2 desc

-- Which day of the week had highest incidents each year
with tb1 as
(select council_dist, dow, 
 count(*) as incident_count, 
 dense_rank() over(partition by council_dist 
				   order by count(*) desc) as myrank
from buf_crimes
group by council_dist, dow)
select council_dist, dow, incident_count
from tb1
where myrank = 1

-- Which month had highest incidents each year
with tb1 as
(select council_dist, 
 extract(month from incident_datetime) as month_num, 
 count(*) as incident_count, 
 dense_rank() over(partition by council_dist order by count(*) desc) as myrank
from buf_crimes
group by council_dist, month_num)
select council_dist, month_num, incident_count
from tb1
where myrank = 1

-- Top 10 crime categories
select incident_category,  count(*)
from buf_crimes
group by incident_category
order by 2 desc
limit 10

-- The top 10 places where the most occured crime took place the most

with tb1 as (
select incident_category,  count(*)
from buf_crimes
group by incident_category
order by 2 desc
limit 1)

select zip_code, council_dist, count(*)
from buf_crimes b
where incident_category = (select incident_category from tb1)
and zip_code != 'UNKNOWN'
and council_dist != 'UNKNOWN'
group by zip_code, council_dist
order by 3 desc
limit 10

