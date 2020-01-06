from typing import Optional, Dict, Any, Tuple

from dal import base_dal


def get_all() -> Tuple[Dict[str, Any], ...]:
    """
    Get groups
    -Input: ---
    -Output:
        *All the groups of the table
        *None value if we cannot find the OID
    """
    return base_dal.query("SELECT * FROM Groups")


def get_by_oid(oid: int) -> Optional[Dict[str, Any]]:
    """
    Get group by OID
    -Input:
        *The OID of the group that we want to get
    -Output:
        *Only one group
        *None value if we cannot find the OID
    """

    q = "SELECT * FROM Groups WHERE groupId = %s"
    params = (oid,)

    res: Tuple[Dict[str, Any], ...] = base_dal.query(q, params)

    return res[0] if res else None


def get_by_name(name: str) -> Optional[Dict[str, Any]]:
    """
    Get group by name
    -Input:
        *The name of the group that we want to get
    -Output:
        *Only one group
        *None value if we cannot find the name
    """

    q = "SELECT * FROM Groups WHERE name = %s"
    params = (name,)

    res: Tuple[Dict[str, Any]] = base_dal.query(q, params)

    return res[0] if res else None


def get_by_classroom_id(classroom_id: int) -> Optional[Dict[str, Any]]:
    """
    Get groups by classroom_id
    -Input:
        *The classroom_id of the groups that we want to get
    -Output:
        *The groups which classroom_id is the same as received as parameter
        *None value if we cannot find the name
    """

    q = "SELECT * FROM Groups WHERE classroomId = %s"
    params = (classroom_id,)

    res: Tuple[Dict[str, Any]] = base_dal.query(q, params)

    return res if res else None


def insert(
    name: str, activity: str, year: int, subjectId: int, classroomId: int
) -> int:
    """
    Insert a new group
    -Input:
        *All of the properties of the group
    - Output:
        *The OID assigned to the group that we have inserted
    """

    q = "INSERT INTO Groups (name, activity, year, subjectId, classroomId) VALUES (%s, %s, %s, %s, %s)"
    params = (name, activity, year, subjectId, classroomId)
    return base_dal.execute(q, params)


def update(
    oid: int, name: str, activity: str, year: int, subjectId: int, classroomId: int,
) -> int:
    """
    Update one group
    -Input:
        *All of the properties of the group, including the OID that we want to update
    -Output:
        *The OID of the group that we have updated
    """

    q = "UPDATE Groups SET name = %s, activity = %s, year = %s, subjectId = %s, classroomId = %s WHERE groupId = %s"
    params = (name, activity, year, subjectId, classroomId, oid)
    return base_dal.execute(q, params)


def delete(oid: int) -> int:
    """
    Delete one department
    -Input:
        *The OID of the group that we want to delete
    -Output:
        *The OID of the group that was deleted
    """

    q = "DELETE FROM Groups WHERE groupId = %s"
    params = (oid,)
    return base_dal.execute(q, params)
