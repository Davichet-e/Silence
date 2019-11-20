from dal.database.db_connection import get_conn

# Method for destroying and creating the database tables
# This shouldn't be modified, it uses the create_database.sql file
def create_database(verbose=False) -> None:
    conn = get_conn()
    cursor = conn.cursor()
    with open("create_database.sql", encoding="utf-8") as f:
        for stmt in f.read().split(";"):
            if stmt.strip():
                if verbose:
                    print(stmt + ";")
                cursor.execute(stmt)
    conn.commit()
    cursor.close()


#######################################
if __name__ == "__main__":
    print("Creating and populating the database...")
    create_database(verbose=True)
    print("Success!")
