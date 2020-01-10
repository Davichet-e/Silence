from typing import Optional
from collections import Counter

from bll.bll_exception import BLLException
from bll.utils import check_not_null, check_field_is_enum
from dal.dal_exception import DALException
from dal import professor_dal


def insert(
    office_id: int,
    department_id: int,
    category: str,
    dni: str,
    first_name: str,
    surname: str,
    birth_date: str,
    email: str,
) -> int:
    """Insert a new professor"""

    check_not_null(office_id, "The group's office_id cannot be empty")
    check_not_null(department_id, "The group's department_id cannot be empty")
    check_not_null(category, "The group's category cannot be empty")
    check_not_null(dni, "The group's dni cannot be empty")
    check_not_null(first_name, "The group's first_name cannot be empty")
    check_not_null(surname, "The group's surname cannot be empty")
    check_not_null(birth_date, "The group's birth_date cannot be empty")
    check_not_null(email, "The group's email cannot be empty")

    check_field_is_enum(
        category,
        {"CU", "TU", "PCD", "PAD"},
        f"The field 'category' must be one of ('CU', 'TU', 'PCD', 'PAD')",
    )

    check_dni(dni)
    check_dni_exists(dni)
    check_email_exists(dni)
    bussines_law_14(category, department_id)

    # Insert the new group
    try:
        oid = professor_dal.insert(
            office_id,
            department_id,
            category,
            dni,
            first_name,
            surname,
            birth_date,
            email,
        )
    except DALException as exc:
        raise BLLException(exc) from exc

    return oid


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
    """Update a professor"""

    check_oid_exists(oid)
    check_not_null(office_id, "The group's office_id cannot be empty")
    check_not_null(department_id, "The group's department_id cannot be empty")
    check_not_null(category, "The group's category cannot be empty")
    check_not_null(dni, "The group's dni cannot be empty")
    check_not_null(first_name, "The group's first_name cannot be empty")
    check_not_null(surname, "The group's surname cannot be empty")
    check_not_null(birth_date, "The group's birth_date cannot be empty")
    check_not_null(email, "The group's email cannot be empty")

    check_field_is_enum(
        category,
        {"CU", "TU", "PCD", "PAD"},
        f"The field 'category' must be one of ('CU', 'TU', 'PCD', 'PAD')",
    )

    check_dni(dni)
    check_dni_exists(dni, oid)
    check_email_exists(dni, oid)
    bussines_law_14(category, department_id)

    try:
        new_oid = professor_dal.update(
            oid,
            office_id,
            department_id,
            category,
            dni,
            first_name,
            surname,
            birth_date,
            email, 
        )

    except DALException as exc:
        raise BLLException(exc) from exc

    return new_oid


def delete(oid: int) -> int:
    """Delete a professor"""
    check_oid_exists(oid)

    try:
        res = professor_dal.delete(oid)
    except DALException as exc:
        raise BLLException(exc) from exc

    return res


##################################################################################
# Auxiliary check methods


def check_oid_exists(oid: int) -> None:
    """Check that there exists a professor with the provided OID"""

    subj = professor_dal.get_by_oid(oid)
    if subj is None:
        raise BLLException(f"Cannot find a professor with oid {oid}")


def check_dni_exists(dni: str, oid: Optional[int] = None) -> None:
    professor = professor_dal.get_by_dni(dni)
    if professor and oid != professor["professorId"]:
        raise DALException("There must be only only professor with the same DNI")


def check_email_exists(email: str, oid: Optional[int] = None) -> None:
    professor = professor_dal.get_by_dni(email)
    if professor and oid != professor["professorId"]:
        raise DALException("There must be only only professor with the same email")


def check_dni(string: str) -> None:
    if len(string) != 9:
        raise BLLException("The input dni does not have the correct length")
    elif any(not char.isnumeric() for char in string[:-1]) or not string[-1].isalpha():
        raise BLLException(
            "The input dni does not have the appropiate structure, it must contain 8 numbers and 1 letter"
        )


def bussines_law_14(category: str, department_id: int):
    professors = professor_dal.get_by_department(department_id)
    c = Counter([professor["category"] for professor in professors])
    c[category] += 1
    if c["CU"] + c["TU"] <= c["PCD"] + c["PAD"]:
        raise BLLException(
            "en cada departamento se tiene que cumplir que #CU+#TU > #PCD+#PAD"
        )
