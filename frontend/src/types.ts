export interface StockData {
    code: string;           // 股票代碼
    name: string;           // 股票名稱
    date?: string;          // 交易日期
    open: number;           // 開盤價
    high: number;           // 最高價
    low: number;            // 最低價
    close: number;          // 收盤價
    volume: number;         // 成交量 (股)
    totalAmount: number;    // 成交金額 (元)
    change: number;         // 漲跌
    changePercent: number;  // 漲跌幅 (%)
  }
  
  export interface NewsArticle {
    id: number;
    title: string;
    category: string;
    source: string;
    publishedAt: string;
    url: string;
  }