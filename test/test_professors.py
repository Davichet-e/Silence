# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

from test.utils import Test, error, success

from bll.bll_exception import BLLException
from bll import professor_bll, teaching_loads_bll
from dal import teaching_loads_dal, professor_dal


class TestsProfessors(Test):
    """Create tests"""

    @success
    def insert_professor_with_4_groups(self):
        id_ = professor_dal.insert(
            1, 2, "PAD", "05727239Y", "Juan", "De Dios", "1960-05-02", "juan@gmail.es"
        )
        teaching_loads_bll.insert(id_, 1, 6)
        teaching_loads_bll.insert(id_, 2, 6)
        teaching_loads_bll.insert(id_, 3, 12)
        teaching_loads_bll.insert(id_, 4, 6)

    @error(BLLException)
    def insert_professor_with_6_groups(self):
        id_ = professor_bll.insert(
            1, 2, "PAD", "05727239Y", "Juan", "De Dios", "1960-05-02", "juan@gmail.es"
        )
        teaching_loads_bll.insert(id_, 1, 6)
        teaching_loads_bll.insert(id_, 2, 6)
        teaching_loads_bll.insert(id_, 3, 12)
        teaching_loads_bll.insert(id_, 4, 6)
        teaching_loads_bll.insert(id_, 11, 6)
        teaching_loads_bll.insert(id_, 10, 6)

    @success
    def insert_tu(self):
        # oid =
        professor_dal.insert(
            1, 1, "PCD", "05727239Y", "Juan", "De Dios", "1960-05-02", "juan@gmail.es"
        )
        professor_dal.insert(
            1, 1, "CU", "05727239X", "Juan", "De Dios", "1960-05-02", "juan@gmail.en"
        )
        professor_bll.insert(
            1, 1, "TU", "05727239C", "Juan", "De Dios", "1960-05-02", "juan@gmail.com"
        )

    @error(BLLException)
    def insert_pad(self):
        professor_bll.insert(
            1, 2, "PAD", "05727239Y", "Juan", "De Dios", "1960-05-02", "juan@gmail.es"
        )

    @success
    def update_dni(self):
        before = professor_dal.get_by_oid(1)
        before["dni"] = "05727239Y"
        before["oid"] = before.pop("professorId")
        before["office_id"] = before.pop("officeId")
        before["department_id"] = before.pop("departmentId")
        before["first_name"] = before.pop("firstName")
        before["birth_date"] = before.pop("birthDate")
        professor_bll.update(**before)

    @error(BLLException)
    def modify_professor(self):
        before = professor_dal.get_by_oid(1)
        before["departmentId"] += 1
        before["oid"] = before.pop("professorId")
        before["office_id"] = before.pop("officeId")
        before["department_id"] = before.pop("departmentId")
        before["first_name"] = before.pop("firstName")
        before["birth_date"] = before.pop("birthDate")
        professor_bll.update(**before)

    @success
    def delete_useless_professor(self):
        oid = professor_bll.insert(
            1,
            1,
            "PAD",
            "05727239Y",
            "Juan",
            "De la Rolla",
            "1991-01-01",
            "delarolla@gmail.com",
        )
        professor_bll.delete(oid)

    @success
    def get_all(self):
        professor_dal.get_all()

