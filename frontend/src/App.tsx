import React, { useState, useEffect, useMemo } from 'react';
import { 
  TrendingUp, 
  TrendingDown, 
  Globe, 
  Flag, 
  RefreshCcw, 
  BarChart3, 
  Search,
  ChevronRight,
  Calendar,
  // Filter,
  Download,
  CheckSquare,
  Zap,
  LayoutGrid,
  // Square,
  Loader2
} from 'lucide-react';
import { StockData, NewsArticle } from './types';
import { fetchStocks, downloadAsCSV } from './services/stockService';
import { fetchMarketNews } from './services/newsService';

const App: React.FC = () => {
  const [stocks, setStocks] = useState<StockData[]>([]);
  const [news, setNews] = useState<NewsArticle[]>([]);
  const [loading, setLoading] = useState(true);
  const [selectedStocks, setSelectedStocks] = useState<Set<string>>(new Set());
  const [searchCode, setSearchCode] = useState('');
  const [selectedDate, setSelectedDate] = useState(new Date().toISOString().split('T')[0]);
  const [activeNewsTab, setActiveNewsTab] = useState<'Taiwan' | 'International'>('Taiwan');

  useEffect(() => {
    const loadData = async () => {
      setLoading(true);
      try {
        const [stockData, newsData] = await Promise.all([
          fetchStocks({ date: selectedDate }),
          fetchMarketNews()
        ]);
        setStocks(stockData);
        setNews(newsData);
        setSelectedStocks(new Set());
      } catch (error) {
        console.error("Error loading data:", error);
      } finally {
        setLoading(false);
      }
    };
    loadData();
  }, [selectedDate]);

  const filteredStocks = useMemo(() => {
    return stocks.filter(s => 
      s.code.includes(searchCode) || s.name.includes(searchCode)
    );
  }, [stocks, searchCode]);

  // 按分类过滤新闻
  const taiwanNews = useMemo(() => news.slice(0, 4), [news]);
  const internationalNews = useMemo(() => news.slice(4, 8), [news]);
  const filteredNews = activeNewsTab === 'Taiwan' ? taiwanNews : internationalNews;

  const allStockIds = useMemo(() => filteredStocks.map(s => s.code), [filteredStocks]);
  const isAllSelected = selectedStocks.size === allStockIds.length && allStockIds.length > 0;

  const toggleStockSelection = (code: string, e?: React.MouseEvent) => {
    if (e) e.stopPropagation();
    const next = new Set(selectedStocks);
    if (next.has(code)) next.delete(code);
    else next.add(code);
    setSelectedStocks(next);
  };

  const handleSelectAll = () => {
    if (isAllSelected) {
      setSelectedStocks(new Set());
    } else {
      setSelectedStocks(new Set(allStockIds));
    }
  };

  const handleDownload = () => {
    const toDownload = filteredStocks.filter(s => selectedStocks.has(s.code));
    if (toDownload.length === 0) {
      alert('請先勾選想要下載的股票');
      return;
    }
    downloadAsCSV(toDownload);
  };

  const todayStr = new Date().toLocaleDateString('zh-TW', { 
    year: 'numeric', 
    month: 'long', 
    day: 'numeric' 
  });

  return (
    <div className="min-h-screen pb-20 selection:bg-emerald-900 selection:text-emerald-100 relative">
      {/* Background */}
      <div className="fixed top-0 left-0 w-full h-full -z-10 overflow-hidden pointer-events-none">
        <div className="absolute top-[5%] left-[10%] w-[40%] h-[40%] bg-emerald-500/5 blur-[120px] rounded-full"></div>
        <div className="absolute bottom-[10%] right-[10%] w-[35%] h-[35%] bg-blue-500/5 blur-[120px] rounded-full"></div>
      </div>

      {/* Header */}
      <header className="sticky top-0 z-50 glass-jelly px-8 py-5 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <div className="gradient-elite p-2 rounded-2xl shadow-lg shadow-emerald-500/10">
            <Zap className="text-slate-900 w-4 h-4 fill-slate-900" />
          </div>
          <span className="text-lg font-medium tracking-tight text-white/90">
            TRADE<span className="text-emerald-400 font-light">HUB</span> 
            <span className="text-[10px] font-medium border border-emerald-500/30 text-emerald-400 px-2 py-0.5 rounded ml-2 tracking-[0.2em]">ELITE</span>
          </span>
        </div>
        
        <div className="flex items-center gap-6">
          <div className="flex items-center bg-white/5 border border-white/10 rounded-2xl px-4 py-2">
            <Search className="w-4 h-4 text-slate-500 mr-2" />
            <input 
              type="text" 
              placeholder="搜尋標的、代碼..." 
              className="bg-transparent text-sm outline-none text-slate-300 w-48 placeholder:text-slate-600 font-light"
              value={searchCode}
              onChange={(e) => setSearchCode(e.target.value)}
            />
          </div>
          <button 
            onClick={() => window.location.reload()}
            className="p-2 text-slate-500 hover:text-emerald-400 transition-colors"
          >
            <RefreshCcw className="w-5 h-5" />
          </button>
        </div>
      </header>

      <main className="max-w-6xl mx-auto px-6 pt-16 space-y-24">
        {/* Hero */}
        <section className="relative grid md:grid-cols-5 gap-16 items-center">
          <div className="md:col-span-3 space-y-8">
            <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 text-[11px] font-medium tracking-widest uppercase">
              <Calendar className="w-3.5 h-3.5" /> {todayStr} TERMINAL ONLINE
            </div>
            <h1 className="text-5xl md:text-6xl font-light leading-tight tracking-tight text-white/95">
              台股瞬覽 <span className="font-normal text-white/50">&</span> <br />
              <span className="text-gradient-neon italic font-medium">精密決策終端</span>
            </h1>
            <p className="text-slate-400 max-w-md leading-relaxed text-lg font-light">
              為台灣投資者打造的極速市場透視窗。整合即時行情分析與一鍵報告導出功能，助您在瞬息萬變的資本市場中準確掌握獲利先機。
            </p>
          </div>
          
          <div className="md:col-span-2 relative">
            <div className="jelly-card rounded-[40px] p-10 flex flex-col gap-10">
              <div className="space-y-4">
                <div className="text-[11px] font-medium text-slate-500 tracking-[0.3em] uppercase">
                  即時監控
                </div>
                <div className="text-5xl font-light text-white tracking-tighter">
                  {stocks.length}
                </div>
                <div className="flex items-center gap-2 text-emerald-400 font-medium text-sm">
                  <BarChart3 className="w-4 h-4" /> 支股票 
                  <span className="text-slate-600 font-light ml-2">實時更新</span>
                </div>
              </div>
            </div>
          </div>
        </section>

        {/* News */}
        <section className="space-y-10">
          <div className="flex flex-col md:flex-row md:items-end justify-between gap-6 border-b border-white/5 pb-10">
            <div className="space-y-3">
              <div className="flex items-center gap-3">
                <LayoutGrid className="text-emerald-400 w-5 h-5" />
                <h2 className="text-3xl font-light tracking-tight text-white/90">焦點即時新聞</h2>
              </div>
              <p className="text-slate-500 text-sm font-light tracking-wide">
                分類追蹤全球核心媒體之財經動向。
              </p>
            </div>
            
            <div className="flex bg-white/5 p-1 rounded-2xl border border-white/10">
              <button 
                onClick={() => setActiveNewsTab('Taiwan')}
                className={`flex items-center gap-2 px-8 py-2.5 rounded-xl text-xs font-medium transition-all tracking-widest ${
                  activeNewsTab === 'Taiwan' 
                  ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20' 
                  : 'text-slate-500 hover:text-slate-300'
                }`}
              >
                <Flag className="w-3.5 h-3.5" /> 台灣市場
              </button>
              <button 
                onClick={() => setActiveNewsTab('International')}
                className={`flex items-center gap-2 px-8 py-2.5 rounded-xl text-xs font-medium transition-all tracking-widest ${
                  activeNewsTab === 'International' 
                  ? 'bg-emerald-500/10 text-emerald-400 border border-emerald-500/20' 
                  : 'text-slate-500 hover:text-slate-300'
                }`}
              >
                <Globe className="w-3.5 h-3.5" /> 國際焦點
              </button>
            </div>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-8">
            {filteredNews.length > 0 ? filteredNews.map(article => (
              <a 
                key={article.id} 
                href={article.url}
                target="_blank"
                rel="noopener noreferrer"
                className="jelly-card p-8 rounded-[32px] group flex flex-col justify-between h-full"
              >
                <div className="space-y-6">
                  <div className="flex items-center justify-between">
                    <span className="text-[10px] font-medium text-emerald-400 bg-emerald-500/10 px-3 py-1 rounded-lg uppercase tracking-widest border border-emerald-500/20">
                      {article.category}
                    </span>
                    <span className="text-[10px] text-slate-500 font-medium">
                      {article.publishedAt}
                    </span>
                  </div>
                  <h4 className="font-normal text-slate-200 text-lg leading-relaxed group-hover:text-emerald-400 transition-colors">
                    {article.title}
                  </h4>
                </div>
                <div className="flex items-center justify-between pt-8 mt-4 border-t border-white/5">
                  <span className="text-[11px] text-slate-500 font-medium tracking-wide">
                    {article.source}
                  </span>
                  <div className="p-2 bg-white/5 rounded-full group-hover:bg-emerald-500 group-hover:text-slate-900 transition-all text-slate-500">
                    <ChevronRight className="w-4 h-4" />
                  </div>
                </div>
              </a>
            )) : (
              <div className="col-span-3 text-center py-10 text-slate-500">
                暫無新聞數據
              </div>
            )}
          </div>
        </section>

        {/* Stocks */}
        <section className="space-y-10">
          <div className="flex flex-col md:flex-row md:items-end justify-between gap-6">
            <div className="space-y-3">
              <div className="flex items-center gap-3">
                <BarChart3 className="text-cyan-400 w-5 h-5" />
                <h2 className="text-3xl font-light tracking-tight text-white/90">個股行情監控</h2>
              </div>
              <p className="text-slate-500 text-sm font-light tracking-wide">
                深度穿透數據，實時反應資本市場水位。
              </p>
            </div>
            <div className="flex items-center gap-3">
              <div className="bg-white/5 border border-white/10 px-6 py-2.5 rounded-2xl text-[11px] font-medium text-slate-500 tracking-[0.2em]">
                MONITORING: <span className="text-emerald-400">{selectedStocks.size}</span> UNITS
              </div>
              <button 
                onClick={handleDownload}
                disabled={selectedStocks.size === 0}
                className={`px-7 py-2.5 rounded-2xl text-[11px] font-medium tracking-widest flex items-center gap-2 transition-all shadow-lg uppercase ${
                  selectedStocks.size > 0
                  ? 'bg-emerald-500/90 text-slate-900 hover:bg-emerald-400'
                  : 'bg-slate-800 text-slate-600 cursor-not-allowed'
                }`}
              >
                <Download className="w-3.5 h-3.5" /> 導出報表
              </button>
            </div>
          </div>

          <div className="jelly-card rounded-[40px] overflow-hidden border-white/5">
            <div className="p-8 border-b border-white/5 flex items-center justify-between bg-white/5">
              <div className="flex items-center gap-3 bg-white/5 border border-white/10 px-5 py-3 rounded-2xl">
                <Calendar className="w-4 h-4 text-slate-600" />
                <input 
                  type="date" 
                  value={selectedDate}
                  onChange={(e) => setSelectedDate(e.target.value)}
                  className="bg-transparent text-xs font-medium text-slate-300 outline-none"
                />
              </div>
            </div>

            <div className="overflow-x-auto">
              <table className="w-full text-left border-collapse">
                <thead>
                  <tr className="border-b border-white/10 text-[11px] font-medium text-slate-300 uppercase tracking-[0.2em] bg-slate-900/60">
                    <th className="px-10 py-6 w-24">
                      <button 
                        onClick={handleSelectAll}
                        className="flex items-center gap-3 hover:text-emerald-400"
                      >
                        {isAllSelected ? (
                          <CheckSquare className="w-5 h-5 text-emerald-400 fill-emerald-400/10" />
                        ) : (
                          <div className="w-5 h-5 border-[1.5px] rounded-lg border-slate-600" />
                        )}
                        <span className="whitespace-nowrap font-semibold">全選</span>
                      </button>
                    </th>
                    <th className="px-10 py-6 font-semibold">資產標的</th>
                    <th className="px-10 py-6 text-right font-semibold">即時成交價</th>
                    <th className="px-10 py-6 text-right font-semibold">漲跌動能</th>
                    <th className="px-10 py-6 text-right font-semibold">量能</th>
                    <th className="px-10 py-6 text-right font-semibold">市值流動</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-white/5">
                  {loading ? (
                    <tr>
                      <td colSpan={6} className="py-20 text-center">
                        <Loader2 className="w-8 h-8 animate-spin mx-auto text-emerald-400" />
                        <p className="mt-4 text-slate-500">載入中...</p>
                      </td>
                    </tr>
                  ) : filteredStocks.length > 0 ? filteredStocks.map(stock => (
                    <tr 
                      key={stock.code} 
                      className={`group cursor-pointer transition-all ${
                        selectedStocks.has(stock.code) ? 'bg-emerald-500/5' : 'hover:bg-white/5'
                      }`}
                      onClick={() => toggleStockSelection(stock.code)}
                    >
                      <td className="px-10 py-7 text-center">
                        <div className="flex justify-center" onClick={(e) => toggleStockSelection(stock.code, e)}>
                          {selectedStocks.has(stock.code) ? (
                            <CheckSquare className="w-5 h-5 text-emerald-400 fill-emerald-400/10" />
                          ) : (
                            <div className="w-5 h-5 border-[1.5px] border-slate-700 rounded-lg group-hover:border-emerald-500/30 transition-all" />
                          )}
                        </div>
                      </td>
                      <td className="px-10 py-7">
                        <div className="flex items-center gap-5">
                          <div className="w-10 h-10 rounded-2xl bg-white/5 flex items-center justify-center font-mono text-[10px] text-slate-500 group-hover:bg-emerald-500/10 group-hover:text-emerald-400 transition-all">
                            {stock.code.substring(0, 2)}
                          </div>
                          <div>
                            <div className="text-lg font-light text-white/90 tracking-tight">
                              {stock.code}
                            </div>
                            <div className="text-[10px] text-slate-500 font-medium mt-0.5 tracking-widest">
                              {stock.name}
                            </div>
                          </div>
                        </div>
                      </td>
                      <td className="px-10 py-7 text-right">
                        <span className="text-2xl font-light text-white font-mono tracking-tighter">
                          {stock.close.toLocaleString()}
                        </span>
                      </td>
                      <td className="px-10 py-7 text-right">
                        <div className={`inline-flex items-center gap-1.5 px-3 py-1.5 rounded-xl text-[12px] font-medium ${
                          stock.changePercent >= 0 
                          ? 'text-emerald-400 bg-emerald-500/10' 
                          : 'text-rose-400 bg-rose-500/10'
                        }`}>
                          {stock.changePercent >= 0 ? (
                            <TrendingUp className="w-3.5 h-3.5" />
                          ) : (
                            <TrendingDown className="w-3.5 h-3.5" />
                          )}
                          {stock.changePercent >= 0 ? '+' : ''}{stock.changePercent.toFixed(2)}%
                        </div>
                      </td>
                      <td className="px-10 py-7 text-right text-slate-500 font-light font-mono text-sm">
                        {(stock.volume / 1000).toLocaleString()}
                      </td>
                      <td className="px-10 py-7 text-right font-medium text-white/80 font-mono">
                        {(stock.totalAmount / 1000000).toFixed(0)}
                      </td>
                    </tr>
                  )) : (
                    <tr>
                      <td colSpan={6} className="py-20 text-center text-slate-500">
                        暫無數據
                      </td>
                    </tr>
                  )}
                </tbody>
              </table>
            </div>
          </div>
        </section>
      </main>

      <footer className="max-w-6xl mx-auto px-6 py-24 mt-12 border-t border-white/5">
        <div className="text-center space-y-8">
          <div className="flex items-center justify-center gap-3 opacity-40">
             <div className="bg-white/5 p-2 rounded-2xl">
               <Zap className="text-emerald-400 w-5 h-5 fill-emerald-400" />
             </div>
             <span className="text-lg font-medium tracking-[0.2em] text-white">TRADE HUB ELITE</span>
          </div>
          <p className="text-slate-500 text-sm max-w-lg mx-auto leading-relaxed font-light">
            為卓越決策者打造的金融解析終端。數據僅供學術參考，不構成投資建議。
          </p>
        </div>
      </footer>
    </div>
  );
};

export default App;
