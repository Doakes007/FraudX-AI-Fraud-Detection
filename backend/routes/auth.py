from flask import Blueprint, request, jsonify
from db.db_config import get_connection
import jwt
import datetime
from utils.device_utils import register_device_if_new

auth_bp = Blueprint("auth", __name__)

SECRET_KEY = "fraudx_secret_key"

@auth_bp.route("/login", methods=["POST"])
def login():

    data = request.get_json()

    email = data.get("email")
    password = data.get("password")

    device_id = data.get("device_id", "unknown")
    location = data.get("location", "unknown")

    conn = get_connection()
    cur = conn.cursor()

    cur.execute("""
        SELECT id, name, email, is_admin
        FROM users
        WHERE email = %s AND password = %s
    """, (email, password))

    user = cur.fetchone()

    cur.close()
    conn.close()

    if user:

        register_device_if_new(
            user[0],
            device_id,
            location
        )

        payload = {
            "user_id": user[0],
            "is_admin": user[3],
            "exp": datetime.datetime.utcnow() + datetime.timedelta(hours=1)
        }

        token = jwt.encode(
            payload,
            SECRET_KEY,
            algorithm="HS256"
        )

        return jsonify({
            "token": token,
            "user": {
                "id": user[0],
                "name": user[1],
                "email": user[2],
                "is_admin": user[3]
            }
        })

    return jsonify({
        "error": "Invalid credentials"
    }), 401