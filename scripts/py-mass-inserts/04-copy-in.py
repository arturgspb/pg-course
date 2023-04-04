import psycopg
import json

conn = psycopg.connect('dbname=lets_goto_it user=postgres password=tr134sdfWE host=localhost port=5432')
cur = conn.cursor()

cur.execute("CREATE TABLE IF NOT EXISTS test_4 (id serial PRIMARY KEY, num integer, data varchar, form_data jsonb);")
conn.commit()

# https://www.psycopg.org/psycopg3/docs/basic/copy.html
# https://postgrespro.ru/docs/postgrespro/15/sql-copy

def gen_records():
    for row_idx in range(1_000_000):
        yield (row_idx, 'txt ' + str(row_idx), json.dumps({"foo": "bar " + str(row_idx)}))

with cur.copy("COPY test_4 (num, data, form_data) FROM STDIN") as copy:
    for record in gen_records():
        copy.write_row(record)
conn.commit()

cur.execute("SELECT count(1) FROM test_4;")
print(cur.fetchone())
cur.close()
conn.close()
