# IPIP 題庫資料庫建置工作規劃

## 📋 專案目標

將 IPIP 題庫的三份 CSV 資料完整匯入到 MySQL 資料庫中。

---

## 📊 資料來源分析

### CSV 檔案清單

| 檔案 | 筆數 | 欄位 | 說明 |
|------|------|------|------|
| `ex05/IPIP_items.csv` | 3,805 | instrument, alpha, key, text, label | 英文題庫 + 量表資訊 |
| `ex05/IPIP_items-zh-tw.csv` | 3,805 | instrument, alpha, key, text, label | 中文翻譯題庫 |
| `docs/ex03/IPIP3320.csv` | 3,320 | Survey, ItemNumber | 原始 IPIP 題號參考 |

### CSV 欄位對應

| CSV 欄位 | 資料庫欄位 | 處理方式 |
|---------|-----------|---------|
| `instrument` | `InstrumentCategory.NameEn` | 需先建立 36 個量表類別 |
| `label` | `TraitCategory.NameEn` | 需先建立 246 個特質類別 |
| `text` (EN) | `QuestionBank.TextEn` | 直接對應 |
| `text` (ZH) | `QuestionBank.TextZh` | 直接對應 |
| `alpha` | `QuestionBank.Alpha` | 直接對應 |
| `key` | `QuestionBank.Key` | 直接對應 |
| `ItemNumber` | `QuestionBank.QuestionCode` | 優先使用，無則自動生成 |

---

## 🔧 資料庫結構調整

### 問題分析

1. **NameZh 欄位要求 NOT NULL**
   - CSV 中沒有 instrument 和 label 的中文翻譯
   - **解決方案**: 將 NameZh 改為 NULL 允許，先使用英文，後續補充

2. **QuestionCode 唯一性衝突**
   - 部分 ItemNumber 有逗號分隔多個值（如 "H596, X9"）
   - **解決方案**: 只取第一個值，或使用自動生成編號

3. **外鍵約束建立順序**
   - 必須先建立父表再建立子表
   - **解決方案**: 按照依賴順序建立

### 調整後的結構

#### 修改點 1: NameZh 允許 NULL

```sql
-- InstrumentCategory
NameZh VARCHAR(100) NULL  -- 原為 NOT NULL

-- TraitCategory  
NameZh VARCHAR(100) NULL  -- 原為 NOT NULL
```

#### 修改點 2: QuestionCode 處理邏輯

```sql
-- 優先使用 ItemNumber，處理多值情況
QuestionCode = COALESCE(
    SUBSTRING_INDEX(IPIP3320.ItemNumber, ',', 1),  -- 取第一個值
    CONCAT(instrument, '_', LPAD(row_id, 4, '0'))   -- 自動生成
)
```

---

## 📝 SQL 檔案規劃

### 1. CREATE_DATABASE.sql

**內容**:
- 建立資料庫
- 建立 7 個資料表（依順序）
- 建立所有索引
- 建立外鍵約束

**建立順序**:
1. `InstrumentCategory`（無依賴）
2. `TraitCategory`（無依賴）
3. `QuestionBank`（依賴 1, 2）
4. `TestPaper`（無依賴）
5. `TestPaperDetail`（依賴 3, 4）
6. `TestSession`（依賴 4）
7. `TestAnswer`（依賴 5, 6）

### 2. INSERT_DATA.sql

**內容**:
- 建立臨時表（3 個）
- 載入 CSV 資料指引
- 匯入 InstrumentCategory（36 筆）
- 匯入 TraitCategory（246 筆）
- 匯入 QuestionBank（3,805 筆）
- 資料驗證查詢

**匯入順序**:
1. 載入臨時表
2. InstrumentCategory（從 IPIP_items 去重）
3. TraitCategory（從 IPIP_items 去重）
4. QuestionBank（關聯臨時表）

---

## ⏱️ 工作時程

| 階段 | 任務 | 預估時間 |
|------|------|---------|
| 1 | 產生 CREATE_DATABASE.sql | 1 小時 |
| 2 | 產生 INSERT_DATA.sql | 2 小時 |
| 3 | 測試建立資料庫 | 0.5 小時 |
| 4 | 匯入 CSV 資料 | 1 小時 |
| 5 | 資料驗證 | 0.5 小時 |
| **總計** | | **5 小時** |

---

## ✅ 檢查清單

### CREATE 階段
- [ ] 資料庫建立成功
- [ ] 7 個資料表建立成功
- [ ] 所有索引建立成功
- [ ] 所有外鍵約束建立成功
- [ ] 字元集為 utf8mb4

### INSERT 階段
- [ ] 臨時表建立成功
- [ ] CSV 資料載入成功（3 個檔案）
- [ ] InstrumentCategory 有 36 筆
- [ ] TraitCategory 有 246 筆
- [ ] QuestionBank 有 3,805 筆
- [ ] 外鍵關聯正確
- [ ] 無資料遺失

---

## 🚨 注意事項

1. **編碼問題**: 確保 CSV 檔案為 UTF-8 編碼
2. **ItemNumber 處理**: 有逗號分隔的取第一個值
3. **中文翻譯**: 後續手動補充 NameZh 欄位
4. **備份**: 匯入前先備份資料庫
5. **測試環境**: 先在測試環境執行驗證

---

## 📂 輸出檔案

1. `CREATE_DATABASE.sql` - 資料庫建立腳本
2. `INSERT_DATA.sql` - 資料匯入腳本
3. `VERIFY_DATA.sql` - 資料驗證腳本（可選）

---

## 🔄 後續工作

1. 補充 36 個 instrument 的中文翻譯
2. 補充 246 個 label 的中文翻譯
3. 建立測卷範例資料
4. 建立 API 測試資料
5. 效能優化調整

---

## 📅 建立日期

2024-12-07

