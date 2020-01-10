# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

from test.utils import Test, error, success

from bll.bll_exception import BLLException
from bll import subject_bll
from dal import subject_dal


class TestsSubject(Test):
    """Create tests"""

    # Create a subject
    @success
    def create_success(self):
        subject_bll.insert("Asignatura Muy Nueva", "AMN", 6, 3, "Obligatoria", 1, 1)

    # Create a subject with incorrect name
    @error(BLLException)
    def create_incorrect_name(self):
        subject_bll.insert(" ", "AMN", 6, 3, "Obligatoria", 1, 1)

    # Create a subject with the same name
    @error(BLLException)
    def create_same_name(self):
        subject_bll.insert(
            "Fundamentos de programación", "AMN", 6, 3, "Obligatoria", 1, 1
        )

    # Create a subject with incorrect acronym
    @error(BLLException)
    def create_incorrect_acronym(self):
        subject_bll.insert("Asignatura Muy Nueva", " ", 6, 3, "Obligatoria", 1, 1)

    # Create a subject with the same acronym
    @error(BLLException)
    def create_same_acronym(self):
        subject_bll.insert("Asignatura Muy Nueva", "FP", 6, 3, "Obligatoria", 1, 1)

    # Create a subject with incorrect credits
    @error(BLLException)
    def create_incorrect_credits(self):
        subject_bll.insert("Asignatura Muy Nueva", "AMN", 0, 3, "Obligatoria", 1, 1)

    # Create a subject with incorrect course
    @error(BLLException)
    def create_incorrect_course(self):
        subject_bll.insert("Asignatura Muy Nueva", "AMN", 6, 7, "Obligatoria", 1, 1)

    # Create a subject with incorrect type
    @error(BLLException)
    def create_incorrect_type(self):
        subject_bll.insert("Asignatura Muy Nueva", "AMN", 6, 3, "Inexistente", 1, 1)

    """Update tests"""
    # Update a subject
    @success
    def update_success(self):
        subject_list = subject_dal.get_all()
        old_subject = subject_list[0]
        oid = old_subject["subjectId"]

        subject_bll.update(
            oid, "Asignatura Muy Nueva", "AMN", 12, 1, "Obligatoria", 1, 1
        )

        subject = subject_dal.get_by_name(old_subject["name"])
        if subject is not None:
            raise BLLException("The subject has the same name as before the change")

        subject = subject_dal.get_by_name("Asignatura Muy Nueva")
        if subject is None:
            raise BLLException("The subject has not got the new name")

    # Update a subject same name
    @error(BLLException)
    def update_same_name(self):
        subject_list = subject_dal.get_all()
        old_subject = subject_list[0]
        other_subject = subject_list[1]
        oid = old_subject["subjectId"]

        subject_bll.update(
            oid, other_subject["name"], "AMN", 12, 1, "Obligatoria", 1, 1
        )

    # Update a subject incorrect name
    @error(BLLException)
    def update_incorrect_name(self):
        subject_list = subject_dal.get_all()
        old_subject = subject_list[0]
        oid = old_subject["subjectId"]

        subject_bll.update(oid, " ", "AMN", 12, 1, "Obligatoria", 1, 1)

    # Update a subject same acronym
    @error(BLLException)
    def update_same_acronym(self):
        subject_list = subject_dal.get_all()
        old_subject = subject_list[0]
        other_subject = subject_list[1]
        oid = old_subject["subjectId"]

        subject_bll.update(
            oid,
            "Asignatura Muy Nueva",
            other_subject["acronym"],
            12,
            1,
            "Obligatoria",
            1,
            1,
        )

    # Update a subject incorrect acronym
    @error(BLLException)
    def update_incorrect_acronym(self):
        subject_list = subject_dal.get_all()
        old_subject = subject_list[0]
        oid = old_subject["subjectId"]

        subject_bll.update(
            oid, "Asignatura Muy Nueva", "   ", 12, 1, "Obligatoria", 1, 1
        )

    # Update a subject incorrect credits
    @error(BLLException)
    def update_incorrect_credits(self):
        subject_list = subject_dal.get_all()
        old_subject = subject_list[0]
        oid = old_subject["subjectId"]

        subject_bll.update(
            oid, "Asignatura Muy Nueva", "AMN", -69, 1, "Obligatoria", 1, 1
        )

    # Update a subject incorrect course
    @error(BLLException)
    def update_incorrect_course(self):
        subject_list = subject_dal.get_all()
        old_subject = subject_list[0]
        oid = old_subject["subjectId"]

        subject_bll.update(
            oid, "Asignatura Muy Nueva", "AMN", 12, -4, "Obligatoria", 1, 1
        )

    # Update a subject incorrect type
    @error(BLLException)
    def update_incorrect_type(self):
        subject_list = subject_dal.get_all()
        old_subject = subject_list[0]
        oid = old_subject["subjectId"]

        subject_bll.update(
            oid, "Asignatura Muy Nueva", "AMN", 12, 1, "Inexistente", 1, 1
        )

    """Delete tests"""
    # Delete a subject
    @success
    def delete_success(self):
        oid = subject_bll.insert(
            "Asignatura Muy Nueva", "AMN", 6, 3, "Obligatoria", 1, 1
        )
        subject = subject_dal.get_by_name("Asignatura Muy Nueva")

        if subject is None:
            raise BLLException("The subject was not created")

        subject_bll.delete(oid)

        subject = subject_dal.get_by_name("Asignatura Muy Nueva")
        if subject is not None:
            raise BLLException("The subject hasn't been deleted")

    # Delete an already deleted subject
    @error(BLLException)
    def delete_one_deleted(self):
        subject_list = subject_dal.get_all()
        old_subject = subject_list[0]
        oid = old_subject["subjectId"]

        subject_bll.delete(oid)
        subject_bll.delete(oid)
