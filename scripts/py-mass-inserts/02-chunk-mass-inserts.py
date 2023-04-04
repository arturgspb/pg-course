import psycopg
import json
from itertools import islice

conn = psycopg.connect('dbname=lets_goto_it user=postgres password=tr134sdfWE host=localhost port=5432')
cur = conn.cursor()

cur.execute("CREATE TABLE IF NOT EXISTS test_2 (id serial PRIMARY KEY, num integer, data varchar, form_data jsonb);")
conn.commit()

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
    placeholders = []
    values = []
    for record in records:
        placeholders.append("(%s, %s, %s)")
        values.append(record[0])
        values.append(record[1])
        values.append(record[2])
    cur.execute("INSERT INTO test_2 (num, data, form_data) VALUES " + (",".join(placeholders)), values)
    conn.commit()


cur.execute("SELECT count(1) FROM test_2;")
print(cur.fetchone())
cur.close()
conn.close()
