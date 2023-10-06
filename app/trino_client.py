from trino.dbapi import connect

conn = connect(
    host="localhost",
    port=8080,
    user="hive",
    catalog="hive",
    schema="datalake",
)

query_1 = """
-- Create the table
CREATE TABLE hive.schcities.tabcities
  (name varchar,
   lastname varchar,
   id varchar)
WITH (FORMAT='csv', 
      external_location = 's3://datalake/names',
      skip_header_line_count=1);
"""


# cur = conn.cursor()
# cur.execute("SELECT * FROM hive.datalake.nodes")
# rows = cur.fetchall()

def create_table(query: str):
    cur = conn.cursor()
    print(cur.execute(query).fetchall())
    # rows = cur.fetchall()



create_table("show catalogs")
create_table("show tables in hive.information_schema")
# create_table("create schema teste with (location = 's3://datalake/")