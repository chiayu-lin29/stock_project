"""
Stock Service
处理股票数据的业务逻辑
"""
from typing import List, Dict, Optional
from datetime import datetime, timedelta
import json
from app.services.cache import get_redis_client


class StockService:
    def __init__(self):
        self.redis_client = get_redis_client()
        self.cache_ttl = 300  # 5分钟缓存
    
    def get_stocks(self, date: str, code: Optional[str] = None) -> List[Dict]:
        """
        获取股票数据
        优先从缓存读取，缓存未命中则从数据库查询
        """
        # 生成缓存键
        cache_key = f"stocks:{date}:{code if code else 'all'}"
        
        # 尝试从缓存获取
        try:
            cached_data = self.redis_client.get(cache_key)
            if cached_data:
                return json.loads(cached_data)
        except Exception as e:
            print(f"Cache error: {e}")
        
        # 从数据库查询
        stocks_data = self._fetch_from_database(date, code)
        
        # 存入缓存
        if stocks_data:
            try:
                self.redis_client.setex(
                    cache_key, 
                    self.cache_ttl, 
                    json.dumps(stocks_data, ensure_ascii=False)
                )
            except Exception as e:
                print(f"Cache set error: {e}")
        
        return stocks_data
    
    def _fetch_from_database(self, date: str, code: Optional[str] = None) -> List[Dict]:
        """
        从数据库查询股票数据
        TODO: 根据你们的实际数据库结构实现
        """
        # 示例：使用 SQLAlchemy 查询
        # from models.stock import Stock
        # from app.utils.db import db_session
        
        # query = db_session.query(Stock).filter(Stock.date == date)
        # if code:
        #     query = query.filter(Stock.code == code)
        # results = query.all()
        
        # return [self._format_stock_data(stock) for stock in results]
        
        # 临时模拟数据（实际应从数据库查询）
        return self._get_mock_data(code)
    
    def _get_mock_data(self, code: Optional[str] = None) -> List[Dict]:
        """
        模拟数据 - 实际应该从数据库查询
        """
        mock_stocks = [
            {
                'code': '2330',
                'name': '台積電',
                'date': datetime.now().strftime('%Y-%m-%d'),
                'open': 585.0,
                'high': 590.0,
                'low': 583.0,
                'close': 588.0,
                'volume': 25000000,
                'totalAmount': 14700000000,
                'change': 5.0,
                'changePercent': 0.86
            },
            {
                'code': '2317',
                'name': '鴻海',
                'date': datetime.now().strftime('%Y-%m-%d'),
                'open': 152.0,
                'high': 155.0,
                'low': 151.5,
                'close': 153.0,
                'volume': 12000000,
                'totalAmount': 1836000000,
                'change': 3.0,
                'changePercent': 2.00
            },
            {
                'code': '2454',
                'name': '聯發科',
                'date': datetime.now().strftime('%Y-%m-%d'),
                'open': 1110.0,
                'high': 1120.0,
                'low': 1105.0,
                'close': 1115.0,
                'volume': 2500000,
                'totalAmount': 2787500000,
                'change': 15.0,
                'changePercent': 1.36
            },
            {
                'code': '2881',
                'name': '富邦金',
                'date': datetime.now().strftime('%Y-%m-%d'),
                'open': 70.5,
                'high': 71.8,
                'low': 70.2,
                'close': 71.2,
                'volume': 8000000,
                'totalAmount': 569600000,
                'change': 1.2,
                'changePercent': 1.71
            }
        ]
        
        if code:
            return [s for s in mock_stocks if s['code'] == code]
        return mock_stocks
    
    def _format_stock_data(self, stock) -> Dict:
        """
        格式化股票数据为前端需要的格式
        """
        return {
            'code': stock.code,
            'name': stock.name,
            'date': stock.date.strftime('%Y-%m-%d') if hasattr(stock, 'date') else None,
            'open': float(stock.open_price),
            'high': float(stock.high_price),
            'low': float(stock.low_price),
            'close': float(stock.close_price),
            'volume': int(stock.volume),
            'totalAmount': float(stock.total_amount),
            'change': float(stock.change),
            'changePercent': float(stock.change_percent)
        }
    
    def get_latest_stocks(self, limit: int = 100) -> List[Dict]:
        """
        获取最新交易日的股票数据
        """
        latest_date = datetime.now().strftime('%Y-%m-%d')
        return self.get_stocks(date=latest_date)[:limit]
    
    def get_stock_history(self, code: str, start_date: Optional[str] = None, 
                         end_date: Optional[str] = None) -> List[Dict]:
        """
        获取股票历史数据
        """
        if not start_date:
            start_date = (datetime.now() - timedelta(days=30)).strftime('%Y-%m-%d')
        if not end_date:
            end_date = datetime.now().strftime('%Y-%m-%d')
        
        return self._get_mock_data(code)