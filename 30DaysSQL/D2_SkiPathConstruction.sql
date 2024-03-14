/* A ski resort company is planning to construct a new ski slope using a pre-existing network of mountain huts and trails
 between them. A new slope has to begin at one of the mountain huts, have a middle station at another hut connected with 
 the first one by a direct trail, and end at the third mountain hut which is also connected by a direct trail to the second hut. 
 The altitude of the three huts chosen for constructing the ski slope has to be strictly decreasing. 
 Each entry in the table trails represents a direct connection between huts with IDs hut1 and hut2. Note that all trails 
 are bidirectional.
Create a query that finds all triplets(startpt,middlept,endpt) representing the mountain huts that may be used for construction of a ski slope.
Output returned by the query can be ordered in any way.
 */
 create table mountain_huts (
id integer not null,
name varchar(40) not null,
altitude integer not null,
unique(name),
unique(id)
);
create table trails (
hut1 integer not null,
hut2 integer not null
);
insert into mountain_huts values (1, 'Dakonat', 1900);
insert into mountain_huts values (2, 'Natisa', 2100);
insert into mountain_huts values (3, 'Gajantut', 1600);
insert into mountain_huts values (4, 'Rifat', 782);
insert into mountain_huts values (5, 'Tupur', 1370);

insert into trails values (1, 3);
insert into trails values (3, 2);
insert into trails values (3, 5);
insert into trails values (4, 5);
insert into trails values (1, 5);

select * from mountain_huts;
select * from trails;

-- Join -> Find possible paths using flag -> rearrange starting and ending point -> self join to final the middle point

with cte_trails1 as 
	(select t1.hut1 as start_hut,h1.name as start_hut_name,
    h1.altitude as start_hut_altitude,t1.hut2 as end_hut
    from mountain_huts as h1
	join trails t1 on t1.hut1 = h1.id),
cte_trails2 as 	
	(select t2.*,h2.name as end_hut_name,h2.altitude as end_hut_altitude
	, case when start_hut_altitude > h2.altitude then 1 else 0 end as altitude_flag
	from cte_trails1 t2
	join mountain_huts h2 on h2.id = t2.end_hut),
cte_final as 
	(select case when altitude_flag = 1 then start_hut else end_hut end as start_hut
	, case when altitude_flag = 1 then start_hut_name else end_hut_name end as start_hut_name
	, case when altitude_flag = 1 then end_hut else start_hut end as end_hut
	, case when altitude_flag = 1 then end_hut_name else start_hut_name end as end_hut_name
	from cte_trails2)
select c1.start_hut_name as start_point,
c1.end_hut_name as middle_point,
c2.end_hut_name as end_point
from cte_final c1
join cte_final c2 on c1.end_hut = c2.start_hut;

-- 1,3,5
-- 2,3,5
-- 3,5,4
-- 1,5,4





