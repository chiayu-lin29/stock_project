
import React, { useState, useEffect, useMemo } from 'react';
import { 
  TrendingUp, 
  TrendingDown, 
  Search, 
  Download, 
  Newspaper, 
  BarChart3, 
  Calendar,
  Loader2,
  CheckSquare,
  Square,
  Filter,
  ArrowRight
} from 'lucide-react';
import { StockData, NewsArticle } from './types';
import { fetchStocks, downloadAsCSV } from './services/stockService';
import { fetchMarketNews } from './services/newsService';

const App: React.FC = () => {
  const [stocks, setStocks] = useState<StockData[]>([]);
  const [news, setNews] = useState<NewsArticle[]>([]);
  const [loading, setLoading] = useState(true);
  
  // Selection State
  const [selectedCodes, setSelectedCodes] = useState<Set<string>>(new Set());
  
  // Filters
  const [searchCode, setSearchCode] = useState('');
  const [selectedDate, setSelectedDate] = useState(new Date().toISOString().split('T')[0]);

  useEffect(() => {
    const loadInitialData = async () => {
      setLoading(true);
      try {
        const [stockData, newsData] = await Promise.all([
          fetchStocks({ date: selectedDate }),
          fetchMarketNews()
        ]);
        setStocks(stockData);
        setNews(newsData);
        // 重置選擇
        setSelectedCodes(new Set());
      } catch (error) {
        console.error("Initialization error:", error);
      } finally {
        setLoading(false);
      }
    };
    loadInitialData();
  }, [selectedDate]);

  const filteredStocks = useMemo(() => {
    return stocks.filter(s => s.code.includes(searchCode) || s.name.includes(searchCode));
  }, [stocks, searchCode]);

  const toggleSelectAll = () => {
    if (selectedCodes.size === filteredStocks.length) {
      setSelectedCodes(new Set());
    } else {
      setSelectedCodes(new Set(filteredStocks.map(s => s.code)));
    }
  };

  const toggleSelect = (code: string) => {
    const next = new Set(selectedCodes);
    if (next.has(code)) {
      next.delete(code);
    } else {
      next.add(code);
    }
    setSelectedCodes(next);
  };

  const handleDownloadSelected = () => {
    const toDownload = filteredStocks.filter(s => selectedCodes.has(s.code));
    if (toDownload.length === 0) {
      alert("請先勾選想要下載的股票");
      return;
    }
    downloadAsCSV(toDownload);
  };

  return (
    <div className="min-h-screen bg-[#f8fafc]">
      {/* Navbar */}
      <nav className="bg-white border-b border-slate-200 sticky top-0 z-50">
        <div className="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="bg-emerald-600 p-2 rounded-xl shadow-lg shadow-emerald-100">
              <TrendingUp className="w-5 h-5 text-white" />
            </div>
            <span className="text-xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-slate-900 to-slate-600">
              StockPulse <span className="text-emerald-600">TW</span>
            </span>
          </div>
          <div className="hidden md:flex items-center gap-8 text-sm font-medium text-slate-500">
            <a href="#" className="text-emerald-600 border-b-2 border-emerald-600 py-5">市場概覽</a>
            <a href="#" className="hover:text-slate-900 transition-colors">自選監控</a>
            <a href="#" className="hover:text-slate-900 transition-colors">研究報告</a>
          </div>
        </div>
      </nav>

      {/* Main Content */}
      <main className="max-w-7xl mx-auto px-6 py-10 space-y-12">
        
        {/* SECTION 1: Market News */}
        <section className="space-y-6">
          <div className="flex items-end justify-between">
            <div>
              <h2 className="text-2xl font-bold text-slate-900 flex items-center gap-2">
                <Newspaper className="w-6 h-6 text-emerald-600" />
                市場即時動態
              </h2>
              <p className="text-slate-500 mt-1">掌握台股最新新聞與盤勢變化</p>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
            {news.map(article => (
              <a 
                key={article.id} 
                href={article.url}
                className="bg-white p-5 rounded-2xl border border-slate-100 hover:border-emerald-200 hover:shadow-md transition-all flex flex-col justify-between group"
              >
                <div>
                  <div className="flex items-center justify-between mb-3">
                    <span className="text-[10px] font-bold px-2 py-0.5 rounded bg-slate-100 text-slate-600 uppercase tracking-tight">
                      {article.category}
                    </span>
                    <span className="text-[10px] text-slate-400">{article.publishedAt}</span>
                  </div>
                  <h4 className="text-sm font-bold text-slate-800 line-clamp-3 group-hover:text-emerald-700 transition-colors leading-snug">
                    {article.title}
                  </h4>
                </div>
                <div className="mt-4 flex items-center text-xs text-slate-400 font-medium border-t border-slate-50 pt-3">
                  {article.source}
                  <ArrowRight className="w-3 h-3 ml-auto opacity-0 group-hover:opacity-100 group-hover:translate-x-1 transition-all" />
                </div>
              </a>
            ))}
            {news.length === 0 && !loading && (
              <div className="col-span-full py-10 text-center text-slate-400 bg-white rounded-2xl border border-dashed border-slate-200">
                暫無最新新聞
              </div>
            )}
          </div>
        </section>

        {/* SECTION 2: Stock Data Table with Custom Selection */}
        <section className="space-y-6">
          <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
            <div>
              <h2 className="text-2xl font-bold text-slate-900 flex items-center gap-2">
                <BarChart3 className="w-6 h-6 text-emerald-600" />
                個股行情監控
              </h2>
              <p className="text-slate-500 mt-1">選取特定股票進行數據匯出</p>
            </div>
            
            <div className="flex items-center gap-3">
              <div className="text-sm font-medium text-slate-600 bg-white px-4 py-2 rounded-lg border border-slate-200 shadow-sm">
                已選擇 <span className="text-emerald-600 font-bold">{selectedCodes.size}</span> 檔股票
              </div>
              <button 
                onClick={handleDownloadSelected}
                disabled={selectedCodes.size === 0}
                className={`flex items-center gap-2 px-5 py-2 rounded-lg text-sm font-bold transition-all shadow-sm
                  ${selectedCodes.size > 0 
                    ? 'bg-slate-900 text-white hover:bg-slate-800 active:scale-95' 
                    : 'bg-slate-100 text-slate-400 cursor-not-allowed'}`}
              >
                <Download className="w-4 h-4" />
                下載自選資料 (CSV)
              </button>
            </div>
          </div>

          {/* Filter Bar */}
          <div className="bg-white p-4 rounded-2xl border border-slate-200 shadow-sm flex flex-wrap gap-4 items-center">
            <div className="relative flex-1 min-w-[280px]">
              <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
              <input 
                type="text"
                placeholder="輸入代碼或名稱過濾..."
                className="w-full pl-11 pr-4 py-2.5 bg-slate-50 border-transparent rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 transition-all"
                value={searchCode}
                onChange={(e) => setSearchCode(e.target.value)}
              />
            </div>
            <div className="flex items-center gap-3">
              <div className="relative">
                <Calendar className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                <input 
                  type="date"
                  className="pl-11 pr-4 py-2.5 bg-slate-50 border-transparent rounded-xl text-sm focus:bg-white focus:ring-2 focus:ring-emerald-500/20 focus:border-emerald-500 transition-all"
                  value={selectedDate}
                  onChange={(e) => setSelectedDate(e.target.value)}
                />
              </div>
              <button className="p-2.5 bg-slate-100 text-slate-500 rounded-xl hover:bg-slate-200 transition-colors">
                <Filter className="w-4 h-4" />
              </button>
            </div>
          </div>

          {/* Table */}
          <div className="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
            <div className="overflow-x-auto">
              <table className="w-full text-left">
                <thead className="bg-slate-50 border-b border-slate-100">
                  <tr>
                    <th className="px-6 py-4 w-12 text-center">
                      <button 
                        onClick={toggleSelectAll}
                        className="text-emerald-600 hover:text-emerald-700"
                        title="全選/取消全選"
                      >
                        {selectedCodes.size === filteredStocks.length && filteredStocks.length > 0 
                          ? <CheckSquare className="w-5 h-5" /> 
                          : <Square className="w-5 h-5" />}
                      </button>
                    </th>
                    <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">個股資料</th>
                    <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">最新收盤</th>
                    <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">漲跌幅度</th>
                    <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider">成交量 (張)</th>
                    <th className="px-6 py-4 text-xs font-bold text-slate-400 uppercase tracking-wider text-right">成交值 (百萬)</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {loading ? (
                    <tr>
                      <td colSpan={6} className="py-20 text-center text-slate-400">
                        <Loader2 className="w-8 h-8 animate-spin mx-auto mb-4" />
                        正在讀取股市數據...
                      </td>
                    </tr>
                  ) : filteredStocks.map(stock => (
                    <tr 
                      key={stock.code} 
                      onClick={() => toggleSelect(stock.code)}
                      className={`group cursor-pointer transition-colors ${selectedCodes.has(stock.code) ? 'bg-emerald-50/30' : 'hover:bg-slate-50'}`}
                    >
                      <td className="px-6 py-4 text-center">
                        <div className={selectedCodes.has(stock.code) ? 'text-emerald-600' : 'text-slate-300 group-hover:text-slate-400'}>
                          {selectedCodes.has(stock.code) ? <CheckSquare className="w-5 h-5" /> : <Square className="w-5 h-5" />}
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-lg bg-slate-100 flex items-center justify-center font-bold text-slate-500 text-xs">
                            {stock.code.substring(0, 2)}
                          </div>
                          <div>
                            <div className="font-bold text-slate-900">{stock.code}</div>
                            <div className="text-xs text-slate-500">{stock.name}</div>
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span className="font-mono font-bold text-slate-800">{stock.close.toLocaleString()}</span>
                      </td>
                      <td className="px-6 py-4">
                        <div className={`flex items-center gap-1 font-bold ${stock.change >= 0 ? 'text-rose-600' : 'text-emerald-600'}`}>
                          {stock.change >= 0 ? <TrendingUp className="w-4 h-4" /> : <TrendingDown className="w-4 h-4" />}
                          {Math.abs(stock.changePercent).toFixed(2)}%
                        </div>
                      </td>
                      <td className="px-6 py-4 text-slate-600 text-sm font-medium">
                        {(stock.volume / 1000).toLocaleString()}
                      </td>
                      <td className="px-6 py-4 text-right">
                        <span className="text-sm font-bold text-slate-700">
                          {(stock.totalAmount / 1000000).toFixed(0)}
                        </span>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            {!loading && filteredStocks.length === 0 && (
              <div className="py-20 text-center">
                <div className="bg-slate-100 w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-4">
                  <Search className="w-8 h-8 text-slate-300" />
                </div>
                <h3 className="text-slate-800 font-bold">找不到相符的股票</h3>
                <p className="text-slate-500 text-sm mt-1">請嘗試更換日期或搜尋代碼</p>
              </div>
            )}
          </div>
        </section>

      </main>

      <footer className="bg-white border-t border-slate-200 mt-20">
        <div className="max-w-7xl mx-auto px-6 py-12 flex flex-col md:flex-row justify-between items-center gap-6">
          <div className="flex items-center gap-2">
            <div className="bg-slate-900 p-1.5 rounded-lg">
              <TrendingUp className="w-4 h-4 text-white" />
            </div>
            <span className="font-bold text-slate-900">StockPulse TW</span>
          </div>
          <p className="text-slate-400 text-xs">
            © 2024 Taiwan Stock Insights Pro. 數據僅供學術參考，不構成投資建議。
          </p>
        </div>
      </footer>
    </div>
  );
};

export default App;
