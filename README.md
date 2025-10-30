# 📈 Stock Analysis Platform - 台湾股票分析平台

一个功能完整的台湾股票分析与投资管理平台，提供自选股管理、财务分析、智能筛选等功能，帮助投资者做出更明智的投资决策。

## 项目截图

![Landing Page](src/assets/LandingPage.png)
![Main Page](./docs/screenshot-main.png) _(开发中)_

## 项目愿景

本平台旨在为个人投资者提供专业级的股票分析工具，涵盖基本面分析、技术面指标、股息追踪、智能筛选等功能，让投资决策更加数据驱动。

## 核心功能

### 📍 已完成 (Landing Page)
- ✅ 台湾股市大盘即时行情展示
- ✅ 热门个股信息（台积电、鸿海、富邦金等）
- ✅ 股票走势图表可视化
- ✅ 财经新闻实时更新
- ✅ 外汇汇率信息展示
- ✅ 行业表现概览

### 开发中 (Main Page)

#### 1. 用户登入与自选股管理
- 用户注册与登入系统
- 自选股票清单（新增、删除、编辑）
- 自选股自动保存，下次登入自动载入
- 购买日期记录功能（支持 1994 年至今的历史数据）

#### 2. 每日股价数据下载
- 一键下载自选股每日成交资讯
- 导出格式：Excel (.xlsx)
- 包含数据：收盘价、涨跌幅、成交量、日期等

#### 3. EPS 公告智能提醒
- 自选股 EPS 公告弹窗提醒
- 股利发放通知
- 财报更新提示

#### 4. 股票深度分析
**基本面分析**
- EPS 成长率（季度 YoY / 年度 YoY）
- 殖利率计算
  - 以最新股价自动计算
  - 可输入个人成本价计算实际殖利率
- 配息率、配股率（近 3 年趋势图）

**技术面分析**
- 均线趋势分析（5日、10日、20日、60日、120日）
- RSI 相对强弱指标
- 52 周高低价位阶分析
- MACD、KD 指标（规划中）

#### 5. 智能股票筛选器 (Preference Filter)

**多层级筛选系统**
```
Default → 按股票代号 (ID)
  └─ Layer 1: 产业分类
       ├─ 半导体
       ├─ 金融保险
       ├─ 传统产业
       ├─ 绿能科技
       └─ ...
           └─ Layer 2: 殖利率筛选
```

**基本面筛选**
- EPS 成长率 > X%
- 殖利率 > Y%
- 市值区间
- 本益比 (P/E Ratio)
- 股价净值比 (P/B Ratio)

**技术面筛选**
- 均线排列（多头/空头）
- RSI 数值区间
- 成交量异常
- 突破新高/新低

**投资风格快速筛选**
- 成长型：高 EPS 成长率、产业前景佳
- 股息型：高殖利率、配息稳定
- 防禦型：低波动、产业稳定
- ⚡ 动能型：技术面强势、成交量放大

#### 6. Watch List / My List
- 多个自定义清单（如：核心持股、观察名单、长期投资）
- 清单间拖拽管理
- 清单分享功能（规划中）

#### 7. 相关新闻专区
- 个股相关新闻快报
- 产业新闻汇整
- 关键字智能抓取（规划中）

## 技术栈

### Frontend
- **框架**: React 19.1.1
- **构建工具**: Vite 7.1.7
- **样式**: Tailwind CSS 3.4.18
- **路由**: React Router DOM 7.9.5
- **图表**: Recharts 3.3.0
- **图标**: Lucide React 0.548.0
- **HTTP 客户端**: Axios 1.13.1

### Backend
- **框架**: （待补充）
- **数据库**: （待补充）
- **API**: RESTful / GraphQL

### 数据来源
- 历史股价数据：1994 年至今
- 即时行情：台湾证券交易所
- 财报数据：公开资讯观测站

## 📦 项目结构

```
stock_project/
├── frontend/                    # 前端项目
│   ├── src/
│   │   ├── components/         # 可复用组件
│   │   │   ├── Header.jsx
│   │   │   ├── StockCard.jsx
│   │   │   ├── StockChart.jsx
│   │   │   └── FilterPanel.jsx
│   │   ├── pages/              # 页面组件
│   │   │   ├── LandingPage.jsx    # 首页（已完成）
│   │   │   ├── MainPage.jsx       # 主页面（开发中）
│   │   │   ├── StockDetail.jsx    # 个股详情
│   │   │   └── WatchList.jsx      # 自选股清单
│   │   ├── services/           # API 服务
│   │   │   └── stockApi.js
│   │   ├── utils/              # 工具函数
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── public/
│   ├── package.json
│   └── vite.config.js
├── backend/                     # 后端项目
│   ├── api/                    # API 路由
│   ├── models/                 # 数据模型
│   ├── services/               # 业务逻辑
│   └── database/               # 数据库配置
├── docs/                       # 文档与截图
└── README.md
```

