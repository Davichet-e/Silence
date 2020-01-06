# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

from typing import Optional

from bll.bll_exception import BLLException
from bll.utils import check_not_null, check_field_is_enum
from dal.dal_exception import DALException
from dal import subject_dal


def insert(
    name: str,
    acronym: str,
    n_credits: int,
    course: int,
    subject_type: str,
    degree_id: int,
) -> int:
    """Insert a new subject"""

    check_not_null(name, "The subject's name cannot be empty")
    check_not_null(acronym, "The subject's acronym cannot be empty")
    check_not_null(n_credits, "The subject's credits cannot be empty")
    check_not_null(course, "The subject's course cannot be empty")
    check_not_null(subject_type, "The subject's subject type cannot be empty")
    check_not_null(degree_id, "The subject's degree_id cannot be empty")

    check_field_is_enum(
        subject_type,
        {"Teoria", "Laboratorio"},
        f"The field 'subject_type' must be one of (Teoría, Laboratorio)",
    )

    # Insert the new subject
    try:
        oid = subject_dal.insert(
            name, acronym, n_credits, course, subject_type, degree_id
        )
    except DALException as exc:
        raise BLLException(exc) from exc

    return oid


def update(
    oid: int,
    name: str,
    acronym: str,
    n_credits: int,
    course: int,
    subject_type: str,
    degree_id: int,
) -> int:
    """Update a subject"""

    check_oid_exists(oid)
    check_not_null(name, "The subject's name cannot be empty")
    check_not_null(acronym, "The subject's acronym cannot be empty")
    check_not_null(n_credits, "The subject's credits cannot be empty")
    check_not_null(course, "The subject's course cannot be empty")
    check_not_null(subject_type, "The subject's subject type cannot be empty")
    check_not_null(degree_id, "The subject's degree_id cannot be empty")

    check_field_is_enum(
        subject_type,
        {"Teoria", "Laboratorio"},
        f"The field 'subject_type' must be one of (Teoria, Laboratorio)",
    )

    try:
        new_oid = subject_dal.update(
            oid, name, acronym, n_credits, course, subject_type, degree_id
        )
    except DALException as exc:
        raise BLLException(exc) from exc

    return new_oid


def delete(oid: int) -> int:
    """Delete a subject"""
    check_oid_exists(oid)

    try:
        res = subject_dal.delete(oid)
    except DALException as exc:
        raise BLLException(exc) from exc

    return res


##################################################################################
# Auxiliary check methods


def check_oid_exists(oid: int) -> None:
    """Check that there exists a subject with the provided OID"""

    subj = subject_dal.get_by_oid(oid)
    if subj is None:
        raise BLLException(f"Cannot find a subject with oid {oid}")


def check_name_exists(name: str) -> None:
    if subject_dal.get_by_name(name):
        raise BLLException("There must be no subject with the same name")


def check_acronym_exists(acronym: str) -> None:
    if subject_dal.get_by_acronym(acronym):
        raise BLLException("There must be no subject with the same acronym")
