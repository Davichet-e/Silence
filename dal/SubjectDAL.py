from typing import Optional

from dal.BaseDAL import BaseDAL


class SubjectDAL(BaseDAL):
    def get_all(self) -> tuple:
        """
        Get subjects
        -Input: ---
        -Output:
            *All the subjects of the table
            *None value if we cannot find the OID
        """

        q = "SELECT * FROM Subjects"
        subjects: tuple = self.query(q)
        return subjects

    def get_by_oid(self, oid: int) -> Optional[tuple]:
        """
        Get subject by OID
        -Input:
            *The OID of the subject that we want to get
        -Output:
            *Only one subject
            *None value if we cannot find the OID
        """

        subject: Optional[tuple] = None
        q = "SELECT * FROM Subjects WHERE subjectId = %s"
        params = (oid,)

        res: tuple = self.query(q, params)
        if len(res):
            subject = res[0]

        return subject

    def get_by_acronym(self, acronym: str) -> Optional[tuple]:
        """
        Get subject by acronym
        -Input:
            *The acronym of the subject that we want to get
        -Output:
            *Only one subject
            *None value if we cannot find the acronym
        """

        subject: Optional[tuple] = None
        q = "SELECT * FROM Subjects WHERE acronym = %s"
        params = (acronym,)

        res: tuple = self.query(q, params)
        if len(res):
            subject = res[0]

        return subject

    def get_by_name(self, name: str) -> tuple:
        """
        Get subject by name
        -Input:
            *The name of the subject that we want to get
        -Output:
            *Only one subject
            *None value if we cannot find the name
        """

        subject: Optional[tuple] = None
        q = "SELECT * FROM Subjects WHERE name = %s"
        params = (name,)

        res: tuple = self.query(q, params)
        if len(res):
            subject = res[0]

        return subject

    def insert(
        self,
        name: str,
        acronym: str,
        n_credits: int,
        course: int,
        subject_type: str,
        degreeId: int,
    ) -> int:
        """
        Insert a new subject
        -Input:
            *All of the properties of the subject
        - Output:
            *The OID assigned to the subject that we have inserted
        """

        q = "INSERT INTO subjects (name, acronym, credits, course, type, degreeId) VALUES (%s, %s, %s, %s, %s, %s)"
        params = (name, acronym, n_credits, course, subject_type, degreeId)
        res = self.execute(q, params)
        return res

    def update(
        self,
        oid: int,
        name: str,
        acronym: str,
        n_credits: int,
        course: int,
        subject_type: str,
        degreeId: int,
    ) -> int:
        """
        Update one subject
        -Input:
            *All of the properties of the subject, including the OID that we want to update
        -Output:
            *The OID of the subject that we have updated
        """

        q = "UPDATE subjects SET name = %s, acronym = %s, credits = %s, course = %s, type = %s, degreeId = %s WHERE subjectId = %s"
        params = (name, acronym, n_credits, course, subject_type, degreeId, oid)
        res = self.execute(q, params)
        return res

    def delete(self, oid: int) -> int:
        """
        Delete one subject
        -Input:
            *The OID of the subject that we want to delete
        -Output:
            *The OID of the subject that was deleted
        """

        q = "DELETE FROM subjects WHERE subjectId = %s"
        params = (oid,)
        res = self.execute(q, params)
        return res
