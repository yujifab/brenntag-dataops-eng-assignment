from trino.dbapi import connect

conn = connect(
    host="127.0.0.1",
    port=8080,
    user="admin",
    catalog="hive-metastore",
    schema="a",
)
cur = conn.cursor()
cur.execute("SELECT * FROM system.runtime.nodes")
rows = cur.fetchall()