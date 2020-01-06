from typing import Optional, Dict, Any, Tuple

from dal.base_dal import query, execute


def get_all() -> Tuple[Dict[str, Any], ...]:
    """
    Get departments
    -Input: ---
    -Output:
        *All the departments of the table
        *None value if we cannot find the OID
    """
    return query("SELECT * FROM Departments")


def get_by_oid(oid: int) -> Optional[Dict[str, Any]]:
    """
    Get departments by OID
    -Input:
        *The OID of the department that we want to get
    -Output:
        *Only one department
        *None value if we cannot find the OID
    """

    q = "SELECT * FROM Departments WHERE departmentId = %s"
    params = (oid,)

    res: Tuple[Dict[str, Any], ...] = query(q, params)

    return res[0] if res else None


def get_by_name(name: str) -> Optional[Tuple[Dict[str, Any], ...]]:
    """
    Get department by name
    -Input:
        *The name of the department that we want to get
    -Output:
        *Only one department
        *None value if we cannot find the name
    """

    q = "SELECT * FROM Department WHERE name = %s"
    params = (name,)

    res: Tuple[Dict[str, Any]] = query(q, params)

    return res[0] if res else None


def insert(name: str) -> int:
    """
    Insert a new department
    -Input:
        *All of the properties of the department
    - Output:
        *The OID assigned to the department that we have inserted
    """

    q = "INSERT INTO Departments (name) VALUES (%s)"
    params = (name,)
    return execute(q, params)


def update(oid: int, name: str) -> int:
    """
    Update one department
    -Input:
        *All of the properties of the department, including the OID that we want to update
    -Output:
        *The OID of the department that we have updated
    """

    q = "UPDATE Departments SET name = %s WHERE departmentId = %s"
    params = (name, oid)
    return execute(q, params)


def delete(oid: int) -> int:
    """
    Delete one department
    -Input:
        *The OID of the department that we want to delete
    -Output:
        *The OID of the department that was deleted
    """

    q = "DELETE FROM Departments WHERE departmentId = %s"
    params = (oid,)
    return execute(q, params)
