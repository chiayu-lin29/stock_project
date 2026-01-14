"""
News Service
处理新闻数据的业务逻辑
"""
from typing import List, Dict
import json
from datetime import datetime
from app.services.cache import get_redis_client


class NewsService:
    def __init__(self):
        self.redis_client = get_redis_client()
        self.cache_ttl = 600  # 10分钟缓存
    
    def get_latest_news(self, limit: int = 8) -> List[Dict]:
        """
        获取最新市场新闻
        优先从缓存读取
        """
        cache_key = f"news:latest:{limit}"
        
        # 尝试从缓存获取
        try:
            cached_data = self.redis_client.get(cache_key)
            if cached_data:
                return json.loads(cached_data)
        except Exception as e:
            print(f"Cache error: {e}")
        
        # 从外部 API 或数据库获取
        news_data = self._fetch_news(limit)
        
        # 存入缓存
        if news_data:
            try:
                self.redis_client.setex(
                    cache_key,
                    self.cache_ttl,
                    json.dumps(news_data, ensure_ascii=False)
                )
            except Exception as e:
                print(f"Cache set error: {e}")
        
        return news_data
    
    def _fetch_news(self, limit: int) -> List[Dict]:
        """
        从外部 API 获取新闻
        TODO: 替换为实际的新闻 API
        """
        try:
            # 示例：调用外部新闻 API
            # import httpx
            # response = httpx.get(
            #     "https://your-news-api.com/latest",
            #     headers={"Authorization": f"Bearer {API_KEY}"},
            #     timeout=10
            # )
            # data = response.json()
            # return self._format_news_data(data['articles'][:limit])
            
            # 返回模拟数据
            return self._get_mock_news()[:limit]
        except Exception as e:
            print(f"Error fetching news: {e}")
            return self._get_mock_news()[:limit]
    
    def _get_mock_news(self) -> List[Dict]:
        """
        模拟新闻数据
        """
        today = datetime.now().strftime('%Y-%m-%d')
        
        return [
            {
                'id': 1,
                'title': '台積電第四季財報超預期，全年營收創歷史新高',
                'category': '科技',
                'source': '經濟日報',
                'publishedAt': today,
                'url': 'https://money.udn.com/example1'
            },
            {
                'id': 2,
                'title': '聯發科推出最新 AI 晶片，股價大漲 3%',
                'category': '大盤',
                'source': '工商時報',
                'publishedAt': today,
                'url': 'https://ctee.com.tw/example2'
            },
            {
                'id': 3,
                'title': '航運三雄營收年增 15%，長榮領漲航運股',
                'category': '航運',
                'source': '非凡新聞',
                'publishedAt': today,
                'url': 'https://news.ustv.com.tw/example3'
            },
            {
                'id': 4,
                'title': '金管會宣布新政策，金融股集體走強',
                'category': '金融',
                'source': '鉅亨網',
                'publishedAt': today,
                'url': 'https://news.cnyes.com/example4'
            },
            {
                'id': 5,
                'title': '電動車供應鏈受惠，相關概念股表現亮眼',
                'category': '產業',
                'source': '財訊',
                'publishedAt': today,
                'url': 'https://wealth.com.tw/example5'
            },
            {
                'id': 6,
                'title': '外資回補台股，單日買超 80 億元',
                'category': '大盤',
                'source': '證券時報',
                'publishedAt': today,
                'url': 'https://securities.tw/example6'
            },
            {
                'id': 7,
                'title': '半導體設備廠營運佳，法人看好後市',
                'category': '科技',
                'source': '商業周刊',
                'publishedAt': today,
                'url': 'https://businessweekly.com.tw/example7'
            },
            {
                'id': 8,
                'title': '房地產類股回溫，建商推案量創新高',
                'category': '產業',
                'source': '自由財經',
                'publishedAt': today,
                'url': 'https://ec.ltn.com.tw/example8'
            }
        ]
    
    def _format_news_data(self, articles: List[Dict]) -> List[Dict]:
        """
        格式化新闻数据
        """
        formatted = []
        for idx, article in enumerate(articles):
            formatted.append({
                'id': idx + 1,
                'title': article.get('title', ''),
                'category': article.get('category', '市場'),
                'source': article.get('source', {}).get('name', '財經新聞'),
                'publishedAt': article.get('publishedAt', '').split('T')[0],
                'url': article.get('url', '#')
            })
        return formatted