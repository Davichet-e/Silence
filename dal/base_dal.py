# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

from typing import Any, Dict, Optional, Tuple, Union

from dal.database.config import DB_CONFIG
from dal.impl import mariadb_dal, oracle_dal

DAL_IMPLS = {
    "oracle": oracle_dal,
    "mariadb": mariadb_dal,
}

impl = DAL_IMPLS[DB_CONFIG["db_engine"]]


def query(
    q: str, params: Optional[Union[tuple, list, dict]] = None
) -> Tuple[Dict[str, Any], ...]:
    return impl.query(q, params)


def execute(q: str, params: Optional[Union[tuple, list, dict]] = None) -> int:
    return impl.execute(q, params)
