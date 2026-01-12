from backend.services.twse_openapi import fetch_stock_day

# 抓 0050 在 2025 年 9 月的日價
df = fetch_stock_day("0050", "202509")

print(df.head())
df.to_csv("0050_202509.csv", index=False, encoding="utf-8")
print("已存成 CSV：0050_202509.csv")
