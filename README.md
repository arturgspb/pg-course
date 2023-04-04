# pg-course


Example with join-s

```sql
select
    cli.id as clinet_id,
    cli.name as client_name,
    COALESCE(usr.id, 0) as user_id,
    COALESCE(NULLIF(TRIM(CONCAT(usr.first_name, ' ', usr.last_name)), ''), '<not set>') as full_user_name
from client as cli
left join user_client_link as ucl on cli.id = ucl.client_id
left join users as usr ON ucl.user_id = usr.id
where cli.id IN (1,2,3)
```



Example triggers

```sql
alter table users add name text;

CREATE OR REPLACE FUNCTION public.update_users_name()
RETURNS trigger AS
$BODY$
BEGIN
NEW.name = CONCAT(NEW.first_name, ' ', NEW.last_name);
RETURN NEW;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;

CREATE TRIGGER "update_users_name_on_update_trigger"
  BEFORE UPDATE OF first_name, last_name ON users
  FOR EACH ROW WHEN ((new.first_name != old.first_name) or (new.last_name != old.last_name))
  EXECUTE PROCEDURE "update_users_name"();

CREATE TRIGGER "update_users_name_on_insert_trigger"
  BEFORE INSERT ON users
  FOR EACH ROW
  EXECUTE PROCEDURE "update_users_name"();
  
update users set name = CONCAT(first_name, ' ', last_name);
```


Example plpgsql function
```sql
create or replace function get_user_clients(_user_id integer) returns TABLE(client_id integer)
	cost 10
	rows 100
	language plpgsql
as $$
BEGIN
    RETURN QUERY
    select t.client_id from user_client_link as t where user_id=_user_id;
END
$$;
```



Example insert generated rows
```sql
alter table client
	add active bool default true;
	
INSERT INTO client (name, active)
SELECT CONCAT('Gen Cli ', idx), (random() > 0.50) FROM generate_series(1,5000000) as idx;

insert into user_client_link (user_id, client_id)
select 1, id from client where id >= 10 and id < 1000000;

insert into user_client_link (user_id, client_id)
select 2, id from client where id >= 10 and id < 1000000;

insert into user_client_link (user_id, client_id)
select 3, id from client where id > 1000000;


select
    usr.id,
	count(distinct cli.id) as client_cnt
from users as usr
left join user_client_link as ucl on ucl.user_id = usr.id
left join client as cli ON cli.id = ucl.client_id
where cli.active
group by 1
order by 2 desc


create index user_client_link_client_id_index
	on user_client_link (client_id);

create index user_client_link_user_id_index
	on user_client_link (user_id);

	analyse user_client_link;


select
    usr.id,
	count(distinct cli.id) as client_cnt
from users as usr
left join user_client_link as ucl on ucl.user_id = usr.id
left join client as cli ON cli.id = ucl.client_id
where cli.active
and usr.id = 1
group by 1
order by 2 desc


select
    usr.id,
	stat.client_cnt
from users as usr
left join lateral (
	select 
		count(distinct cli.id) as client_cnt
	from user_client_link as ucl
	left join client as cli ON cli.id = ucl.client_id
	where ucl.user_id = usr.id and cli.active
) stat on true
order by 2 desc







create index client_id_active_index
	on client (active) INCLUDE (id);

create index user_client_link_client_id_user_id_index
	on user_client_link (client_id, user_id);



with stat as (
	select 
		ucl.user_id,
		count(distinct cli.id) as client_cnt
	from user_client_link as ucl
	left join client as cli ON cli.id = ucl.client_id
	where cli.active
	group by 1
)
select
    usr.id,
	stat.client_cnt
from users as usr
left join stat on stat.user_id=usr.id
order by 2 desc



update client set active=(random() > 0.90);

select 
active, count(1)
from client
where id > 2500000
group by 1

```


## Window functions

