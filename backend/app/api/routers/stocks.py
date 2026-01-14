"""
Stock API Router
提供股票数据查询接口
"""
from flask import Blueprint, request, jsonify
from app.services.stock_service import StockService
from datetime import datetime

bp = Blueprint('stocks', __name__)
stock_service = StockService()


@bp.route('', methods=['GET'])
def get_stocks():
    """
    获取股票数据
    Query Parameters:
        - date: 交易日期 (YYYY-MM-DD), 默认今天
        - code: 股票代码, 可选
    
    Returns:
        JSON array of stock data
    """
    try:
        # 获取查询参数
        date_str = request.args.get('date')
        stock_code = request.args.get('code')
        
        # 默认日期为今天
        if not date_str:
            date_str = datetime.now().strftime('%Y-%m-%d')
        
        # 调用服务层获取数据
        stocks = stock_service.get_stocks(date=date_str, code=stock_code)
        
        return jsonify(stocks), 200
        
    except ValueError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': 'Internal server error', 'message': str(e)}), 500


@bp.route('/latest', methods=['GET'])
def get_latest_stocks():
    """
    获取最新交易日的股票数据
    Query Parameters:
        - limit: 返回数量限制, 默认100
    """
    try:
        limit = request.args.get('limit', 100, type=int)
        stocks = stock_service.get_latest_stocks(limit=limit)
        return jsonify(stocks), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500


@bp.route('/<stock_code>', methods=['GET'])
def get_stock_by_code(stock_code):
    """
    获取特定股票的历史数据
    Path Parameters:
        - stock_code: 股票代码
    Query Parameters:
        - start_date: 开始日期
        - end_date: 结束日期
    """
    try:
        start_date = request.args.get('start_date')
        end_date = request.args.get('end_date')
        
        stock_data = stock_service.get_stock_history(
            code=stock_code,
            start_date=start_date,
            end_date=end_date
        )
        
        return jsonify(stock_data), 200
    except Exception as e:
        return jsonify({'error': str(e)}), 500