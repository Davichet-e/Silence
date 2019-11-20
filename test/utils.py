from functools import wraps
from dal.database.db_connection import get_conn
from dal import transaction

# This is the test.utils class, which contains the tools that are needed to
# create tests.

# The base Test class. Every class with test methods must inherit from it.
class Test:
    pass


# The exception that is thrown when a test fails
# If the code inside the test throws an unexpected exception, this one wraps it
class TestNotPassedException(Exception):
    pass


# Auxiliary methods to be ran before and after every single test
def _test_setup():
    # Set the autocommit mode to false
    setattr(transaction.this, "autocommit", False)


def _test_teardown():
    # Roll back the data modified by every test
    get_conn().rollback()


# Function decorator for tests that are not expected to throw any exceptions
def success(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        _test_setup()
        try:
            func(*args, **kwargs)
        except Exception as exc:
            raise TestNotPassedException(
                f"Test failed: Got unexpected exception {type(exc).__name__}"
            ) from exc
        finally:
            _test_teardown()

    return wrapper


# Function decorator for tests that should throw an exception
def error(exception_type):
    def wrapper(func):
        @wraps(func)
        def decorator(*args, **kwargs):
            _test_setup()
            try:
                func(*args, **kwargs)
                raise TestNotPassedException(
                    f"Test failed: Did not get expected exception {exception_type.__name__}"
                )
            except TestNotPassedException:
                raise
            except exception_type:
                pass
            except Exception as exc:
                raise TestNotPassedException(
                    f"Test failed: Expected {exception_type.__name__} but got {type(exc).__name__}"
                ) from exc
            finally:
                _test_teardown()

        return decorator

    return wrapper
