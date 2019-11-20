# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

from flask import g, has_app_context
from dal.database.db_connection import get_conn
import sys

this = sys.modules[__name__]


def get_g():
    if has_app_context():
        # We're in a Flask request, the 'g' object is available
        return g
    else:
        # We're outside Flask (testing), use this module as a replacement 'g'
        return this


def get(attr, default=None):
    try:
        return getattr(this, attr)
    except AttributeError:
        return default


# This is the class for database transactions
# It is meant to be used as follows:

# with Transaction(dal_object):
#     code to be executed under the transaction
#     ...
class Transaction:

    # Transaction start: set the autocommit mode to false for this request
    def __enter__(self):
        get_g().autocommit = False

    # Transaction end: set the autocommit mode to true again
    def __exit__(self, type, value, traceback):
        if type is None:
            # If the transaction has ended successfully with a clean exit
            get_conn().commit()
        else:
            # If the transaction has been interrupted due to an unexpected exception
            get_conn().rollback()
        get_g().autocommit = True
