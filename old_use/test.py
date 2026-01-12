import requests
import pandas as pd
from io import StringIO

#API URL
url = "https://openapi.twse.com.tw/v1/exchangeReport/STOCK_DAY_ALL"

#json format
# r = requests.get(url, headers={"accept":"application/json"}) #指定要json format
# r.raise_for_status() #check http response狀態(成功>200)
# data = r.json() # 轉換回傳字串成python list of dicts
# df_json = pd.DataFrame(data) #表格結構
# print("JSON data: ")
# print(df_json.head(10))

#csv format
r = requests.get(url, headers={"accept":"text/csv"})
r.raise_for_status()
df_csv = pd.read_csv(StringIO(r.content.decode("utf-8")))
df_csv.to_csv("test.csv", index=False,encoding="utf-8-sig")
print("done")
print(df_csv.tail())