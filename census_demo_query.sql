use [census_demo]
go


/* 

-- this query returns the ordered list of data elements
select distinct 
     
      cast([member id  profile of dissemination areas (2247)] as int),
	  [dim  profile of dissemination areas (2247)]
  from [dbo].[census_raw]
 order by
      cast([member id  profile of dissemination areas (2247)] as int)
go

-- this query returns the list of geo_levels and a count of elements 
-- select distinct 
	geo_level, 
	count(*) 
	from census_raw group by geo_level order by count(*) asc
*/

drop table if exists #output 
create table #output
(da_id int,
 population_2016 int,
 population_0_to_14 int)

insert into #output  (da_id)
select distinct [geo_code (por)]
from census_raw 
WHERE GEO_LEVEL = 4

update #output 
set 
	population_2016 = try_cast(c.[Dim  Sex (3)  Member ID   1   Total - Sex] as int)
from #output o
inner join census_raw c on c.[geo_code (por)] = o.da_id and try_cast(c.[Member ID  Profile of Dissemination Areas (2247)] as int) = 1

update #output
set
	population_0_to_14 = try_cast(c.[Dim  Sex (3)  Member ID   1   Total - Sex] as int)
from #output o
inner join census_raw c on c.[geo_code (por)] = o.da_id and try_cast(c.[Member ID  Profile of Dissemination Areas (2247)] as int) = 9

select *,
	   case 
		when population_2016 > 0 then round(cast(population_0_to_14 as decimal (12,4)) / cast(population_2016 as decimal (12,4)),4)
		else NULL
		end as percent_children
from #output