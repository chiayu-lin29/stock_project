"""
News API Router
提供市场新闻接口
"""
from flask import Blueprint, jsonify
from app.services.news_service import NewsService

bp = Blueprint('news', __name__)
news_service = NewsService()


@bp.route('', methods=['GET'])
def get_news():
    """
    获取市场新闻
    Returns:
        JSON array of news articles
    """
    try:
        news = news_service.get_latest_news(limit=8)
        return jsonify(news), 200
    except Exception as e:
        # 返回模拟数据作为后备
        fallback_news = [
            {
                'id': 1,
                'title': '台積電第四季財報超預期，股價創新高',
                'category': '科技',
                'source': '經濟日報',
                'publishedAt': '2024-01-12',
                'url': '#'
            },
            {
                'id': 2,
                'title': '聯發科推出新款 AI 晶片，市場反應熱烈',
                'category': '大盤',
                'source': '工商時報',
                'publishedAt': '2024-01-12',
                'url': '#'
            },
            {
                'id': 3,
                'title': '航運三雄營收成長，帶動航運類股上漲',
                'category': '航運',
                'source': '非凡新聞',
                'publishedAt': '2024-01-11',
                'url': '#'
            },
            {
                'id': 4,
                'title': '金融股配息題材發酵，吸引資金回流',
                'category': '金融',
                'source': '鉅亨網',
                'publishedAt': '2024-01-11',
                'url': '#'
            }
        ]
        return jsonify(fallback_news), 200