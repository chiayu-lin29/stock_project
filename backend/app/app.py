from flask import Flask
from app.core.config import settings
from app.db.session import init_db
from app.api.routers.health import bp as health_bp

def create_app():
    app = Flask(__name__)
    app.config["ENV"] = settings.ENV
    init_db(app)
    app.register_blueprint(health_bp, url_prefix="/healthz")
    return app

app = create_app()
