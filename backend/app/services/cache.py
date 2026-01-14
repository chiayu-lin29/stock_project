"""
Redis Cache Service
提供 Redis 连接和缓存功能
"""
import redis
from app.core.config import Config

_redis_client = None

def get_redis_client():
    """
    获取 Redis 客户端单例
    """
    global _redis_client
    
    if _redis_client is None:
        try:
            _redis_client = redis.Redis(
                host=Config.REDIS_HOST,
                port=Config.REDIS_PORT,
                db=Config.REDIS_DB,
                decode_responses=True
            )
            # 测试连接
            _redis_client.ping()
        except Exception as e:
            print(f"Redis connection error: {e}")
            # 返回一个模拟的 Redis 客户端
            _redis_client = MockRedisClient()
    
    return _redis_client


class MockRedisClient:
    """
    模拟 Redis 客户端（当 Redis 不可用时使用）
    """
    def __init__(self):
        self.data = {}
    
    def get(self, key):
        return self.data.get(key)
    
    def set(self, key, value):
        self.data[key] = value
        return True
    
    def setex(self, key, time, value):
        self.data[key] = value
        return True
    
    def delete(self, key):
        if key in self.data:
            del self.data[key]
        return True
    
    def ping(self):
        return True
