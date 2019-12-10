# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

from typing import Optional

from bll.BLLException import BLLException
from bll.utils import check_not_null
from dal.DALException import DALException
from dal.SubjectDAL import SubjectDAL


class SubjectBLL(SubjectDAL):
    def insert(
        self,
        name: str,
        acronym: str,
        n_credits: int,
        course: int,
        subject_type: str,
        degree_id: int,
    ) -> int:
        """Check that the name and acronym are not empty"""

        check_not_null(name, "The subject's name cannot be empty")
        check_not_null(acronym, "The subject's acronym cannot be empty")
        check_not_null(n_credits, "The subject's credits cannot be empty")
        check_not_null(course, "The subject's course cannot be empty")
        check_not_null(subject_type, "The subject's subject type cannot be empty")
        check_not_null(degree_id, "The subject's degree_id cannot be empty")

        # Insert the new subject
        try:
            oid = super().insert(
                name, acronym, n_credits, course, subject_type, degree_id
            )
        except DALException as exc:
            raise BLLException(exc) from exc

        return oid

    def update(
        self,
        oid: int,
        name: str,
        acronym: str,
        n_credits: int,
        course: int,
        subject_type: str,
        degree_id: int,
    ) -> int:
        """Check that the name and acronym are not empty, and that the OID exists"""

        self.check_oid_exists(oid)
        check_not_null(name, "The subject's name cannot be empty")
        check_not_null(acronym, "The subject's acronym cannot be empty")
        check_not_null(n_credits, "The subject's credits cannot be empty")
        check_not_null(course, "The subject's course cannot be empty")
        check_not_null(subject_type, "The subject's subject type cannot be empty")
        check_not_null(degree_id, "The subject's degree_id cannot be empty")

        try:
            new_oid = super().update(
                oid, name, acronym, n_credits, course, subject_type, degree_id
            )
        except DALException as exc:
            raise BLLException(exc) from exc

        return new_oid

    def delete(self, oid: int) -> int:
        """Check that the OID exists"""
        self.check_oid_exists(oid)

        try:
            res = super().delete(oid)
        except DALException as exc:
            raise BLLException(exc) from exc

        return res

    ##################################################################################
    # Auxiliary check methods

    def check_oid_exists(self, oid: int) -> None:
        """Check that there exists a subject with the provided OID"""

        subj = super().get_by_oid(oid)
        if subj is None:
            raise BLLException(f"Cannot find a subject with oid {oid}")
