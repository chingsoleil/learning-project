# CSV 準備檢查清單

## 📋 最終需要準備的 CSV 檔案

### ✅ 已確認在 `ex06/` 資料夾的檔案

| 檔案名稱 | 狀態 | 用途 | 說明 |
|---------|------|------|------|
| `IPIP_items-merged.csv` | ✅ 已完成 | 主要匯入檔案 | 已包含 3805 題的完整資料（9個欄位） |
| `instrument_translations_template.csv` | ✅ 已完成 | 量表翻譯範本 | 36 個量表，已完成中文翻譯 |
| `label_translations_template.csv` | ✅ 已完成 | 特質翻譯範本 | 246 個特質，已完成中文翻譯 |

---

## 🔧 準備步驟

### 步驟 1：整理主要資料 CSV（`IPIP_items-merged.csv`）

#### 使用 Excel 檔案：`DataMerge.xlsx`

**目標檔案**：`ex06/IPIP_items-merged.csv`

**欄位結構**（9 個欄位）：
```csv
instrument,alpha,alpha2,scoring_key,text_en,text_zh,label,label_zh,IPIP_item_number
```

**資料來源**：
- `instrument`, `alpha`, `key`, `text_en`, `label` → 來自 `IPIP_items.csv`（合併時將 `key` 改為 `scoring_key`，資料庫欄位名稱：`ScoringKey`）
- `alpha2` → 從 `alpha` 欄位分離（如果有兩個 alpha 值）
- `text_zh` → 來自 `IPIP_items-zh-tw.csv`（對應同一列）
- `label_zh` → 來自 `label_translations_template.csv`（匹配 `label` 欄位）
- `IPIP_item_number` → 來自 `IPIP3320.csv`（透過題目文字匹配）

**資料處理**：
- ✅ Alpha 值已分離為 `alpha` 和 `alpha2` 兩個欄位
- ✅ 異常值已修正（BIS_BAS 的 1994 和 MPQ 的 12 已改為空值）
- ✅ 中文翻譯已完成（`label_zh` 欄位已填入）

**資料量**：
- 總共 **3,805 題**（每一列對應一題）

**注意事項**：
- ✅ 必須包含標題列（第一列）
- ✅ 所有欄位必須對齊
- ✅ 文字欄位如果包含逗號或換行，需要用雙引號包圍
- ✅ 必須以 **UTF-8 編碼**儲存

---

### 步驟 2：準備翻譯範本 CSV（選填）

#### 2.1 `instrument_translations_template.csv`

**檔案位置**：`ex06/instrument_translations_template.csv`

**欄位結構**：
```csv
instrument_en,instrument_zh,description
```

**資料來源**：
- `instrument_en`：從 `IPIP_items-merged.csv` 的 `instrument` 欄位提取不重複值（36 個）
- `instrument_zh`：填入中文翻譯（可選）
- `description`：填入描述（可選）

**Excel 操作**：
1. 從 `IPIP_items-merged.csv` 選取 `instrument` 欄位
2. **資料** → **移除重複值**
3. 建立三欄：`instrument_en`, `instrument_zh`, `description`
4. 填入中文翻譯（如果需要的話）

#### 2.2 `label_translations_template.csv`

**檔案位置**：`ex06/label_translations_template.csv`

**欄位結構**：
```csv
label_en,label_zh,description
```

**資料來源**：
- `label_en`：從 `IPIP_items-merged.csv` 的 `label` 欄位提取不重複值（246 個）
- `label_zh`：填入中文翻譯（可選）
- `description`：填入描述（可選）

**Excel 操作**：
1. 從 `IPIP_items-merged.csv` 選取 `label` 欄位
2. **資料** → **移除重複值**
3. 建立三欄：`label_en`, `label_zh`, `description`
4. 填入中文翻譯（如果需要的話）

---

## ⚠️ 重要注意事項

### 1. UTF-8 編碼（重要：不要 BOM）

**必須以 UTF-8 without BOM 編碼儲存 CSV 檔案！**

⚠️ **關鍵**：使用 **UTF-8 without BOM**，不是 UTF-8 with BOM。

#### Excel 儲存為 UTF-8 without BOM 的方法：

