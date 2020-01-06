from typing import Optional

from bll.BLLException import BLLException
from bll.utils import check_not_null
from dal.DALException import DALException
from dal import GroupDAL


def insert(
    name: str, activity: str, year: int, subjectId: int, classroomId: int
) -> int:
    """Insert a new group"""

    check_not_null(name, "The group's name cannot be empty")
    check_not_null(activity, "The group's activity cannot be empty")
    check_not_null(year, "The group's year cannot be empty")
    check_not_null(subjectId, "The group's subjectId cannot be empty")
    check_not_null(classroomId, "The group's classroomId cannot be empty")

    # Insert the new group
    try:
        oid = GroupDAL.insert(name, activity, year, subjectId, classroomId)
    except DALException as exc:
        raise BLLException(exc) from exc

    return oid


def update(
    oid: int, name: str, activity: str, year: int, subjectId: int, classroomId: int,
) -> int:
    """Update a group"""

    check_oid_exists(oid)
    check_not_null(name, "The group's name cannot be empty")
    check_not_null(activity, "The group's activity cannot be empty")
    check_not_null(year, "The group's year cannot be empty")
    check_not_null(subjectId, "The group's subjectId cannot be empty")
    check_not_null(classroomId, "The group's classroomId cannot be empty")

    try:
        new_oid = GroupDAL.update(oid, name)
    except DALException as exc:
        raise BLLException(exc) from exc

    return new_oid


def delete(oid: int) -> int:
    """Delete a group"""
    check_oid_exists(oid)

    try:
        res = GroupDAL.delete(oid)
    except DALException as exc:
        raise BLLException(exc) from exc

    return res


##################################################################################
# Auxiliary check methods


def check_oid_exists(oid: int) -> None:
    """Check that there exists a group with the provided OID"""

    subj = GroupDAL.get_by_oid(oid)
    if subj is None:
        raise BLLException(f"Cannot find a group with oid {oid}")
