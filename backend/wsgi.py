from flask import Flask
from stock.backend.app.core.config import Config
from app import app

def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)
    
    @app.get("/health")
    def health():
        return {"status":"ok"}
    return app
app = create_app()