**方法 A：使用記事本轉換（推薦）**
1. Excel 另存為一般 CSV（CSV (逗號分隔) (*.csv)）
2. 用記事本開啟
3. **檔案** → **另存新檔**
4. **編碼**選擇：**UTF-8**（⚠️ 不是「UTF-8 with BOM」）
5. 儲存

**方法 B：使用 Excel 的 UTF-8 選項（需驗證）**
1. **檔案** → **另存新檔**
2. **檔案類型**選擇：**CSV UTF-8 (逗號分隔) (*.csv)**
3. ⚠️ **注意**：這個選項可能帶 BOM，建議用方法 A 或驗證後轉換

**驗證方法**：
- 用記事本開啟 CSV
- **檔案** → **另存新檔**
- 檢查編碼欄位顯示為「UTF-8」（不是「UTF-8 with BOM」）

**詳細說明**：請參考 `UTF8_BOM_GUIDE.md`

---

### 2. CSV 格式規範

#### 欄位分隔符號
- 使用 **逗號** (`,`) 分隔欄位

#### 文字限定符號
- 如果欄位內容包含逗號、換行、雙引號，必須用 **雙引號** (`"`) 包圍
- 範例：
  ```csv
  "This is a question, right?",Yes,No
  ```

#### 換行符號
- Windows：`\r\n`
- 資料庫匯入時通常會自動處理

---

### 3. 資料完整性檢查

#### `IPIP_items-merged.csv` 檢查項目：

- [ ] 標題列正確（9 個欄位：instrument, alpha, alpha2, scoring_key, text_en, text_zh, label, label_zh, IPIP_item_number）
- [ ] 總共 3,805 列資料（不含標題列）
- [ ] `instrument` 欄位：36 個不重複值
- [ ] `label` 欄位：246 個不重複值
- [ ] `text_en` 和 `text_zh` 都有值（不能為空）
- [ ] `alpha` 和 `alpha2` 欄位：已分離，異常值已修正
- [ ] `label_zh` 欄位：已填入中文翻譯
- [ ] `IPIP_item_number` 可為空（約 485 題沒有 item number）
- [ ] 所有中文文字顯示正常（UTF-8 編碼正確）

#### 翻譯範本檢查項目：

- [ ] `instrument_translations_template.csv`：36 個量表
- [ ] `label_translations_template.csv`：246 個特質
- [ ] （可選）中文翻譯已填入

---

## 📂 檔案路徑對照

### SQL 匯入時使用的路徑

在 `INSERT_DATA_DIRECT.sql` 中，CSV 檔案路徑為：

```sql
-- 主要資料檔案
LOAD DATA INFILE 'D:/github/learning-project/ex06/IPIP_items-merged.csv'
INTO TABLE temp_ipip_merged
...

-- 翻譯範本（透過 DBeaver Import Data 匯入）
-- 路徑：ex06/instrument_translations_template.csv
-- 路徑：ex06/label_translations_template.csv
```

**確認**：
- ✅ 所有 CSV 檔案都放在 `ex06/` 資料夾
- ✅ 路徑中的斜線使用 `/` 或 `\\`（Windows）
- ✅ 絕對路徑：`D:/github/learning-project/ex06/`

---

## 🎯 最終檢查清單

匯入資料前，確認：

- [ ] `ex06/IPIP_items-merged.csv` 已準備完成（3,805 題）
- [ ] `ex06/instrument_translations_template.csv` 已準備完成（36 個量表）
- [ ] `ex06/label_translations_template.csv` 已準備完成（246 個特質）
- [ ] 所有 CSV 檔案都是 **UTF-8 編碼**
- [ ] 所有 CSV 檔案都有正確的標題列
- [ ] 資料完整性已檢查（數量、格式正確）

---

## 📝 下一步

準備完成後，執行：

1. **執行 `CREATE_DATABASE.sql`** 建立資料庫結構
2. **執行 `INSERT_DATA_DIRECT.sql`** 匯入資料
   - 步驟 2：匯入 `IPIP_items-merged.csv` 到臨時表
   - 步驟 3：匯入翻譯範本 CSV（如果已準備）
   - 步驟 4-6：匯入正式資料表

詳細步驟請參考 `README.md`。

---

**最後更新**：2024-12-07  
**版本**：2.0（CSV 結構已更新為 9 個欄位，翻譯已完成）

