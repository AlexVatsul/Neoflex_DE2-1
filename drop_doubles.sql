-- Проверка на копии 
create table dm.client_copy as
select * from dm.client;

drop table dm.client_copy;

select count(*)
from dm.client_copy;


with gro_b as (
	select client_rk, effective_from_date, effective_to_date, count(client_rk) as cnt
	from dm.client_copy
	group by client_rk, effective_from_date, effective_to_date
	order by cnt desc
)
select gb.cnt, count(gb.cnt)
from gro_b gb
group by gb.cnt; 


select *
from dm.client_copy cc 
where cc.client_rk = 2460995 and cc.effective_from_date = '2023-08-11';



delete from dm.client_copy
where ctid not in (
    select min(ctid)
    from dm.client_copy
    group by client_rk, effective_from_date, effective_to_date
);


-- Итоговый скрипт для оригинальной dm.client
select *
from dm.client c;

select client_rk, effective_from_date, count(client_rk) as cnt
from dm.client
group by client_rk, effective_from_date
order by cnt desc;


select client_rk, effective_from_date, effective_to_date, count(client_rk) as cnt
from dm.client_copy
group by client_rk, effective_from_date, effective_to_date
order by cnt desc;



delete from dm.client
where ctid not in (
    select min(ctid)
    from dm.client
    group by client_rk, effective_from_date, effective_to_date
);








