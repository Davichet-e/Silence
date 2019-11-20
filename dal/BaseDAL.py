# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

from dal.database.config import DB_CONFIG
from dal.impl.MariaDBDAL import MariaDBDAL
from dal.impl.OracleDAL import OracleDAL

DAL_IMPLS = {
    "oracle": OracleDAL,
    "mariadb": MariaDBDAL,
}


class BaseDAL:
    def __init__(self):
        self.impl = DAL_IMPLS[DB_CONFIG["db_engine"]]()

    def query(self, q, params=None):
        return self.impl.query(q, params)

    def execute(self, q, params=None):
        return self.impl.execute(q, params)
