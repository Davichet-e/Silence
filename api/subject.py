# This file is part of the Silence framework.
# Silence was developed by the IISSI1-TI team
# (Agustín Borrego, Daniel Ayala, Carlos Ortiz, Inma Hernández & David Ruiz)
# and it is distributed as open source software under the GNU-GPL 3.0 License.

from typing import Optional, Tuple

from flask import Blueprint, Response, jsonify, request

from bll.bll_exception import BLLException
from bll import subject_bll
from dal import subject_dal

subject_api = Blueprint("subject_api", __name__)

# Methods for the subject endpoint


def get_fields() -> tuple:
    name: Optional[str] = request.form.get("name", default=None)
    acronym: Optional[str] = request.form.get("acronym", default=None)
    n_credits: Optional[float] = request.form.get("credits", default=None)
    course: Optional[int] = request.form.get("course", default=None)
    subject_type: Optional[str] = request.form.get("subject_type", default=None)
    degreeId: Optional[int] = request.form.get("degreeId", default=None)

    return name, acronym, n_credits, course, subject_type, degreeId


@subject_api.route("/subject", methods=["GET"])
def get_all() -> Tuple[Response, int]:
    """Returns all subjects in the system"""
    subjects: tuple = subject_dal.get_all()
    return jsonify(subjects), 200


@subject_api.route("/subject/<int:oid>", methods=["GET"])
def get_by_oid(oid: int) -> Tuple[Response, int]:
    """Returns one subject by OID"""
    response: Response
    response_code: int

    try:
        subject = subject_dal.get_by_oid(oid)
    except BLLException as exc:
        error = {"error": str(exc)}
        response = jsonify(error)
        response_code = 400
    else:
        response = jsonify(subject)
        response_code = 200 if response else 404

    return response, response_code


@subject_api.route("/subject", methods=["POST"])
def insert() -> Tuple[Response, int]:
    """Creates a new subject"""
    subject_fields: tuple = get_fields()

    res: Tuple[Response, int]

    try:
        oid: int = subject_bll.insert(*subject_fields)
        res = jsonify({"oid": oid}), 200
    except BLLException as exc:
        error = {"error": str(exc)}
        res = jsonify(error), 400

    return res


@subject_api.route("/subject/<int:oid>", methods=["PUT"])
def update(oid: int):
    """Updates an existing subject"""
    subject_fields: tuple = get_fields()

    res: Tuple[Response, int]

    try:
        new_oid = subject_bll.update(oid, *subject_fields)
        res = jsonify({"oid": new_oid}), 200
    except BLLException as exc:
        error = {"error": str(exc)}
        res = jsonify(error), 400

    return res


@subject_api.route("/subject/<int:oid>", methods=["DELETE"])
def delete(oid: int):
    """Deletes a subject by OID"""
    res: Tuple[Response, int]

    try:
        subject_bll.delete(oid)
        res = jsonify({"oid": oid}), 200
    except BLLException as exc:
        error = {"error": str(exc)}
        res = jsonify(error), 400

    return res
