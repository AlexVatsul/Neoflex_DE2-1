-- Проверка на копии 
create table dm.client_copy as
select * from dm.client;

drop table dm.client_copy;

select count(*)
from dm.client_copy;

-- в условии сказано, что необходимо получить уникальные значения по паре client_rk, effective_from_date 
select client_rk, effective_from_date, count(client_rk) as cnt
from dm.client_copy
group by client_rk, effective_from_date
order by cnt desc;

-- однако есть проблема по атрибуту effective_to_date в данном запросе ниже
select *
from dm.client_copy cc 
where cc.client_rk = 3055149 and cc.effective_from_date = '2023-08-11';


-- соответственно принял решение писать по 3 ключам client_rk, effective_from_date, effective_to_date
-- при такой конфигарации ошибка пропадает и можно с уверенностью удалять дубликаты
select client_rk, effective_from_date, effective_to_date, count(client_rk) as cnt
from dm.client_copy cc
group by client_rk, effective_from_date, effective_to_date
having cc.client_rk = 3055149 and cc.effective_from_date = '2023-08-11'
order by cnt desc;


select client_rk, effective_from_date, effective_to_date, count(client_rk) as cnt
from dm.client_copy cc
group by client_rk, effective_from_date, effective_to_date
order by cnt desc;



-- из данного запроса следует, что уникальных записей без повторений должно быть 10020 
with gro_b as (
	select client_rk, effective_from_date, effective_to_date, count(client_rk) as cnt
	from dm.client_copy
	group by client_rk, effective_from_date, effective_to_date
	order by cnt desc
), sm as (
	select gb.cnt, count(gb.cnt) as cnt1
	from gro_b gb
	group by gb.cnt
)
select sum(sm.cnt1)
from sm;


delete from dm.client_copy
where ctid not in (
    select min(ctid)
    from dm.client_copy
    group by client_rk, effective_from_date, effective_to_date
);


-- Итоговый скрипт для оригинальной dm.client
select count(*)
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








