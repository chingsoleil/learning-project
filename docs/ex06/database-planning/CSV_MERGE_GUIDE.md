# CSV 合併指南

## 📋 目標

將三個 CSV 檔案合併成一個完整的 CSV，只需**一個臨時表**即可匯入到資料庫，簡化匯入流程。

---

## 🔄 合併後的 CSV 格式

### 檔案名稱
```
IPIP_items-merged.csv
```

### 欄位結構（7 個欄位）

| 欄位名稱 | 資料類型 | 來源 | 說明 | 必填 |
|---------|---------|------|------|------|
| `instrument` | VARCHAR(50) | `IPIP_items.csv` | 量表名稱（英文） | ✅ |
| `alpha` | DECIMAL(5,3) | `IPIP_items.csv` | 信度係數（0.000-1.000） | ❌ 可為空 |
| `key` | TINYINT | `IPIP_items.csv` | 計分方向：1=正向, -1=反向 | ✅ |
| `text_en` | TEXT | `IPIP_items.csv` 的 `text` | 英文題目 | ✅ |
| `text_zh` | TEXT | `IPIP_items-zh-tw.csv` 的 `text` | 中文題目 | ✅ |
| `label` | VARCHAR(100) | `IPIP_items.csv` | 特質名稱（英文） | ✅ |
| `IPIP_item_number` | VARCHAR(50) | `IPIP3320.csv` 的 `ItemNumber` | IPIP item number（參考用） | ❌ 可為空 |

### CSV 範例（前 3 行）

```csv
instrument,alpha,key,text_en,text_zh,label,IPIP_item_number
16PF,0.78,1,Act wild and crazy.,行為狂野瘋狂。,Gregariousness,
16PF,0.8,1,Am afraid that I will do the wrong thing.,我擔心自己會做錯事。,Anxiety,
16PF,0.76,1,Am annoyed by others' mistakes.,我會因他人的錯誤而感到煩躁。,Emotionality,
```

---

## 📝 合併步驟

1. **開啟三個 CSV 檔案**：
   - `IPIP_items.csv` (英文)
   - `IPIP_items-zh-tw.csv` (中文)
   - `IPIP3320.csv` (ItemNumber)

2. **建立新工作表**，設定欄位標題：
   ```
   instrument,alpha,key,text_en,text_zh,label,IPIP_item_number
   ```

3. **複製資料**（確保行順序一致）：
   - `instrument` ← 從英文 CSV 的 `instrument` 欄位
   - `alpha` ← 從英文 CSV 的 `alpha` 欄位
   - `key` ← 從英文 CSV 的 `key` 欄位
   - `text_en` ← 從英文 CSV 的 `text` 欄位
   - `text_zh` ← 從中文 CSV 的 `text` 欄位（對應相同行號）
   - `label` ← 從英文 CSV 的 `label` 欄位
   - `IPIP_item_number` ← 從 `IPIP3320.csv` 透過 `text_en` 匹配 `Survey` 欄位

4. **儲存為 CSV**：
   - 檔案名稱：`IPIP_items-merged.csv`
   - 編碼：UTF-8
   - 分隔符號：逗號

---

## ✅ 合併前檢查清單

- [ ] 確認英文和中文 CSV 都有 **3,805 行資料**（不含標題列）
- [ ] 確認英文和中文 CSV 的**行順序一致**（第 N 行對應同一題）
- [ ] 確認所有 CSV 編碼為 **UTF-8**
- [ ] 確認 `text_en` 和 `text_zh` 有對應關係
- [ ] 確認 `IPIP_item_number` 欄位可以透過 `text_en` 匹配到（約 87% 可匹配）

---

## 📊 合併後的資料統計

- **總筆數**：3,805 題
- **欄位數**：7 個
- **Primary Key**：`Id`（自動遞增，系統產生）
- **IPIP item number**：僅為參考用
  - 有 IPIP item number 的題目：約 3,320 題（87%）
  - 無 IPIP item number 的題目：約 485 題（13%）
  - **注意**：IPIP item number 不是 Primary Key，也不是唯一值，允許為 NULL 和重複值，僅作為研究參考用

---

## 🚀 使用合併後的 CSV

1. **執行 `CREATE_DATABASE.sql`** 建立資料庫結構

2. **執行 `INSERT_DATA_DIRECT.sql`**：
   - 步驟 1：建立單一臨時表 `temp_ipip_merged`
   - 步驟 2：匯入 `IPIP_items-merged.csv` 到臨時表
   - 步驟 3-5：匯入到正式資料表
   - 步驟 8：清理臨時表（可選）

3. **驗證資料**：檢查匯入報告

---

## ⚠️ 注意事項

1. **IPIP item number 說明**：
   - IPIP item number 只是參考用，不是 Primary Key
   - 對應資料庫欄位：`QuestionBank.IPIPItemNumber`
   - 允許為 NULL，也允許重複值（非唯一）
   - Primary Key 是資料庫自動產生的 `Id`（自動遞增）
   - 無法匹配 IPIP item number 時可留空（NULL）

2. **中文編碼**：
   - 確保 CSV 儲存為 UTF-8 編碼
   - 避免使用 Excel 直接另存，建議使用 UTF-8 編輯器

3. **資料驗證**：
   - 合併後建議檢查前幾行資料是否正確
   - 確認中英文題目對應關係

---

## 📞 下一步

合併完成後，請使用 `INSERT_DATA_DIRECT.sql` 進行匯入。

