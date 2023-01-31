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
