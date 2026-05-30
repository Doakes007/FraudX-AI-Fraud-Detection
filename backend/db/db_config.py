import psycopg2

def get_connection():
    return psycopg2.connect(
        host="host.docker.internal",
        dbname="fraudx",
        user="postgres",
        password="postgres123"  # <-- Must match what you just set
    )

