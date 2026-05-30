from flask import Flask
from flask_cors import CORS

# Create Flask app instance
app = Flask(__name__)
CORS(app)

# ✅ Import route blueprints
from routes.users import user_bp
from routes.transactions import txn_bp
from routes.admin import admin_bp
from routes.auth import auth_bp

# ✅ Register route blueprints with proper URL prefixes
app.register_blueprint(user_bp, url_prefix='/api/user')
app.register_blueprint(txn_bp, url_prefix='/api/transaction')
app.register_blueprint(admin_bp, url_prefix='/api/admin')   # ✅ admin routes
app.register_blueprint(auth_bp, url_prefix='/api/auth')

# ✅ Log all registered routes for debugging
print("Registered routes:")
for rule in app.url_map.iter_rules():
    print(rule)

# ✅ Test route (optional)
@app.route('/test', methods=['GET'])
def test():
    return {"message": "Flask is working!"}

# ✅ Run the app
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)


