import React from 'react';
import { Bell, ChevronDown } from 'lucide-react';

// Header Component
const Header = () => (
  <header className="bg-white border-b px-6 py-4 flex items-center justify-between">
    <div className="flex items-center gap-2">
      <div className="w-10 h-10 bg-gray-800 rounded"></div>
      <div>
        <div className="font-bold">LOGO</div>
        <div className="text-sm text-gray-600">Finance</div>
      </div>
    </div>
    <div className="flex items-center gap-6">
      <button className="text-gray-700 hover:text-gray-900">Saved List</button>
      <button className="flex items-center gap-1 text-gray-700 hover:text-gray-900">
        More <ChevronDown size={16} />
      </button>
      <Bell size={20} className="text-gray-700 cursor-pointer" />
      <div className="w-8 h-8 bg-gray-300 rounded-full flex items-center justify-center">
        J
      </div>
    </div>
  </header>
);

// Stock Overview Component
const StockOverview = () => (
  <div className="bg-white rounded-lg p-6 shadow-sm">
    <h1 className="text-2xl font-bold mb-4">台湾股票</h1>
    <div className="flex items-baseline gap-4 mb-4">
      <span className="text-4xl font-bold">25,820.54</span>
      <span className="text-green-600 flex items-center gap-1">
        ↑ 0.94%
      </span>
      <span className="text-green-600">+240.22</span>
    </div>
    <div className="flex gap-2 mb-4">
      {['1D', '5D', '1M', '6M', 'YTD', '1Y', '5Y', 'MAX'].map(period => (
        <button
          key={period}
          className={`px-3 py-1 rounded ${
            period === '1D' ? 'bg-blue-50 text-blue-600 font-medium' : 'text-gray-600 hover:bg-gray-50'
          }`}
        >
          {period}
        </button>
      ))}
    </div>
    <div className="h-64 bg-linear-to-b from-green-50 to-white rounded relative">
      <svg viewBox="0 0 400 200" className="w-full h-full">
        <polyline
          points="0,150 50,120 100,130 150,110 200,115 250,100 300,105 350,90 400,95"
          fill="none"
          stroke="#22c55e"
          strokeWidth="2"
        />
      </svg>
      <div className="absolute bottom-4 right-4 text-sm text-gray-500">
        <div>Prev close</div>
        <div className="font-medium">25,580.32</div>
      </div>
    </div>
  </div>
);

// Stock Card Component
const StockCard = ({ name, code, price, changePercent, trend, color }) => (
  <div className="bg-white rounded-lg p-4 shadow-sm">
    <div className="flex items-center gap-2 mb-2">
      <div className={`w-10 h-10 ${color} rounded flex items-center justify-center text-white font-bold`}>
        {code}
      </div>
      <div>
        <div className="font-medium">{name}</div>
        <div className="text-xs text-gray-500">{code}</div>
      </div>
    </div>
    <div className="flex items-baseline gap-2 mb-2">
      <span className="text-2xl font-bold">{price}</span>
      <span className="text-sm text-gray-600">TWD</span>
    </div>
    <div className={`text-sm ${changePercent >= 0 ? 'text-green-600' : 'text-red-600'}`}>
      {changePercent >= 0 ? '+' : ''}{changePercent}%
    </div>
    <div className="h-16 mt-2">
      <svg viewBox="0 0 100 40" className="w-full h-full">
        <polyline
          points={trend}
          fill="none"
          stroke={changePercent >= 0 ? '#22c55e' : '#ef4444'}
          strokeWidth="2"
        />
      </svg>
    </div>
  </div>
);

// News Section Component
const NewsSection = () => {
  const news = [
    { title: '正大航運重新上市 股價飆升', time: '09:48' },
    { title: '日本新幹線列車運行異常 旅客受影響', time: '09:45' },
    { title: '電子零組件需求強勁 台股小漲', time: '09:37' },
    { title: '房地產市場升溫 新屋開工量增加', time: '09:30' },
  ];

  return (
    <div className="bg-white rounded-lg p-4 shadow-sm">
      <div className="flex items-center justify-between mb-4">
        <h3 className="font-bold">新闻</h3>
        <button className="text-blue-600 text-sm">更多</button>
      </div>
      <div className="space-y-3">
        {news.map((item, index) => (
          <div key={index} className="flex justify-between items-start text-sm">
            <span className="text-gray-700 flex-1">{item.title}</span>
            <span className="text-gray-400 text-xs ml-2">{item.time}</span>
          </div>
        ))}
      </div>
    </div>
  );
};

// Exchange Rates Component
const ExchangeRates = () => {
  const rates = [
    { name: '美元/人民币...', rate: '4.7858', change: '0.44%', positive: true },
    { name: '澳元人民币中...', rate: '4.6761', change: '0.31%', positive: true },
    { name: '人民币港元...', rate: '1.4051', change: '0.29%', positive: true },
    { name: '人民币澳元...', rate: '1.3252', change: '0.22%', positive: true },
  ];

  return (
    <div className="bg-white rounded-lg p-4 shadow-sm">
      <div className="flex items-center justify-between mb-4">
        <h3 className="font-bold">外汇行情</h3>
        <button className="text-blue-600 text-sm">更多</button>
      </div>
      <div className="space-y-3">
        {rates.map((item, index) => (
          <div key={index} className="flex justify-between items-center text-sm">
            <span className="text-gray-700">{item.name}</span>
            <div className="flex gap-4 items-center">
              <span className="font-medium">{item.rate}</span>
              <span className={item.positive ? 'text-green-600' : 'text-red-600'}>
                {item.change}
              </span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

// Main Landing Page
const LandingPage = () => {
  const stockCards = [
    { name: '台积电', code: 'tsmc', price: '1,305', change: '+0.38%', changePercent: 0.38, trend: '0,30 20,25 40,28 60,20 80,22 100,15', color: 'bg-red-600' },
    { name: '鸿海', code: 'HH', price: '216.0', change: '-1.59%', changePercent: -1.59, trend: '0,10 20,15 40,12 60,20 80,25 100,30', color: 'bg-red-600' },
    { name: '富邦金', code: 'FH', price: '88.3', change: '+2.08%', changePercent: 2.08, trend: '0,30 20,28 40,25 60,20 80,15 100,10', color: 'bg-teal-600' },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      <Header />
      <main className="max-w-7xl mx-auto p-6">
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
          <div className="lg:col-span-2">
            <StockOverview />
          </div>
          <div className="space-y-6">
            <NewsSection />
            <ExchangeRates />
          </div>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
          {stockCards.map((stock, index) => (
            <StockCard key={index} {...stock} />
          ))}
        </div>

        <div className="bg-white rounded-lg p-6 shadow-sm">
          <h3 className="font-bold mb-4">行业表现 ›</h3>
          <div className="text-sm text-gray-500 text-center py-8">
            行业表现数据表格区域
          </div>
        </div>
      </main>
    </div>
  );
};

export default LandingPage;