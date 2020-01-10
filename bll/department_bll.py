from typing import Optional

from bll.bll_exception import BLLException
from bll.utils import check_not_null
from dal.dal_exception import DALException
from dal import department_dal


def insert(name: str) -> int:
    """Insert a new department"""

    check_not_null(name, "The subject's name cannot be empty")

    # Insert the new department
    try:
        oid = department_dal.insert(name)
    except DALException as exc:
        raise BLLException(exc) from exc

    return oid


def update(oid: int, name: str) -> int:
    """Update a department"""

    check_oid_exists(oid)
    check_not_null(name, "The department's name cannot be empty")

    try:
        new_oid = department_dal.update(oid, name)
    except DALException as exc:
        raise BLLException(exc) from exc

    return new_oid


def delete(oid: int) -> int:
    """Delete a department"""
    check_oid_exists(oid)

    try:
        res = department_dal.delete(oid)
    except DALException as exc:
        raise BLLException(exc) from exc

    return res


##################################################################################
# Auxiliary check methods


def check_oid_exists(oid: int) -> None:
    """Check that there exists a department with the provided OID"""

    subj = department_dal.get_by_oid(oid)
    if subj is None:
        raise BLLException(f"Cannot find a department with oid {oid}")
