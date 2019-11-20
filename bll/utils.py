from bll.BLLException import BLLException


def check_not_null(value, msg: str):
    if value is None or (isinstance(value, str) and value.strip() == ""):
        raise BLLException(msg)
