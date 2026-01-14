import { StockData } from '../types';

const API_URL = import.meta.env.VITE_API_URL || '/api';

interface FetchStocksParams {
  date?: string;
  code?: string;
}

export async function fetchStocks(params: FetchStocksParams = {}): Promise<StockData[]> {
  try {
    const queryParams = new URLSearchParams();
    if (params.date) queryParams.append('date', params.date);
    if (params.code) queryParams.append('code', params.code);

    const url = `${API_URL}/stocks${queryParams.toString() ? `?${queryParams.toString()}` : ''}`;
    
    console.log('Fetching stocks from:', url);
    
    const response = await fetch(url, {
      method: 'GET',
      headers: {
        'Content-Type': 'application/json',
      },
    });
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const data = await response.json();
    
    if (!Array.isArray(data)) {
      console.error('Expected array but got:', typeof data);
      return [];
    }
    
    return data;
  } catch (error) {
    console.error('Error fetching stocks:', error);
    return [];
  }
}

export function downloadAsCSV(stocks: StockData[]) {
  if (stocks.length === 0) {
    alert('請先勾選想要下載的股票');
    return;
  }

  const headers = [
    '日期',
    '股票代碼',
    '股票名稱',
    '開盤價',
    '最高價',
    '最低價',
    '收盤價',
    '成交量(股)',
    '成交金額(元)',
    '漲跌',
    '漲跌幅(%)'
  ];

  const rows = stocks.map(stock => [
    stock.date || new Date().toISOString().split('T')[0],
    stock.code,
    stock.name,
    stock.open.toFixed(2),
    stock.high.toFixed(2),
    stock.low.toFixed(2),
    stock.close.toFixed(2),
    stock.volume,
    stock.totalAmount.toFixed(2),
    stock.change.toFixed(2),
    stock.changePercent.toFixed(2)
  ]);

  const csvContent = [
    headers.join(','),
    ...rows.map(row => row.join(','))
  ].join('\n');

  const BOM = '\uFEFF';
  const blob = new Blob([BOM + csvContent], { type: 'text/csv;charset=utf-8;' });
  
  const link = document.createElement('a');
  const url = URL.createObjectURL(blob);
  
  const fileName = `台股資料_${new Date().toISOString().split('T')[0]}.csv`;
  link.setAttribute('href', url);
  link.setAttribute('download', fileName);
  link.style.visibility = 'hidden';
  
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  
  URL.revokeObjectURL(url);
}
