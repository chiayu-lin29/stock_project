--
-- PostgreSQL database dump
--

\restrict RIjK4itigIohilcHdTouHWYinUvLtgT6s15i50EUQYiSH6Yj7SGiBf0tyUMceCM

-- Dumped from database version 16.11 (Debian 16.11-1.pgdg13+1)
-- Dumped by pg_dump version 17.6

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: api_log; Type: TABLE; Schema: public; Owner: stock_db
--

CREATE TABLE public.api_log (
    id integer NOT NULL,
    source character varying(50) NOT NULL,
    "timestamp" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20),
    row_count integer,
    remarks text
);


ALTER TABLE public.api_log OWNER TO stock_db;

--
-- Name: api_log_id_seq; Type: SEQUENCE; Schema: public; Owner: stock_db
--

CREATE SEQUENCE public.api_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.api_log_id_seq OWNER TO stock_db;

--
-- Name: api_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: stock_db
--

ALTER SEQUENCE public.api_log_id_seq OWNED BY public.api_log.id;


--
-- Name: eps_quarter; Type: TABLE; Schema: public; Owner: stock_db
--

CREATE TABLE public.eps_quarter (
    stock_id character varying(16) NOT NULL,
    period_end date NOT NULL,
    eps numeric(10,4) NOT NULL
);


ALTER TABLE public.eps_quarter OWNER TO stock_db;

--
-- Name: exchange_rate; Type: TABLE; Schema: public; Owner: stock_db
--

