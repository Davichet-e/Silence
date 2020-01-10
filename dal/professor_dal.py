from typing import Optional, Dict, Any, Tuple

from dal import base_dal
from dal.dal_exception import DALException


def get_all() -> Tuple[Dict[str, Any], ...]:
    """
    Get professors
    -Input: ---
    -Output:
        *All the professors of the table
        *None value if we cannot find the OID
    """
    return base_dal.query("SELECT * FROM Professors")


def get_by_oid(oid: int) -> Optional[Dict[str, Any]]:
    """
    Get professor by OID
    -Input:
        *The OID of the professor that we want to get
    -Output:
        *Only one professor
        *None value if we cannot find the OID
    """

    q = "SELECT * FROM Professors WHERE professorId = %s"
    params = (oid,)

    res: Tuple[Dict[str, Any], ...] = base_dal.query(q, params)

    return res[0] if res else None


def get_by_dni(dni: str) -> Optional[Dict[str, Any]]:
    """
    Get professor by DNI
    -Input:
        *The name of the professor that we want to get
    -Output:
        *Only one professor
        *None value if we cannot find the DNI
    """

    q = "SELECT * FROM Professors WHERE dni = %s"
    params = (dni,)

    res: Tuple[Dict[str, Any]] = base_dal.query(q, params)

    return res[0] if res else None


def get_by_email(email: str) -> Optional[Dict[str, Any]]:
    """
    Get professor by email
    -Input:
        *The name of the professor that we want to get
    -Output:
        *Only one professor
        *None value if we cannot find the email
    """

    q = "SELECT * FROM Professors WHERE email = %s"
    params = (email,)

    res: Tuple[Dict[str, Any]] = base_dal.query(q, params)

    return res[0] if res else None


def get_by_department(department_id: int):
    q = "SELECT * FROM Professors WHERE departmentId = %s"
    params = (department_id,)
    return base_dal.query(q, params)


def insert(
    office_id: int,
    department_id: int,
    category: str,
    dni: str,
    firstname: str,
    surname: str,
    birthdate: str,
    email: str,
) -> int:
    """
    Insert a new professor
    -Input:
        *All of the properties of the professor
    - Output:
        *The OID assigned to the professor that we have inserted
    """

    q = (
        "INSERT INTO Professors (officeId, departmentId, category, dni, firstname, surname, birthdate, email) "
        "VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
    )
    params = (
        office_id,
        department_id,
        category,
        dni,
        firstname,
        surname,
        birthdate,
        email,
    )

    return base_dal.execute(q, params)


def update(
    oid: int,
    office_id: int,
    department_id: int,
    category: str,
    dni: str,
    first_name: str,
    surname: str,
    birth_date: str,
    email: str,
) -> int:
    """
    Update one professor
    -Input:
        *All of the properties of the professor, including the OID that we want to update
    -Output:
        *The OID of the professor that we have updated
    """

    q = (
        "UPDATE Professors SET officeId = %s, departmentId = %s, category = %s, "
        "dni = %s, firstname = %s, surname = %s, birthdate = %s, email = %s WHERE professorId = %s"
    )
    params = (
        office_id,
        department_id,
        category,
        dni,
        first_name,
        surname,
        birth_date,
        email,
        oid,
    )

    return base_dal.execute(q, params)


def delete(oid: int) -> int:
    """
    Delete one professor
    -Input:
        *The OID of the professor that we want to delete
    -Output:
        *The OID of the professor that was deleted
    """

    q = "DELETE FROM Professors WHERE professorId = %s"
    params = (oid,)
    return base_dal.execute(q, params)

