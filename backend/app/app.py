"""
Flask Application Factory
注册所有路由和配置
"""
from flask import Flask
from flask_cors import CORS
from app.core.config import Config
from app.api.routers.stocks import bp as stocks_bp
from app.api.routers.news import bp as news_bp


def create_app():
    """创建并配置 Flask 应用"""
    app = Flask(__name__)
    
    # 从 Config 类加载配置
    app.config.from_object(Config)
    
    # 配置 CORS - 允许前端访问
    CORS(app, resources={
        r"/api/*": {
            "origins": [
                "http://localhost:3000",  # Docker 前端
                "http://localhost:5173",  # Vite 开发服务器
                "http://localhost:8000"   # 本地开发
            ],
            "methods": ["GET", "POST", "PUT", "DELETE"],
            "allow_headers": ["Content-Type", "Authorization"]
        }
    })
    
    # 注册蓝图
    app.register_blueprint(stocks_bp, url_prefix="/api/stocks")
    app.register_blueprint(news_bp, url_prefix="/api/news")
    
    # 根路由
    @app.route('/')
    def index():
        return {
            'message': 'StockPulse TW API',
            'version': '1.0.0',
            'endpoints': {
                'stocks': '/api/stocks',
                'news': '/api/news'
            }
        }
    
    # Health check
    @app.route('/healthz')
    def health():
        return {'status': 'healthy'}
    
    return app


app = create_app()