```sql
create table transaction
(
	id bigserial
		constraint transaction_pk
			primary key,
	client_id int
		constraint transaction_client_id_fk
			references client,
	amount decimal,
	created_at timestamptz default NOW()
);


insert into transaction (client_id, amount, created_at) values (1, 1500, '2023-01-01 00:00:01');
insert into transaction (client_id, amount, created_at) values (1, 1500, '2023-01-01 13:00:02');
insert into transaction (client_id, amount, created_at) values (1, 2700, '2023-01-02 11:47:17');
insert into transaction (client_id, amount, created_at) values (1, 2700, '2023-01-11 15:20:24');
insert into transaction (client_id, amount, created_at) values (1, 1500, '2023-02-01 00:00:01');
insert into transaction (client_id, amount, created_at) values (1, 1500, '2023-02-01 13:00:02');
insert into transaction (client_id, amount, created_at) values (1, 2700, '2023-02-02 11:47:17');
insert into transaction (client_id, amount, created_at) values (1, 2700, '2023-02-11 15:20:24');
insert into transaction (client_id, amount, created_at) values (1, 1500, '2023-03-01 00:00:01');
insert into transaction (client_id, amount, created_at) values (1, 1500, '2023-03-01 13:00:02');
insert into transaction (client_id, amount, created_at) values (1, 2700, '2023-03-02 11:47:17');
insert into transaction (client_id, amount, created_at) values (1, 2700, '2023-03-11 15:20:24');

insert into transaction (client_id, amount, created_at) values (2, 500, '2023-01-01 00:00:01');
insert into transaction (client_id, amount, created_at) values (3, 41500, '2023-01-01 15:00:02');
insert into transaction (client_id, amount, created_at) values (3, 32700, '2023-01-02 15:47:17');
insert into transaction (client_id, amount, created_at) values (3, 12700, '2023-01-11 17:45:24');
insert into transaction (client_id, amount, created_at) values (2, 500, '2023-02-02 00:00:01');
insert into transaction (client_id, amount, created_at) values (3, 41500, '2023-02-02 15:00:02');
insert into transaction (client_id, amount, created_at) values (3, 32700, '2023-02-03 15:47:17');
insert into transaction (client_id, amount, created_at) values (3, 12700, '2023-02-12 17:45:24');
insert into transaction (client_id, amount, created_at) values (3, 700, '2023-03-12 01:05:01');

-- среднее в рамках партиции окна
-- https://postgrespro.ru/docs/postgresql/9.5/tutorial-window
select
    *,
    AVG(amount) OVER(PARTITION BY "month") as avg_by_month,
    AVG(amount) OVER() as avg_total,
    ROUND(
        amount * 100.0 / AVG(amount) OVER(PARTITION BY "month")
    , 2)
from (
    select
        c.id,
        c.name,
        LEFT(t.created_at::date::text, 7) as month,
        amount
    from transaction as t
    left join client as c ON c.id = t.client_id
) prep

-- Тразнакция с минимальным значением
-- https://postgrespro.ru/docs/postgrespro/15/functions-window
select
    *,
    first_value(transaction_id) OVER(PARTITION BY "month" ORDER BY "amount") as min_amount_transaction_id
from (
    select
        c.id,
        c.name,
        LEFT(t.created_at::date::text, 7) as month,
        amount,
        t.id as transaction_id
    from transaction as t
    left join client as c ON c.id = t.client_id
) prep

-- для пагинации
select
    c.id,
    c.name,
    LEFT(t.created_at::date::text, 7) as month,
    amount,
    count(1) OVER() as total_rows
from transaction as t
left join client as c ON c.id = t.client_id
limit 10 offset 0


-- row_number
select
    c.id,
    c.name,
    LEFT(t.created_at::date::text, 7) as month,
    amount,
    row_number() over () as row_idx,
    count(1) OVER() as total_rows
from transaction as t
left join client as c ON c.id = t.client_id
limit 10 offset 10


-- нарастающий итог
-- https://habr.com/ru/company/otus/blog/490296/
select
    *,
    SUM(t_amount) over(ORDER BY c_id, t_created_at rows between unbounded preceding and current row) as sum_total,
    SUM(t_amount) over(partition by c_id, t_month order by c_id, t_created_at rows between unbounded preceding and current row)
from (
    select
        c.id as c_id,
        c.name as c_name,
        LEFT(t.created_at::date::text, 7) as t_month,
        amount as t_amount,
        t.created_at as t_created_at
    from transaction as t
    left join client as c ON c.id = t.client_id
) prep
order by c_id, t_created_at
```
