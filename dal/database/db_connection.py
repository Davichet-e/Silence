# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

from typing import Union

from dal.database.config import DB_CONFIG

try:
    import cx_Oracle as oracle_engine
except ModuleNotFoundError:
    pass

try:
    import pymysql as mariadb_engine
except ModuleNotFoundError:
    pass

selected_engine: str = DB_CONFIG["db_engine"]

# Select the connection that is appropriate for the selected database
# If the selected database is not supported, raise an error.

conn: Union[oracle_engine.Connection, mariadb_engine.Connection]

if selected_engine == "oracle":
    conn = oracle_engine.connect(
        f'{DB_CONFIG["user"]}/{DB_CONFIG["password"]}@localhost/XE'
    )
elif selected_engine == "mariadb":
    config_data: dict = DB_CONFIG.copy()
    del config_data["db_engine"]
    conn = mariadb_engine.connect(**config_data)
else:
    raise SystemError(f'DB engine "{DB_CONFIG["db_engine"]}" is not supported.')

###############################################################################
