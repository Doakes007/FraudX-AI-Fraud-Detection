from flask import Blueprint, jsonify, request
from db.db_config import get_connection
from utils.jwt_helper import token_required

admin_bp = Blueprint("admin", __name__)

def admin_required():
    if not request.is_admin:
        return jsonify({
            "error": "Admin only"
        }), 403
    return None


@admin_bp.route("/stats", methods=["GET"])
@token_required
def get_admin_stats():

    admin_check = admin_required()
    if admin_check:
        return admin_check

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("SELECT COUNT(*) FROM users")
        total_users = cur.fetchone()[0]

        cur.execute("SELECT COUNT(*) FROM transactions")
        total_txns = cur.fetchone()[0]

        cur.execute(
            "SELECT COUNT(*) FROM transactions WHERE is_fraud = TRUE"
        )
        total_frauds = cur.fetchone()[0]

        cur.execute(
            "SELECT risk_level, COUNT(*) FROM users GROUP BY risk_level"
        )

        risk_data = cur.fetchall()

        risk_breakdown = {
            level: count for level, count in risk_data
        }

        cur.close()
        conn.close()

        return jsonify({
            "total_users": total_users,
            "total_transactions": total_txns,
            "total_frauds": total_frauds,
            "risk_breakdown": risk_breakdown
        })

    except Exception as e:
        return jsonify({
            "error": str(e)
        }), 500


@admin_bp.route("/users", methods=["GET"])
@token_required
def get_all_users():

    admin_check = admin_required()
    if admin_check:
        return admin_check

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("""
            SELECT id, name, email, risk_level
            FROM users
        """)

        users = cur.fetchall()

        cur.close()
        conn.close()

        return jsonify([
            {
                "id": u[0],
                "name": u[1],
                "email": u[2],
                "risk_level": u[3]
            }
            for u in users
        ])

    except Exception as e:
        return jsonify({
            "error": str(e)
        }), 500


@admin_bp.route("/transactions/all", methods=["GET"])
@token_required
def get_all_transactions():

    admin_check = admin_required()
    if admin_check:
        return admin_check

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("""
            SELECT 
                t.id,
                t.amount,
                t.timestamp,
                u1.name,
                u1.email,
                u1.risk_level,
                u2.name,
                u2.email,
                u2.risk_level
            FROM transactions t
            JOIN users u1 ON t.from_id = u1.id
            JOIN users u2 ON t.to_id = u2.id
        """)

        rows = cur.fetchall()

        cur.close()
        conn.close()

        return jsonify([
            {
                "id": row[0],
                "amount": float(row[1]),
                "timestamp": row[2].strftime('%Y-%m-%d %H:%M:%S'),
                "sender_name": row[3],
                "sender_email": row[4],
                "sender_risk": row[5],
                "receiver_name": row[6],
                "receiver_email": row[7],
                "receiver_risk": row[8]
            }
            for row in rows
        ])

    except Exception as e:
        return jsonify({
            "error": str(e)
        }), 500


@admin_bp.route("/transactions/fraud", methods=["GET"])
@token_required
def get_fraud_transactions():

    admin_check = admin_required()
    if admin_check:
        return admin_check

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("""
            SELECT 
                t.id,
                t.amount,
                t.timestamp,
                u1.name,
                u1.email,
                u1.risk_level,
                u2.name,
                u2.email,
                u2.risk_level
            FROM transactions t
            JOIN users u1 ON t.from_id = u1.id
            JOIN users u2 ON t.to_id = u2.id
            WHERE t.is_fraud = TRUE
        """)

        rows = cur.fetchall()

        cur.close()
        conn.close()

        return jsonify([
            {
                "id": row[0],
                "amount": float(row[1]),
                "timestamp": row[2].strftime('%Y-%m-%d %H:%M:%S'),
                "sender_name": row[3],
                "sender_email": row[4],
                "sender_risk": row[5],
                "receiver_name": row[6],
                "receiver_email": row[7],
                "receiver_risk": row[8]
            }
            for row in rows
        ])

    except Exception as e:
        return jsonify({
            "error": str(e)
        }), 500