import psycopg
import json

conn = psycopg.connect('dbname=lets_goto_it user=postgres password=tr134sdfWE host=localhost port=5432')
cur = conn.cursor()

cur.execute("CREATE TABLE IF NOT EXISTS test_1 (id serial PRIMARY KEY, num integer, data varchar, form_data jsonb);")
conn.commit()

def gen_records():
    for row_idx in range(10_000):
        yield (row_idx, 'txt ' + str(row_idx), json.dumps({"foo": "bar " + str(row_idx)}))

#with conn.pipeline():
# https://www.psycopg.org/psycopg3/docs/advanced/pipeline.html
for record in gen_records():
    cur.execute("INSERT INTO test_1 (num, data, form_data) VALUES (%s, %s, %s)", record)
    conn.commit()

cur.execute("SELECT count(1) FROM test_1;")
print(cur.fetchone())
cur.close()
conn.close()
