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
