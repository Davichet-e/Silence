# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

from typing import Optional, Dict, Any, Tuple

from dal import base_dal


def get_all() -> Tuple[Dict[str, Any], ...]:
    """
    Get subjects
    -Input: ---
    -Output:
        *All the subjects of the table
        *None value if we cannot find the OID
    """
    return base_dal.query("SELECT * FROM Subjects")


def get_by_oid(oid: int) -> Optional[Dict[str, Any]]:
    """
    Get subject by OID
    -Input:
        *The OID of the subject that we want to get
    -Output:
        *Only one subject
        *None value if we cannot find the OID
    """

    q = "SELECT * FROM Subjects WHERE subjectId = %s"
    params = (oid,)

    res: Tuple[Dict[str, Any], ...] = base_dal.query(q, params)

    return res[0] if res else None


def get_by_acronym(acronym: str) -> Optional[Dict[str, Any]]:
    """
    Get subject by acronym
    -Input:
        *The acronym of the subject that we want to get
    -Output:
        *Only one subject
        *None value if we cannot find the acronym
    """
    q = "SELECT * FROM Subjects WHERE acronym = %s"
    params = (acronym,)

    res: Tuple[Dict[str, Any], ...] = base_dal.query(q, params)

    return res[0] if res else None


def get_by_name(name: str) -> Optional[Dict[str, Any]]:
    """
    Get subject by name
    -Input:
        *The name of the subject that we want to get
    -Output:
        *Only one subject
        *None value if we cannot find the name
    """

    q = "SELECT * FROM Subjects WHERE name = %s"
    params = (name,)

    res: Tuple[Dict[str, Any]] = base_dal.query(q, params)

    return res[0] if res else None


def insert(
    name: str,
    acronym: str,
    n_credits: int,
    course: int,
    subject_type: str,
    degreeId: int,
    departmentId: int,
) -> int:
    """
    Insert a new subject
    -Input:
        *All of the properties of the subject
    - Output:
        *The OID assigned to the subject that we have inserted
    """

    q = "INSERT INTO Subjects (name, acronym, credits, course, type, degreeId, departmentId) VALUES (%s, %s, %s, %s, %s, %s, %s)"
    params = (name, acronym, n_credits, course, subject_type, degreeId, departmentId)
    return base_dal.execute(q, params)


def update(
    oid: int,
    name: str,
    acronym: str,
    n_credits: int,
    course: int,
    subject_type: str,
    degreeId: int,
    departmentId: int,
) -> int:
    """
    Update one subject
    -Input:
        *All of the properties of the subject, including the OID that we want to update
    -Output:
        *The OID of the subject that we have updated
    """

    q = "UPDATE subjects SET name = %s, acronym = %s, credits = %s, course = %s, type = %s, degreeId = %s, departmentId = %s WHERE subjectId = %s"
    params = (
        name,
        acronym,
        n_credits,
        course,
        subject_type,
        degreeId,
        departmentId,
        oid,
    )
    return base_dal.execute(q, params)


def delete(oid: int) -> int:
    """
    Delete one subject
    -Input:
        *The OID of the subject that we want to delete
    -Output:
        *The OID of the subject that was deleted
    """

    q = "DELETE FROM subjects WHERE subjectId = %s"
    params = (oid,)
    return base_dal.execute(q, params)
