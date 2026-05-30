from flask import Blueprint, jsonify, request
from db.db_config import get_connection
from utils.jwt_helper import token_required

user_bp = Blueprint("user", __name__)

@user_bp.route("/<int:user_id>", methods=["GET"])
@token_required
def get_user(user_id):

    # Prevent unauthorized access
    if request.user_id != user_id:
        return jsonify({
            "error": "Unauthorized access"
        }), 403

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute(
            "SELECT id, name, email, risk_level FROM users WHERE id = %s",
            (user_id,)
        )

        user = cur.fetchone()

        cur.close()
        conn.close()

        if user:
            return jsonify({
                "id": user[0],
                "name": user[1],
                "email": user[2],
                "risk_level": user[3]
            })

        return jsonify({
            "error": "User not found"
        }), 404

    except Exception as e:
        return jsonify({
            "error": str(e)
        }), 500


@user_bp.route("/<int:user_id>/balance", methods=["GET"])
@token_required
def check_balance(user_id):

    # Prevent unauthorized access
    if request.user_id != user_id:
        return jsonify({
            "error": "Unauthorized access"
        }), 403

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute(
            "SELECT balance FROM accounts WHERE user_id = %s",
            (user_id,)
        )

        row = cur.fetchone()

        cur.close()
        conn.close()

        if row:
            return jsonify({
                "balance": float(row[0])
            })

        return jsonify({
            "error": "User not found"
        }), 404

    except Exception as e:
        return jsonify({
            "error": str(e)
        }), 500