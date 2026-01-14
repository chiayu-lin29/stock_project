import { NewsArticle } from '../types';

const API_URL = import.meta.env.VITE_API_URL || '/api';

export async function fetchMarketNews(): Promise<NewsArticle[]> {
  try {
    const url = `${API_URL}/news`;
    
    console.log('Fetching news from:', url);
    
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
    console.error('Error fetching news:', error);
    return [];
  }
}
