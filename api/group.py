from typing import Optional, Tuple, List, Dict, Any

from flask import Blueprint, Response, jsonify, request
from werkzeug.datastructures import MultiDict

from bll.bll_exception import BLLException
from bll import group_bll
from dal import group_dal

group_api = Blueprint("group_api", __name__)

# Methods for the subject endpoint


def get_fields() -> tuple:
    args: MultiDict = request.args

    name: Optional[str] = args.get("name", default=None)
    activity: Optional[str] = args.get("activity", default=None)
    year: Optional[int] = args.get("year", default=None, type=int)
    subjectId: Optional[int] = args.get("subjectId", default=None, type=int)
    classroomId: Optional[int] = args.get("classroomId", default=None, type=int)

    return name, activity, year, subjectId, classroomId


@group_api.route("/grupos", methods=["GET"])
def get_all() -> Tuple[Response, int]:
    """Returns all groups in the system"""
    response_code = 200

    subjects: List[Dict[str, Any]] = list(group_dal.get_all())

    args: MultiDict = request.args
    limit: Optional[int] = args.get("limit", default=None, type=int)
    order_by: Optional[str] = args.get("orderBy", default=None)

    if order_by:
        if order_by in {"name", "activity", "year", "subjectId", "classroomId"}:
            subjects.sort(key=lambda dict_: dict_.get(order_by))
        else:
            return (
                jsonify(
                    {
                        "error": "The supported orders are: 'name', 'activity', 'year', 'subjectId' and 'classroomId'"
                    }
                ),
                404,
            )

    if limit:
        subjects = subjects[:limit]

    return jsonify(subjects), response_code


@group_api.route("/grupos/<int:oid>", methods=["GET"])
def get_by_oid(oid: int) -> Tuple[Response, int]:
    """Returns one group by OID"""
    response: Response
    response_code: int

    try:
        group = group_dal.get_by_oid(oid)
    except BLLException as exc:
        error = {"error": str(exc)}
        response, response_code = jsonify(error), 400
    else:
        response = jsonify(group)
        response_code = 200 if response else 404

    return response, response_code


@group_api.route("/grupos/aulas/<int:oid>", methods=["GET"])
def get_by_classroom(oid: int) -> Tuple[Response, int]:
    """Returns all groups in the system where the classroomId is equal to the one passed as parameter"""
    response: Response
    response_code: int

    try:
        subjects = group_dal.get_by_classroom_id(oid)
    except BLLException as exc:
        error = {"error": str(exc)}
        response, response_code = jsonify(error), 400
    else:
        response = jsonify(subjects)
        response_code = 200 if response else 404

    return response, response_code


@group_api.route("/grupos", methods=["POST"])
def insert() -> Tuple[Response, int]:
    """Creates a new subject"""
    subject_fields: tuple = get_fields()

    res: Tuple[Response, int]

    try:
        oid: int = group_bll.insert(*subject_fields)
        res = jsonify({"oid": oid}), 200
    except BLLException as exc:
        error = {"error": str(exc)}
        res = jsonify(error), 400

    return res


@group_api.route("/grupos/<int:oid>", methods=["PUT"])
def update(oid: int):
    """Updates an existing subject"""
    subject_fields: tuple = get_fields()

    res: Tuple[Response, int]

    try:
        new_oid = group_dal.update(oid, *subject_fields)
        res = jsonify({"oid": new_oid}), 200
    except BLLException as exc:
        error = {"error": str(exc)}
        res = jsonify(error), 400

    return res


@group_api.route("/grupos/<int:oid>", methods=["DELETE"])
def delete(oid: int):
    """Deletes a subject by OID"""
    res: Tuple[Response, int]

    try:
        group_bll.delete(oid)
        res = jsonify({"oid": oid}), 200
    except BLLException as exc:
        error = {"error": str(exc)}
        res = jsonify(error), 400

    return res
