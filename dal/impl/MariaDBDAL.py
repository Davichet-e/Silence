from typing import Optional

import pymysql
from pymysql.cursors import DictCursor

from dal.DALException import DALException
from dal.database.db_connection import get_conn
from dal.transaction import get_g



class MariaDBDAL:
    """The base Data Access Layer class (implementation for MariaDB/MySQL)"""

    def query(self, q: str, params: Optional[tuple] = None) -> Optional[tuple]:
        """Query method to retrieve information"""
        # Fetch the connection and get a cursor
        conn: pymysql.Connection = get_conn()
        cursor: DictCursor = conn.cursor(DictCursor)
        try:
            # Execute the query, with or without parameters and return the result
            if params:
                cursor.execute(q, params)
            else:
                cursor.execute(q)
            res: tuple = cursor.fetchall()
            return res
        except Exception as exc:
            # If anything happens, wrap the exceptions in a DALException
            raise DALException(exc) from exc
        finally:
            # Close the cursor
            cursor.close()

    def execute(self, q: str, params: Optional[tuple] = None) -> Optional[int]:
        """Execute method to update information"""
        conn: pymysql.Connection = get_conn()
        cursor: DictCursor = conn.cursor(DictCursor)

        # Check whether we are under autocommit mode or not
        # (it will be false inside a transaction)
        try:
            autocommit = get_g().get("autocommit", True)
        except RuntimeError:
            # Allow this code to run outside the application context
            # (useful for populate_database.py and tests)
            autocommit = True

        # Fetch the connection and get a cursor
        try:
            # Execute the query, with or without parameters and return the result
            if params:
                cursor.execute(q, params)
            else:
                cursor.execute(q)

            # If we're in autocommit mode (true by default), commit the operation
            # This will be false if we're inside a transaction
            if autocommit:
                conn.commit()

            # Return the ID of the row that was modified or inserted
            return cursor.lastrowid
        except Exception as exc:
            # Rollback the operation if we're under autocommit mode and
            # wrap the exception in a DALException
            if autocommit:
                conn.rollback()
            raise DALException(exc) from exc
        finally:
            # Close the cursor
            cursor.close()
