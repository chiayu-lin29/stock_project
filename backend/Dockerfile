# backend/Dockerfile
# === 1. Official Python  ===
FROM python:3.11-slim

# === 2. 設定工作目錄 ===
WORKDIR /app

# === 3. 複製需求檔並安裝套件 ===
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# === 4. 複製全部程式到容器 ===
COPY . .

# === 5. 環境變數 ===
ENV PYTHONUNBUFFERED=1

# === 6. 對外埠口 ===
EXPOSE 8000

# === 7. 啟動指令 ===
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "wsgi:app"]
