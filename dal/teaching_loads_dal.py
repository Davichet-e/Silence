from typing import Optional, Dict, Any, Tuple

from dal import base_dal
from dal.dal_exception import DALException


def get_all() -> Tuple[Dict[str, Any], ...]:
    """
    Get TeachingLoads
    -Input: ---
    -Output:
        *All the TeachingLoads of the table
        *None value if we cannot find the OID
    """
    return base_dal.query("SELECT * FROM TeachingLoads")


def get_by_oid(oid: int) -> Optional[Dict[str, Any]]:
    """
    Get TeachingLoad by OID
    -Input:
        *The OID of the TeachingLoad that we want to get
    -Output:
        *Only one TeachingLoad
        *None value if we cannot find the OID
    """

    q = "SELECT * FROM TeachingLoads WHERE teachingLoadId = %s"
    params = (oid,)

    res: Tuple[Dict[str, Any], ...] = base_dal.query(q, params)

    return res[0] if res else None


def insert(professorId: int, groupId: int, credits: int) -> int:
    """
    Insert a new TeachingLoad
    -Input:
        *All of the properties of the TeachingLoad
    - Output:
        *The OID assigned to the TeachingLoad that we have inserted
    """

    q = (
        "INSERT INTO TeachingLoads (professorId, groupId, credits) "
        "VALUES (%s, %s, %s)"
    )
    params = (
        professorId,
        groupId,
        credits,
    )

    return base_dal.execute(q, params)


def update(oid: int, professorId: int, groupId: int, credits: int) -> int:
    """
    Update one TeachingLoad
    -Input:
        *All of the properties of the TeachingLoad, including the OID that we want to update
    -Output:
        *The OID of the TeachingLoad that we have updated
    """

    q = (
        "UPDATE TeachingLoads SET teachingLoadId = %s, professorId = %s, groupId = %s, "
        "credits = %s WHERE teachingLoadId = %s"
    )
    params = (
        professorId,
        groupId,
        credits,
        oid,
    )

    return base_dal.execute(q, params)


def delete(oid: int) -> int:
    """
    Delete one TeachingLoad
    -Input:
        *The OID of the TeachingLoad that we want to delete
    -Output:
        *The OID of the TeachingLoad that was deleted
    """

    q = "DELETE FROM TeachingLoads WHERE teachingLoadId = %s"
    params = (oid,)
    return base_dal.execute(q, params)


def get_by_professor_id(professor_id: int) -> Tuple[Dict[str, Any]]:
    q = "SELECT * FROM TeachingLoads WHERE professorId = %s"
    params = (professor_id,)
    return base_dal.query(q, params)
