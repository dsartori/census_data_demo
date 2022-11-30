use [census_demo]
go


/* 

-- this query returns the ordered list of data elements for 2016
select distinct 
     
      cast([member id  profile of dissemination areas (2247)] as int),
	  [dim  profile of dissemination areas (2247)]
  from [dbo].[census_raw_2016]
 order by
      cast([member id  profile of dissemination areas (2247)] as int)

-- for 2021: 
select distinct cast(characteristic_id as int), characteristic_name from census_raw_2021
order by casT(characteristic_id as int)

-- this query returns the list of geo_levels and a count of elements 
-- select distinct 
	geo_level, 
	count(*) 
	from census_raw_2016 group by geo_level order by count(*) asc
*/

drop table if exists #output 
create table #output
(da_id int,
 population_2016 int,
 population_0_to_14_2016 int,
 population_2021 int,
 population_0_to_14_2021 int)

insert into #output  (da_id)
select distinct [geo_code (por)]
from census_raw_2016
WHERE GEO_LEVEL = 4

-- select * from #output

update #output 
set 
	population_2016 = try_cast(c.[Dim  Sex (3)  Member ID   1   Total - Sex] as int)
from #output o
inner join census_raw_2016 c on c.[geo_code (por)] = o.da_id and try_cast(c.[Member ID  Profile of Dissemination Areas (2247)] as int) = 1

update #output
set
	population_0_to_14_2016 = try_cast(c.[Dim  Sex (3)  Member ID   1   Total - Sex] as int)
from #output o
inner join census_raw_2016 c on c.[geo_code (por)] = o.da_id and try_cast(c.[Member ID  Profile of Dissemination Areas (2247)] as int) = 9

update #output
set 
	population_2021 = try_cast(c.c1_count_total as int)
from #output o
inner join census_raw_2021 c on c.[ALT_GEO_CODE] = o.da_id and try_cast(c.[characteristic_id] as int) = 1

update #output
set 
	population_0_to_14_2021 = try_cast(c.c1_count_total as int)
from #output o
inner join census_raw_2021 c on c.[ALT_GEO_CODE] = o.da_id and try_cast(c.[characteristic_id] as int) = 9


select *,
    case 
		when population_2016 > 0 then round(cast(population_0_to_14_2016 as decimal (12,4)) / cast(population_2016 as decimal (12,4)),4)
		else NULL
	end as percent_children_2016,
	case
		when population_2021 > 0 then round(cast(population_0_to_14_2021 as decimal (12,4)) / cast(population_2021 as decimal (12,4)),4)
		else NULL
	end as percent_children_2021

from #output

