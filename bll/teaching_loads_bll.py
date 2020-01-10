from typing import Optional

from bll.bll_exception import BLLException
from bll.utils import check_not_null
from dal.dal_exception import DALException
from dal import teaching_loads_dal, group_dal


def insert(professorId: int, groupId: int, credits: int) -> int:
    """Insert a new group"""

    check_not_null(professorId, "The group's professorId cannot be empty")
    check_not_null(groupId, "The group's groupId cannot be empty")
    check_not_null(credits, "The group's credits cannot be empty")

    # Insert the new group
    try:
        oid = teaching_loads_dal.insert(professorId, groupId, credits)
        bussines_law_13(professorId, groupId)
    except DALException as exc:
        raise BLLException(exc) from exc

    return oid


def update(oid: int, professorId: int, groupId: int, credits: int) -> int:
    """Update a group"""

    check_oid_exists(oid)
    check_not_null(professorId, "The group's name cannot be empty")
    check_not_null(groupId, "The group's activity cannot be empty")
    check_not_null(credits, "The group's year cannot be empty")

    try:
        new_oid = teaching_loads_dal.update(oid, professorId, groupId, credits)
        bussines_law_13(professorId, groupId)
    except DALException as exc:
        raise BLLException(exc) from exc

    return new_oid


def delete(oid: int) -> int:
    """Delete a group"""
    check_oid_exists(oid)

    try:
        res = teaching_loads_dal.delete(oid)
    except DALException as exc:
        raise BLLException(exc) from exc

    return res


##################################################################################
# Auxiliary check methods


def check_oid_exists(oid: int) -> None:
    """Check that there exists a group with the provided OID"""

    subj = teaching_loads_dal.get_by_oid(oid)
    if subj is None:
        raise BLLException(f"Cannot find a group with oid {oid}")


def bussines_law_13(professor_id: int, group_id: int) -> None:
    """En un año académico un profesor no puede impartir docencia en más de 5 grupos."""
    year = group_dal.get_by_oid(group_id)["year"]

    teaching_loads_by_professor_id = teaching_loads_dal.get_by_professor_id(
        professor_id
    )

    groups_id_by_year = {group["groupId"] for group in group_dal.get_by_year(year)}

    counter = 0
    for teaching_load in teaching_loads_by_professor_id:
        if teaching_load["groupId"] in groups_id_by_year:
            counter += 1

        if counter > 5:
            raise BLLException(
                "En un año académico un profesor no puede impartir docencia en más de 5 grupos"
            )