CREATE TABLE public.exchange_rate (
    rate_date date NOT NULL,
    currency character varying(8) NOT NULL,
    cash_buy numeric(10,4),
    cash_sell numeric(10,4),
    spot_buy numeric(10,4),
    spot_sell numeric(10,4),
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.exchange_rate OWNER TO stock_db;

--
-- Name: fin_raw; Type: TABLE; Schema: public; Owner: stock_db
--

CREATE TABLE public.fin_raw (
    stock_id character varying(16) NOT NULL,
    period_end date NOT NULL,
    freq character varying(8) NOT NULL,
    type character varying(64) NOT NULL,
    origin_name character varying(128),
    value numeric(20,6),
    source_rev integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.fin_raw OWNER TO stock_db;

--
-- Name: market_news; Type: TABLE; Schema: public; Owner: stock_db
--

CREATE TABLE public.market_news (
    news_id bigint NOT NULL,
    stock_id character varying(16),
    published_at timestamp without time zone NOT NULL,
    title text NOT NULL,
    url text NOT NULL,
    source character varying(128),
    created_at timestamp without time zone DEFAULT now(),
    market character varying(8) DEFAULT 'TW'::character varying NOT NULL,
    symbol_type character varying(16) DEFAULT 'equity'::character varying,
    language character varying(8) DEFAULT 'zh'::character varying,
    stock_id_norm character varying(64) GENERATED ALWAYS AS (COALESCE(stock_id, ''::character varying)) STORED,
    CONSTRAINT chk_market_news_market CHECK (((market)::text = ANY (ARRAY[('TW'::character varying)::text, ('US'::character varying)::text]))),
    CONSTRAINT chk_market_news_symbol_type CHECK (((symbol_type)::text = ANY (ARRAY[('equity'::character varying)::text, ('index'::character varying)::text, ('etf'::character varying)::text, ('other'::character varying)::text])))
);


ALTER TABLE public.market_news OWNER TO stock_db;

--
-- Name: stock_dailyprice; Type: TABLE; Schema: public; Owner: stock_db
--

CREATE TABLE public.stock_dailyprice (
    stock_id character varying(16) NOT NULL,
    trade_date date NOT NULL,
    open numeric(14,4),
    high numeric(14,4),
    low numeric(14,4),
    close numeric(14,4),
    trading_volume bigint,
    trading_money bigint,
    spread numeric(10,4),
    trading_turnover integer
);


ALTER TABLE public.stock_dailyprice OWNER TO stock_db;

--
-- Name: stock_info; Type: TABLE; Schema: public; Owner: stock_db
--

CREATE TABLE public.stock_info (
    stock_id character varying(16) NOT NULL,
    stock_name character varying(128) NOT NULL,
    industry_category character varying(64),
    list_type character varying(16),
    list_date date
);


ALTER TABLE public.stock_info OWNER TO stock_db;

--
-- Name: stock_news_news_id_seq; Type: SEQUENCE; Schema: public; Owner: stock_db
--

CREATE SEQUENCE public.stock_news_news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.stock_news_news_id_seq OWNER TO stock_db;

--
-- Name: stock_news_news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: stock_db
--

ALTER SEQUENCE public.stock_news_news_id_seq OWNED BY public.market_news.news_id;


--
-- Name: us_stock_index; Type: TABLE; Schema: public; Owner: stock_db
--

CREATE TABLE public.us_stock_index (
    index_id character varying(16) NOT NULL,
    index_name character varying(64) NOT NULL,
    trade_date date NOT NULL,
    open numeric(14,4),
    high numeric(14,4),
    low numeric(14,4),
    close numeric(14,4),
    adj_close numeric(14,4),
    volume bigint,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.us_stock_index OWNER TO stock_db;

--
-- Name: users; Type: TABLE; Schema: public; Owner: stock_db
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    email character varying(100) NOT NULL,
    password_hash character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    last_login timestamp without time zone
);


ALTER TABLE public.users OWNER TO stock_db;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: stock_db
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO stock_db;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: stock_db
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: watch_list; Type: TABLE; Schema: public; Owner: stock_db
--

CREATE TABLE public.watch_list (
    id integer NOT NULL,
    user_id integer NOT NULL,
    stock_id character varying(20) NOT NULL,
    added_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_active boolean DEFAULT true
);


ALTER TABLE public.watch_list OWNER TO stock_db;

--
-- Name: watch_list_id_seq; Type: SEQUENCE; Schema: public; Owner: stock_db
--

CREATE SEQUENCE public.watch_list_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.watch_list_id_seq OWNER TO stock_db;

--
-- Name: watch_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: stock_db
--

ALTER SEQUENCE public.watch_list_id_seq OWNED BY public.watch_list.id;


--
-- Name: api_log id; Type: DEFAULT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.api_log ALTER COLUMN id SET DEFAULT nextval('public.api_log_id_seq'::regclass);


--
-- Name: market_news news_id; Type: DEFAULT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.market_news ALTER COLUMN news_id SET DEFAULT nextval('public.stock_news_news_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: watch_list id; Type: DEFAULT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.watch_list ALTER COLUMN id SET DEFAULT nextval('public.watch_list_id_seq'::regclass);


--
-- Data for Name: api_log; Type: TABLE DATA; Schema: public; Owner: stock_db
--

COPY public.api_log (id, source, "timestamp", status, row_count, remarks) FROM stdin;
\.


--
-- Data for Name: eps_quarter; Type: TABLE DATA; Schema: public; Owner: stock_db
--

COPY public.eps_quarter (stock_id, period_end, eps) FROM stdin;
\.


--
-- Data for Name: exchange_rate; Type: TABLE DATA; Schema: public; Owner: stock_db
--

COPY public.exchange_rate (rate_date, currency, cash_buy, cash_sell, spot_buy, spot_sell, created_at) FROM stdin;
\.


--
-- Data for Name: fin_raw; Type: TABLE DATA; Schema: public; Owner: stock_db
--

COPY public.fin_raw (stock_id, period_end, freq, type, origin_name, value, source_rev) FROM stdin;
\.


--
-- Data for Name: market_news; Type: TABLE DATA; Schema: public; Owner: stock_db
--

COPY public.market_news (news_id, stock_id, published_at, title, url, source, created_at, market, symbol_type, language) FROM stdin;
\.


--
-- Data for Name: stock_dailyprice; Type: TABLE DATA; Schema: public; Owner: stock_db
--

COPY public.stock_dailyprice (stock_id, trade_date, open, high, low, close, trading_volume, trading_money, spread, trading_turnover) FROM stdin;
\.


--
-- Data for Name: stock_info; Type: TABLE DATA; Schema: public; Owner: stock_db
--

COPY public.stock_info (stock_id, stock_name, industry_category, list_type, list_date) FROM stdin;
0050	元大台灣50	ETF	twse	2025-09-30
0051	元大中型100	ETF	twse	2025-09-30
0052	富邦科技	ETF	twse	2025-09-30
0053	元大電子	ETF	twse	2025-09-30
0054	元大台商50	ETF	twse	2025-08-27
0055	元大MSCI金融	ETF	twse	2025-09-30
0056	元大高股息	ETF	twse	2025-09-30
0057	富邦摩台	ETF	twse	2025-09-30
0058	富邦發達	ETF	twse	2025-08-27
0059	富邦金融	ETF	twse	2025-08-27
0060	新台灣	ETF	twse	2024-12-04
0061	元大寶滬深	ETF	twse	2025-09-30
006201	元大富櫃50	上櫃ETF	tpex	2025-09-30
006203	元大MSCI台灣	ETF	twse	2025-09-30
006204	永豐臺灣加權	ETF	twse	2025-09-30
006205	富邦上証	ETF	twse	2025-09-30
006206	元大上證50	ETF	twse	2025-09-30
006207	復華滬深	ETF	twse	2025-09-30
006208	富邦台50	ETF	twse	2025-09-30
00625K	富邦上証+R	ETF	twse	2025-09-30
00631L	元大台灣50正2	ETF	twse	2025-09-30
00632R	元大台灣50反1	ETF	twse	2025-09-30
00633L	富邦上証正2	ETF	twse	2025-09-30
00634R	富邦上証反1	ETF	twse	2025-09-30
00635U	期元大S&P黃金	ETF	twse	2025-09-30
00636	國泰中國A50	ETF	twse	2025-09-30
00636K	國泰中國A50+U	ETF	twse	2025-09-30
00637L	元大滬深300正2	ETF	twse	2025-09-30
00638R	元大滬深300反1	ETF	twse	2025-09-30
00639	富邦深100	ETF	twse	2025-09-30
00640L	富邦日本正2	ETF	twse	2025-09-30
00641R	富邦日本反1	ETF	twse	2025-09-30
00642U	期元大S&P石油	ETF	twse	2025-09-30
00643	群益深証中小	ETF	twse	2025-09-30
00643K	群益深証中小+R	ETF	twse	2025-09-30
00645	富邦日本	ETF	twse	2025-09-30
00646	元大S&P500	ETF	twse	2025-09-30
00647L	元大S&P500正2	ETF	twse	2025-09-30
00648R	元大S&P500反1	ETF	twse	2025-09-30
00649	FH香港	ETF	twse	2025-08-27
00650L	復華香港正2	ETF	twse	2025-09-30
00651R	復華香港反1	ETF	twse	2025-09-30
00652	富邦印度	ETF	twse	2025-09-30
00653L	富邦印度正2	ETF	twse	2025-09-30
00654R	富邦印度反1	ETF	twse	2025-09-30
00655L	國泰中國A50正2	ETF	twse	2025-09-30
00656R	國泰中國A50反1	ETF	twse	2025-09-30
00657	國泰日經225	ETF	twse	2025-09-30
00657K	國泰日經225+U	ETF	twse	2025-09-30
00658L	國泰日本正2	ETF	twse	2025-08-27
00659R	國泰日本反1	ETF	twse	2025-08-27
00660	元大歐洲50	ETF	twse	2025-09-30
00661	元大日經225	ETF	twse	2025-09-30
00662	富邦NASDAQ	ETF	twse	2025-09-30
00663L	國泰臺灣加權正2	ETF	twse	2025-09-30
00664R	國泰臺灣加權反1	ETF	twse	2025-09-30
00665L	富邦恒生國企正2	ETF	twse	2025-09-30
00666R	富邦恒生國企反1	ETF	twse	2025-09-30
00667	元大韓國	ETF	twse	2025-08-27
00668	國泰美國道瓊	ETF	twse	2025-09-30
00668K	國泰美國道瓊+U	ETF	twse	2025-09-30
00669R	國泰美國道瓊反1	ETF	twse	2025-09-30
00670L	富邦NASDAQ正2	ETF	twse	2025-09-30
00671R	富邦NASDAQ反1	ETF	twse	2025-09-30
00672L	元大S&P原油正2	ETF	twse	2025-08-27
00673R	期元大S&P原油反1	ETF	twse	2025-09-30
00674R	期元大S&P黃金反1	ETF	twse	2025-09-30
00675L	富邦臺灣加權正2	ETF	twse	2025-09-30
00676R	富邦臺灣加權反1	ETF	twse	2025-09-30
00677U	期富邦VIX	ETF	twse	2025-08-27
00678	群益那斯達克生技	ETF	twse	2025-09-30
00679B	元大美債20年	上櫃ETF	tpex	2025-09-30
00680L	元大美債20正2	ETF	twse	2025-09-30
00681R	元大美債20反1	ETF	twse	2025-09-30
00682U	期元大美元指數	ETF	twse	2025-09-30
00683L	期元大美元指正2	ETF	twse	2025-09-30
00684R	期元大美元指反1	ETF	twse	2025-09-30
00685L	群益臺灣加權正2	ETF	twse	2025-09-30
00686R	群益臺灣加權反1	ETF	twse	2025-09-30
00687B	國泰20年美債	上櫃ETF	tpex	2025-09-30
00687C	國泰20年美債+櫃U	上櫃ETF	tpex	2025-09-30
00688L	國泰20年美債正2	ETF	twse	2025-09-30
00689R	國泰20年美債反1	ETF	twse	2025-09-30
00690	兆豐藍籌30	ETF	twse	2025-09-30
00691R	兆豐藍籌30反1	ETF	twse	2025-08-27
00692	富邦公司治理	ETF	twse	2025-09-30
00693U	期街口S&P黃豆	ETF	twse	2025-09-30
00694B	富邦美債1-3	上櫃ETF	tpex	2025-09-30
00695B	富邦美債7-10	上櫃ETF	tpex	2025-09-30
00696B	富邦美債20年	上櫃ETF	tpex	2025-09-30
00697B	元大美債7-10	上櫃ETF	tpex	2025-09-30
00698L	元大美債7-10正2	ETF	twse	2025-08-27
00699R	元大美債7-10反1	ETF	twse	2025-08-27
00700	富邦恒生國企	ETF	twse	2025-09-30
00701	國泰股利精選30	ETF	twse	2025-09-30
00702	國泰標普低波高息	ETF	twse	2025-09-30
00703	台新MSCI中國	ETF	twse	2025-09-30
00704L	台新MSCI台灣正2	ETF	twse	2025-08-27
00705R	台新MSCI台灣反1	ETF	twse	2025-08-27
00706L	期元大S&P日圓正2	ETF	twse	2025-09-30
00707R	期元大S&P日圓反1	ETF	twse	2025-09-30
00708L	期元大S&P黃金正2	ETF	twse	2025-09-30
00709	富邦歐洲	ETF	twse	2025-09-30
00710B	復華彭博非投等債	ETF	twse	2025-09-30
00711B	復華彭博新興債	ETF	twse	2025-09-30
00712	復華富時不動產	ETF	twse	2025-09-30
00713	元大台灣高息低波	ETF	twse	2025-09-30
00714	群益道瓊美國地產	ETF	twse	2025-09-30
00715L	期街口布蘭特正2	ETF	twse	2025-09-30
00716R	華頓S&P布蘭特反1	ETF	twse	2025-08-27
00717	富邦美國特別股	ETF	twse	2025-09-30
00718B	富邦中國政策債	上櫃ETF	tpex	2025-06-20
00719B	元大美債1-3	上櫃ETF	tpex	2025-09-30
00720B	元大投資級公司債	上櫃ETF	tpex	2025-09-30
00721B	元大中國債3-5	上櫃指數股票型基金(ETF)	tpex	2024-10-16
00722B	群益投資級電信債	上櫃ETF	tpex	2025-09-30
00723B	群益投資級科技債	上櫃ETF	tpex	2025-09-30
00724B	群益投資級金融債	上櫃ETF	tpex	2025-09-30
00725B	國泰投資級公司債	上櫃ETF	tpex	2025-09-30
00726B	國泰新興投等債	上櫃ETF	tpex	2025-09-30
00727B	國泰優選非投等債	上櫃ETF	tpex	2025-09-30
00728	第一金工業30	ETF	twse	2025-09-30
00729R	第一金工業30反1	ETF	twse	2024-12-04
00730	富邦臺灣優質高息	ETF	twse	2025-09-30
00731	復華富時高息低波	ETF	twse	2025-09-30
00732	國泰RMB短期報酬	ETF	twse	2024-12-04
00733	富邦臺灣中小	ETF	twse	2025-09-30
00734B	台新JPM新興債	上櫃ETF	tpex	2025-09-30
00735	國泰臺韓科技	ETF	twse	2025-09-30
00736	國泰新興市場	ETF	twse	2025-09-30
00737	國泰AI機器人	ETF	twse	2025-09-30
00738U	期元大道瓊白銀	ETF	twse	2025-09-30
00739	元大MSCI A股	ETF	twse	2025-09-30
00740B	富邦全球投等債	上櫃ETF	tpex	2025-09-30
00741B	富邦全球非投等債	上櫃ETF	tpex	2025-09-30
00742	新光內需收益	ETF	twse	2024-12-04
00743	國泰中國A150	ETF	twse	2024-12-04
00744B	國泰中國政金債5+	上櫃指數股票型基金(ETF)	tpex	2023-11-22
00745B	富邦中政債0-1	上櫃指數股票型基金(ETF)	tpex	2022-12-11
00746B	富邦A級公司債	上櫃ETF	tpex	2025-09-30
00747B	FH中國政策債	上櫃指數股票型基金(ETF)	tpex	2022-12-28
00748B	凱基中國債3-10	上櫃指數股票型基金(ETF)	tpex	2023-02-22
00749B	凱基新興債10+	上櫃ETF	tpex	2025-09-30
00750B	凱基科技債10+	上櫃ETF	tpex	2025-09-30
00751B	元大AAA至A公司債	上櫃ETF	tpex	2025-09-30
00752	中信中國50	ETF	twse	2025-09-30
00753L	中信中國50正2	ETF	twse	2025-09-30
00754B	群益AAA-AA公司債	上櫃ETF	tpex	2025-09-30
00755B	群益投資級公用債	上櫃ETF	tpex	2025-09-30
00756B	群益投等新興公債	上櫃ETF	tpex	2025-09-30
00757	統一FANG+	ETF	twse	2025-09-30
00758B	復華能源債	上櫃ETF	tpex	2025-09-30
00759B	復華製藥債	上櫃ETF	tpex	2025-09-30
00760B	復華新興企業債	上櫃ETF	tpex	2025-09-30
00761B	國泰A級公司債	上櫃ETF	tpex	2025-09-30
00762	元大全球AI	ETF	twse	2025-09-30
00763U	期街口道瓊銅	ETF	twse	2025-09-30
00764B	群益25年美債	上櫃ETF	tpex	2025-09-30
00765B	群益中國政金債	上櫃指數股票型基金(ETF)	tpex	2023-06-01
00766L	台新MSCI中國正2	ETF	twse	2024-12-04
00767	FH美國金融股	ETF	twse	2024-12-04
00768B	復華20年美債	上櫃ETF	tpex	2025-09-30
00770	國泰北美科技	ETF	twse	2025-09-30
00771	元大US高息特別股	ETF	twse	2025-09-30
00772B	中信高評級公司債	上櫃ETF	tpex	2025-09-30
00773B	中信優先金融債	上櫃ETF	tpex	2025-09-30
00774B	新光中國政金綠債	ETF	twse	2024-12-04
00774C	新光中政金綠債+R	ETF	twse	2024-12-04
00775B	新光投等債15+	ETF	twse	2025-09-30
00776	新光ICE美國權值	ETF	twse	2024-12-04
00777B	凱基AAA至A公司債	上櫃ETF	tpex	2025-09-30
00778B	凱基金融債20+	上櫃ETF	tpex	2025-09-30
00779B	凱基美債25+	上櫃ETF	tpex	2025-09-30
00780B	國泰A級金融債	上櫃ETF	tpex	2025-09-30
00781B	國泰A級科技債	上櫃ETF	tpex	2025-09-30
00782B	國泰A級公用債	上櫃ETF	tpex	2025-09-30
00783	富邦中証500	ETF	twse	2025-09-30
00784B	富邦中國投等債	上櫃ETF	tpex	2025-04-25
00785B	富邦金融投等債	上櫃ETF	tpex	2025-09-30
00786B	元大10年IG銀行債	上櫃ETF	tpex	2025-09-30
00787B	元大10年IG醫療債	上櫃ETF	tpex	2025-09-30
00788B	元大10年IG電能債	上櫃ETF	tpex	2025-09-30
00789B	復華公司債A3	上櫃ETF	tpex	2025-09-30
00790B	復華次順位金融債	上櫃ETF	tpex	2025-04-18
00791B	復華信用債1-5	上櫃ETF	tpex	2025-09-30
00792B	群益A級公司債	上櫃ETF	tpex	2025-09-30
00793B	群益AAA-A醫療債	上櫃ETF	tpex	2025-09-30
00794B	群益7+中國政金債	上櫃ETF	tpex	2025-08-24
00795B	中信美國公債20年	上櫃ETF	tpex	2025-09-30
00796B	中信中國債7-10	上櫃指數股票型基金(ETF)	tpex	2022-08-27
00798B	國泰中企A級債7+	上櫃指數股票型基金(ETF)	tpex	2020-07-16
00799B	國泰A級醫療債	上櫃ETF	tpex	2025-09-30
0080	恒中國	ETF	twse	2024-12-04
0081	恒香港	ETF	twse	2024-12-04
008201	BP上證50	ETF	twse	2025-08-27
00830	國泰費城半導體	ETF	twse	2025-09-30
00831B	新光美債1-3	上櫃指數股票型基金(ETF)	tpex	2024-07-20
00832B	新光美債20+	上櫃指數股票型基金(ETF)	tpex	2021-09-11
00833B	第一金美債20+	上櫃指數股票型基金(ETF)	tpex	2020-12-03
00834B	第一金金融債10+	上櫃ETF	tpex	2025-09-30
00835B	第一金科技債10+	上櫃指數股票型基金(ETF)	tpex	2020-06-24
00836B	永豐10年A公司債	上櫃ETF	tpex	2025-09-30
00837B	永豐15年金融債	上櫃指數股票型基金(ETF)	tpex	2020-07-02
00838B	永豐7-10年中國債	上櫃指數股票型基金(ETF)	tpex	2022-06-02
00839B	凱基醫療保健債	上櫃指數股票型基金(ETF)	tpex	2021-08-05
00840B	凱基IG精選15+	上櫃ETF	tpex	2025-09-30
00841B	凱基AAA-AA公司債	上櫃ETF	tpex	2025-09-30
00842B	台新美元銀行債	上櫃ETF	tpex	2025-09-30
00843B	台新中國政策債	上櫃指數股票型基金(ETF)	tpex	2022-07-22
00844B	新光15年IG金融債	上櫃ETF	tpex	2025-09-30
00845B	富邦新興投等債	上櫃ETF	tpex	2025-09-30
00846B	富邦歐洲銀行債	上櫃ETF	tpex	2025-09-30
00847B	中信美國市政債	上櫃ETF	tpex	2025-09-30
00848B	中信新興亞洲債	上櫃ETF	tpex	2025-09-30
00849B	中信EM主權債0-5	上櫃ETF	tpex	2025-09-30
00850	元大臺灣ESG永續	ETF	twse	2025-09-30
00851	台新全球AI	ETF	twse	2025-09-30
00852L	國泰美國道瓊正2	ETF	twse	2025-09-30
00853B	統一美債10年Aa-A	上櫃ETF	tpex	2025-09-30
00854B	富邦全球保險債	上櫃指數股票型基金(ETF)	tpex	2020-12-04
00855B	富邦全球能源債	上櫃指數股票型基金(ETF)	tpex	2020-12-04
00856B	永豐1-3年美公債	上櫃ETF	tpex	2025-09-30
00857B	永豐20年美公債	上櫃ETF	tpex	2025-09-30
00858	永豐美國500大	上櫃ETF	tpex	2025-09-30
00859B	群益0-1年美債	上櫃ETF	tpex	2025-09-30
00860B	群益1-5Y投資級債	上櫃ETF	tpex	2025-09-30
00861	元大全球未來通訊	ETF	twse	2025-09-30
00862B	中信投資級公司債	上櫃ETF	tpex	2025-09-30
00863B	中信全球電信債	上櫃ETF	tpex	2025-09-30
00864B	中信美國公債0-1	上櫃ETF	tpex	2025-09-30
00865B	國泰US短期公債	ETF	twse	2025-09-30
00866	新光Shiller CAPE	ETF	twse	2024-12-04
00867B	新光A-BBB電信債	上櫃ETF	tpex	2025-09-30
00868B	FT1-3年美公債	上櫃指數股票型基金(ETF)	tpex	2021-05-14
00869B	FT10-25年公司債	上櫃指數股票型基金(ETF)	tpex	2021-08-19
00870B	元大15年EM主權債	上櫃ETF	tpex	2025-09-30
00871B	元大中國政金債	上櫃指數股票型基金(ETF)	tpex	2021-03-03
00872B	凱基美債1-3	上櫃指數股票型基金(ETF)	tpex	2021-10-08
00873B	凱基新興債1-5	上櫃指數股票型基金(ETF)	tpex	2021-02-23
00874B	凱基BBB公司債15+	上櫃指數股票型基金(ETF)	tpex	2021-02-23
00875	國泰網路資安	ETF	twse	2025-09-30
00876	元大全球5G	ETF	twse	2025-09-30
00877	復華中國5G	上櫃ETF	tpex	2025-09-30
00878	國泰永續高股息	ETF	twse	2025-09-30
00879B	第一金美債0-1	上櫃指數股票型基金(ETF)	tpex	2021-10-08
00880B	第一金電信債15+	上櫃指數股票型基金(ETF)	tpex	2021-10-08
00881	國泰台灣科技龍頭	ETF	twse	2025-09-30
00882	中信中國高股息	ETF	twse	2025-09-30
00883B	中信ESG投資級債	上櫃ETF	tpex	2025-09-30
00884B	中信低碳新興債	上櫃ETF	tpex	2025-09-30
00885	富邦越南	ETF	twse	2025-09-30
00886	永豐美國科技	上櫃ETF	tpex	2025-09-30
00887	永豐中國科技50大	上櫃ETF	tpex	2025-09-30
00888	永豐台灣ESG	上櫃ETF	tpex	2025-09-30
00889B	凱基ESG新興債15+	上櫃指數股票型基金(ETF)	tpex	2022-06-24
00890B	凱基ESG BBB債15+	上櫃ETF	tpex	2025-09-30
00891	中信關鍵半導體	ETF	twse	2025-09-30
00892	富邦台灣半導體	ETF	twse	2025-09-30
00893	國泰智能電動車	ETF	twse	2025-09-30
00894	中信小資高價30	ETF	twse	2025-09-30
00895	富邦未來車	ETF	twse	2025-09-30
00896	中信綠能及電動車	ETF	twse	2025-09-30
00897	富邦基因免疫生技	ETF	twse	2025-09-30
00898	國泰基因免疫革命	ETF	twse	2025-09-30
00899	FT潔淨能源	ETF	twse	2025-09-30
00900	富邦特選高股息30	ETF	twse	2025-09-30
00901	永豐智能車供應鏈	ETF	twse	2025-09-30
00902	中信電池及儲能	ETF	twse	2025-09-30
00903	富邦元宇宙	ETF	twse	2025-09-30
00904	新光臺灣半導體30	ETF	twse	2025-09-30
00905	FT臺灣Smart	ETF	twse	2025-09-30
00906	大華元宇宙科技50	ETF	twse	2024-12-04
00907	永豐優息存股	ETF	twse	2025-09-30
00908	富邦入息REITs+	ETF	twse	2025-09-30
00909	國泰數位支付服務	ETF	twse	2025-09-30
00910	第一金太空衛星	ETF	twse	2025-09-30
00911	兆豐洲際半導體	ETF	twse	2025-09-30
00912	中信臺灣智慧50	ETF	twse	2025-09-30
00913	兆豐台灣晶圓製造	ETF	twse	2025-09-30
00915	凱基優選高股息30	ETF	twse	2025-09-30
00916	國泰全球品牌50	ETF	twse	2025-09-30
00917	中信特選金融	ETF	twse	2025-09-30
00918	大華優利高填息30	ETF	twse	2025-09-30
00919	群益台灣精選高息	ETF	twse	2025-09-30
00920	富邦ESG綠色電力	ETF	twse	2025-09-30
00921	兆豐龍頭等權重	ETF	twse	2025-09-30
00922	國泰台灣領袖50	ETF	twse	2025-09-30
00923	群益台ESG低碳50	ETF	twse	2025-09-30
00924	復華S&P500成長	ETF	twse	2025-09-30
00925	新光標普電動車	ETF	twse	2025-06-05
00926	凱基全球菁英55	ETF	twse	2025-09-30
00927	群益半導體收益	ETF	twse	2025-09-30
00928	中信上櫃ESG 30	上櫃ETF	tpex	2025-09-30
00929	復華台灣科技優息	ETF	twse	2025-09-30
00930	永豐ESG低碳高息	ETF	twse	2025-09-30
00931B	統一美債20年	上櫃ETF	tpex	2025-09-30
00932	兆豐永續高息等權	ETF	twse	2025-09-30
00933B	國泰10Y+金融債	上櫃ETF	tpex	2025-09-30
00934	中信成長高股息	ETF	twse	2025-09-30
00935	野村臺灣新科技50	ETF	twse	2025-09-30
00936	台新永續高息中小	ETF	twse	2025-09-30
00937B	群益ESG投等債20+	上櫃ETF	tpex	2025-09-30
00938	凱基優選30	ETF	twse	2025-09-30
00939	統一台灣高息動能	ETF	twse	2025-09-30
00940	元大台灣價值高息	ETF	twse	2025-09-30
00941	中信上游半導體	ETF	twse	2025-09-30
00942B	台新美A公司債20+	上櫃ETF	tpex	2025-09-30
00943	兆豐電子高息等權	ETF	twse	2025-09-30
00944	野村趨勢動能高息	ETF	twse	2025-09-30
00945B	凱基美國非投等債	ETF	twse	2025-09-30
00946	群益科技高息成長	ETF	twse	2025-09-30
00947	台新臺灣IC設計	ETF	twse	2025-09-30
00948B	中信優息投資級債	上櫃ETF	tpex	2025-09-30
00949	復華日本龍頭	ETF	twse	2025-09-30
00950B	凱基A級公司債	上櫃ETF	tpex	2025-09-30
00951	台新日本半導體	ETF	twse	2025-09-30
00952	凱基台灣AI50	ETF	twse	2025-09-30
00953B	群益優選非投等債	ETF	twse	2025-09-30
00954	中信日本半導體	ETF	twse	2025-09-30
00955	中信日本商社	上櫃ETF	tpex	2025-09-30
00956	中信日經高股息	ETF	twse	2025-09-30
00957B	兆豐US優選投等債	上櫃ETF	tpex	2025-09-30
00958B	永豐ESG銀行債15+	上櫃ETF	tpex	2025-09-30
00959B	大華投等美債15Y+	上櫃ETF	tpex	2025-09-30
00960	野村全球航運龍頭	ETF	twse	2025-09-30
00961	FT臺灣永續高息	ETF	twse	2025-09-30
00962	台新AI優息動能	ETF	twse	2025-09-30
00963	中信全球高股息	ETF	twse	2025-09-30
00964	中信亞太高股息	ETF	twse	2025-09-30
00965	元大航太防衛科技	ETF	twse	2025-09-30
00966B	統一ESG投等債15+	上櫃ETF	tpex	2025-09-30
00967B	元大優息美債	上櫃ETF	tpex	2025-09-30
00968B	元大優息投等債	上櫃ETF	tpex	2025-09-30
00969B	元大零息超長美債	上櫃ETF	tpex	2025-09-30
00970B	新光BBB投等債20+	上櫃ETF	tpex	2025-09-30
00971	野村美國研發龍頭	ETF	twse	2025-09-30
00972	野村日本動能高息	ETF	twse	2025-09-30
009800	中信NASDAQ	ETF	twse	2025-09-30
009801	中信美國創新科技	ETF	twse	2025-09-30
009802	富邦旗艦50	ETF	twse	2025-09-30
009803	保德信市值動能50	ETF	twse	2025-09-30
009804	聯邦台精彩50	ETF	twse	2025-09-30
009805	新光美國電力基建	ETF	twse	2025-09-30
009806	台新標普500	上櫃ETF	tpex	2025-09-30
009807	台新標普科技精選	上櫃ETF	tpex	2025-09-30
009808	華南永昌優選50	ETF	twse	2025-09-30
00980A	主動野村臺灣優選	ETF	twse	2025-09-30
00980B	台新特選IG債10+	上櫃ETF	tpex	2025-09-30
00980D	主動聯博投等入息	上櫃ETF	tpex	2025-09-30
00980T	平衡凱基美國TOP	上櫃ETF	tpex	2025-09-30
009810	保德信全球藍籌	ETF	twse	2025-09-30
009811	統一美國50	ETF	twse	2025-09-30
009812	野村日本東證	ETF	twse	2025-09-30
00981A	主動統一台股增長	ETF	twse	2025-09-30
00981B	第一金優選非投債	上櫃ETF	tpex	2025-09-30
00981D	主動中信非投等債	上櫃ETF	tpex	2025-09-30
00981T	平衡凱基雙核收息	ETF	twse	2025-09-30
00982A	主動群益台灣強棒	ETF	twse	2025-09-30
00982B	FT投資級債20+	上櫃ETF	tpex	2025-09-30
00983A	主動中信ARK創新	ETF	twse	2025-09-30
00983B	大華優利美公債20	上櫃ETF	tpex	2025-09-30
00984A	主動安聯台灣高息	ETF	twse	2025-09-30
00984B	大華優利美A債15	上櫃ETF	tpex	2025-09-30
00985A	主動野村台灣50	ETF	twse	2025-09-30
00985B	群益ESG投等債0-5	ETF	twse	2025-09-30
00986A	主動台新龍頭成長	ETF	twse	2025-09-30
01001T	土銀富邦R1	受益證券	twse	2020-11-14
01002T	土銀國泰R1	受益證券	twse	2020-11-14
01003T	兆豐新光R1	受益證券	twse	2020-11-14
01004T	土銀富邦R2	受益證券	twse	2020-11-14
01005T	三鼎	受益證券	twse	2020-11-14
01007T	兆豐國泰R2	受益證券	twse	2020-11-14
01008T	駿馬R1	受益證券	twse	2020-11-14
01009T	王道圓滿R1	受益證券	twse	2020-11-14
020000	富邦特選蘋果N	ETN	twse	2025-09-30
020001	富邦存股雙十N	指數投資證券(ETN)	tpex	2025-09-30
020002	元富新中國N	ETN	twse	2024-12-04
020003	統一漲升股利150N	指數投資證券(ETN)	tpex	2022-04-30
020004	兆豐電菁英30N	ETN	twse	2024-12-04
020005	永豐外資50N	ETN	twse	2024-12-04
020006	永昌中小300N	ETN	twse	2024-12-04
020007	凱基臺灣500N	ETN	twse	2024-12-04
020008	元大特股高息N	ETN	twse	2024-12-04
020009	群益A50綠碳N	指數投資證券(ETN)	tpex	2022-04-30
020010	永昌富櫃200N	指數投資證券(ETN)	tpex	2022-09-30
020011	統一微波高息20N	ETN	twse	2025-09-30
020012	富邦行動通訊N	ETN	twse	2025-09-30
020013	元富亞洲高股息N	指數投資證券(ETN)	tpex	2022-12-24
020014	元大富櫃200N	指數投資證券(ETN)	tpex	2022-12-30
020015	統一MSCI美低波N	ETN	twse	2025-03-25
020016	統一MSCI美科技N	ETN	twse	2025-03-25
020017	永豐富櫃200N	指數投資證券(ETN)	tpex	2021-06-12
020018	統一價值成長30N	ETN	twse	2025-07-28
020019	統一特選台灣5GN	ETN	twse	2025-07-28
02001B	統一美國政府債N	指數投資證券(ETN)	tpex	2025-09-30
02001L	富邦蘋果正二N	ETN	twse	2025-09-30
02001R	富邦蘋果反一N	ETN	twse	2025-09-30
02001S	策元大加權策略N	ETN	twse	2025-09-30
020020	元大台股領航N	ETN	twse	2025-09-30
020021	統一恒生科技N	指數投資證券(ETN)	tpex	2022-03-18
020022	元大電動車N	ETN	twse	2024-12-04
020023	元大櫃買半導體N	指數投資證券(ETN)	tpex	2025-09-30
020024	兆豐富櫃200N	指數投資證券(ETN)	tpex	2023-12-16
020025	統一亞洲半導體N	指數投資證券(ETN)	tpex	2025-09-30
020026	兆豐上櫃ESG電菁N	指數投資證券(ETN)	tpex	2024-06-22
020027	元大上櫃ESG成長N	指數投資證券(ETN)	tpex	2025-09-30
020028	元大特選電動車N	ETN	twse	2025-09-30
020029	元大ESG高股息N	ETN	twse	2025-09-30
02002L	兆豐富櫃200正二N	指數投資證券(ETN)	tpex	2023-12-16
020030	統一智慧電動車N	ETN	twse	2025-09-30
020031	統一IC設計臺灣N	ETN	twse	2025-09-30
020032	元大綠能N	ETN	twse	2025-09-30
020033	統一恒生科期N	指數投資證券(ETN)	tpex	2025-09-30
020034	元大IC設計N	ETN	twse	2025-09-30
020035	元大上櫃ESG高息N	指數投資證券(ETN)	tpex	2025-09-30
020036	元大金融配息N	ETN	twse	2025-09-30
020037	元大金融高股息N	ETN	twse	2025-09-30
020038	元大ESG配息N	ETN	twse	2025-09-30
020039	元大加權N	ETN	twse	2025-09-30
02003L	永豐富櫃200正2N	指數投資證券(ETN)	tpex	2022-12-24
020040	元大上櫃ESG龍頭N	指數投資證券(ETN)	tpex	2025-09-30
020041	兆豐半導體氣候N	指數投資證券(ETN)	tpex	2025-09-30
1101	台泥	水泥工業	twse	2025-09-30
1101B	台泥乙特	水泥工業	twse	2025-09-30
1102	亞泥	水泥工業	twse	2025-09-30
1103	嘉泥	水泥工業	twse	2025-09-30
1104	環泥	水泥工業	twse	2025-09-30
1107	建台	其他	twse	2024-12-04
1108	幸福	水泥工業	twse	2025-09-30
1109	信大	水泥工業	twse	2025-09-30
1110	東泥	水泥工業	twse	2025-09-30
1201	味全	食品工業	twse	2025-09-30
1203	味王	食品工業	twse	2025-09-30
1210	大成	食品工業	twse	2025-09-30
1213	大飲	食品工業	twse	2025-09-30
1215	卜蜂	食品工業	twse	2025-09-30
1216	統一	食品工業	twse	2025-09-30
1217	愛之味	食品工業	twse	2025-09-30
1218	泰山	食品工業	twse	2025-09-30
1219	福壽	食品工業	twse	2025-09-30
1220	台榮	食品工業	twse	2025-09-30
1225	福懋油	食品工業	twse	2025-09-30
1227	佳格	食品工業	twse	2025-09-30
1229	聯華	食品工業	twse	2025-09-30
1230	聯成食	電器電纜	twse	2024-12-03
1231	聯華食	食品工業	twse	2025-09-30
1232	大統益	食品工業	twse	2025-09-30
1233	天仁	食品工業	twse	2025-09-30
1234	黑松	食品工業	twse	2025-09-30
1235	興泰	食品工業	twse	2025-09-30
1236	宏亞	食品工業	twse	2025-09-30
1240	茂生農經	農業科技業	tpex	2025-09-30
1256	鮮活果汁-KY	食品工業	twse	2025-09-30
1258	其祥-KY	食品工業	tpex	2023-06-03
1259	安心	觀光餐旅	tpex	2025-09-30
1260	富味鄉	食品工業	emerging	2025-09-30
1262	綠悅-KY	其他	twse	2025-09-26
1264	德麥	食品工業	tpex	2025-09-30
1268	漢來美食	觀光餐旅	tpex	2025-09-30
1269	乾杯	觀光餐旅	emerging	2025-09-30
1271	晨暉生技	生技醫療業	emerging	2025-09-30
1293	利統	食品工業	emerging	2025-09-30
1294	漢田生技	食品工業	tpex	2025-09-30
1295	生合	食品工業	tpex	2025-09-30
1301	台塑	塑膠工業	twse	2025-09-30
1303	南亞	塑膠工業	twse	2025-09-30
1304	台聚	塑膠工業	twse	2025-09-30
1305	華夏	塑膠工業	twse	2025-09-30
1307	三芳	塑膠工業	twse	2025-09-30
1308	亞聚	塑膠工業	twse	2025-09-30
1309	台達化	塑膠工業	twse	2025-09-30
1310	台苯	塑膠工業	twse	2025-09-30
1311	福聚	塑膠工業	twse	2024-12-03
1312	國喬	塑膠工業	twse	2025-09-30
1312A	國喬特	塑膠工業	twse	2025-09-30
1313	聯成	塑膠工業	twse	2025-09-30
1314	中石化	塑膠工業	twse	2025-09-30
1315	達新	塑膠工業	twse	2025-09-30
1316	上曜	建材營造	twse	2025-09-30
1319	東陽	汽車工業	twse	2025-09-30
1321	大洋	塑膠工業	twse	2025-09-30
1323	永裕	塑膠工業	twse	2025-09-30
1324	地球	塑膠工業	twse	2025-09-30
1325	恆大	塑膠工業	twse	2025-09-30
1326	台化	塑膠工業	twse	2025-09-30
1336	台翰	電子零組件業	tpex	2025-09-30
1337	再生-KY	塑膠工業	twse	2025-09-30
1338	廣華-KY	汽車工業	twse	2025-09-30
1339	昭輝	汽車工業	twse	2025-09-30
1340	勝悅-KY	塑膠工業	twse	2025-09-30
1341	富林-KY	塑膠工業	twse	2025-09-30
1342	八貫	其他	twse	2025-09-30
1343	旭東環保	綠能環保	emerging	2025-09-30
1402	遠東新	紡織纖維	twse	2025-09-30
1409	新纖	紡織纖維	twse	2025-09-30
1410	南染	紡織纖維	twse	2025-09-30
1413	宏洲	紡織纖維	twse	2025-09-30
1414	東和	紡織纖維	twse	2025-09-30
1416	廣豐	其他	twse	2025-09-30
1417	嘉裕	紡織纖維	twse	2025-09-30
1418	東華	紡織纖維	twse	2025-09-30
1419	新紡	紡織纖維	twse	2025-09-30
1423	利華	紡織纖維	twse	2025-09-30
1432	大魯閣	運動休閒	twse	2025-09-30
1434	福懋	紡織纖維	twse	2025-09-30
1435	中福	其他	twse	2025-09-30
1436	華友聯	建材營造	twse	2025-09-30
1437	勤益控	其他	twse	2025-09-30
1438	三地開發	建材營造	twse	2025-09-30
1439	雋揚	建材營造	twse	2025-09-30
1440	南紡	紡織纖維	twse	2025-09-30
1441	大東	紡織纖維	twse	2025-09-30
1442	名軒	建材營造	twse	2025-09-30
1443	立益物流	其他	twse	2025-09-30
1444	力麗	紡織纖維	twse	2025-09-30
1445	大宇	紡織纖維	twse	2025-09-30
1446	宏和	紡織纖維	twse	2025-09-30
1447	力鵬	紡織纖維	twse	2025-09-30
1449	佳和	紡織纖維	twse	2025-09-30
1451	年興	紡織纖維	twse	2025-09-30
1452	宏益	紡織纖維	twse	2025-09-30
1453	大將	建材營造	twse	2025-09-30
1454	台富	紡織纖維	twse	2025-09-30
1455	集盛	紡織纖維	twse	2025-09-30
1456	怡華	建材營造	twse	2025-09-30
1457	宜進	紡織纖維	twse	2025-09-30
1459	聯發	紡織纖維	twse	2025-09-30
1460	宏遠	紡織纖維	twse	2025-09-30
1463	強盛新	紡織纖維	twse	2025-09-30
1464	得力	紡織纖維	twse	2025-09-30
1465	偉全	紡織纖維	twse	2025-09-30
1466	聚隆	紡織纖維	twse	2025-09-30
1467	南緯	紡織纖維	twse	2025-09-30
1468	昶和	紡織纖維	twse	2025-09-30
1469	理隆	紡織纖維	twse	2025-09-20
1470	大統新創	紡織纖維	twse	2025-09-30
1471	首利	電子零組件業	twse	2025-09-30
1472	三洋實業	建材營造	twse	2025-09-30
1473	台南	紡織纖維	twse	2025-09-30
1474	弘裕	紡織纖維	twse	2025-09-30
1475	業旺	紡織纖維	twse	2025-09-30
1476	儒鴻	紡織纖維	twse	2025-09-30
1477	聚陽	紡織纖維	twse	2025-09-30
1480	東盟開發	鋼鐵工業	emerging	2025-09-30
1503	士電	電機機械	twse	2025-09-30
1504	東元	電機機械	twse	2025-09-30
1506	正道	電機機械	twse	2025-09-30
1507	永大	電機機械	twse	2025-04-28
1512	瑞利	汽車工業	twse	2025-09-30
1513	中興電	電機機械	twse	2025-09-30
1514	亞力	電機機械	twse	2025-09-30
1515	力山	電機機械	twse	2025-09-30
1516	川飛	其他	twse	2025-09-30
1517	利奇	電機機械	twse	2025-09-30
1519	華城	電機機械	twse	2025-09-30
1520	復盛	其他	twse	2024-12-04
1521	大億	汽車工業	twse	2025-09-30
1522	堤維西	汽車工業	twse	2025-09-30
1522A	堤維西甲特	汽車工業	twse	2025-09-30
1523	開億	電機機械	twse	2024-12-03
1524	耿鼎	汽車工業	twse	2025-09-30
1525	江申	汽車工業	twse	2025-09-30
1526	日馳	電機機械	twse	2025-09-30
1527	鑽全	電機機械	twse	2025-09-30
1528	恩德	電機機械	twse	2025-09-30
1529	樂事綠能	電機機械	twse	2025-09-30
1530	亞崴	電機機械	twse	2025-09-30
1531	高林股	電機機械	twse	2025-09-30
1532	勤美	電機機械	twse	2025-09-30
1533	車王電	汽車工業	twse	2025-09-30
1535	中宇	電機機械	twse	2025-09-30
1536	和大	汽車工業	twse	2025-09-30
1537	廣隆	電機機械	twse	2025-09-30
1538	正峰	電機機械	twse	2025-09-30
1539	巨庭	電機機械	twse	2025-09-30
1540	喬福	電機機械	twse	2025-09-30
1541	錩泰	電機機械	twse	2025-09-30
1558	伸興	電機機械	twse	2025-09-30
1560	中砂	電機機械	twse	2025-09-30
1563	巧新	汽車工業	twse	2025-09-30
1565	精華	生技醫療業	tpex	2025-09-30
1568	倉佑	汽車工業	twse	2025-09-30
1569	濱川	電腦及週邊設備業	tpex	2025-09-30
1570	力肯	電機機械	tpex	2025-09-30
1580	新麥	電機機械	tpex	2025-09-30
1582	信錦	電子零組件業	twse	2025-09-30
1583	程泰	電機機械	twse	2025-09-30
1584	精剛	其他	tpex	2025-09-30
1585	鎧鉅	電子零組件業	emerging	2025-05-27
1586	和勤	電機機械	tpex	2025-09-30
1587	吉茂	汽車工業	twse	2025-09-30
1589	永冠-KY	電機機械	twse	2025-09-30
1590	亞德客-KY	電機機械	twse	2025-09-30
1591	駿吉-KY	電機機械	tpex	2025-09-30
1592	英瑞-KY	汽車工業	twse	2025-09-01
1593	祺驊	運動休閒類	tpex	2025-09-30
1594	日高	電機機械	emerging	2025-09-30
1595	川寶	電子零組件業	tpex	2025-09-30
1597	直得	電機機械	twse	2025-09-30
1598	岱宇	運動休閒	twse	2025-09-30
1599	宏佳騰	電機機械	tpex	2025-09-30
1601	台光	電器電纜	twse	2024-12-03
1603	華電	電器電纜	twse	2025-09-30
1604	聲寶	電器電纜	twse	2025-09-30
1605	華新	電器電纜	twse	2025-09-30
1606	歌林	電器電纜	twse	2024-12-03
1608	華榮	電器電纜	twse	2025-09-30
1609	大亞	電器電纜	twse	2025-09-30
1611	中電	電器電纜	twse	2025-09-30
1612	宏泰	電器電纜	twse	2025-09-30
1613	台一	電器電纜	twse	2025-06-17
1614	三洋電	電器電纜	twse	2025-09-30
1615	大山	電器電纜	twse	2025-09-30
1616	億泰	電器電纜	twse	2025-09-30
1617	榮星	電器電纜	twse	2025-09-30
1618	合機	電器電纜	twse	2025-09-30
1623	大東電	電器電纜	emerging	2025-09-30
1626	艾美特-KY	電器電纜	twse	2025-09-30
1701	中化	生技醫療業	twse	2025-09-03
1702	南僑	食品工業	twse	2025-09-30
1704	榮化	化學工業	twse	2025-09-24
1707	葡萄王	生技醫療業	twse	2025-09-30
1708	東鹼	化學生技醫療	twse	2025-09-30
1709	和益	化學生技醫療	twse	2025-09-30
1710	東聯	化學工業	twse	2025-09-30
1711	永光	化學工業	twse	2025-09-30
1712	興農	化學生技醫療	twse	2025-09-30
1713	國化	化學生技醫療	twse	2025-09-30
1714	和桐	化學生技醫療	twse	2025-09-30
1715	萬洲	塑膠工業	twse	2024-12-03
1716	永信	生技醫療業	twse	2025-04-30
1717	長興	化學生技醫療	twse	2025-09-30
1718	中纖	化學生技醫療	twse	2025-09-30
1720	生達	生技醫療業	twse	2025-09-30
1721	三晃	化學生技醫療	twse	2025-09-30
1722	台肥	化學生技醫療	twse	2025-09-30
1723	中碳	化學生技醫療	twse	2025-09-30
1724	台硝	化學工業	twse	2025-09-24
1725	元禎	化學生技醫療	twse	2025-09-30
1726	永記	化學生技醫療	twse	2025-09-30
1727	中華化	化學工業	twse	2025-09-30
1729	必翔	生技醫療業	twse	2025-04-30
1730	花仙子	化學工業	twse	2025-09-30
1731	美吾華	化學生技醫療	twse	2025-09-30
1732	毛寶	化學生技醫療	twse	2025-09-30
1733	五鼎	生技醫療業	twse	2025-09-30
1734	杏輝	生技醫療業	twse	2025-09-30
1735	日勝化	化學生技醫療	twse	2025-09-30
1736	喬山	運動休閒	twse	2025-09-30
1737	臺鹽	食品工業	twse	2025-09-30
1742	台蠟	化學工業	tpex	2025-09-30
1752	南光	化學生技醫療	twse	2025-09-30
1760	寶齡富錦	生技醫療業	twse	2025-09-30
1762	中化生	生技醫療業	twse	2025-09-30
1773	勝一	化學生技醫療	twse	2025-09-30
1776	展宇	化學生技醫療	twse	2025-09-30
1777	生泰	生技醫療業	tpex	2025-09-30
1780	立弘	生技醫療業	emerging	2025-09-30
1781	合世	生技醫療業	tpex	2025-09-30
1783	和康生	化學生技醫療	twse	2025-09-30
1784	訊聯	生技醫療業	tpex	2025-09-30
1785	光洋科	其他電子類	tpex	2025-09-30
1786	科妍	生技醫療業	twse	2025-09-30
1788	杏昌	生技醫療業	tpex	2025-09-30
1789	神隆	生技醫療業	twse	2025-09-30
1795	美時	生技醫療業	twse	2025-09-30
1796	金穎生技	食品工業	tpex	2025-09-30
1799	易威	生技醫療業	tpex	2025-09-30
1802	台玻	玻璃陶瓷	twse	2025-09-30
1805	寶徠	建材營造	twse	2025-09-30
1806	冠軍	玻璃陶瓷	twse	2025-09-30
1808	潤隆	建材營造	twse	2025-09-30
1809	中釉	玻璃陶瓷	twse	2025-09-30
1810	和成	玻璃陶瓷	twse	2025-09-30
1813	寶利徠	生技醫療業	tpex	2025-09-30
1815	富喬	電子零組件業	tpex	2025-09-30
1817	凱撒衛	玻璃陶瓷	twse	2025-09-30
1902	台紙	造紙工業	twse	2025-08-14
1903	士紙	造紙工業	twse	2025-09-30
1904	正隆	造紙工業	twse	2025-09-30
1905	華紙	造紙工業	twse	2025-09-30
1906	寶隆	造紙工業	twse	2025-09-30
1907	永豐餘	造紙工業	twse	2025-09-30
1909	榮成	造紙工業	twse	2025-09-30
2002	中鋼	鋼鐵工業	twse	2025-09-30
2002A	中鋼特	鋼鐵工業	twse	2025-09-30
2006	東和鋼鐵	鋼鐵工業	twse	2025-09-30
2007	燁興	鋼鐵工業	twse	2025-09-30
2008	高興昌	鋼鐵工業	twse	2025-09-30
2009	第一銅	鋼鐵工業	twse	2025-09-30
2010	春源	鋼鐵工業	twse	2025-09-30
2012	春雨	鋼鐵工業	twse	2025-09-30
2013	中鋼構	鋼鐵工業	twse	2025-09-30
2014	中鴻	鋼鐵工業	twse	2025-09-30
2015	豐興	鋼鐵工業	twse	2025-09-30
2017	官田鋼	鋼鐵工業	twse	2025-09-30
2020	美亞	鋼鐵工業	twse	2025-09-30
2022	聚亨	鋼鐵工業	twse	2025-09-30
2023	燁輝	鋼鐵工業	twse	2025-09-30
2024	志聯	鋼鐵工業	twse	2025-09-30
2025	千興	鋼鐵工業	twse	2025-09-30
2027	大成鋼	鋼鐵工業	twse	2025-09-30
2028	威致	鋼鐵工業	twse	2025-09-30
2029	盛餘	鋼鐵工業	twse	2025-09-30
2030	彰源	鋼鐵工業	twse	2025-09-30
2031	新光鋼	鋼鐵工業	twse	2025-09-30
2032	新鋼	鋼鐵工業	twse	2025-09-30
2033	佳大	鋼鐵工業	twse	2025-09-30
2034	允強	鋼鐵工業	twse	2025-09-30
2035	唐榮	鋼鐵工業	tpex	2025-09-30
2038	海光	鋼鐵工業	twse	2025-09-30
2049	上銀	電機機械	twse	2025-09-30
2059	川湖	電子工業	twse	2025-09-30
2061	風青	電器電纜	tpex	2025-09-30
2062	橋椿	居家生活	twse	2025-09-30
2063	世鎧	鋼鐵工業	tpex	2025-09-30
2064	晉椿	鋼鐵工業	tpex	2025-09-30
2065	世豐	鋼鐵工業	tpex	2025-09-30
2066	世德	電機機械	tpex	2025-09-30
2067	嘉鋼	電機機械	tpex	2025-09-30
2069	運錩	鋼鐵工業	twse	2025-09-30
2070	精湛	電機機械	tpex	2025-09-30
2071	震南鐵	鋼鐵工業	emerging	2025-09-30
2072	世紀風電	鋼鐵工業	emerging	2025-09-30
2073	雄順	鋼鐵工業	tpex	2025-09-30
2101	南港	橡膠工業	twse	2025-09-30
2102	泰豐	橡膠工業	twse	2025-09-30
2103	台橡	橡膠工業	twse	2025-09-30
2104	國際中橡	橡膠工業	twse	2025-09-30
2105	正新	橡膠工業	twse	2025-09-30
2106	建大	橡膠工業	twse	2025-09-30
2107	厚生	橡膠工業	twse	2025-09-30
2108	南帝	橡膠工業	twse	2025-09-30
2109	華豐	橡膠工業	twse	2025-09-30
2114	鑫永銓	橡膠工業	twse	2025-09-30
2115	六暉-KY	汽車工業	twse	2025-09-30
2201	裕隆	汽車工業	twse	2025-09-30
2204	中華	汽車工業	twse	2025-09-30
2206	三陽工業	汽車工業	twse	2025-09-30
2207	和泰車	汽車工業	twse	2025-09-30
2208	台船	航運業	twse	2025-09-30
2211	長榮鋼	鋼鐵工業	twse	2025-09-30
2221	大甲	其他	tpex	2025-09-30
2227	裕日車	汽車工業	twse	2025-09-30
2228	劍麟	汽車工業	twse	2025-09-30
2230	泰茂	電機機械	tpex	2025-09-30
2231	為升	汽車工業	twse	2025-09-30
2233	宇隆	汽車工業	twse	2025-09-30
2235	謚源	電機機械	tpex	2025-09-30
2236	百達-KY	汽車工業	twse	2025-09-30
2237	華德動能	電機機械	emerging	2025-09-30
2239	英利-KY	汽車工業	twse	2025-09-30
2241	艾姆勒	汽車工業	twse	2025-09-30
2243	宏旭-KY	汽車工業	twse	2025-09-30
2245	詠勝昌*	電機機械	emerging	2025-09-30
2247	汎德永業	汽車工業	twse	2025-09-30
2248	華勝-KY	汽車工業	twse	2025-09-30
2249	湧盛	電機機械	emerging	2025-09-30
2250	IKKA-KY	汽車工業	twse	2025-09-30
2252	為昇科	其他電子業	emerging	2025-09-30
2254	巨鎧精密-創	汽車工業	twse	2025-09-30
2255	凱銳光電	其他電子業	emerging	2025-09-30
2256	歐特明	其他電子業	emerging	2025-09-30
2258	鴻華先進-創	創新板股票	twse	2025-09-30
2301	光寶科	電子工業	twse	2025-09-30
2302	麗正	電子工業	twse	2025-09-30
2303	聯電	電子工業	twse	2025-09-30
2305	全友	電腦及週邊設備業	twse	2025-09-30
2308	台達電	電子零組件業	twse	2025-09-30
2311	日月光	電子工業	twse	2025-09-24
2312	金寶	電子工業	twse	2025-09-30
2313	華通	電子零組件業	twse	2025-09-30
2314	台揚	電子工業	twse	2025-09-30
2315	神達	電子工業	twse	2024-12-04
2316	楠梓電	電子零組件業	twse	2025-09-30
2317	鴻海	電子工業	twse	2025-09-30
2321	東訊	電子工業	twse	2025-09-30
2323	中環	電子工業	twse	2025-09-30
2324	仁寶	電腦及週邊設備業	twse	2025-09-30
2325	矽品	電子工業	twse	2025-09-24
2327	國巨*	電子零組件業	twse	2025-09-30
2328	廣宇	電子零組件業	twse	2025-09-30
2329	華泰	電子工業	twse	2025-09-30
2330	台積電	電子工業	twse	2025-09-30
2331	精英	電腦及週邊設備業	twse	2025-09-30
2332	友訊	電子工業	twse	2025-09-30
2336	致伸	電腦及週邊設備業	twse	2024-12-04
2337	旺宏	電子工業	twse	2025-09-30
2338	光罩	電子工業	twse	2025-09-30
2340	台亞	電子工業	twse	2025-09-30
2341	英群	電子工業	twse	2024-12-04
2342	茂矽	電子工業	twse	2025-09-30
2344	華邦電	電子工業	twse	2025-09-30
2345	智邦	電子工業	twse	2025-09-30
2347	聯強	電子通路業	twse	2025-09-30
2348	海悅	其他	twse	2025-09-30
2348A	海悅甲特	其他	twse	2025-09-30
2349	錸德	光電業	twse	2025-09-30
2350	環電	其他電子業	twse	2024-12-04
2351	順德	半導體業	twse	2025-09-30
2352	佳世達	電子工業	twse	2025-09-25
2353	宏碁	電腦及週邊設備業	twse	2025-09-30
2354	鴻準	電子工業	twse	2025-09-30
2355	敬鵬	電子零組件業	twse	2025-09-30
2356	英業達	電腦及週邊設備業	twse	2025-09-30
2357	華碩	電腦及週邊設備業	twse	2025-09-30
2358	廷鑫	其他	twse	2025-09-26
2359	所羅門	電子工業	twse	2025-09-30
2360	致茂	電子工業	twse	2025-09-30
2361	鴻友	電子工業	twse	2024-12-04
2362	藍天	電腦及週邊設備業	twse	2025-09-30
2363	矽統	電子工業	twse	2025-09-30
2364	倫飛	電腦及週邊設備業	twse	2025-09-30
2365	昆盈	電腦及週邊設備業	twse	2025-09-30
2367	燿華	電子工業	twse	2025-09-30
2368	金像電	電子工業	twse	2025-09-30
2369	菱生	半導體業	twse	2025-09-30
2371	大同	電機機械	twse	2025-09-30
2373	震旦行	電子工業	twse	2025-09-30
2374	佳能	電子工業	twse	2025-09-30
2375	凱美	電子零組件業	twse	2025-09-30
2376	技嘉	電腦及週邊設備業	twse	2025-09-30
2377	微星	電腦及週邊設備業	twse	2025-09-30
2379	瑞昱	半導體業	twse	2025-09-30
2380	虹光	電腦及週邊設備業	twse	2025-09-30
2381	華宇	電子工業	twse	2024-12-04
2382	廣達	電腦及週邊設備業	twse	2025-09-30
2383	台光電	電子零組件業	twse	2025-09-30
2384	勝華	光電業	twse	2024-12-04
2385	群光	電子零組件業	twse	2025-09-30
2387	精元	電腦及週邊設備業	twse	2025-09-30
2388	威盛	半導體業	twse	2025-09-30
2390	云辰	其他電子業	twse	2025-09-30
2391	合勤	電子工業	twse	2024-12-04
2392	正崴	電子零組件業	twse	2025-09-30
2393	億光	電子工業	twse	2025-09-30
2395	研華	電腦及週邊設備業	twse	2025-09-30
2396	精碟	光電業	twse	2024-12-04
2397	友通	電腦及週邊設備業	twse	2025-09-30
2399	映泰	電腦及週邊設備業	twse	2025-09-30
2401	凌陽	電子工業	twse	2025-09-30
2402	毅嘉	電子零組件業	twse	2025-09-30
2403	友尚	電子通路業	twse	2024-12-04
2404	漢唐	電子工業	twse	2025-09-30
2405	輔信	電腦及週邊設備業	twse	2025-09-30
2406	國碩	電子工業	twse	2025-09-30
2408	南亞科	電子工業	twse	2025-09-30
2409	友達	電子工業	twse	2025-09-30
2411	飛瑞	電子工業	twse	2024-12-04
2412	中華電	電子工業	twse	2025-09-30
2413	環科	電子零組件業	twse	2025-09-30
2414	精技	電子通路業	twse	2025-09-30
2415	錩新	電子零組件業	twse	2025-09-30
2417	圓剛	電腦及週邊設備業	twse	2025-09-30
2418	雅新	電子工業	twse	2024-12-04
2419	仲琦	電子工業	twse	2025-09-30
2420	新巨	電子零組件業	twse	2025-09-30
2421	建準	電子零組件業	twse	2025-09-30
2423	固緯	電子工業	twse	2025-09-30
2424	隴華	電子工業	twse	2025-09-30
2425	承啟	電腦及週邊設備業	twse	2025-09-30
2426	鼎元	電子工業	twse	2025-09-30
2427	三商電	電子工業	twse	2025-09-30
2428	興勤	電子工業	twse	2025-09-30
2429	銘旺科	光電業	twse	2025-09-30
2430	燦坤	電子工業	twse	2025-09-30
2431	聯昌	電子零組件業	twse	2025-09-30
2432	倚天酷碁-創	電腦及週邊設備業	twse	2025-09-30
2433	互盛電	電子工業	twse	2025-09-30
2434	統懋	電子工業	twse	2025-09-30
2436	偉詮電	半導體業	twse	2025-09-30
2437	旺詮	電子工業	twse	2025-05-14
2438	翔耀	電子工業	twse	2025-09-30
2439	美律	電子工業	twse	2025-09-30
2440	太空梭	電子零組件業	twse	2025-09-30
2441	超豐	電子工業	twse	2025-09-30
2442	新美齊	建材營造	twse	2025-09-30
2443	昶虹	其他	twse	2025-09-26
2444	兆勁	電子工業	twse	2025-09-30
2446	全懋	電子工業	twse	2024-12-04
2447	鼎新	資訊服務業	twse	2024-12-04
2448	晶電	電子工業	twse	2025-09-24
2449	京元電子	電子工業	twse	2025-09-30
2450	神腦	通信網路業	twse	2025-09-30
2451	創見	電子工業	twse	2025-09-30
2452	乾坤	電子工業	twse	2024-12-04
2453	凌群	電子工業	twse	2025-09-30
2454	聯發科	電子工業	twse	2025-09-30
2455	全新	電子工業	twse	2025-09-30
2456	奇力新	電子工業	twse	2025-09-24
2457	飛宏	電子零組件業	twse	2025-09-30
2458	義隆	電子工業	twse	2025-09-30
2459	敦吉	其他電子業	twse	2025-09-30
2460	建通	電子零組件業	twse	2025-09-30
2461	光群雷	電子工業	twse	2025-09-30
2462	良得電	電子零組件業	twse	2025-09-30
2463	研揚	電腦及週邊設備業	twse	2024-12-04
2464	盟立	電子工業	twse	2025-09-30
2465	麗臺	電腦及週邊設備業	twse	2025-09-30
2466	冠西電	光電業	twse	2025-09-30
2467	志聖	電子工業	twse	2025-09-30
2468	華經	電子工業	twse	2025-09-30
2469	力信	電子零組件業	twse	2024-12-04
2471	資通	電子工業	twse	2025-09-30
2472	立隆電	電子零組件業	twse	2025-09-30
2473	思源	電子工業	twse	2024-12-04
2474	可成	電子工業	twse	2025-09-30
2475	華映	電子工業	twse	2025-09-24
2476	鉅祥	電子零組件業	twse	2025-09-30
2477	美隆電	電子工業	twse	2025-09-30
2478	大毅	電子零組件業	twse	2025-09-30
2479	和立	電子工業	twse	2024-12-04
2480	敦陽科	電子工業	twse	2025-09-30
2481	強茂	電子工業	twse	2025-09-30
2482	連宇	電子工業	twse	2025-09-30
2483	百容	電子零組件業	twse	2025-09-30
2484	希華	電子零組件業	twse	2025-09-30
2485	兆赫	電子工業	twse	2025-09-30
2486	一詮	電子工業	twse	2025-09-30
2488	漢平	電子工業	twse	2025-09-30
2489	瑞軒	電子工業	twse	2025-09-25
2491	吉祥全	電子工業	twse	2025-09-30
2492	華新科	電子零組件業	twse	2025-09-30
2493	揚博	電子零組件業	twse	2025-09-30
2494	廣業科	電子工業	twse	2024-12-04
2495	普安	電腦及週邊設備業	twse	2025-09-30
2496	卓越	其他	twse	2025-09-30
2497	怡利電	汽車工業	twse	2025-09-30
2498	宏達電	電子工業	twse	2025-09-30
2499	東貝	電子工業	twse	2025-09-24
2501	國建	建材營造	twse	2025-09-30
2504	國產	建材營造	twse	2025-09-30
2505	國揚	建材營造	twse	2025-09-30
2506	太設	建材營造	twse	2025-09-30
2509	全坤建	建材營造	twse	2025-09-30
2511	太子	建材營造	twse	2025-09-30
2514	龍邦	其他	twse	2025-09-30
2515	中工	建材營造	twse	2025-09-30
2516	新建	建材營造	twse	2025-09-30
2520	冠德	建材營造	twse	2025-09-30
2524	京城	建材營造	twse	2025-09-30
2526	大陸	建材營造	twse	2024-12-04
2527	宏璟	建材營造	twse	2025-09-30
2528	皇普	建材營造	twse	2025-09-30
2530	華建	建材營造	twse	2025-09-30
2534	宏盛	建材營造	twse	2025-09-30
2535	達欣工	建材營造	twse	2025-09-30
2536	宏普	建材營造	twse	2025-09-30
2537	聯上發	建材營造	twse	2025-09-30
2538	基泰	建材營造	twse	2025-09-30
2539	櫻花建	建材營造	twse	2025-09-30
2540	愛山林	建材營造	twse	2025-09-30
2542	興富發	建材營造	twse	2025-09-30
2543	皇昌	建材營造	twse	2025-09-30
2545	皇翔	建材營造	twse	2025-09-30
2546	根基	建材營造	twse	2025-09-30
2547	日勝生	建材營造	twse	2025-09-30
2548	華固	建材營造	twse	2025-09-30
2596	綠意	建材營造	tpex	2025-09-30
2597	潤弘	建材營造	twse	2025-09-30
2601	益航	貿易百貨	twse	2025-09-30
2603	長榮	航運業	twse	2025-09-30
2605	新興	航運業	twse	2025-09-30
2606	裕民	航運業	twse	2025-09-30
2607	榮運	航運業	twse	2025-09-25
2608	嘉里大榮	航運業	twse	2025-09-30
2609	陽明	航運業	twse	2025-09-30
2610	華航	航運業	twse	2025-09-30
2611	志信	航運業	twse	2025-09-30
2612	中航	航運業	twse	2025-09-30
2613	中櫃	航運業	twse	2025-09-30
2614	東森	其他	twse	2025-09-30
2615	萬海	航運業	twse	2025-09-30
2616	山隆	油電燃氣業	twse	2025-09-30
2617	台航	航運業	twse	2025-09-30
2618	長榮航	航運業	twse	2025-09-30
2630	亞航	航運業	twse	2025-09-30
2633	台灣高鐵	航運業	twse	2025-09-30
2634	漢翔	航運業	twse	2025-09-30
2636	台驊控股	航運業	twse	2025-09-30
2637	慧洋-KY	航運業	twse	2025-09-30
2640	大車隊	數位雲端類	tpex	2025-09-30
2641	正德	航運業	tpex	2025-09-30
2642	宅配通	航運業	twse	2025-09-30
2643	捷迅	航運業	tpex	2025-09-30
2644	中信造船	航運業	emerging	2025-09-30
2645	長榮航太	航運業	twse	2025-09-30
2646	星宇航空	航運業	twse	2025-09-30
2701	萬企	觀光餐旅	twse	2025-09-30
2702	華園	觀光餐旅	twse	2025-09-30
2704	國賓	觀光餐旅	twse	2025-09-30
2705	六福	觀光餐旅	twse	2025-09-30
2706	第一店	觀光餐旅	twse	2025-09-30
2707	晶華	觀光餐旅	twse	2025-09-30
2712	遠雄來	觀光餐旅	twse	2025-09-30
2718	全心投控	建材營造	tpex	2025-09-30
2719	燦星旅	觀光餐旅	tpex	2025-09-30
2722	夏都	觀光餐旅	twse	2025-09-30
2723	美食-KY	觀光餐旅	twse	2025-09-30
2724	藝舍-KY	其他	tpex	2025-09-30
2726	雅茗-KY	觀光餐旅	tpex	2025-09-30
2727	王品	觀光餐旅	twse	2025-09-30
2729	瓦城	觀光餐旅	tpex	2025-09-30
2731	雄獅	觀光餐旅	twse	2025-09-30
2732	六角	觀光餐旅	tpex	2025-09-30
2733	維格餅家	觀光餐旅	emerging	2025-09-30
2734	易飛網	觀光餐旅	tpex	2025-09-30
2736	富野	觀光餐旅	tpex	2025-09-30
2739	寒舍	觀光餐旅	twse	2025-09-30
2740	天蔥	觀光餐旅	tpex	2025-09-30
2741	老四川	觀光餐旅	emerging	2025-09-30
2743	山富	觀光餐旅	tpex	2025-09-30
2745	五福	觀光餐旅	tpex	2025-09-30
2748	雲品	觀光餐旅	twse	2025-09-30
2750	桃禧	觀光餐旅	emerging	2025-09-24
2751	王座	觀光餐旅	tpex	2025-09-30
2752	豆府	觀光餐旅	tpex	2025-09-30
2753	八方雲集	觀光餐旅	twse	2025-09-30
2754	亞洲藏壽司	觀光餐旅	tpex	2025-09-30
2755	揚秦	觀光餐旅	tpex	2025-09-30
2756	聯發國際	觀光餐旅	tpex	2025-09-30
2758	路易莎咖啡	觀光餐旅	emerging	2025-09-30
2760	巨宇翔	觀光餐旅	emerging	2025-09-30
2761	橘焱胡同	觀光餐旅	emerging	2025-09-30
2762	世界健身-KY	運動休閒	twse	2025-09-30
2801	彰銀	金融保險	twse	2025-09-30
2807	竹商銀	金融保險	twse	2024-12-04
2809	京城銀	金融保險	twse	2025-09-18
2812	台中銀	金融保險	twse	2025-09-30
2816	旺旺保	金融保險	twse	2025-09-30
2820	華票	金融保險	twse	2025-09-30
2823	中壽	金融保險	twse	2025-09-09
2827	中聯	金融保險	twse	2024-12-04
2831	中華銀	金融保險	twse	2024-12-04
2832	台產	金融保險	twse	2025-09-30
2833	台壽保	金融保險	twse	2024-12-04
2833A	台壽甲	金融保險	twse	2024-12-04
2834	臺企銀	金融保險	twse	2025-09-30
2836	高雄銀	金融保險	twse	2025-09-30
2836A	高雄銀甲特	金融保險	twse	2025-09-30
2837	萬泰銀	金融保險	twse	2024-12-04
2838	聯邦銀	金融保險	twse	2025-09-30
2838A	聯邦銀甲特	金融保險	twse	2025-09-30
2841	台開	建材營造	twse	2025-08-17
2845	遠東銀	金融保險	twse	2025-09-30
2847	大眾銀	金融保險	twse	2024-12-04
2849	安泰銀	金融保險	twse	2025-09-30
2850	新產	金融保險	twse	2025-09-30
2851	中再保	金融保險	twse	2025-09-30
2852	第一保	金融保險	twse	2025-09-30
2854	寶來證	金融保險	twse	2024-12-04
2855	統一證	金融保險	twse	2025-09-30
2856	元富證	金融保險	twse	2025-09-09
2867	三商壽	金融保險	twse	2025-09-30
2880	華南金	金融保險	twse	2025-09-30
2881	富邦金	金融保險	twse	2025-09-30
2881A	富邦特	金融保險	twse	2025-09-30
2881B	富邦金乙特	金融保險	twse	2025-09-30
2881C	富邦金丙特	金融保險	twse	2025-09-30
2882	國泰金	金融保險	twse	2025-09-30
2882A	國泰特	金融保險	twse	2025-09-30
2882B	國泰金乙特	金融保險	twse	2025-09-30
2883	凱基金	金融保險	twse	2025-09-30
2883A	開發特	金融保險	twse	2024-12-04
2883B	凱基金乙特	金融保險	twse	2025-09-30
2884	玉山金	金融保險	twse	2025-09-30
2885	元大金	金融保險	twse	2025-09-30
2886	兆豐金	金融保險	twse	2025-09-30
2887	台新新光金	金融保險	twse	2025-09-30
2887C	新丙特	金融保險	twse	2024-12-04
2887E	台新新光戊特一	金融保險	twse	2025-09-30
2887F	台新新光戊特二	金融保險	twse	2025-09-30
2887G	台新新光庚特一	金融保險	twse	2025-09-30
2887H	台新新光庚特二	金融保險	twse	2025-09-30
2887I	台新新光辛特	金融保險	twse	2025-09-30
2887Z1	台新新光己特	金融保險	twse	2025-09-30
2888	新光金	金融保險	twse	2025-09-09
2888A	新光金甲特	金融保險	twse	2025-07-14
2888B	新光金乙特	金融保險	twse	2025-07-14
2889	國票金	金融保險	twse	2025-09-30
2890	永豐金	金融保險	twse	2025-09-30
2891	中信金	金融保險	twse	2025-09-30
2891A	中信特	金融保險	twse	2024-12-04
2891B	中信金乙特	金融保險	twse	2025-09-30
2891C	中信金丙特	金融保險	twse	2025-09-30
2892	第一金	金融保險	twse	2025-09-30
2897	王道銀行	金融保險	twse	2025-09-30
2897A	王道銀甲特	金融保險	twse	2024-12-04
2897B	王道銀乙特	金融保險	twse	2025-09-30
2901	欣欣	貿易百貨	twse	2025-09-30
2903	遠百	貿易百貨	twse	2025-09-30
2904	匯僑	其他	twse	2025-09-30
2905	三商	貿易百貨	twse	2025-09-30
2906	高林	貿易百貨	twse	2025-09-30
2908	特力	貿易百貨	twse	2025-09-30
2910	統領	貿易百貨	twse	2025-09-30
2911	麗嬰房	貿易百貨	twse	2025-09-30
2912	統一超	貿易百貨	twse	2025-09-30
2913	農林	貿易百貨	twse	2025-09-30
2915	潤泰全	貿易百貨	twse	2025-09-30
2916	滿心	居家生活類	tpex	2025-09-30
2923	鼎固-KY	建材營造	twse	2025-09-30
2924	宏太-KY	居家生活類	tpex	2025-09-30
2926	誠品生活	文化創意業	tpex	2025-09-30
2928	紅馬-KY	觀光事業	tpex	2021-10-16
2929	淘帝-KY	貿易百貨	twse	2025-09-30
2936	客思達-KY	貿易百貨	twse	2025-09-15
2937	集雅社	居家生活類	tpex	2025-09-30
2938	床的世界	居家生活	emerging	2025-09-30
2939	永邑-KY	貿易百貨	twse	2025-09-30
2940	歐都納	運動休閒	emerging	2025-09-30
2941	米斯特	居家生活類	tpex	2025-09-30
2942	京站	居家生活	emerging	2025-09-30
2945	三商家購	貿易百貨	twse	2025-09-30
2947	振宇五金	居家生活類	tpex	2025-09-30
2948	寶陞	居家生活類	tpex	2025-09-30
2949	欣新網	數位雲端類	tpex	2025-09-30
3002	歐格	電腦及週邊設備業	twse	2025-09-30
3003	健和興	電子零組件業	twse	2025-09-30
3004	豐達科	鋼鐵工業	twse	2025-09-30
3005	神基	電腦及週邊設備業	twse	2025-09-30
3006	晶豪科	電子工業	twse	2025-09-30
3007	綠點	電子工業	twse	2024-12-04
3008	大立光	電子工業	twse	2025-09-30
3009	奇美電	電子工業	twse	2024-12-04
3010	華立	電子工業	twse	2025-09-30
3011	今皓	電子工業	twse	2025-09-30
3013	晟銘電	電腦及週邊設備業	twse	2025-09-30
3014	聯陽	電子工業	twse	2025-09-30
3015	全漢	電子零組件業	twse	2025-09-30
3016	嘉晶	電子工業	twse	2025-09-30
3017	奇鋐	電腦及週邊設備業	twse	2025-09-30
3018	隆銘綠能	電子工業	twse	2025-09-30
3019	亞光	電子工業	twse	2025-09-30
3020	奇普仕	電子工業	twse	2024-12-04
3021	鴻名	電子零組件業	twse	2025-09-30
3022	威強電	電腦及週邊設備業	twse	2025-09-30
3023	信邦	電子零組件業	twse	2025-09-30
3024	憶聲	電子工業	twse	2025-09-30
3025	星通	電子工業	twse	2025-09-30
3026	禾伸堂	電子零組件業	twse	2025-09-30
3027	盛達	電子工業	twse	2025-09-30
3028	增你強	電子通路業	twse	2025-09-30
3029	零壹	電子工業	twse	2025-09-30
3030	德律	其他電子業	twse	2025-09-30
3031	佰鴻	電子工業	twse	2025-09-30
3032	偉訓	電子零組件業	twse	2025-09-30
3033	威健	電子通路業	twse	2025-09-30
3034	聯詠	電子工業	twse	2025-09-30
3035	智原	半導體業	twse	2025-09-30
3036	文曄	電子工業	twse	2025-09-30
3036A	文曄甲特	電子工業	twse	2025-09-30
3037	欣興	電子工業	twse	2025-09-30
3038	全台	光電業	twse	2025-09-30
3040	遠見	其他	twse	2025-09-30
3041	揚智	半導體業	twse	2025-09-30
3042	晶技	電子零組件業	twse	2025-09-30
3043	科風	電子工業	twse	2025-09-30
3044	健鼎	電子零組件業	twse	2025-09-30
3045	台灣大	電子工業	twse	2025-09-30
3046	建碁	電腦及週邊設備業	twse	2025-09-30
3047	訊舟	電子工業	twse	2025-09-30
3048	益登	電子工業	twse	2025-09-30
3049	精金	電子工業	twse	2025-09-30
3050	鈺德	電子工業	twse	2025-09-30
3051	力特	電子工業	twse	2025-09-30
3052	夆典	建材營造	twse	2025-09-30
3053	鼎營	其他電子業	twse	2024-12-04
3054	立萬利	食品工業	twse	2025-09-30
3055	蔚華科	電子工業	twse	2025-09-30
3056	富華新	建材營造	twse	2025-09-30
3057	喬鼎	電子工業	twse	2025-09-25
3058	立德	電子工業	twse	2025-09-30
3059	華晶科	電子工業	twse	2025-09-30
3060	銘異	電腦及週邊設備業	twse	2025-09-30
3061	璨圓	電子工業	twse	2024-12-04
3062	建漢	電子工業	twse	2025-09-30
3063	飛信	半導體業	twse	2024-12-04
3064	泰偉	文化創意業	tpex	2025-09-30
3066	李洲	光電業	tpex	2025-09-30
3067	全域	其他電子類	tpex	2025-09-30
3071	協禧	電腦及週邊設備業	tpex	2025-09-30
3073	天方能源	綠能環保類	tpex	2025-09-30
3078	僑威	電子零組件業	tpex	2025-09-30
3080	威力盟	電子工業	twse	2024-12-04
3081	聯亞	通信網路業	tpex	2025-09-30
3083	網龍	文化創意業	tpex	2025-09-30
3085	新零售	數位雲端類	tpex	2025-09-30
3086	華義	文化創意業	tpex	2025-09-30
3088	艾訊	電腦及週邊設備業	tpex	2025-09-30
3089	億杰	電子零組件業	tpex	2023-07-22
3090	日電貿	電子零組件業	twse	2025-09-30
3092	鴻碩	電子零組件業	twse	2025-09-30
3093	港建*	其他電子類	tpex	2025-09-30
3094	聯傑	電子工業	twse	2025-09-30
3095	及成	通信網路業	tpex	2025-09-30
3097	拍檔	電腦及週邊設備業	emerging	2025-09-30
3105	穩懋	半導體業	tpex	2025-09-30
3114	好德	電子零組件業	tpex	2025-09-30
3115	富榮綱	電子零組件業	tpex	2025-09-30
3117	年程	電子零組件業	emerging	2025-09-30
3118	進階	生技醫療業	tpex	2025-09-30
3122	笙泉	半導體業	tpex	2025-09-30
3128	昇銳	光電業	tpex	2025-09-30
3130	一零四	數位雲端	twse	2025-09-30
3131	弘塑	其他電子類	tpex	2025-09-30
3135	凌航	電子工業	twse	2025-09-30
3138	耀登	電子工業	twse	2025-09-30
3141	晶宏	半導體業	tpex	2025-09-30
3142	遠茂	電子工業	twse	2024-12-04
3144	新揚科	電子零組件業	tpex	2021-12-16
3147	大綜	資訊服務業	tpex	2025-09-30
3149	正達	電子工業	twse	2025-09-30
3150	鈺寶-創	電子工業	twse	2025-09-30
3152	璟德	通信網路業	tpex	2025-09-30
3158	嘉實	資訊服務業	emerging	2025-09-30
3162	精確	電機機械	tpex	2025-09-30
3163	波若威	通信網路業	tpex	2025-09-30
3164	景岳	生技醫療業	twse	2025-09-30
3167	大量	電機機械	twse	2025-09-30
3168	眾福科	電子工業	twse	2025-09-30
3169	亞信	半導體業	tpex	2025-09-30
3171	炎洲流通	居家生活類	tpex	2025-09-30
3176	基亞	生技醫療業	tpex	2025-09-30
3178	公準	半導體業	tpex	2025-09-30
3184	微邦	生技醫療業	emerging	2025-09-30
3188	鑫龍騰	建材營造	tpex	2025-09-30
3189	景碩	電子工業	twse	2025-09-30
3191	雲嘉南	電子零組件業	tpex	2025-09-30
3202	樺晟	電子零組件業	tpex	2025-04-05
3205	佰研	生技醫療業	tpex	2025-09-30
3206	志豐	電子零組件業	tpex	2025-09-30
3207	耀勝	電子零組件業	tpex	2025-09-30
3209	全科	電子工業	twse	2025-09-30
3211	順達	電腦及週邊設備業	tpex	2025-09-30
3213	茂訊	電腦及週邊設備業	tpex	2025-09-30
3214	元砷	電子工業	twse	2024-12-04
3217	優群	電子零組件業	tpex	2025-09-30
3218	大學光	生技醫療業	tpex	2025-09-30
3219	倚強科	其他電子類	tpex	2025-09-30
3221	台嘉碩	通信網路業	tpex	2025-09-30
3224	三顧	電子通路業	tpex	2025-09-30
3226	龍鋒	電機機械	tpex	2025-09-30
3227	原相	半導體業	tpex	2025-09-30
3228	金麗科	半導體業	tpex	2025-09-30
3229	晟鈦	電子零組件業	twse	2025-09-30
3230	錦明	光電業	tpex	2025-09-30
3231	緯創	電子工業	twse	2025-09-30
3232	昱捷	電子通路業	tpex	2025-09-30
3234	光環	通信網路業	tpex	2025-09-30
3236	千如	電子零組件業	tpex	2025-09-30
3252	海灣	觀光餐旅	tpex	2025-09-30
3257	虹冠電	電子工業	twse	2025-09-30
3259	鑫創	半導體業	tpex	2025-09-30
3260	威剛	半導體業	tpex	2025-09-30
3264	欣銓	半導體業	tpex	2025-09-30
3265	台星科	半導體業	tpex	2025-09-30
3266	昇陽	建材營造	twse	2025-09-30
3268	海德威	半導體業	tpex	2025-09-30
3271	其樂達	電子工業	twse	2024-12-04
3272	東碩	電腦及週邊設備業	tpex	2025-09-30
3276	宇環	電子零組件業	tpex	2025-09-30
3284	太普高	其他	tpex	2025-09-30
3285	微端	其他電子類	tpex	2025-09-30
3287	廣寰科	電腦及週邊設備業	tpex	2025-09-30
3288	點晶	電子零組件業	tpex	2025-09-30
3289	宜特	其他電子類	tpex	2025-09-30
3290	東浦	電子零組件業	tpex	2025-09-30
3293	鈊象	文化創意業	tpex	2025-09-30
3294	英濟	電子零組件業	tpex	2025-09-30
3296	勝德	電子工業	twse	2025-09-30
3297	杭特	光電業	tpex	2025-09-30
3303	岱稜	其他電子類	tpex	2025-09-30
3305	昇貿	其他電子業	twse	2025-09-30
3306	鼎天	通信網路業	tpex	2025-09-30
3308	聯德	電子零組件業	twse	2025-09-30
3310	佳穎	電子零組件業	tpex	2025-09-30
3311	閎暉	電子工業	twse	2025-09-30
3312	弘憶股	電子通路業	twse	2025-09-30
3313	斐成	其他	tpex	2025-09-30
3315	宣昶	電子通路業	twse	2025-05-28
3317	尼克森	半導體業	tpex	2025-09-30
3321	同泰	電子零組件業	twse	2025-09-30
3322	建舜電	電子零組件業	tpex	2025-09-30
3323	加百裕	電腦及週邊設備業	tpex	2025-09-30
3324	雙鴻	其他電子類	tpex	2025-09-30
3325	旭品	電腦及週邊設備業	tpex	2025-09-30
3332	幸康	電子零組件業	tpex	2025-09-30
3338	泰碩	電子零組件業	twse	2025-09-30
3339	泰谷	光電業	tpex	2025-09-30
3346	麗清	汽車工業	twse	2025-09-30
3349	寶德	電腦及週邊設備業	tpex	2025-09-30
3354	律勝	電子零組件業	tpex	2025-09-30
3356	奇偶	光電業	twse	2025-09-30
3357	臺慶科	電子零組件業	tpex	2025-09-30
3360	尚立	電子通路業	tpex	2025-09-30
3362	先進光	光電業	tpex	2025-09-30
3363	上詮	通信網路業	tpex	2025-09-30
3367	英華達	電子工業	twse	2024-12-04
3372	典範	半導體業	tpex	2025-09-30
3373	熱映	其他電子類	tpex	2025-09-30
3374	精材	半導體業	tpex	2025-09-30
3376	新日興	電子零組件業	twse	2025-09-30
3379	彬台	電機機械	tpex	2025-09-30
3380	明泰	電子工業	twse	2025-09-30
3383	新世紀	電子工業	twse	2025-09-24
3388	崇越電	電子零組件業	tpex	2025-09-30
3390	旭軟	電子零組件業	tpex	2025-09-30
3402	漢科	其他電子類	tpex	2025-09-30
3406	玉晶光	電子工業	twse	2025-09-30
3413	京鼎	電子工業	twse	2025-09-30
3416	融程電	電腦及週邊設備業	twse	2025-09-30
3419	譁裕	電子工業	twse	2025-09-30
3426	台興	電機機械	tpex	2025-09-30
3430	奇鈦科	化學工業	tpex	2025-09-30
3432	台端	電子零組件業	twse	2025-09-30
3434	哲固	光電業	tpex	2025-09-30
3437	榮創	電子工業	twse	2025-09-30
3438	類比科	半導體業	tpex	2025-09-30
3441	聯一光	光電業	tpex	2025-09-30
3443	創意	電子工業	twse	2025-09-30
3444	利機	電子通路業	tpex	2025-09-30
3447	展達	電子工業	twse	2025-09-30
3450	聯鈞	電子工業	twse	2025-09-30
3454	晶睿	電子工業	twse	2025-09-30
3455	由田	光電業	tpex	2025-09-30
3465	進泰電子	其他電子類	tpex	2025-09-30
3466	德晉	通信網路業	tpex	2025-09-30
3467	台灣精材	半導體業	tpex	2025-09-30
3473	智通聯網	通信網路業	emerging	2025-09-30
3474	華亞科	電子工業	twse	2024-12-04
3479	安勤	電腦及週邊設備業	tpex	2025-09-30
3481	群創	電子工業	twse	2025-09-30
3483	力致	電腦及週邊設備業	tpex	2025-09-30
3484	崧騰	電子零組件業	tpex	2025-09-30
3485	敘豐	光電業	emerging	2025-09-30
3489	森寶	建材營造	tpex	2025-09-30
3490	單井	光電業	tpex	2025-09-30
3491	昇達科	通信網路業	tpex	2025-09-30
3492	長盛	電子零組件業	tpex	2025-09-30
3494	誠研	電子工業	twse	2025-09-30
3498	陽程	其他電子類	tpex	2025-09-30
3499	環天科	通信網路業	tpex	2025-09-30
3501	維熹	電子零組件業	twse	2025-09-30
3504	揚明光	電子工業	twse	2025-09-30
3508	位速	其他電子類	tpex	2025-09-30
3511	矽瑪	電子零組件業	tpex	2025-09-30
3512	皇龍	建材營造	tpex	2025-09-30
3514	昱晶	電子工業	twse	2025-09-24
3515	華擎	電腦及週邊設備業	twse	2025-09-30
3516	亞帝歐	光電業	tpex	2025-09-30
3518	柏騰	電子工業	twse	2025-09-30
3519	綠能	電子工業	twse	2025-09-24
3520	華盈	電子零組件業	tpex	2025-09-30
3521	鴻翊	建材營造	tpex	2025-09-30
3522	御嵿	觀光餐旅	tpex	2025-09-30
3523	迎輝	光電業	tpex	2025-09-30
3526	凡甲	電子零組件業	tpex	2025-09-30
3527	聚積	半導體業	tpex	2025-09-30
3528	安馳	電子通路業	twse	2025-09-30
3529	力旺	半導體業	tpex	2025-09-30
3530	晶相光	半導體業	twse	2025-09-30
3531	先益	光電業	tpex	2025-09-30
3532	台勝科	電子工業	twse	2025-09-30
3533	嘉澤	電子零組件業	twse	2025-09-30
3534	雷凌	半導體業	twse	2024-12-04
3535	晶彩科	電子工業	twse	2025-09-30
3536	誠創	電子工業	twse	2025-09-24
3537	堡達	電子零組件業	tpex	2025-09-30
3540	曜越	電腦及週邊設備業	tpex	2025-09-30
3541	西柏	其他電子類	tpex	2025-09-30
3543	州巧	電子工業	twse	2025-09-30
3545	敦泰	電子工業	twse	2025-09-30
3546	宇峻	文化創意業	tpex	2025-09-30
3548	兆利	電子零組件業	tpex	2025-09-30
3550	聯穎	電子零組件業	twse	2025-09-30
3551	世禾	綠能環保類	tpex	2025-09-30
3552	同致	其他電子類	tpex	2025-09-30
3555	博士旺	半導體業	tpex	2025-09-30
3556	禾瑞亞	半導體業	tpex	2025-09-30
3557	嘉威	居家生活	twse	2025-09-30
3558	神準	通信網路業	tpex	2025-09-30
3559	全智科	電子工業	twse	2025-05-14
3561	昇陽光電	電子工業	twse	2025-09-24
3563	牧德	光電業	twse	2025-09-30
3564	其陽	通信網路業	tpex	2025-09-30
3567	逸昌	半導體業	tpex	2025-09-30
3570	大塚	資訊服務業	tpex	2025-09-30
3573	穎台	電子工業	twse	2024-12-04
3576	聯合再生	電子工業	twse	2025-09-30
3577	泓格	電腦及週邊設備業	tpex	2025-09-30
3579	尚志	電子工業	twse	2025-09-24
3580	友威科	其他電子類	tpex	2025-09-30
3581	博磊	半導體業	tpex	2025-09-30
3583	辛耘	電子工業	twse	2025-09-30
3584	介面	電子工業	twse	2024-12-04
3585	聯致	電子零組件業	emerging	2025-09-30
3587	閎康	其他電子類	tpex	2025-09-30
3588	通嘉	電子工業	twse	2025-09-30
3591	艾笛森	電子工業	twse	2025-09-30
3592	瑞鼎	電子工業	twse	2025-09-30
3593	力銘	電子零組件業	twse	2025-09-30
3594	磐儀	電腦及週邊設備業	tpex	2025-09-30
3595	山太士	光電業	emerging	2025-09-30
3596	智易	電子工業	twse	2025-09-30
3597	映興	電子零組件業	tpex	2025-09-30
3598	奕力	電子工業	twse	2024-12-04
3599	旺能	電子工業	twse	2024-12-04
3603	建祥國際	電子通路業	emerging	2025-09-30
3605	宏致	電子零組件業	twse	2025-09-30
3607	谷崧	電子工業	twse	2025-09-30
3609	三一東林	電子零組件業	tpex	2025-09-30
3611	鼎翰	電腦及週邊設備業	tpex	2025-09-30
3614	誠致	電子工業	twse	2024-12-04
3615	安可	光電業	tpex	2025-09-30
3616	泓辰	電機機械	emerging	2025-09-30
3617	碩天	電子工業	twse	2025-09-30
3622	洋華	電子工業	twse	2025-09-30
3623	富晶通	光電業	tpex	2025-09-30
3624	光頡	電子零組件業	tpex	2025-09-30
3625	西勝	電腦及週邊設備業	tpex	2025-09-30
3627	華信科	光電業	emerging	2024-04-29
3628	盈正	其他電子類	tpex	2025-09-30
3629	地心引力	文化創意業	tpex	2025-09-30
3630	新鉅科	光電業	tpex	2025-09-30
3631	晟楠	電子零組件業	tpex	2025-09-30
3632	研勤	通信網路業	tpex	2025-09-30
3633	云光	光電業	emerging	2025-09-30
3638	F-IML	半導體業	twse	2024-12-04
3642	駿熠電	其他電子類	tpex	2022-11-19
3645	達邁	電子零組件業	twse	2025-09-30
3646	艾恩特	電子零組件業	tpex	2025-09-30
3652	精聯	電腦及週邊設備業	twse	2025-09-30
3653	健策	電子零組件業	twse	2025-09-30
3659	百辰	光電業	emerging	2025-09-30
3661	世芯-KY	半導體業	twse	2025-09-30
3663	鑫科	其他電子類	tpex	2025-09-30
3664	安瑞-KY	通信網路業	tpex	2025-09-30
3665	貿聯-KY	電子工業	twse	2025-09-30
3666	光耀	光電業	tpex	2025-09-30
3669	圓展	電子工業	twse	2025-09-30
3672	康聯訊	通信網路業	tpex	2025-09-30
3673	TPK-KY	電子工業	twse	2025-09-30
3675	德微	半導體業	tpex	2025-09-30
3678	聯享	光電業	emerging	2025-09-30
3679	新至陞	電子零組件業	twse	2025-09-30
3680	家登	半導體業	tpex	2025-09-30
3682	亞太電	電子工業	twse	2025-09-24
3684	榮昌	通信網路業	tpex	2025-09-30
3685	元創精密	電機機械	tpex	2025-09-30
3686	達能	電子工業	twse	2025-09-30
3687	歐買尬	數位雲端類	tpex	2025-09-30
3689	湧德	電子零組件業	tpex	2025-09-30
3691	碩禾	光電業	tpex	2025-09-30
3693	營邦	電腦及週邊設備業	tpex	2025-09-30
3694	海華	電子工業	twse	2025-09-30
3697	F-晨星	半導體業	twse	2024-12-04
3698	隆達	電子工業	twse	2025-09-24
3701	大眾控	電腦及週邊設備業	twse	2025-09-30
3702	大聯大	電子通路業	twse	2025-09-30
3702A	大聯大甲特	電子工業	twse	2025-08-21
3703	欣陸	建材營造	twse	2025-09-30
3704	合勤控	電子工業	twse	2025-09-30
3705	永信	生技醫療業	twse	2025-09-30
3706	神達	電腦及週邊設備業	twse	2025-09-30
3707	漢磊	半導體業	tpex	2025-09-30
3708	上緯投控	綠能環保	twse	2025-09-30
3709	鑫聯大投控	電腦及週邊設備業	tpex	2025-09-30
3710	連展投控	電子零組件業	tpex	2025-09-30
3711	日月光投控	半導體業	twse	2025-09-30
3712	永崴投控	電子工業	twse	2025-09-30
3713	新晶投控	綠能環保類	tpex	2025-09-30
3714	富采	電子工業	twse	2025-09-30
3715	定穎投控	電子零組件業	twse	2025-09-30
3716	中化控股	生技醫療業	twse	2025-09-30
3717	聯嘉投控	汽車工業	twse	2025-09-30
4102	永日	生技醫療業	tpex	2025-09-30
4104	佳醫	化學生技醫療	twse	2025-09-30
4105	東洋	生技醫療業	tpex	2025-09-30
4106	雃博	化學生技醫療	twse	2025-09-30
4107	邦特	生技醫療業	tpex	2025-09-30
4108	懷特	生技醫療業	twse	2025-09-30
4109	加捷生醫	生技醫療業	tpex	2025-09-30
4111	濟生	生技醫療業	tpex	2025-09-30
4113	聯上	建材營造	tpex	2025-09-30
4114	健喬	生技醫療業	tpex	2025-09-30
4115	善德生技	生技醫療業	emerging	2025-09-30
4116	明基醫	生技醫療業	tpex	2025-09-30
4117	普生	生技醫療業	emerging	2025-09-30
4119	旭富	生技醫療業	twse	2025-09-30
4120	友華	生技醫療業	tpex	2025-09-30
4121	優盛	生技醫療業	tpex	2025-09-30
4123	晟德	生技醫療業	tpex	2025-09-30
4126	太醫	生技醫療業	tpex	2025-09-30
4127	天良	生技醫療業	tpex	2025-09-30
4128	中天	生技醫療業	tpex	2025-09-30
4129	聯合	生技醫療業	tpex	2025-09-30
4129A	聯合甲特	生技醫療業	tpex	2023-08-10
4130	健亞	生技醫療業	tpex	2025-09-30
4131	浩泰	生技醫療業	tpex	2025-09-30
4132	國鼎	生技醫療業	emerging	2025-09-30
4133	亞諾法	生技醫療業	twse	2025-09-30
4137	麗豐-KY	生技醫療業	twse	2025-09-30
4138	曜亞	生技醫療業	tpex	2025-09-30
4139	馬光-KY	生技醫療業	tpex	2025-09-30
4141	龍燈-KY	生技醫療業	twse	2025-09-03
4142	國光生	生技醫療業	twse	2025-09-30
4144	康聯-KY	生技醫療業	twse	2025-09-03
4147	中裕	生技醫療業	tpex	2025-09-30
4148	全宇生技-KY	生技醫療業	twse	2025-09-30
4150	優你康	生技醫療業	emerging	2025-09-30
4152	台微體	生技醫療業	tpex	2021-10-02
4153	鈺緯	生技醫療業	tpex	2025-09-30
4154	樂威科-KY	其他	tpex	2025-09-30
4155	訊映	生技醫療業	twse	2025-09-30
4157	太景*-KY	生技醫療業	tpex	2025-09-30
4160	訊聯基因	生技醫療業	tpex	2025-09-30
4161	聿新科	生技醫療業	tpex	2025-09-30
4162	智擎	生技醫療業	tpex	2025-09-30
4163	鐿鈦	生技醫療業	tpex	2025-09-30
4164	承業醫	生技醫療業	twse	2025-09-30
4166	友霖	生技醫療業	tpex	2025-09-30
4167	松瑞藥	生技醫療業	tpex	2025-09-30
4168	醣聯	生技醫療業	tpex	2025-09-30
4169	泰宗	生技醫療業	emerging	2025-09-30
4170	鑫品生醫	生技醫療業	emerging	2025-09-30
4171	瑞基	農業科技業	tpex	2025-09-30
4172	因華	生技醫療業	emerging	2025-09-30
4173	久裕	生技醫療業	tpex	2025-09-30
4174	浩鼎	生技醫療業	tpex	2025-09-30
4175	杏一	生技醫療業	tpex	2025-09-30
4178	永笙-KY	生技醫療業	emerging	2025-09-30
4183	福永生技	生技醫療業	tpex	2025-09-30
4186	尖端醫	生技醫療業	emerging	2025-09-30
4188	安克	生技醫療業	tpex	2025-09-30
4190	佐登-KY	生技醫療業	twse	2025-09-30
4192	杏國	生技醫療業	tpex	2025-09-30
4194	禾生技	生技醫療業	emerging	2025-09-30
4195	基米	生技醫療業	emerging	2025-09-30
4197	暐世	生技醫療業	emerging	2025-09-30
4198	欣大健康	生技醫療業	tpex	2025-09-30
4205	中華食	食品工業	tpex	2025-09-30
4207	環泰	食品工業	tpex	2025-09-30
4303	信立	塑膠工業	tpex	2025-09-30
4304	勝昱	塑膠工業	tpex	2025-09-30
4305	世坤	塑膠工業	tpex	2025-09-30
4306	炎洲	塑膠工業	twse	2025-09-30
4401	東隆興	紡織纖維	tpex	2025-09-30
4402	郡都開發	紡織纖維	tpex	2025-09-30
4406	新昕纖	紡織纖維	tpex	2025-09-30
4413	飛寶企業	紡織纖維	tpex	2025-09-30
4414	如興	紡織纖維	twse	2025-09-30
4416	三圓	建材營造	tpex	2025-09-30
4417	金洲	紡織纖維	tpex	2025-09-30
4419	皇家美食	觀光餐旅	tpex	2025-09-30
4420	光明	紡織纖維	tpex	2025-09-30
4426	利勤	紡織纖維	twse	2025-09-30
4429	聚紡	紡織纖維	tpex	2022-05-27
4430	耀億	其他	tpex	2025-09-30
4431	敏成健康	其他	emerging	2025-09-30
4432	銘旺實	紡織纖維	tpex	2025-09-30
4433	興采	紡織纖維	tpex	2025-09-30
4438	廣越	紡織纖維	twse	2025-09-30
4439	冠星-KY	紡織纖維	twse	2025-09-30
4440	宜新實業	紡織纖維	twse	2025-09-30
4441	振大環球	紡織纖維	twse	2025-09-30
4442	竣邦-KY	紡織纖維	tpex	2025-09-30
4502	健信	電機機械	tpex	2025-09-30
4503	金雨	電機機械	tpex	2025-09-30
4506	崇友	電機機械	tpex	2025-09-30
4510	高鋒	電機機械	tpex	2025-09-30
4513	福裕	電機機械	tpex	2025-09-30
4523	永彰	電機機械	tpex	2025-09-30
4526	東台	電機機械	twse	2025-09-30
4527	方土霖	電機機械	tpex	2025-09-30
4528	江興鍛	電機機械	tpex	2025-09-30
4529	淳紳	其他	tpex	2025-09-30
4530	宏易	觀光餐旅	tpex	2025-09-30
4532	瑞智	電機機械	twse	2025-09-30
4533	協易機	電機機械	tpex	2025-09-30
4534	慶騰	電機機械	tpex	2025-09-30
4535	至興	電機機械	tpex	2025-09-30
4536	拓凱	運動休閒	twse	2025-09-30
4537	旭東	光電業	emerging	2025-09-30
4538	大詠城	電機機械	tpex	2025-09-30
4540	全球傳動	電機機械	twse	2025-09-30
4541	晟田	其他	tpex	2025-09-30
4542	科嶠	電子零組件業	tpex	2025-09-30
4543	萬在	電機機械	tpex	2025-09-30
4544	春日	電機機械	emerging	2025-09-30
4545	銘鈺	電子零組件業	twse	2025-09-30
4546	長亨	電機機械	emerging	2025-09-30
4549	桓達	電機機械	tpex	2025-09-30
4550	長佳	電機機械	tpex	2025-09-30
4551	智伸科	汽車工業	twse	2025-09-30
4552	力達-KY	電機機械	twse	2025-09-30
4553	盛復	電機機械	emerging	2025-09-30
4554	橙的	其他電子類	tpex	2025-09-30
4555	氣立	電機機械	twse	2025-09-30
4556	旭然	其他	tpex	2025-09-30
4557	永新-KY	汽車工業	twse	2025-09-30
4558	寶緯	電機機械	tpex	2025-09-30
4559	久裕興	運動休閒	emerging	2025-09-30
4560	強信-KY	電機機械	twse	2025-09-30
4561	健椿	電機機械	tpex	2025-09-30
4562	穎漢	電機機械	twse	2025-09-30
4563	百德	電機機械	tpex	2025-09-30
4564	元翎	電機機械	twse	2025-09-30
4565	宏偉	電機機械	emerging	2025-09-30
4566	時碩工業	電機機械	twse	2025-09-30
4568	科際精密	電機機械	tpex	2025-09-30
4569	六方科-KY	汽車工業	twse	2025-09-30
4570	傑生	電機機械	emerging	2025-09-30
4571	鈞興-KY	電機機械	twse	2025-09-30
4572	駐龍	電機機械	twse	2025-09-30
4573	高明鐵	電機機械	emerging	2025-09-30
4575	銓寶	電機機械	emerging	2025-09-30
4576	大銀微系統	電機機械	twse	2025-09-30
4577	達航科技	其他電子類	tpex	2025-09-30
4578	總格精密	電機機械	emerging	2024-04-25
4580	捷流閥業	電機機械	tpex	2025-09-30
4581	光隆精密-KY	汽車工業	twse	2025-09-30
4582	聚恆	綠能環保	emerging	2025-09-30
4583	台灣精銳	電機機械	twse	2025-09-30
4584	君帆	電機機械	tpex	2025-09-30
4585	達明	其他電子業	twse	2025-09-30
4587	寶元數控	電機機械	emerging	2025-09-30
4588	玖鼎電力	電子工業	twse	2025-09-30
4589	碩陽電機	電機機械	emerging	2025-09-30
4590	富田	電機機械	emerging	2025-09-30
4609	唐鋒	居家生活類	tpex	2025-09-30
4702	中美實	居家生活類	tpex	2025-09-30
4706	大恭	化學工業	tpex	2025-09-30
4707	磐亞	化學工業	tpex	2025-09-30
4711	永純	化學工業	tpex	2025-09-30
4712	南璋	食品工業	tpex	2024-02-08
4714	永捷	化學工業	tpex	2025-09-30
4716	大立	化學工業	tpex	2025-09-30
4720	德淵	化學工業	twse	2025-09-30
4721	美琪瑪	化學工業	tpex	2025-09-30
4722	國精化	化學生技醫療	twse	2025-09-30
4724	宣捷幹細胞	生技醫療業	emerging	2025-09-30
4725	信昌化	化學工業	twse	2025-09-24
4726	永昕	生技醫療業	tpex	2025-09-30
4728	雙美	生技醫療業	tpex	2025-09-30
4729	熒茂	光電業	tpex	2025-09-30
4732	彥臣	生技醫療業	emerging	2025-09-30
4733	上緯	化學生技醫療	twse	2024-12-03
4735	豪展	生技醫療業	tpex	2025-09-30
4736	泰博	生技醫療業	twse	2025-09-30
4737	華廣	生技醫療業	twse	2025-09-30
4738	大同精化	化學工業	emerging	2025-09-30
4739	康普	化學生技醫療	twse	2025-09-30
4741	泓瀚	化學工業	tpex	2025-09-30
4743	合一	生技醫療業	tpex	2025-09-30
4744	皇將	生技醫療業	tpex	2025-09-30
4745	合富-KY	生技醫療業	tpex	2025-09-30
4746	台耀	生技醫療業	twse	2025-09-30
4747	強生	生技醫療業	tpex	2025-09-30
4749	新應材	半導體業	tpex	2025-09-30
4754	國碳科	化學工業	tpex	2025-09-30
4755	三福化	化學工業	twse	2025-09-30
4760	勤凱	其他電子類	tpex	2025-09-30
4763	材料*-KY	化學生技醫療	twse	2025-09-30
4764	雙鍵	化學生技醫療	twse	2025-09-30
4765	磐采	化學工業	emerging	2025-09-30
4766	南寶	化學生技醫療	twse	2025-09-30
4767	誠泰科技	化學工業	tpex	2025-09-30
4768	晶呈科技	化學工業	tpex	2025-09-30
4770	上品	化學生技醫療	twse	2025-09-30
4771	望隼	生技醫療業	twse	2025-09-30
4772	台特化	化學工業	tpex	2025-09-30
4773	高福	化學工業	emerging	2025-09-30
4803	VHQ-KY	文化創意業	tpex	2021-12-18
4804	大略-KY	觀光餐旅	tpex	2025-09-30
4806	桂田文創	文化創意業	tpex	2025-09-27
4807	日成-KY	貿易百貨	twse	2025-09-30
4903	聯光通	通信網路業	tpex	2025-09-30
4904	遠傳	電子工業	twse	2025-09-30
4905	台聯電	通信網路業	tpex	2025-09-30
4906	正文	通信網路業	twse	2025-09-30
4907	富宇	建材營造	tpex	2025-09-30
4908	前鼎	通信網路業	tpex	2025-09-30
4909	新復興	通信網路業	tpex	2025-09-30
4911	德英	生技醫療業	tpex	2025-09-30
4912	聯德控股-KY	電子零組件業	twse	2025-09-30
4915	致伸	電子零組件業	twse	2025-09-30
4916	事欣科	電腦及週邊設備業	twse	2025-09-30
4919	新唐	電子工業	twse	2025-09-30
4923	力士	半導體業	tpex	2025-09-30
4924	欣厚-KY	電腦及週邊設備業	tpex	2025-09-30
4925	智微	半導體業	emerging	2025-09-30
4927	泰鼎-KY	電子零組件業	twse	2025-09-30
4930	燦星網	電器電纜	twse	2025-09-30
4931	新盛力	電腦及週邊設備業	tpex	2025-09-30
4933	友輝	光電業	tpex	2025-09-30
4934	太極	電子工業	twse	2025-09-30
4935	茂林-KY	電子工業	twse	2025-09-30
4938	和碩	電子工業	twse	2025-09-30
4939	亞電	電子零組件業	tpex	2025-09-30
4942	嘉彰	電子工業	twse	2025-09-30
4943	康控-KY	電子零組件業	twse	2025-09-30
4944	兆遠	光電業	tpex	2023-10-27
4945	陞達科技	半導體業	tpex	2025-09-04
4946	辣椒	文化創意業	tpex	2025-09-30
4949	有成精密	電子工業	twse	2025-09-30
4950	金耘國際	鋼鐵工業	tpex	2025-09-30
4951	精拓科	半導體業	tpex	2025-09-30
4952	凌通	電子工業	twse	2025-09-30
4953	緯軟	資訊服務業	tpex	2025-09-30
4956	光鋐	電子工業	twse	2025-09-30
4958	臻鼎-KY	電子零組件業	twse	2025-09-30
4960	誠美材	電子工業	twse	2025-09-30
4961	天鈺	電子工業	twse	2025-09-30
4966	譜瑞-KY	半導體業	tpex	2025-09-30
4967	十銓	半導體業	twse	2025-09-30
4968	立積	半導體業	twse	2025-09-30
4971	IET-KY	半導體業	tpex	2025-09-30
4972	湯石照明	光電業	tpex	2025-09-30
4973	廣穎	半導體業	tpex	2025-09-30
4974	亞泰	電子零組件業	tpex	2025-09-30
4976	佳凌	電子工業	twse	2025-09-30
4977	眾達-KY	電子工業	twse	2025-09-30
4979	華星光	通信網路業	tpex	2025-09-30
4980	佐臻	電子零組件業	emerging	2025-09-30
4984	科納-KY	電子工業	twse	2025-09-24
4987	科誠	電腦及週邊設備業	tpex	2025-09-30
4989	榮科	電子零組件業	twse	2025-09-30
4991	環宇-KY	半導體業	tpex	2025-09-30
4994	傳奇	電子工業	twse	2025-09-30
4995	晶達	光電業	tpex	2025-09-30
4999	鑫禾	電子零組件業	twse	2025-09-30
5007	三星	鋼鐵工業	twse	2025-09-30
5009	榮剛	鋼鐵工業	tpex	2025-09-30
5011	久陽	鋼鐵工業	tpex	2025-09-30
5013	強新	鋼鐵工業	tpex	2025-09-30
5014	建錩	鋼鐵工業	tpex	2025-09-30
5015	華祺	鋼鐵工業	tpex	2025-09-30
5016	松和	鋼鐵工業	tpex	2025-09-30
5102	富強	橡膠工業	tpex	2022-07-09
5201	凱衛	資訊服務業	tpex	2025-09-30
5202	力新	資訊服務業	tpex	2025-09-30
5203	訊連	電子工業	twse	2025-09-30
5205	中茂	綠能環保類	tpex	2025-09-30
5206	坤悅	建材營造	tpex	2025-09-30
5209	新鼎	其他	tpex	2025-09-30
5210	寶碩	資訊服務業	tpex	2025-09-30
5211	蒙恬	資訊服務業	tpex	2025-09-30
5212	凌網	資訊服務業	tpex	2025-09-30
5213	亞昕	建材營造	tpex	2025-09-30
5215	科嘉-KY	電腦及週邊設備業	twse	2025-09-30
5220	萬達光電	光電業	tpex	2025-09-30
5222	全訊	電子工業	twse	2025-09-30
5223	安力-KY	電腦及週邊設備業	tpex	2025-09-30
5225	東科-KY	電子工業	twse	2025-09-30
5227	立凱-KY	電子零組件業	tpex	2025-09-30
5228	鈺鎧	電子零組件業	tpex	2025-09-30
5230	雷笛克光學	光電業	tpex	2025-09-30
5233	有量	其他電子業	emerging	2024-08-13
5234	達興材料	光電業	twse	2025-09-30
5236	凌陽創新	半導體業	tpex	2025-09-30
5240	建騰	光電業	emerging	2025-09-30
5243	乙盛-KY	電子工業	twse	2025-09-30
5244	弘凱	電子工業	twse	2025-09-30
5245	智晶	光電業	tpex	2025-09-30
5246	勵威	半導體業	emerging	2025-09-30
5248	景傳	光電業	emerging	2025-09-30
5251	天鉞電	光電業	tpex	2025-09-30
5254	欣訊科技	電子零組件業	emerging	2025-09-30
5258	虹堡	電腦及週邊設備業	twse	2025-09-30
5259	奕智博	電子工業	twse	2025-09-24
5262	立達	半導體業	emerging	2025-09-30
5263	智崴	文化創意業	tpex	2025-09-30
5264	鎧勝-KY	電子工業	twse	2025-09-24
5267	龍翩	光電業	emerging	2025-09-30
5269	祥碩	電子工業	twse	2025-09-30
5271	紘通	電子零組件業	emerging	2025-09-30
5272	笙科	半導體業	tpex	2025-09-30
5274	信驊	半導體業	tpex	2025-09-30
5276	達輝-KY	其他	tpex	2025-09-30
5277	葳天	光電業	emerging	2025-07-24
5278	尚凡*	數位雲端類	tpex	2025-09-30
5280	F-敦泰	半導體業	twse	2024-12-04
5281	大峽谷-KY	光電業	tpex	2023-10-27
5283	禾聯碩	電器電纜	twse	2025-09-30
5284	jpp-KY	其他	twse	2025-09-30
5285	界霖	電子工業	twse	2025-09-30
5287	數字	數位雲端類	tpex	2025-09-30
5288	豐祥-KY	電機機械	twse	2025-09-30
5289	宜鼎	電腦及週邊設備業	tpex	2025-09-30
5291	邑昇	電子零組件業	tpex	2025-09-30
5292	華懋	綠能環保	twse	2025-09-30
5297	廣化	半導體業	emerging	2025-09-30
5299	杰力	半導體業	tpex	2025-09-30
5301	寶得利	觀光餐旅	tpex	2025-09-30
5302	太欣	半導體業	tpex	2025-09-30
5304	鼎創達	電腦及週邊設備業	tpex	2020-11-22
5305	敦南	電子工業	twse	2025-09-24
5306	桂盟	運動休閒	twse	2025-09-30
5309	系統電	電子零組件業	tpex	2025-09-30
5310	天剛	資訊服務業	tpex	2025-09-30
5312	寶島科	生技醫療業	tpex	2025-09-30
5314	世紀*	其他	tpex	2025-09-30
5315	光聯	光電業	tpex	2025-09-30
5321	美而快	數位雲端類	tpex	2025-09-30
5324	士開	建材營造	tpex	2025-09-30
5328	華容	電子零組件業	tpex	2025-09-30
5340	建榮	電子零組件業	tpex	2025-09-30
5344	立衛	半導體業	tpex	2025-09-30
5345	馥鴻	其他	tpex	2025-09-30
5347	世界	半導體業	tpex	2025-09-30
5348	正能量智能	運動休閒類	tpex	2025-09-30
5349	先豐	電子零組件業	tpex	2020-10-31
5351	鈺創	半導體業	tpex	2025-09-30
5353	台林	通信網路業	tpex	2025-09-30
5355	佳總	電子零組件業	tpex	2025-09-30
5356	協益	電腦及週邊設備業	tpex	2025-09-30
5364	力麗店	觀光餐旅	tpex	2025-09-30
5371	中光電	光電業	tpex	2025-09-30
5381	合正	電子零組件業	tpex	2025-09-30
5383	金利	其他電子類	tpex	2024-05-25
5386	青雲	電腦及週邊設備業	tpex	2025-09-30
5388	中磊	電子工業	twse	2025-09-30
5392	能率	光電業	tpex	2025-09-30
5398	慕康生醫	其他	tpex	2025-09-30
5403	中菲	資訊服務業	tpex	2025-09-30
5410	國眾	資訊服務業	tpex	2025-09-30
5425	台半	半導體業	tpex	2025-09-30
5426	振發	電腦及週邊設備業	tpex	2025-09-30
5432	新門	綠能環保類	tpex	2025-09-30
5434	崇越	電子通路業	twse	2025-09-30
5438	東友	電腦及週邊設備業	tpex	2025-09-30
5439	高技	電子零組件業	tpex	2025-09-30
5443	均豪	半導體業	tpex	2025-09-30
5450	南良	其他	tpex	2025-09-30
5452	佶優	其他電子類	tpex	2025-09-30
5455	昇益	建材營造	tpex	2025-09-30
5457	宣德	電子零組件業	tpex	2025-09-30
5460	同協	電子零組件業	tpex	2025-09-30
5464	霖宏	電子零組件業	tpex	2025-09-30
5465	富驊	電腦及週邊設備業	tpex	2025-09-30
5468	凱鈺	半導體業	tpex	2025-09-30
5469	瀚宇博	電子零組件業	twse	2025-09-30
5471	松翰	電子工業	twse	2025-09-30
5474	聰泰	電腦及週邊設備業	tpex	2025-09-30
5475	德宏	電子零組件業	tpex	2025-09-30
5478	智冠	文化創意業	tpex	2025-09-30
5481	新華	其他	tpex	2025-09-30
5483	中美晶	半導體業	tpex	2025-09-30
5484	慧友	電子工業	twse	2025-09-30
5487	通泰	半導體業	tpex	2025-09-30
5488	松普	電子零組件業	tpex	2025-09-30
5489	彩富	其他電子類	tpex	2025-09-30
5490	同亨	電腦及週邊設備業	tpex	2025-09-30
5493	三聯	其他電子類	tpex	2025-09-30
5498	凱崴	電子零組件業	tpex	2025-09-30
5508	永信建	建材營造	tpex	2025-09-30
5511	德昌	建材營造	tpex	2025-09-30
5512	力麒	建材營造	tpex	2025-09-30
5514	三豐	建材營造	tpex	2025-09-30
5515	建國	建材營造	twse	2025-09-30
5516	雙喜	建材營造	tpex	2025-09-30
5519	隆大	建材營造	twse	2025-09-30
5520	力泰	建材營造	tpex	2025-09-30
5521	工信	建材營造	twse	2025-09-30
5522	遠雄	建材營造	twse	2025-09-30
5523	豐謙	建材營造	tpex	2025-09-30
5525	順天	建材營造	twse	2025-09-30
5529	鉅陞	建材營造	tpex	2025-09-30
5530	龍巖	其他	tpex	2025-09-30
5531	鄉林	建材營造	twse	2025-09-30
5533	皇鼎	建材營造	twse	2025-09-30
5534	長虹	建材營造	twse	2025-09-30
5536	聖暉*	其他電子類	tpex	2025-09-30
5538	東明-KY	鋼鐵工業	twse	2025-09-30
5543	桓鼎-KY	建材營造	tpex	2025-09-30
5546	永固-KY	建材營造	twse	2025-09-30
5547	久舜	建材營造	emerging	2025-09-30
5548	安倉	建材營造	tpex	2025-09-30
5601	台聯櫃	航運業	tpex	2025-09-30
5603	陸海	航運業	tpex	2025-09-30
5604	中連	其他	tpex	2025-09-30
5607	遠雄港	航運業	twse	2025-09-30
5608	四維航	航運業	twse	2025-09-30
5609	中菲行	航運業	tpex	2025-09-30
5701	劍湖山	觀光餐旅	tpex	2025-09-30
5703	亞都	觀光餐旅	tpex	2025-09-30
5704	老爺知	觀光餐旅	tpex	2025-09-30
5706	鳳凰	觀光餐旅	twse	2025-09-30
5820	日盛金	金融業	tpex	2022-11-03
5854	合庫	金融保險	twse	2024-12-04
5859	遠壽	金融業	emerging	2025-09-30
5863	瑞興銀	金融業	emerging	2025-09-30
5864	致和證	金融業	tpex	2025-09-30
5871	中租-KY	其他	twse	2025-09-30
5871A	中租-KY甲特	其他	twse	2025-09-30
5876	上海商銀	金融保險	twse	2025-09-30
5878	台名	金融業	tpex	2025-09-30
5880	合庫金	金融保險	twse	2025-09-30
5902	德記	居家生活類	tpex	2025-09-30
5903	全家	居家生活類	tpex	2025-09-30
5904	寶雅	居家生活類	tpex	2025-09-30
5905	南仁湖	觀光餐旅	tpex	2025-09-30
5906	台南-KY	貿易百貨	twse	2025-09-30
5907	大洋-KY	貿易百貨	twse	2025-09-30
6004	元京證	金融保險	twse	2024-12-04
6005	群益證	金融保險	twse	2025-09-30
6012	金鼎證	金融保險	twse	2024-12-04
6015	宏遠證	金融業	tpex	2025-09-30
6016	康和證	金融業	tpex	2025-09-30
6020	大展證	金融業	tpex	2025-09-30
6021	美好證	金融業	tpex	2025-09-30
6023	元大期	金融業	tpex	2025-09-30
6024	群益期	金融保險	twse	2025-09-30
6026	福邦證	金融業	tpex	2025-09-30
6027	德信	金融業	emerging	2025-09-30
6028	公勝保經	金融業	emerging	2025-09-30
6035	悠遊卡	金融業	emerging	2025-09-30
6101	寬魚國際	文化創意業	tpex	2025-09-30
6103	合邦	半導體業	tpex	2025-09-30
6104	創惟	半導體業	tpex	2025-09-30
6108	競國	電子零組件業	twse	2025-09-30
6109	亞元	通信網路業	tpex	2025-09-30
6111	大宇資	文化創意業	tpex	2025-09-30
6112	邁達特	電子工業	twse	2025-09-30
6113	亞矽	電子通路業	tpex	2025-09-30
6114	久威	電子零組件業	tpex	2025-09-30
6115	鎰勝	電子零組件業	twse	2025-09-30
6116	彩晶	電子工業	twse	2025-09-30
6117	迎廣	電腦及週邊設備業	twse	2025-09-30
6118	建達	電子通路業	tpex	2025-09-30
6119	大傳	電子通路業	twse	2024-12-04
6120	達運	光電業	twse	2025-09-30
6121	新普	電腦及週邊設備業	tpex	2025-09-30
6122	擎邦	電機機械	tpex	2025-09-30
6123	上奇	資訊服務業	tpex	2025-09-30
6124	業強	電子零組件業	tpex	2025-09-30
6125	廣運	光電業	tpex	2025-09-30
6126	信音	電子零組件業	tpex	2025-09-30
6127	九豪	電子零組件業	tpex	2025-09-30
6128	上福	電腦及週邊設備業	twse	2025-09-30
6129	普誠	半導體業	tpex	2025-09-30
6130	上亞科技	生技醫療業	tpex	2025-09-30
6131	鈞泰	電子工業	twse	2025-09-24
6133	金橋	電子零組件業	twse	2025-09-30
6134	萬旭	電子零組件業	tpex	2025-09-30
6136	富爾特	電子工業	twse	2025-09-30
6138	茂達	半導體業	tpex	2025-09-30
6139	亞翔	電子工業	twse	2025-09-30
6140	訊達	資訊服務業	tpex	2025-09-30
6141	柏承	電子零組件業	twse	2025-09-30
6142	友勁	通信網路業	twse	2025-09-30
6143	振曜	通信網路業	tpex	2025-09-30
6144	得利影	文化創意業	tpex	2025-09-30
6145	勁永	電子工業	twse	2025-09-24
6146	耕興	其他電子類	tpex	2025-09-30
6147	頎邦	半導體業	tpex	2025-09-30
6148	驊宏資	資訊服務業	tpex	2025-09-30
6150	撼訊	電腦及週邊設備業	tpex	2025-09-30
6151	晉倫	其他電子類	tpex	2025-09-30
6152	百一	電子工業	twse	2025-09-30
6153	嘉聯益	電子零組件業	twse	2025-09-30
6154	順發	電子通路業	tpex	2025-09-30
6155	鈞寶	電子零組件業	twse	2025-09-30
6156	松上	電子零組件業	tpex	2025-09-30
6158	禾昌	電子零組件業	tpex	2025-09-30
6409	旭隼	其他電子業	twse	2025-09-30
6160	欣技	電腦及週邊設備業	tpex	2025-09-30
6161	捷波	電腦及週邊設備業	tpex	2025-09-30
6163	華電網	通信網路業	tpex	2025-09-30
6164	華興	電子工業	twse	2025-09-30
6165	浪凡	數位雲端	twse	2025-09-30
6166	凌華	電腦及週邊設備業	twse	2025-09-30
6167	久正	光電業	tpex	2025-09-30
6168	宏齊	電子工業	twse	2025-09-30
6169	昱泉	文化創意業	tpex	2025-09-30
6170	統振	通信網路業	tpex	2025-09-30
6171	大城地產	建材營造	tpex	2025-09-30
6172	互億	電子工業	twse	2025-09-24
6173	信昌電	電子零組件業	tpex	2025-09-30
6174	安碁	電子零組件業	tpex	2025-09-30
6175	立敦	電子零組件業	tpex	2025-09-30
6176	瑞儀	電子工業	twse	2025-09-30
6177	達麗	建材營造	twse	2025-09-30
6179	亞通	其他	tpex	2025-09-30
6180	橘子	文化創意業	tpex	2025-09-30
6182	合晶	半導體業	tpex	2025-09-30
6183	關貿	電子工業	twse	2025-09-30
6184	大豐電	其他	twse	2025-09-30
6185	幃翔	電子零組件業	tpex	2025-09-30
6186	新潤	建材營造	tpex	2025-09-30
6187	萬潤	半導體業	tpex	2025-09-30
6188	廣明	電腦及週邊設備業	tpex	2025-09-30
6189	豐藝	電子通路業	twse	2025-09-30
6190	萬泰科	通信網路業	tpex	2025-09-30
6191	精成科	電子工業	twse	2025-09-30
6192	巨路	電子工業	twse	2025-09-30
6194	育富	電子零組件業	tpex	2025-09-30
6195	詩肯	居家生活類	tpex	2025-09-30
6196	帆宣	電子工業	twse	2025-09-30
6197	佳必琪	電子零組件業	twse	2025-09-30
6198	瑞築	建材營造	tpex	2025-09-30
6199	天品	其他	tpex	2025-09-30
6201	亞弘電	電子工業	twse	2025-09-30
6202	盛群	電子工業	twse	2025-09-30
6203	海韻電	電子零組件業	tpex	2025-09-30
6204	艾華	電子零組件業	tpex	2025-09-30
6205	詮欣	電子零組件業	twse	2025-09-30
6206	飛捷	電腦及週邊設備業	twse	2025-09-30
6207	雷科	電子零組件業	tpex	2025-09-30
6208	日揚	半導體業	tpex	2025-09-30
6209	今國光	光電業	twse	2025-09-30
6210	慶生	電子零組件業	tpex	2025-09-30
6212	理銘	建材營造	tpex	2025-09-30
6213	聯茂	電子工業	twse	2025-09-30
6214	精誠	資訊服務業	twse	2025-09-30
6215	和椿	其他電子業	twse	2025-09-30
6216	居易	通信網路業	twse	2025-09-30
6217	中探針	電子零組件業	tpex	2025-09-30
6218	豪勉	通信網路業	tpex	2025-09-30
6219	富旺	建材營造	tpex	2025-09-30
6220	岳豐	電子零組件業	tpex	2025-09-30
6221	晉泰	資訊服務業	tpex	2025-09-30
6222	立軒	光電業	tpex	2025-09-30
6223	旺矽	半導體業	tpex	2025-09-30
6224	聚鼎	電子工業	twse	2025-09-30
6225	天瀚	光電業	twse	2025-09-30
6226	光鼎	光電業	twse	2025-09-30
6227	茂綸	電子通路業	tpex	2025-09-30
6228	全譜	電腦及週邊設備業	tpex	2025-09-30
6229	研通	半導體業	tpex	2025-09-30
6230	尼得科超眾	電腦及週邊設備業	twse	2025-09-30
6231	系微	資訊服務業	tpex	2025-09-30
6233	旺玖	半導體業	tpex	2025-09-30
6234	高僑	光電業	tpex	2025-09-30
6235	華孚	電腦及週邊設備業	twse	2025-09-30
6236	中湛	其他	tpex	2025-09-30
6237	驊訊	半導體業	tpex	2025-09-30
6238	勝麗	其他電子類	tpex	2020-06-13
6239	力成	半導體業	twse	2025-09-30
6240	松崗	資訊服務業	tpex	2025-09-30
6241	易通展	通信網路業	tpex	2025-09-30
6242	立康	生技醫療業	tpex	2025-09-30
6243	迅杰	半導體業	twse	2025-09-30
6244	茂迪	光電業	tpex	2025-09-30
6245	立端	通信網路業	tpex	2025-09-30
6246	臺龍	光電業	tpex	2025-09-30
6247	淇譽電	其他電子類	tpex	2023-02-04
6248	沛波	鋼鐵工業	tpex	2025-09-30
6251	定穎	電子工業	twse	2025-09-24
6255	奈普	光電業	twse	2024-12-04
6257	矽格	半導體業	twse	2025-09-30
6259	百徽	電子零組件業	tpex	2025-09-30
6261	久元	半導體業	tpex	2025-09-30
6263	普萊德	通信網路業	tpex	2025-09-30
6264	富裔	建材營造	tpex	2025-09-30
6265	方土昶	電子通路業	tpex	2025-09-30
6266	泰詠	電子零組件業	tpex	2025-09-30
6269	台郡	電子零組件業	twse	2025-09-30
6270	倍微	電子通路業	tpex	2025-09-30
6271	同欣電	半導體業	twse	2025-09-30
6272	驊陞	電子零組件業	emerging	2025-09-30
6274	台燿	電子零組件業	tpex	2025-09-30
6275	元山	電子零組件業	tpex	2025-09-30
6276	安鈦克	電腦及週邊設備業	tpex	2025-09-30
6277	宏正	電腦及週邊設備業	twse	2025-09-30
6278	台表科	電子工業	twse	2025-09-30
6279	胡連	電子零組件業	tpex	2025-09-30
6280	崇貿	電子工業	twse	2024-12-04
6281	全國電	電子通路業	twse	2025-09-30
6282	康舒	電子零組件業	twse	2025-09-30
6283	淳安	電子工業	twse	2025-09-30
6284	佳邦	電子零組件業	tpex	2025-09-30
6285	啟碁	電子工業	twse	2025-09-30
6286	立錡	電子工業	twse	2024-12-04
6287	元隆	半導體業	tpex	2025-06-25
6288	聯嘉	汽車工業	twse	2025-08-05
6289	華上	電子工業	twse	2025-09-24
6290	良維	電子零組件業	tpex	2025-09-30
6291	沛亨	半導體業	tpex	2025-09-30
6292	迅德	電子零組件業	tpex	2025-09-30
6294	智基	文化創意業	tpex	2025-09-30
6403	群登	通信網路業	emerging	2025-09-30
6404	通訊-KY	資訊服務業	tpex	2023-11-24
6405	悅城	光電業	twse	2025-09-30
6407	相互	電子零組件業	emerging	2025-09-30
6411	晶焱	半導體業	tpex	2025-09-30
6412	群電	電子零組件業	twse	2025-09-30
6414	樺漢	電腦及週邊設備業	twse	2025-09-30
6415	矽力*-KY	電子工業	twse	2025-09-30
6416	瑞祺電通	電子工業	twse	2025-09-30
6417	韋僑	通信網路業	tpex	2025-09-30
6418	詠昇	電子零組件業	tpex	2025-09-30
6419	京晨科	光電業	tpex	2025-09-30
6422	君耀-KY	電子工業	twse	2025-09-24
6423	億而得-創	電子工業	twse	2025-09-30
6425	易發	電機機械	tpex	2025-09-30
6426	統新	電子工業	twse	2025-09-30
6428	台灣淘米	文化創意業	emerging	2025-09-30
6431	光麗-KY	生技醫療業	twse	2025-09-30
6432	今展科	電子零組件業	tpex	2025-09-30
6434	達輝光電	光電業	emerging	2025-09-30
6435	大中	半導體業	tpex	2025-09-30
6438	迅得	電子工業	twse	2025-09-30
6441	廣錠	電腦及週邊設備業	tpex	2025-09-30
6442	光聖	電子工業	twse	2025-09-30
6443	元晶	電子工業	twse	2025-09-30
6446	藥華藥	生技醫療業	twse	2025-09-30
6449	鈺邦	電子零組件業	twse	2025-09-30
6451	訊芯-KY	電子工業	twse	2025-09-30
6452	康友-KY	生技醫療業	twse	2025-09-03
6456	GIS-KY	電子工業	twse	2025-09-30
6457	紘康	半導體業	tpex	2024-12-28
6461	益得	生技醫療業	tpex	2025-09-30
6462	神盾	半導體業	tpex	2025-09-30
6464	台數科	其他	twse	2025-09-30
6465	威潤	通信網路業	tpex	2025-09-30
6467	泰合	生技醫療業	emerging	2025-09-30
6469	大樹	生技醫療業	tpex	2025-09-30
6470	宇智	通信網路業	tpex	2025-09-30
6472	保瑞	生技醫療業	twse	2025-09-30
6473	美賣*	數位雲端	emerging	2025-09-30
6474	華豫寧	電子通路業	emerging	2025-09-30
6477	安集	電子工業	twse	2025-09-30
6482	弘煜科	文化創意業	tpex	2025-09-30
6483	原創生醫	生技醫療業	emerging	2025-09-30
6485	點序	半導體業	tpex	2025-09-30
6486	互動	通信網路業	tpex	2025-09-30
6488	環球晶	半導體業	tpex	2025-09-30
6491	晶碩	化學生技醫療	twse	2025-09-30
6492	生華科	生技醫療業	tpex	2025-09-30
6493	雷虎生	生技醫療業	emerging	2025-09-30
6494	九齊	半導體業	tpex	2025-09-30
6495	納諾*-KY	化學工業	emerging	2025-02-20
6496	科懋	生技醫療業	tpex	2025-09-30
6497	亞獅康-KY	生技醫療業	tpex	2020-08-27
6498	久禾光	光電業	tpex	2025-09-30
6499	益安	生技醫療業	tpex	2025-09-30
6504	南六	其他	twse	2025-09-30
6505	台塑化	油電燃氣業	twse	2025-09-30
6506	雙邦	紡織纖維	tpex	2025-09-30
6508	惠光	農業科技業	tpex	2025-09-30
6509	聚和	化學工業	tpex	2025-09-30
6510	精測	半導體業	tpex	2025-09-30
6512	啟發電	其他電子類	tpex	2025-09-30
6514	芮特-KY	通信網路業	tpex	2024-10-11
6515	穎崴	電子工業	twse	2025-09-30
6516	勤崴國際	資訊服務業	tpex	2025-09-30
6517	保勝光學	光電業	tpex	2025-09-30
6518	康科特	生技醫療業	emerging	2025-09-30
6523	達爾膚	生技醫療業	tpex	2025-09-30
6525	捷敏-KY	電子工業	twse	2025-09-30
6526	達發	半導體業	twse	2025-09-30
6527	明達醫	生技醫療業	tpex	2025-09-30
6530	創威	通信網路業	tpex	2025-09-30
6531	愛普*	電子工業	twse	2025-09-30
6532	瑞耘	半導體業	tpex	2025-09-30
6533	晶心科	電子工業	twse	2025-09-30
6534	正瀚-創	生技醫療業	twse	2025-09-30
6535	順藥	生技醫療業	tpex	2025-09-30
6536	碩豐	資訊服務業	emerging	2025-09-30
6538	倉和	電子零組件業	tpex	2025-09-30
6539	麗彤	生技醫療業	emerging	2025-09-30
6541	泰福-KY	生技醫療業	twse	2025-09-30
6542	隆中	文化創意業	tpex	2025-09-30
6543	普惠醫工	生技醫療業	emerging	2025-09-30
6546	正基	通信網路業	tpex	2025-09-30
6547	高端疫苗	生技醫療業	tpex	2025-09-30
6548	長科*	半導體業	tpex	2025-09-30
6549	景凱	生技醫療業	emerging	2025-09-30
6550	北極星藥業-KY	生技醫療業	twse	2025-09-30
6552	易華電	電子工業	twse	2025-09-30
6555	榮炭	電子零組件業	emerging	2025-09-30
6556	勝品	光電業	tpex	2025-09-30
6558	興能高	電子工業	twse	2025-09-30
6559	研晶	光電業	emerging	2025-09-30
6560	欣普羅	光電業	tpex	2025-09-30
6561	是方	通信網路業	tpex	2025-09-30
6562	聯亞藥	生技醫療業	emerging	2024-05-06
6563	映智	半導體業	emerging	2025-09-30
6564	安特羅	生技醫療業	emerging	2025-09-30
6565	物聯	數位雲端	emerging	2025-09-30
6568	宏觀	半導體業	tpex	2025-09-30
6569	醫揚	生技醫療業	tpex	2025-09-30
6570	維田	電腦及週邊設備業	tpex	2025-09-30
6572	博錸	生技醫療業	emerging	2025-09-30
6573	虹揚-KY	電子工業	twse	2025-09-30
6574	霈方	生技醫療業	tpex	2025-09-30
6576	逸達	生技醫療業	tpex	2025-09-30
6577	勁豐	電腦及週邊設備業	tpex	2025-09-30
6578	達邦蛋白	農業科技業	tpex	2025-09-30
6579	研揚	電腦及週邊設備業	twse	2025-09-30
6580	台睿	生技醫療業	emerging	2025-09-30
6581	鋼聯	綠能環保	twse	2025-09-30
6582	申豐	橡膠工業	twse	2025-09-30
6583	友松	文化創意業	emerging	2025-09-30
6584	南俊國際	電子零組件業	tpex	2025-09-30
6585	鼎基	其他	twse	2025-09-30
6586	醣基	生技醫療業	emerging	2025-09-30
6588	東典光電	通信網路業	tpex	2025-09-30
6589	台康生技	生技醫療業	twse	2025-09-30
6590	普鴻	資訊服務業	tpex	2025-09-30
6591	動力-KY	電腦及週邊設備業	twse	2025-09-30
6592	和潤企業	其他	twse	2025-09-30
6592A	和潤企業甲特	其他	twse	2025-09-30
6592B	和潤企業乙特	其他	twse	2025-09-30
6593	台灣銘板	資訊服務業	tpex	2025-09-30
6594	展匯科	半導體業	tpex	2023-03-25
6595	光禹國際	文化創意業	emerging	2025-09-30
6596	寬宏藝術	文化創意業	tpex	2025-09-30
6597	立誠	電子零組件業	tpex	2025-09-30
6598	ABC-KY	生技醫療業	twse	2025-09-30
6599	普達系統	電腦及週邊設備業	emerging	2025-09-30
6603	富強鑫	電機機械	tpex	2025-09-30
6605	帝寶	汽車工業	twse	2025-09-30
6606	建德工業	電機機械	twse	2025-09-30
6609	瀧澤科	電機機械	tpex	2025-09-30
6610	安成生技	生技醫療業	emerging	2025-09-30
6612	奈米醫材	生技醫療業	tpex	2025-09-30
6613	朋億*	其他電子類	tpex	2025-09-30
6614	資拓宏宇	數位雲端	emerging	2025-09-30
6615	慧智	生技醫療業	tpex	2025-09-30
6616	特昇-KY	居家生活類	tpex	2025-09-30
6617	共信-KY	生技醫療業	tpex	2025-09-30
6618	永虹先進	化學工業	emerging	2025-09-30
6620	漢達	生技醫療業	emerging	2025-09-30
6621	華宇藥	生技醫療業	emerging	2025-09-30
6622	百聿數碼	文化創意業	emerging	2025-09-30
6624	萬年清	綠能環保類	tpex	2025-09-30
6625	必應	其他	twse	2025-09-30
6626	唯數	文化創意業	emerging	2025-05-08
6629	泰金-KY	居家生活類	tpex	2025-09-30
6634	欣耀	生技醫療業	emerging	2025-09-30
6637	醫影	生技醫療業	tpex	2025-09-30
6638	沅聖	電腦及週邊設備業	emerging	2025-09-30
6639	源大環能	油電燃氣業	emerging	2025-09-30
6640	均華	半導體業	tpex	2025-09-30
6641	基士德-KY	綠能環保	twse	2025-09-30
6642	富致	電子零組件業	tpex	2025-09-30
6643	M31	半導體業	tpex	2025-09-30
6645	金萬林-創	生技醫療業	twse	2025-09-30
6648	斯其大	其他電子業	emerging	2025-09-30
6649	台生材	生技醫療業	tpex	2025-09-30
6650	帝圖	文化創意業	emerging	2025-09-30
6651	全宇昕	半導體業	tpex	2025-09-30
6652	雅祥生醫	生技醫療業	emerging	2025-09-30
6654	天正國際	其他電子類	tpex	2025-09-30
6655	科定	其他	twse	2025-09-30
6657	華安	生技醫療業	twse	2025-09-30
6658	聯策	電子工業	twse	2025-09-30
6661	威健生技	生技醫療業	tpex	2025-09-30
6662	樂斯科	生技醫療業	tpex	2025-09-30
6664	群翊	電子零組件業	tpex	2025-09-30
6665	康聯生醫	生技醫療業	emerging	2025-09-30
6666	羅麗芬-KY	生技醫療業	twse	2025-09-30
6667	信紘科	其他電子類	tpex	2025-09-30
6668	中揚光	電子工業	twse	2025-09-30
6669	緯穎	電腦及週邊設備業	twse	2025-09-30
6670	復盛應用	運動休閒	twse	2025-09-30
6671	三能-KY	居家生活	twse	2025-09-30
6672	騰輝電子-KY	電子零組件業	twse	2025-09-30
6673	和詮	光電業	emerging	2025-09-30
6674	鋐寶科技	電子工業	twse	2025-09-30
6676	祥翊	生技醫療業	emerging	2025-09-30
6677	瑩碩生技	生技醫療業	emerging	2025-09-30
6679	鈺太	半導體業	tpex	2025-09-30
6680	鑫創電子	電腦及週邊設備業	tpex	2025-09-30
6682	華旭先進	光電業	emerging	2025-09-30
6683	雍智科技	半導體業	tpex	2025-09-30
6684	安格	半導體業	tpex	2025-09-30
6689	伊雲谷	數位雲端	twse	2025-09-30
6690	安碁資訊	數位雲端類	tpex	2025-09-30
6691	洋基工程	其他電子業	twse	2025-09-30
6692	進能服	綠能環保類	tpex	2025-09-30
6693	廣閎科	半導體業	tpex	2025-09-30
6695	芯鼎	電子工業	twse	2025-09-30
6696	仁新	生技醫療業	emerging	2025-09-30
6697	東捷資訊	資訊服務業	tpex	2025-09-30
6698	旭暉應材	電子工業	twse	2025-09-30
6699	奇邑	半導體業	emerging	2025-09-30
6702	興航	航運業	twse	2024-12-04
6703	軒郁	生技醫療業	tpex	2025-09-30
6704	國璽幹細胞	生技醫療業	emerging	2025-09-30
6705	振躍精密	電機機械	emerging	2025-09-30
6706	惠特	電子工業	twse	2025-09-30
6707	富基電通	電子通路業	emerging	2025-09-30
6708	天擎	半導體業	tpex	2025-09-30
6709	昱厚生技	生技醫療業	emerging	2025-09-30
6712	長聖	生技醫療業	tpex	2025-09-30
6715	嘉基	電子零組件業	twse	2025-09-30
6716	應廣	半導體業	tpex	2025-09-30
6719	力智	電子工業	twse	2025-09-30
6720	久昌	半導體業	tpex	2025-09-30
6721	信實	其他	tpex	2025-09-30
6722	輝創	其他電子業	emerging	2025-09-30
6723	傑智環境	綠能環保	emerging	2025-09-30
6725	矽科宏晟	其他電子業	emerging	2025-09-30
6727	亞泰金屬	電子零組件業	tpex	2025-09-30
6728	上洋	居家生活類	tpex	2025-09-30
6729	機光科技	光電業	emerging	2025-09-30
6730	常廣	生技醫療業	emerging	2025-09-30
6732	昇佳電子	半導體業	tpex	2025-09-30
6733	博晟生醫	生技醫療業	tpex	2025-09-30
6734	安盛生	生技醫療業	emerging	2025-09-30
6735	美達科技	其他電子類	tpex	2025-09-30
6737	秀育	電腦及週邊設備業	emerging	2025-09-30
6738	鼎恒	資訊服務業	emerging	2025-09-30
6739	竹陞科技	其他電子類	tpex	2025-09-30
6741	91APP*-KY	數位雲端類	tpex	2025-09-30
6742	澤米	電子工業	twse	2025-09-30
6743	安普新	電子工業	twse	2025-09-30
6744	豐技生技	生技醫療業	emerging	2025-09-30
6747	亨泰光	生技醫療業	tpex	2025-09-30
6748	亞果生醫	生技醫療業	emerging	2025-09-30
6750	泰創工程	其他電子業	emerging	2025-09-30
6751	智聯服務	資訊服務業	tpex	2025-09-30
6752	叡揚	資訊服務業	tpex	2025-09-30
6753	龍德造船	航運業	twse	2025-09-30
6754	匯僑設計	居家生活	twse	2025-09-30
6755	連鋐科技	電子零組件業	emerging	2025-09-30
6756	威鋒電子	電子工業	twse	2025-09-30
6757	台灣虎航	航運業	twse	2025-09-30
6758	冠亞	生技醫療業	emerging	2025-09-30
6761	穩得	電子零組件業	tpex	2025-09-30
6762	達亞	生技醫療業	tpex	2025-09-30
6763	綠界科技*	數位雲端類	tpex	2025-09-30
6764	亞洲教育	其他	emerging	2025-09-30
6767	台微醫	生技醫療業	tpex	2025-09-30
6768	志強-KY	運動休閒	twse	2025-09-30
6770	力積電	半導體業	twse	2025-09-30
6771	平和環保-創	綠能環保	twse	2025-09-30
6775	穎台科技	光電業	emerging	2025-09-30
6776	展碁國際	電子通路業	twse	2025-09-30
6780	學習王	文化創意業	emerging	2025-09-30
6781	AES-KY	電子零組件業	twse	2025-09-30
6782	視陽	生技醫療業	twse	2025-09-30
6784	天凱科技	通信網路業	emerging	2025-09-30
6785	昱展新藥	生技醫療業	tpex	2025-09-30
6786	芯測	半導體業	emerging	2025-09-30
6787	晶瑞光	光電業	emerging	2025-09-30
6788	華景電	半導體業	tpex	2025-09-30
6789	采鈺	電子工業	twse	2025-09-30
6790	永豐實	造紙工業	twse	2025-09-30
6791	虎門科技	資訊服務業	tpex	2025-09-30
6792	詠業	電子工業	twse	2025-09-30
6793	天力離岸	其他	emerging	2025-09-30
6794	向榮生技-創	化學生技醫療	twse	2025-09-30
6796	晉弘	生技醫療業	twse	2025-09-30
6797	圓點奈米	生技醫療業	emerging	2025-09-30
6798	展逸	運動休閒	emerging	2025-09-30
6799	來頡	電子工業	twse	2025-09-30
6803	崑鼎	綠能環保類	tpex	2025-09-30
6804	明係	運動休閒類	tpex	2025-09-30
6805	富世達	電子工業	twse	2025-09-30
6806	森崴能源	綠能環保	twse	2025-09-30
6807	峰源-KY	居家生活	twse	2025-09-30
6808	三鼎生技	生技醫療業	emerging	2025-09-30
6810	新穎生醫	生技醫療業	emerging	2025-09-30
6811	宏碁資訊	數位雲端類	tpex	2025-09-30
6812	梭特	光電業	emerging	2025-09-30
6813	富動科	電腦及週邊設備業	emerging	2024-06-13
6814	路迦生醫	生技醫療業	emerging	2025-09-30
6815	晶鑽生醫	生技醫療業	emerging	2025-09-30
6816	捷智商訊	資訊服務業	emerging	2025-09-30
6817	溫士頓	生技醫療業	emerging	2025-09-30
6818	連騰	通信網路業	emerging	2025-09-30
6819	眾智	半導體業	emerging	2025-09-30
6820	連訊	通信網路業	emerging	2025-09-30
6821	聯寶	電子零組件業	tpex	2025-09-30
6823	濾能	半導體業	tpex	2025-09-30
6825	和暢科技	電腦及週邊設備業	emerging	2025-09-30
6826	和淞	其他電子業	emerging	2025-09-30
6827	巨生醫	生技醫療業	emerging	2025-09-30
6829	千附精密	半導體業	tpex	2025-09-30
6830	汎銓	電子工業	twse	2025-09-30
6831	邁科	電腦及週邊設備業	emerging	2025-09-30
6832	金鼎科	其他	emerging	2025-09-30
6833	太康精密	電子零組件業	emerging	2025-09-30
6834	天二科技	電子零組件業	twse	2025-09-30
6835	圓裕	電子零組件業	twse	2025-09-30
6838	台新藥	生技醫療業	twse	2025-09-30
6839	開陽能源	綠能環保	emerging	2025-09-30
6840	東研信超	其他電子類	tpex	2025-09-30
6841	長佳智能	生技醫療業	tpex	2025-09-30
6842	一元素	半導體業	emerging	2025-09-30
6843	進典	電機機械	tpex	2025-09-30
6844	諾貝兒	生技醫療業	tpex	2025-09-30
6846	綠茵	食品工業	tpex	2025-09-30
6847	普瑞博	生技醫療業	emerging	2025-09-30
6848	拉法醫	生技醫療業	emerging	2025-09-30
6849	奇鼎科技	其他電子業	emerging	2025-09-30
6850	光鼎生技	生技醫療業	emerging	2025-09-30
6854	錼創科技-KY創	電子工業	twse	2025-09-30
6855	數泓科	其他電子類	tpex	2025-09-30
6856	鑫傳	文化創意業	tpex	2025-09-30
6857	宏碁智醫	生技醫療業	emerging	2025-09-30
6858	愛比科技	電腦及週邊設備業	emerging	2025-09-30
6859	伯特光	光電業	tpex	2025-09-30
6861	睿生光電	化學生技醫療	twse	2025-09-30
6862	三集瑞-KY	電子工業	twse	2025-09-30
6863	永道-KY	通信網路業	twse	2025-09-30
6864	元樟生技	生技醫療業	emerging	2025-09-30
6865	偉康科技	數位雲端類	tpex	2025-09-30
6867	坦德科技	光電業	emerging	2025-09-30
6868	采威國際	資訊服務業	emerging	2025-09-30
6869	雲豹能源	綠能環保	twse	2025-09-30
6870	騰雲	數位雲端類	tpex	2025-09-30
6872	浩宇生醫	生技醫療業	tpex	2025-09-30
6873	泓德能源	綠能環保	twse	2025-09-30
6874	倍力	資訊服務業	tpex	2025-09-30
6875	國邑*	生技醫療業	tpex	2025-09-30
6876	朗齊生醫*	生技醫療業	emerging	2025-09-30
6877	鏵友益	其他電子類	tpex	2025-09-30
6878	歐付寶	金融業	emerging	2025-09-30
6879	大江基因	生技醫療業	emerging	2025-09-30
6881	潤德	其他	tpex	2025-09-30
6882	甲尚	資訊服務業	emerging	2025-09-30
6883	微電能源	綠能環保	emerging	2025-09-30
6884	海柏特	資訊服務業	emerging	2025-09-30
6885	全福生技	生技醫療業	twse	2025-09-30
6886	遠東生技	食品工業	emerging	2025-09-30
6887	寶綠特-KY	綠能環保	twse	2025-09-30
6890	來億-KY	運動休閒	twse	2025-09-30
6891	樂迦再生	生技醫療業	emerging	2025-09-30
6892	台寶生醫	生技醫療業	emerging	2025-09-30
6894	衛司特	綠能環保類	tpex	2025-09-30
6895	宏碩系統	半導體業	tpex	2025-09-30
6898	程曦資訊	資訊服務業	emerging	2025-09-30
6899	創為精密	光電業	tpex	2025-09-30
6901	鑽石投資	其他	twse	2025-09-30
6902	GOGOLOOK	數位雲端	twse	2025-09-30
6903	巨漢	其他電子類	tpex	2025-09-30
6904	伯鑫	其他	tpex	2025-09-30
6906	現觀科	數位雲端	twse	2025-09-30
6908	宏碁遊戲	電子通路業	emerging	2025-09-30
6909	創控	電子工業	twse	2025-09-30
6910	德鴻	數位雲端	emerging	2025-09-30
6911	群運	其他	emerging	2025-09-30
6912	益鈞環科*	綠能環保	emerging	2025-09-30
6913	鴻呈	電子零組件業	tpex	2025-09-30
6914	阜爾運通	其他	twse	2025-09-30
6915	美強光	電子零組件業	emerging	2025-09-30
6916	華凌	電子工業	twse	2025-09-30
6917	竟天	生技醫療業	emerging	2025-09-30
6918	愛派司	化學生技醫療	twse	2025-09-30
6919	康霈*	化學生技醫療	twse	2025-09-30
6920	恆勁科技	半導體業	emerging	2025-09-30
6922	宸曜	電腦及週邊設備業	tpex	2025-09-30
6923	中台	綠能環保	twse	2025-09-30
6924	榮惠-KY創	電子零組件業	twse	2025-09-30
6925	意藍	數位雲端類	tpex	2025-09-30
6926	聖安生醫	生技醫療業	emerging	2025-09-30
6927	聯合聚晶	半導體業	emerging	2025-09-30
6928	攸泰科技	電腦及週邊設備業	twse	2025-09-30
6929	佑全	生技醫療業	tpex	2025-09-30
6931	青松健康	生技醫療業	twse	2025-09-30
6932	水星生醫*	生技醫療業	emerging	2025-09-30
6933	AMAX-KY	電腦及週邊設備業	twse	2025-09-30
6934	心誠鎂	生技醫療業	emerging	2025-09-30
6935	王子製藥	食品工業	emerging	2025-09-30
6936	永鴻生技	生技醫療業	twse	2025-09-30
6937	天虹	電子工業	twse	2025-09-30
6938	藍新資訊	資訊服務業	emerging	2025-09-30
6939	啟弘生技	生技醫療業	emerging	2025-09-30
6940	格斯科技*	電子零組件業	emerging	2025-09-30
6944	兆聯實業	綠能環保	twse	2025-09-30
6945	圓祥生技	生技醫療業	emerging	2025-09-30
6946	三地能源	綠能環保	emerging	2025-09-30
6947	台鎔科技	綠能環保	emerging	2025-09-30
6949	沛爾生醫-創	生技醫療業	twse	2025-09-30
6951	青新-創	綠能環保	twse	2025-09-30
6952	大武山	其他	twse	2025-09-30
6953	家碩	半導體業	tpex	2025-09-30
6955	邦睿生技-創	創新板股票	twse	2025-09-30
6957	裕慶-KY	其他	twse	2025-09-30
6958	日盛台駿	其他	twse	2025-09-30
6959	兆捷科技	化學工業	emerging	2025-09-30
6961	旅天下	觀光餐旅	emerging	2025-09-30
6962	奕力-KY	電子工業	twse	2025-09-30
6963	品元	食品工業	emerging	2025-09-30
6965	中傑-KY	運動休閒	twse	2025-09-30
6967	汎瑋材料	電子零組件業	tpex	2025-09-30
6968	萬達寵物	居家生活類	tpex	2025-09-30
6969	成信實業*-創	創新板股票	twse	2025-09-30
6971	惠民實業	綠能環保	emerging	2025-09-30
6972	博瑞達應材	化學工業	emerging	2025-09-30
6973	永立榮	生技醫療業	emerging	2025-09-30
6976	育世博-KY	生技醫療業	emerging	2025-09-30
6977	聯純	綠能環保	emerging	2025-09-30
6979	勝釩	光電業	emerging	2025-09-30
6980	鐳洋科技	通信網路業	emerging	2025-09-30
6982	大井泵浦	電機機械	tpex	2025-09-30
6983	華洋精機	其他電子業	emerging	2025-09-30
6984	ACpay	數位雲端	emerging	2025-09-30
6986	和迅	生技醫療業	emerging	2025-09-30
6987	寶晶能源*	綠能環保	emerging	2025-09-30
6988	威力暘-創	汽車工業	twse	2025-09-30
6990	華鉬	綠能環保	emerging	2025-09-30
6994	富威電力	綠能環保	twse	2025-09-30
6995	野獸國	其他	emerging	2025-09-30
6996	力領科技	半導體業	tpex	2025-09-30
6997	博弘	數位雲端類	tpex	2025-09-30
6999	瀚醫生技	生技醫療業	emerging	2025-09-30
708785	信驊中信9B購01	所有證券	tpex	2020-11-15
709403	雙美國票9B購01	所有證券	tpex	2020-11-15
709966	金居群益9B購01	所有證券	tpex	2020-11-15
709972	旺矽元大9B購01	所有證券	tpex	2020-11-15
709983	群聯日盛9B購01	所有證券	tpex	2020-11-15
709985	大江富邦9B購02	所有證券	tpex	2020-11-15
709994	中美晶元大9B購01	所有證券	tpex	2020-11-15
710499	網家國泰9B購01	所有證券	tpex	2020-11-15
710502	泰博元大9B購01	所有證券	tpex	2020-11-15
710505	泰博富邦9B購01	所有證券	tpex	2020-11-15
710509	建榮凱基9B購01	所有證券	tpex	2020-11-15
710510	群聯凱基9B購03	所有證券	tpex	2020-11-15
710516	宇峻永豐9B購01	所有證券	tpex	2020-11-15
710533	鈊象元大9B購04	所有證券	tpex	2020-11-15
710534	鈺太元大9B購01	所有證券	tpex	2020-11-15
710553	穩懋統一9B購03	所有證券	tpex	2020-11-15
710560	宏捷科元大9B購02	所有證券	tpex	2020-11-15
710561	威剛元大9B購02	所有證券	tpex	2020-11-15
710566	碩禾元大9B購01	所有證券	tpex	2020-11-15
710569	中美晶富邦9B購04	所有證券	tpex	2020-11-15
710575	環球晶中信9B購01	所有證券	tpex	2020-11-15
710590	鈺太凱基9B購01	所有證券	tpex	2020-11-15
711126	聯亞元大9B購05	所有證券	tpex	2020-11-15
711127	頎邦元大9B購03	所有證券	tpex	2020-11-15
711131	胡連永豐9B購01	所有證券	tpex	2020-11-15
711132	僑威永豐9B購01	所有證券	tpex	2020-11-15
711133	寶雅永豐9B購01	所有證券	tpex	2020-11-15
711134	中美晶群益9B購03	所有證券	tpex	2020-11-15
711135	元太群益9B購01	所有證券	tpex	2020-11-15
711137	胡連群益9B購01	所有證券	tpex	2020-11-15
711139	中美晶凱基9B購02	所有證券	tpex	2020-11-15
8155	博智	電子零組件業	tpex	2025-09-30
711140	旺矽凱基9B購01	所有證券	tpex	2020-11-15
711141	胡連凱基9B購01	所有證券	tpex	2020-11-15
711145	環球晶國票9B購02	所有證券	tpex	2020-11-15
73107P	原相國票9B售02	所有證券	tpex	2020-11-15
73193P	神盾元大9B售04	所有證券	tpex	2020-11-15
7402	邑錡	光電業	tpex	2025-09-30
7419	達勝	電子零組件業	emerging	2025-09-30
7427	華上生醫	生技醫療業	emerging	2025-09-30
7443	凡事康	其他	emerging	2025-09-30
7455	樺緯物聯	電腦及週邊設備業	emerging	2025-09-30
7507	環拓科技	綠能環保	emerging	2025-09-30
7516	清淨海	其他	emerging	2025-09-30
7530	鋒魁科技	半導體業	emerging	2025-09-30
7547	碩網	數位雲端類	tpex	2025-09-30
7551	知識科技	數位雲端	emerging	2025-09-30
7555	美萌	生技醫療業	emerging	2025-05-23
7556	意德士	半導體業	tpex	2025-09-30
7558	群利科技	其他	emerging	2025-09-30
7561	光晟生技	生技醫療業	emerging	2025-09-30
7562	博來科技	電腦及週邊設備業	emerging	2025-09-30
7566	亞果遊艇	觀光餐旅	emerging	2025-09-30
7575	安美得	生技醫療業	emerging	2025-09-30
7578	利百景	其他	emerging	2025-09-30
7583	國際海洋	綠能環保	emerging	2025-09-30
7584	樂意	文化創意業	tpex	2025-09-30
7590	怡和國際	其他	emerging	2025-09-30
7595	世基生醫	生技醫療業	emerging	2025-09-30
7607	通用幹細胞*	生技醫療業	emerging	2025-09-30
7610	聯友金屬-創	綠能環保	twse	2025-09-30
7631	聚賢研發-創	電子工業	twse	2025-09-30
7642	昶瑞機電	電機機械	tpex	2025-09-30
7702	前端風電	綠能環保	emerging	2025-09-30
7703	銳澤	其他電子類	tpex	2025-09-30
7704	明遠精密	半導體業	tpex	2025-09-30
7705	三商餐飲	觀光餐旅	twse	2025-09-30
7706	宏碁創達	其他	emerging	2025-09-30
7707	益芯科	半導體業	emerging	2025-09-30
7708	全家餐飲	觀光餐旅	tpex	2025-09-30
7709	榮田	電機機械	tpex	2025-09-30
7711	永擎	電腦及週邊設備業	emerging	2025-09-30
7712	博盛半導體	半導體業	tpex	2025-09-30
7713	威力德生醫	生技醫療業	tpex	2025-09-30
7714	創泓科技	數位雲端類	tpex	2025-09-30
7715	裕山	綠能環保類	tpex	2025-09-30
7716	昱臺國際	航運業	emerging	2025-09-30
7718	友鋮	鋼鐵工業	tpex	2025-09-30
7719	碳基	其他	emerging	2025-09-30
7721	微程式	數位雲端	twse	2025-09-30
7722	LINEPAY	數位雲端	twse	2025-09-30
7723	築間	觀光餐旅	tpex	2025-09-30
7724	諾亞克	生技醫療業	emerging	2025-09-30
7725	列特博	生技醫療業	emerging	2025-09-30
7726	暄達	生技醫療業	emerging	2025-09-30
7728	光焱科技	其他電子類	tpex	2025-09-30
7729	仲恩生醫	生技醫療業	emerging	2025-09-30
7730	暉盛	半導體業	emerging	2025-09-30
7731	火星生技*	食品工業	emerging	2025-09-30
7732	金興精密	汽車工業	twse	2025-09-30
7734	印能科技	半導體業	tpex	2025-09-30
7736	虎山	汽車工業	twse	2025-09-30
7737	凱鈿	數位雲端	emerging	2025-09-30
7738	東聯互動	數位雲端	emerging	2025-09-30
7740	熙特爾-創	綠能環保	twse	2025-09-30
7742	天弘化	化學工業	emerging	2025-09-30
7743	金利食安	食品工業	tpex	2025-09-30
7744	崴寶	電子零組件業	emerging	2025-09-30
7747	昕奇雲端	數位雲端類	tpex	2025-09-30
7748	鑫囍創業	其他	emerging	2025-09-30
7749	意騰-KY	電子工業	twse	2025-09-30
7750	新代	電機機械	twse	2025-09-30
7751	竑騰	半導體業	tpex	2025-09-30
7752	世紀樺欣	綠能環保	emerging	2025-09-30
7753	星亞	光電業	tpex	2025-09-30
7754	安基生技	生技醫療業	emerging	2025-09-30
7756	多那之	觀光餐旅	emerging	2025-09-30
7757	金色三麥	觀光餐旅	emerging	2025-09-30
7758	睿騰能源	電子零組件業	emerging	2025-09-30
7759	視航生醫	生技醫療業	emerging	2025-09-30
7760	享溫馨	觀光餐旅	emerging	2025-09-30
7761	三大未來	綠能環保	emerging	2025-09-30
7762	吉晟生	生技醫療業	emerging	2025-09-30
7763	崇舜	化學工業	emerging	2025-09-30
7764	聖州	其他	emerging	2025-09-30
7765	中華資安	數位雲端	twse	2025-09-30
7767	仁大資訊	資訊服務業	emerging	2025-09-30
7768	頌勝科技	半導體業	emerging	2025-09-30
7769	鴻勁	半導體業	emerging	2025-09-30
7770	君曜	半導體業	emerging	2025-09-30
7772	耀穎	半導體業	emerging	2025-09-30
7773	富禾生醫	生技醫療業	emerging	2025-09-30
7776	奧孟亞	生技醫療業	emerging	2025-09-30
7777	能率亞洲	其他	emerging	2025-09-30
7779	鍇睿國際	運動休閒	emerging	2025-09-30
7780	大研生醫	食品工業	twse	2025-09-30
7781	昕力資*	數位雲端	emerging	2025-09-30
7782	光速火箭	居家生活	emerging	2025-09-30
7783	佳運	綠能環保	emerging	2025-09-30
7785	北祥科服	數位雲端	emerging	2025-09-30
7786	東方風能	綠能環保	emerging	2025-09-30
7788	松川精密	電子零組件業	emerging	2025-09-30
7789	開展	觀光餐旅	emerging	2025-09-30
7790	思必瑞特	生技醫療業	emerging	2025-09-30
7791	皇家可口	食品工業	emerging	2025-09-30
7792	安葆	其他電子業	emerging	2025-09-30
7794	宏碁智新	居家生活	emerging	2025-09-30
7795	長廣	電子零組件業	emerging	2025-09-30
7796	擷發科	半導體業	emerging	2025-09-30
7797	Q Burger	觀光餐旅	emerging	2025-09-30
7799	禾榮科	生技醫療業	twse	2025-09-30
7801	華芸科技	資訊服務業	emerging	2025-09-30
7803	雲象科技	生技醫療業	emerging	2025-09-30
7805	威聯通	數位雲端	emerging	2025-09-30
7806	精華生醫	食品工業	emerging	2025-09-30
7808	訊聯智藥	生技醫療業	emerging	2025-09-30
7810	捷創科技	半導體業	emerging	2025-09-30
7811	民盛	運動休閒	emerging	2025-09-30
7812	稜研科技*	通信網路業	emerging	2025-09-30
7813	宇辰系統	其他電子業	emerging	2025-09-30
7814	海昌生技	生技醫療業	emerging	2025-09-30
7815	新特	半導體業	emerging	2025-09-30
7816	來穎	電子零組件業	emerging	2025-09-30
7818	溢泰實業	其他	emerging	2025-09-30
7819	精誠金融	資訊服務業	emerging	2025-09-30
7820	立盈	綠能環保	emerging	2025-09-30
7821	神數	其他電子業	emerging	2025-09-30
7822	倍利科	半導體業	emerging	2025-09-30
7824	智寶	其他	emerging	2025-09-30
7825	和亞智慧	其他電子業	emerging	2025-09-30
7826	極風雲創	數位雲端	emerging	2025-09-30
7827	漢康-KY	生技醫療業	emerging	2025-09-30
7828	創新服務	半導體業	emerging	2025-09-30
7829	思捷優達-KY	生技醫療業	emerging	2025-09-30
7831	捷博	居家生活	emerging	2025-09-30
7832	智新生技*	生技醫療業	emerging	2025-09-30
7833	綠岩能源	綠能環保	emerging	2025-09-30
7834	來毅數位	資訊服務業	emerging	2025-09-30
7836	今網智慧	其他	emerging	2025-09-30
7837	啟新生	生技醫療業	emerging	2025-09-30
7839	達人網	數位雲端	emerging	2025-09-30
7840	祥圃	農業科技	emerging	2025-09-30
7841	經貿聯網	資訊服務業	emerging	2025-09-30
7842	天能綠電	綠能環保	emerging	2025-09-30
7843	英柏得	半導體業	emerging	2025-09-30
7846	德揚	綠能環保	emerging	2025-09-30
7847	豊漁	觀光餐旅	emerging	2025-09-30
7848	騏億鑫	其他電子業	emerging	2025-09-30
7849	旭誼	其他電子業	emerging	2025-09-30
7850	寶泰生醫	生技醫療業	emerging	2025-09-30
7853	政美應用	半導體業	emerging	2025-09-30
7855	和運租車	其他	emerging	2025-09-30
7856	漢測	半導體業	emerging	2025-09-30
7857	合水先進	綠能環保	emerging	2025-09-30
7858	芝普	化學工業	emerging	2025-09-30
7860	得生製藥	生技醫療業	emerging	2025-09-30
7863	中科物流	航運業	emerging	2025-09-30
8008	建興電	電子工業	twse	2024-12-04
8011	台通	電子工業	twse	2025-09-30
8016	矽創	電子工業	twse	2025-09-30
8021	尖點	電子工業	twse	2025-09-30
8024	佑華	半導體業	tpex	2025-09-30
8027	鈦昇	電機機械	tpex	2025-09-30
8028	昇陽半導體	電子工業	twse	2025-09-30
8032	光菱	電子通路業	tpex	2025-09-30
8033	雷虎	其他	twse	2025-09-30
8034	榮群	通信網路業	tpex	2025-09-30
8038	長園科	電子零組件業	tpex	2025-09-30
8039	台虹	電子工業	twse	2025-09-30
8040	九暘	半導體業	tpex	2025-09-30
8041	東元精電	電機機械	emerging	2024-08-22
8042	金山電	電子零組件業	tpex	2025-09-30
8043	蜜望實	電子零組件業	tpex	2025-09-30
8044	網家	數位雲端類	tpex	2025-09-30
8045	達運光電	電子工業	twse	2025-09-30
8046	南電	電子零組件業	twse	2025-09-30
8047	星雲	其他電子類	tpex	2025-09-30
8048	德勝	通信網路業	tpex	2025-09-30
8049	晶采	光電業	tpex	2025-09-30
8050	廣積	電腦及週邊設備業	tpex	2025-09-30
8054	安國	半導體業	tpex	2025-09-30
8058	耐特	其他電子業	emerging	2025-09-30
8059	凱碩	通信網路業	tpex	2025-09-30
8064	東捷	光電業	tpex	2025-09-30
8066	來思達	居家生活類	tpex	2025-09-30
8067	志旭	電子通路業	tpex	2025-09-30
8068	全達	電子通路業	tpex	2025-09-30
8069	元太	光電業	tpex	2025-09-30
8070	長華*	電子通路業	twse	2025-09-30
8071	能率網通	電子零組件業	tpex	2025-09-30
8072	陞泰	電子通路業	twse	2025-09-30
8074	鉅橡	電子零組件業	tpex	2025-09-30
8076	伍豐	電腦及週邊設備業	tpex	2025-09-30
8077	洛碁	觀光餐旅	tpex	2025-09-30
8078	華寶	電子工業	twse	2024-12-04
8080	泰霖	建材營造	tpex	2025-09-30
8081	致新	電子工業	twse	2025-09-30
8083	瑞穎	電機機械	tpex	2025-09-30
8084	巨虹	電子通路業	tpex	2025-09-30
8085	福華	其他電子類	tpex	2025-09-30
8086	宏捷科	半導體業	tpex	2025-09-30
8087	麗升能源	綠能環保類	tpex	2025-09-30
8088	品安	半導體業	tpex	2025-09-30
8089	康全電訊	通信網路業	tpex	2025-09-30
8091	翔名	半導體業	tpex	2025-09-30
8092	建暐	其他電子類	tpex	2025-09-30
8093	保銳	電子零組件業	tpex	2025-09-30
8096	擎亞	電子通路業	tpex	2025-09-30
8097	常珵	通信網路業	tpex	2025-09-30
8098	慶康科技	半導體業	emerging	2025-09-30
8099	大世科	資訊服務業	tpex	2025-09-30
8101	華冠	電子工業	twse	2025-09-30
8102	傑霖科技	半導體業	emerging	2025-09-30
8103	瀚荃	電子零組件業	twse	2025-09-30
8104	錸寶	電子工業	twse	2025-09-30
8105	凌巨	電子工業	twse	2025-09-30
8107	大億金茂	電機機械	tpex	2025-09-30
8109	博大	電子零組件業	tpex	2025-09-30
8110	華東	電子工業	twse	2025-09-30
8111	立碁	光電業	tpex	2025-09-30
8112	至上	電子工業	twse	2025-09-30
8112A	至上甲特	電子工業	twse	2025-09-30
8114	振樺電	電子工業	twse	2025-09-30
8119	公信	電腦及週邊設備業	emerging	2025-09-30
8121	越峰	電子零組件業	tpex	2025-09-30
8131	福懋科	電子工業	twse	2025-09-30
8147	正淩	電子零組件業	tpex	2025-09-30
8150	南茂	電子工業	twse	2025-09-30
8162	微矽電子-創	電子工業	twse	2025-09-30
8163	達方	電腦及週邊設備業	twse	2025-09-30
8171	天宇	綠能環保類	tpex	2025-09-30
8176	智捷	通信網路業	tpex	2025-09-30
8182	加高	電子零組件業	tpex	2025-09-30
8183	精星	其他電子類	tpex	2025-09-30
8199	廣鎵	光電業	twse	2024-12-04
8201	無敵	電子工業	twse	2025-09-30
8210	勤誠	電腦及週邊設備業	twse	2025-09-30
8213	志超	電子零組件業	twse	2025-09-30
8215	明基材	電子工業	twse	2025-09-30
8222	寶一	電機機械	twse	2025-09-30
8227	巨有科技	半導體業	tpex	2025-09-30
8234	新漢	電腦及週邊設備業	tpex	2025-09-30
8240	華宏	光電業	tpex	2025-09-30
8249	菱光	電子零組件業	twse	2025-09-30
8255	朋程	電機機械	tpex	2025-09-30
8261	富鼎	電子工業	twse	2025-09-30
8271	宇瞻	電子工業	twse	2025-09-30
8272	全景軟體	資訊服務業	tpex	2025-09-30
8277	商丞	半導體業	tpex	2025-09-30
8279	生展	生技醫療業	tpex	2025-09-30
8284	三竹	資訊服務業	tpex	2025-09-30
8289	泰藝	電子零組件業	tpex	2025-09-30
8291	尚茂	電子零組件業	tpex	2025-08-22
8298	威睿	資訊服務業	emerging	2025-09-30
8299	群聯	半導體業	tpex	2025-09-30
8329	台視	文化創意業	emerging	2025-09-30
8341	日友	綠能環保	twse	2025-09-30
8342	益張	其他	tpex	2025-09-30
8345	超秦	農業科技	emerging	2025-09-30
8349	恒耀	鋼鐵工業	tpex	2025-09-30
8349A	恒耀甲特	鋼鐵工業	tpex	2025-09-30
8354	冠好	其他	tpex	2025-09-30
8358	金居	電子零組件業	tpex	2025-09-30
8359	錢櫃	觀光餐旅	emerging	2025-09-30
8367	建新國際	航運業	twse	2025-09-30
8374	羅昇	電機機械	twse	2025-09-30
8383	千附	半導體業	tpex	2025-09-30
8390	金益鼎	綠能環保類	tpex	2025-09-30
8401	白紗科	其他	tpex	2025-09-30
8403	盛弘	生技醫療業	tpex	2025-09-30
8404	百和興業-KY	其他	twse	2025-09-30
8406	金可-KY	生技醫療業	tpex	2022-04-23
8409	商之器	生技醫療業	tpex	2025-09-30
8410	森田	電腦及週邊設備業	tpex	2025-09-30
8411	福貞-KY	其他	twse	2025-09-30
8415	大國鋼	鋼鐵工業	tpex	2025-09-30
8416	實威	資訊服務業	tpex	2025-09-30
8418	捷必勝-KY	其他	tpex	2024-01-27
8420	明揚	運動休閒類	tpex	2024-11-23
8421	旭源	其他	tpex	2025-09-30
8422	可寧衛	綠能環保	twse	2025-09-30
8423	保綠-KY	綠能環保類	tpex	2025-09-30
8424	惠普	建材營造	tpex	2025-09-30
8426	紅木-KY	其他	tpex	2025-09-30
8427	基勝-KY	其他	twse	2025-09-26
8429	金麗-KY	貿易百貨	twse	2025-09-30
8431	匯鑽科	其他電子類	tpex	2025-09-30
8432	東生華	生技醫療業	tpex	2025-09-30
8433	弘帆	居家生活類	tpex	2025-09-30
8435	鉅邁	其他	tpex	2025-09-30
8436	大江	生技醫療業	tpex	2025-09-30
8437	大地-KY	其他	tpex	2025-09-30
8438	昶昕	綠能環保	twse	2025-09-30
8440	綠電	綠能環保類	tpex	2025-09-30
8442	威宏-KY	其他	twse	2025-09-30
8443	阿瘦	貿易百貨	twse	2025-09-30
8444	綠河-KY	其他	tpex	2025-09-30
8446	華研	文化創意業	tpex	2025-09-30
8450	霹靂	文化創意業	tpex	2025-09-30
8454	富邦媒	數位雲端	twse	2025-09-30
8455	大拓-KY	其他電子類	tpex	2025-09-30
8458	影一	文化創意業	emerging	2025-09-30
8462	柏文	運動休閒	twse	2025-09-30
8463	潤泰材	其他	twse	2025-09-30
8464	億豐	居家生活	twse	2025-09-30
8466	美吉吉-KY	其他	twse	2025-09-30
8467	波力-KY	運動休閒	twse	2025-09-30
8472	夠麻吉	數位雲端類	tpex	2025-09-30
8473	山林水	綠能環保	twse	2025-09-30
8476	台境*	綠能環保	twse	2025-09-30
8477	創業家	數位雲端類	tpex	2025-09-30
8478	東哥遊艇	運動休閒	twse	2025-09-30
8480	泰昇-KY	其他	twse	2025-09-26
8481	政伸	其他	twse	2025-09-30
8482	商億-KY	居家生活	twse	2025-09-30
8487	愛爾達-創	創新板股票	twse	2025-09-30
8488	吉源-KY	其他	twse	2025-09-30
8489	三貝德	其他	tpex	2025-09-30
8497	格威傳媒	其他	twse	2025-09-26
8499	鼎炫-KY	電子工業	twse	2025-09-30
8905	裕國	其他	tpex	2025-09-30
8906	花王	其他	tpex	2025-09-30
8908	欣雄	油電燃氣業	tpex	2025-09-30
8916	光隆	其他	tpex	2025-09-30
8916A	光隆甲特	其他	tpex	2023-07-21
8917	欣泰	油電燃氣業	tpex	2025-09-30
8921	沈氏	其他	tpex	2025-09-30
8923	時報	文化創意業	tpex	2025-09-30
8924	大田	運動休閒類	tpex	2025-09-30
8926	台汽電	油電燃氣業	twse	2025-09-30
8927	北基	油電燃氣業	tpex	2025-09-30
8928	鉅明	運動休閒類	tpex	2025-09-30
8929	富堡	其他	tpex	2025-09-30
8930	青鋼	鋼鐵工業	tpex	2025-09-30
8931	大汽電	油電燃氣業	tpex	2025-09-30
8932	智通*	其他	tpex	2025-09-30
8933	愛地雅	運動休閒類	tpex	2025-09-30
8934	衡平	其他	tpex	2020-11-20
8935	邦泰	其他	tpex	2025-09-30
8936	國統	其他	tpex	2025-09-30
8937	合騏	其他	tpex	2025-09-30
8938	明安	運動休閒類	tpex	2025-09-30
8940	新天地	觀光餐旅	twse	2025-09-30
8941	關中	居家生活類	tpex	2025-09-30
8942	森鉅	其他	tpex	2025-09-30
8996	高力	電機機械	twse	2025-09-30
8999	台灣積層	其他	emerging	2025-09-30
910069	新曄	存託憑證	twse	2024-12-04
9101	福雷電	存託憑證	twse	2024-12-04
9102	東亞科	存託憑證	twse	2024-12-04
9103	美德醫療-DR	存託憑證	twse	2024-12-04
910322	康師傅-DR	存託憑證	twse	2024-12-04
9104	萬宇科	存託憑證	twse	2024-12-04
910482	聖馬丁-DR	存託憑證	twse	2024-12-04
9105	泰金寶-DR	存託憑證	twse	2024-12-04
910579	歐聖	存託憑證	twse	2024-12-04
9106	新焦點-DR	存託憑證	twse	2024-12-04
910708	恒大健-DR	存託憑證	twse	2024-12-04
910801	金衛-DR	存託憑證	twse	2024-12-04
910861	神州-DR	存託憑證	twse	2024-12-04
910948	融達	存託憑證	twse	2024-12-04
9110	越南控-DR	存託憑證	twse	2024-12-04
911201	僑威控	存託憑證	twse	2024-12-04
911602	華豐泰	存託憑證	twse	2024-12-04
911606	超級	存託憑證	twse	2024-12-04
911608	明輝-DR	存託憑證	twse	2024-12-04
911609	揚子江	存託憑證	twse	2024-12-04
911610	聯環	存託憑證	twse	2024-12-04
911611	中泰山-DR	存託憑證	twse	2024-12-04
911612	滬安	存託憑證	twse	2024-12-04
911616	杜康-DR	存託憑證	twse	2024-12-04
911619	耀傑-DR	存託憑證	twse	2024-12-04
911622	泰聚亨-DR	存託憑證	twse	2024-12-04
911626	MSH-DR	存託憑證	twse	2024-12-04
911868	同方友友-DR	存託憑證	twse	2024-12-04
912000	晨訊科-DR	存託憑證	twse	2024-12-04
912398	友佳-DR	存託憑證	twse	2024-12-04
9136	巨騰-DR	存託憑證	twse	2024-12-04
913889	大成糖	存託憑證	twse	2024-12-04
9151	旺旺	存託憑證	twse	2024-12-04
9157	陽光能源-DR	存託憑證	twse	2024-12-04
916665	爾必達	存託憑證	twse	2024-12-04
9188	精熙-DR	存託憑證	twse	2024-12-04
9801	力霸	貿易百貨	twse	2024-12-04
9802	鈺齊-KY	運動休閒	twse	2025-09-30
9902	台火	其他	twse	2025-09-30
9904	寶成	運動休閒	twse	2025-09-30
9905	大華	其他	twse	2025-09-30
9906	欣巴巴	建材營造	twse	2025-09-30
9907	統一實	其他	twse	2025-09-30
9908	大台北	油電燃氣業	twse	2025-09-30
9910	豐泰	運動休閒	twse	2025-09-30
9911	櫻花	居家生活	twse	2025-09-30
9912	偉聯	電子工業	twse	2025-09-30
9914	美利達	運動休閒	twse	2025-09-30
9915	億豐	其他	twse	2024-12-04
9917	中保科	其他	twse	2025-09-30
9918	欣天然	油電燃氣業	twse	2025-09-30
9919	康那香	其他	twse	2025-09-30
9921	巨大	運動休閒	twse	2025-09-30
9922	優美	其他	twse	2024-12-04
9924	福興	居家生活	twse	2025-09-25
9925	新保	其他	twse	2025-09-30
9926	新海	油電燃氣業	twse	2025-09-30
9927	泰銘	其他	twse	2025-09-30
9928	中視	其他	twse	2025-09-30
9929	秋雨	其他	twse	2025-09-30
9930	中聯資源	綠能環保	twse	2025-09-30
9931	欣高	油電燃氣業	twse	2025-09-30
9933	中鼎	其他	twse	2025-09-30
9934	成霖	居家生活	twse	2025-09-30
9935	慶豐富	居家生活	twse	2025-09-30
9937	全國	油電燃氣業	twse	2025-09-30
9938	百和	其他	twse	2025-09-30
9939	宏全	其他	twse	2025-09-30
9940	信義	其他	twse	2025-09-30
9941	裕融	其他	twse	2025-09-30
9941A	裕融甲特	其他	twse	2025-09-30
9942	茂順	其他	twse	2025-09-30
9943	好樂迪	觀光餐旅	twse	2025-09-30
9944	新麗	其他	twse	2025-09-30
9945	潤泰新	其他	twse	2025-09-30
9946	三發地產	建材營造	twse	2025-09-30
9949	琉園	文化創意業	tpex	2025-09-30
9950	萬國通	塑膠工業	tpex	2025-09-30
9951	皇田	電機機械	tpex	2025-09-30
9955	佳龍	綠能環保	twse	2025-09-30
9957	燁聯	鋼鐵工業	emerging	2025-09-30
9958	世紀鋼	鋼鐵工業	twse	2025-09-30
9960	邁達康	運動休閒類	tpex	2025-09-30
9962	有益	鋼鐵工業	tpex	2025-09-30
\.


--
-- Data for Name: us_stock_index; Type: TABLE DATA; Schema: public; Owner: stock_db
--

COPY public.us_stock_index (index_id, index_name, trade_date, open, high, low, close, adj_close, volume, created_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: stock_db
--

COPY public.users (id, username, email, password_hash, created_at, last_login) FROM stdin;
1	seed_user	seed_user@example.com	seed_hash	2026-01-12 12:38:26.543517	\N
\.


--
-- Data for Name: watch_list; Type: TABLE DATA; Schema: public; Owner: stock_db
--

COPY public.watch_list (id, user_id, stock_id, added_at, is_active) FROM stdin;
1	1	0050	2026-01-12 12:41:11.885294	t
2	1	0051	2026-01-12 12:41:11.885294	t
3	1	0052	2026-01-12 12:41:11.885294	t
4	1	0053	2026-01-12 12:41:11.885294	t
5	1	0054	2026-01-12 12:41:11.885294	t
6	1	0055	2026-01-12 12:41:11.885294	t
7	1	0056	2026-01-12 12:41:11.885294	t
8	1	0057	2026-01-12 12:41:11.885294	t
\.


--
-- Name: api_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stock_db
--

SELECT pg_catalog.setval('public.api_log_id_seq', 1, false);


--
-- Name: stock_news_news_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stock_db
--

SELECT pg_catalog.setval('public.stock_news_news_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stock_db
--

SELECT pg_catalog.setval('public.users_id_seq', 1, true);


--
-- Name: watch_list_id_seq; Type: SEQUENCE SET; Schema: public; Owner: stock_db
--

SELECT pg_catalog.setval('public.watch_list_id_seq', 8, true);


--
-- Name: api_log api_log_pkey; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.api_log
    ADD CONSTRAINT api_log_pkey PRIMARY KEY (id);


--
-- Name: eps_quarter eps_quarter_pkey; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.eps_quarter
    ADD CONSTRAINT eps_quarter_pkey PRIMARY KEY (stock_id, period_end);


--
-- Name: exchange_rate exchange_rate_pkey; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.exchange_rate
    ADD CONSTRAINT exchange_rate_pkey PRIMARY KEY (rate_date, currency);


--
-- Name: fin_raw fin_raw_pkey; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.fin_raw
    ADD CONSTRAINT fin_raw_pkey PRIMARY KEY (stock_id, period_end, type, source_rev);


--
-- Name: stock_dailyprice stock_dailyprice_pkey; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.stock_dailyprice
    ADD CONSTRAINT stock_dailyprice_pkey PRIMARY KEY (trade_date, stock_id);


--
-- Name: stock_info stock_info_pkey; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.stock_info
    ADD CONSTRAINT stock_info_pkey PRIMARY KEY (stock_id);


--
-- Name: market_news stock_news_pkey; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.market_news
    ADD CONSTRAINT stock_news_pkey PRIMARY KEY (news_id);


--
-- Name: market_news uq_market_news; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.market_news
    ADD CONSTRAINT uq_market_news UNIQUE (market, stock_id_norm, published_at, title);


--
-- Name: us_stock_index us_stock_index_pkey; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.us_stock_index
    ADD CONSTRAINT us_stock_index_pkey PRIMARY KEY (index_id, trade_date);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: watch_list watch_list_pkey; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.watch_list
    ADD CONSTRAINT watch_list_pkey PRIMARY KEY (id);


--
-- Name: watch_list watch_list_user_id_stock_id_key; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.watch_list
    ADD CONSTRAINT watch_list_user_id_stock_id_key UNIQUE (user_id, stock_id);


--
-- Name: watch_list watch_list_user_stock_unique; Type: CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.watch_list
    ADD CONSTRAINT watch_list_user_stock_unique UNIQUE (user_id, stock_id);


--
-- Name: idx_eps_q_id; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_eps_q_id ON public.eps_quarter USING btree (stock_id, period_end DESC);


--
-- Name: idx_exchange_rate_currency; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_exchange_rate_currency ON public.exchange_rate USING btree (currency, rate_date DESC);


--
-- Name: idx_fs_raw_eps; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_fs_raw_eps ON public.fin_raw USING btree (stock_id, type, period_end);


--
-- Name: idx_market_news_symbol_time; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_market_news_symbol_time ON public.market_news USING btree (market, stock_id, published_at DESC);


--
-- Name: idx_market_news_time; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_market_news_time ON public.market_news USING btree (published_at DESC);


--
-- Name: idx_price_id_date; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_price_id_date ON public.stock_dailyprice USING btree (stock_id, trade_date DESC);


--
-- Name: idx_stock_info_category; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_stock_info_category ON public.stock_info USING btree (industry_category);


--
-- Name: idx_stock_info_list_type; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_stock_info_list_type ON public.stock_info USING btree (list_type);


--
-- Name: idx_stock_info_name; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_stock_info_name ON public.stock_info USING btree (stock_name);


--
-- Name: idx_stock_news_id_time; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_stock_news_id_time ON public.market_news USING btree (stock_id, published_at DESC);


--
-- Name: idx_stock_news_source; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_stock_news_source ON public.market_news USING btree (source);


--
-- Name: idx_us_stock_index_date; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_us_stock_index_date ON public.us_stock_index USING btree (index_id, trade_date DESC);


--
-- Name: idx_watch_list_stock; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_watch_list_stock ON public.watch_list USING btree (stock_id);


--
-- Name: idx_watch_list_user; Type: INDEX; Schema: public; Owner: stock_db
--

CREATE INDEX idx_watch_list_user ON public.watch_list USING btree (user_id);


--
-- Name: eps_quarter eps_quarter_stock_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.eps_quarter
    ADD CONSTRAINT eps_quarter_stock_id_fkey FOREIGN KEY (stock_id) REFERENCES public.stock_info(stock_id);


--
-- Name: fin_raw fin_raw_stock_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.fin_raw
    ADD CONSTRAINT fin_raw_stock_id_fkey FOREIGN KEY (stock_id) REFERENCES public.stock_info(stock_id);


--
-- Name: stock_dailyprice stock_dailyprice_stock_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.stock_dailyprice
    ADD CONSTRAINT stock_dailyprice_stock_id_fkey FOREIGN KEY (stock_id) REFERENCES public.stock_info(stock_id);


--
-- Name: market_news stock_news_stock_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.market_news
    ADD CONSTRAINT stock_news_stock_id_fkey FOREIGN KEY (stock_id) REFERENCES public.stock_info(stock_id);


--
-- Name: watch_list watch_list_stock_fk; Type: FK CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.watch_list
    ADD CONSTRAINT watch_list_stock_fk FOREIGN KEY (stock_id) REFERENCES public.stock_info(stock_id) ON DELETE CASCADE;


--
-- Name: watch_list watch_list_user_fk; Type: FK CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.watch_list
    ADD CONSTRAINT watch_list_user_fk FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: watch_list watch_list_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: stock_db
--

ALTER TABLE ONLY public.watch_list
    ADD CONSTRAINT watch_list_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict RIjK4itigIohilcHdTouHWYinUvLtgT6s15i50EUQYiSH6Yj7SGiBf0tyUMceCM