## 🚀 快速开始

### 前置要求

- Node.js 18+ 
- npm 或 yarn
- Git

### 安装步骤

1. **克隆仓库**

```bash
git clone https://github.com/chiayu-lin29/stock_project.git
cd stock_project
```

2. **安装前端依赖**

```bash
cd frontend
npm install
```

3. **启动前端开发服务器**

```bash
npm run dev
```

前端将运行在 `http://localhost:5173`

4. **安装并启动后端**（待补充）

```bash
cd backend
# 安装依赖
npm install

# 启动后端服务器
npm start
```

后端将运行在 `http://localhost:3000`（或其他端口）

## 📝 开发指南

### Git 分支策略

```
main
├── feature/frontend      # 前端开发
├── feature/backend       # 后端开发
├── feature/data         # 数据处理
└── feature/dev          # 开发整合分支
```

### 开发流程

1. **从对应分支创建功能分支**
```bash
git checkout feature/frontend
git checkout -b feature/add-stock-filter
```

2. **开发完成后提交**
```bash
git add .
git commit -m "feat: add stock filter by industry"
git push origin feature/add-stock-filter
```

3. **创建 Pull Request**
   - 选择目标分支为对应的 feature 分支
   - 添加详细的描述和截图
   - 等待 Code Review

### Commit 规范

遵循 Conventional Commits：

- `feat:` 新功能
- `fix:` 修复 bug
- `docs:` 文档更新
- `style:` 代码格式调整
- `refactor:` 代码重构
- `test:` 测试相关
- `chore:` 构建/工具相关

示例：
```bash
git commit -m "feat: implement EPS growth rate calculation"
git commit -m "fix: correct dividend yield formula"
git commit -m "docs: update API documentation"
```

## 设计资源

- Figma 设计稿: [Landing Page 设计]（你提供的设计）
- UI/UX 参考: Google Finance, Yahoo Finance

## API 文档

### 股票数据 API（规划）

```javascript
// 获取自选股清单
GET /api/watchlist

// 新增自选股
POST /api/watchlist
Body: { stockId: "2330", purchaseDate: "2024-01-15", cost: 500 }

// 获取股票详细资讯
GET /api/stocks/:id

// 获取历史股价（支持 1994 年至今）
GET /api/stocks/:id/history?startDate=1994-01-01&endDate=2024-12-31

// 下载股价数据为 Excel
GET /api/stocks/export?ids=2330,2317,2454

// 股票筛选
POST /api/stocks/filter
Body: {
  industry: "半导体",
  minYield: 5,
  maxPE: 20,
  style: "dividend"
}
```

## 测试

```bash
# 前端测试
cd frontend
npm test

# 后端测试
cd backend
npm test
```

## 构建部署

```bash
# 前端构建
cd frontend
npm run build
# 构建产物在 frontend/dist

# 后端构建
cd backend
npm run build
```

## 🗓️ 开发路线图

### Phase 1: 基础架构 ✅
- [x] Landing Page 完成
- [x] 项目架构搭建
- [x] Tailwind CSS 配置

### Phase 2: 核心功能（进行中）
- [ ] 用户登入系统
- [ ] 自选股管理
- [ ] Main Page 开发
- [ ] 股票详情页面

### Phase 3: 数据分析
- [ ] EPS 成长率计算
- [ ] 殖利率分析
- [ ] 技术指标实现
- [ ] 历史数据整合（1994-现在）

### Phase 4: 智能筛选
- [ ] 多层级筛选器
- [ ] 投资风格快速筛选
- [ ] 筛选结果保存

### Phase 5: 进阶功能
- [ ] EPS 公告提醒系统
- [ ] Excel 数据导出
- [ ] 新闻专区
- [ ] 移动端优化

## 👥 团队成员

- **前端开发**: Zhuowen Chen
- **后端开发**: Chiayu Lin/Zhuowen Chen
- **数据分析**: Chiaye Lin
- **UI/UX 设计**: Zhuowen Chen

---

**最后更新**: 2025-10-30  
**当前版本**: v0.1.0 (Landing Page)  
**下一里程碑**: Main Page 开发