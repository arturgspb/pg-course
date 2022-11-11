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
