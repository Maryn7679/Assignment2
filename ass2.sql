create index idx on table2(price)

explain analyze

with my_data1 as (select user_id, name, surname, price, registration_date, min(transaction_time) from 
(select * from table1 where name = 'Anna') as t1
inner join
(select * from table2 where price > 5000 and is_available = 1) as t2
on t1.item_bought = t2.item_id
cross join (select * from table3 where transaction_type = 'not' and device = 'Device5') as t3
where registration_date < transaction_time
group by user_id, name, surname, price, registration_date
)

select * from my_data1
where price < (select avg(price)+800 from my_data1)
order by price

~~~~
alter table table2 drop index idx

explain analyze

select user_id, name, surname, price, registration_date, min(transaction_time) from table1 as t1
inner join table2 as t2
on t1.item_bought = t2.item_id
cross join table3 as t3
where name = 'Anna'
and price > 5000 
and is_available = 1
and transaction_type = 'not' 
and device = 'Device5'
and registration_date < transaction_time
group by user_id, name, surname, price, registration_date
having price < (select avg(price)+800 from (
	select user_id, name, surname, price, registration_date, min(transaction_time) from table1 as t1
	inner join table2 as t2
	on t1.item_bought = t2.item_id
	cross join table3 as t3
	where name = 'Anna'
	and price > 5000 
	and is_available = 1
	and transaction_type = 'not' 
	and device = 'Device5'
	and registration_date < transaction_time
	group by user_id, name, surname, price, registration_date) as t5)
order by price
