import psycopg
import json
from itertools import islice

conn = psycopg.connect('dbname=lets_goto_it user=postgres password=tr134sdfWE host=localhost port=5432')
cur = conn.cursor()

cur.execute("CREATE TABLE IF NOT EXISTS test_3 (id serial PRIMARY KEY, num integer, data varchar, form_data jsonb);")
conn.commit()

# https://www.postgresql.org/docs/current/functions-json.html

def chunks_generator(iterable, count_items_in_chunk):
    iterator = iter(iterable)
    for first in iterator:  # stops when iterator is depleted
        def chunk():  # construct generator for next chunk
            yield first  # yield element from for loop
            for more in islice(iterator, count_items_in_chunk - 1):
                yield more  # yield more elements from the iterator

        yield chunk()  # in outer generator, yield next chunk

def gen_records():
    for row_idx in range(1_000_000):
        yield (row_idx, 'txt ' + str(row_idx), json.dumps({"foo": "bar " + str(row_idx)}))

rows_per_once = 1000
for records in chunks_generator(gen_records(), rows_per_once):
    values = []
    for record in records:
      values.append({"num": record[0], "data": record[1], "form_data": record[2]})

    query_params = [json.dumps(values)]
    cur.execute("""
    INSERT INTO test_3 (num, data, form_data)
    SELECT x.num, x.data, x.form_data
    FROM jsonb_to_recordset(%s) as x(num int, data varchar, form_data jsonb)
    """, query_params)
    conn.commit()

cur.execute("SELECT count(1) FROM test_3;")
print(cur.fetchone())
cur.close()
conn.close()
