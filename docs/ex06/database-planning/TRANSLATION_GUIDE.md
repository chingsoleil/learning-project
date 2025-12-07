# 翻譯範本使用指南

## 📋 這兩個 CSV 檔案的用途

### 檔案說明

| 檔案 | 用途 | 資料筆數 |
|------|------|---------|
| `instrument_translations_template.csv` | 量表名稱中文翻譯範本 | 36 個 |
| `label_translations_template.csv` | 特質名稱中文翻譯範本 | 246 個 |

---

## 🔍 資料來源

### 這些值從哪裡來的？

這些 CSV 檔案中的**英文名稱**是從原始資料中**自動提取**的不重複值。

**您也可以用 Excel 從 3805 題的 CSV 自行 GROUP 出來！** 詳細步驟請參考 `TRANSLATION_TEMPLATE_GUIDE.md`。

### 自動提取方式

#### 1. `instrument_translations_template.csv`

**來源**：`IPIP_items.csv` 的 `instrument` 欄位

**提取方式**：
```sql
SELECT DISTINCT instrument FROM temp_ipip_merged
```

**結果**：36 個不重複的量表名稱
- `16PF`, `BigFive`, `NEO`, `HEXACO_PI`, `MMPI`, 等等

#### 2. `label_translations_template.csv`

**來源**：`IPIP_items.csv` 的 `label` 欄位

**提取方式**：
```sql
SELECT DISTINCT label FROM temp_ipip_merged
```

**結果**：246 個不重複的特質名稱
- `Gregariousness`, `Anxiety`, `Openness`, `Conscientiousness`, 等等

---

## 📝 目前的狀態

### 檔案結構

#### `instrument_translations_template.csv`
```csv
"instrument_en","instrument_zh","description"
"16PF","",""                    ← 中文欄位是空的
"BigFive","",""                 ← 需要手動填入
"NEO","",""                     ← 需要手動填入
```

#### `label_translations_template.csv`
```csv
"label_en","label_zh","description"
"Achievement-striving","",""    ← 中文欄位是空的
"Anxiety","",""                 ← 需要手動填入
"Openness","",""                ← 需要手動填入
```

---

## 🎯 使用目的

### 為什麼需要這些翻譯範本？

在資料匯入時，SQL 腳本會自動處理：

```sql
-- 步驟 4: 匯入 InstrumentCategory（支援翻譯範本）
INSERT INTO InstrumentCategory (NameEn, NameZh, ...)
SELECT DISTINCT 
    tm.instrument AS NameEn,
    -- 優先使用翻譯範本的中文，如果沒有則使用英文作為備用
    COALESCE(
        NULLIF(TRIM(trans.instrument_zh), ''),
        tm.instrument
    ) AS NameZh,
    ...
FROM temp_ipip_merged tm
LEFT JOIN temp_instrument_translations trans ON tm.instrument = trans.instrument_en
```

**兩種使用方式**：

1. ✅ **匯入時直接使用**（推薦）
   - 如果翻譯範本已經準備好中文，在執行 `INSERT_DATA_DIRECT.sql` 時會自動使用
   - 資料匯入時直接包含中文翻譯，不需要後續更新

2. ⚠️ **後續補充翻譯**
   - 如果翻譯範本還沒準備好，可以先匯入（使用英文作為備用）
   - 後續填入翻譯後，使用 SQL UPDATE 更新資料庫

---

## 📊 資料對應關係

### 翻譯範本 → 資料表對應

| 翻譯範本欄位 | → | 資料表欄位 | 說明 |
|-------------|---|-----------|------|
| `instrument_en` | → | `InstrumentCategory.NameEn` | 用於匹配（比對用） |
| `instrument_zh` | → | `InstrumentCategory.NameZh` | 更新為中文 |
| `description` | → | `InstrumentCategory.Description` | 更新描述 |
| `label_en` | → | `TraitCategory.NameEn` | 用於匹配（比對用） |
| `label_zh` | → | `TraitCategory.NameZh` | 更新為中文 |
| `description` | → | `TraitCategory.Description` | 更新描述 |

---

## 🔧 使用步驟

### 方式一：匯入時直接使用（推薦）✨

如果**已經準備好中文翻譯**，可以在資料匯入時就一併處理：

#### 步驟 1：填寫中文翻譯

打開 CSV 檔案，填入中文翻譯：

**範例**：
```csv
"instrument_en","instrument_zh","description"
"16PF","十六種人格因素測驗",""
"BigFive","大五人格測驗",""
"NEO","NEO 人格量表",""
```

```csv
"label_en","label_zh","description"
"Anxiety","焦慮","情緒不穩定的表現之一"
"Openness","開放性","對新經驗的開放程度"
"Conscientiousness","嚴謹性","自律和組織能力"
```

#### 步驟 2：在 INSERT SQL 中載入翻譯範本

執行 `INSERT_DATA_DIRECT.sql` 時：

1. **步驟 3**：系統會自動建立臨時表 `temp_instrument_translations` 和 `temp_label_translations`
2. 使用 DBeaver Import Data 功能：
   - 右鍵 `temp_instrument_translations` → Import Data
   - 選擇檔案：`docs/ex06/database-planning/instrument_translations_template.csv`
   - 右鍵 `temp_label_translations` → Import Data
   - 選擇檔案：`docs/ex06/database-planning/label_translations_template.csv`
3. **步驟 4-5**：匯入分類表時，系統會自動使用翻譯範本的中文
4. **如果翻譯範本未準備好**：可以跳過步驟 2，系統會使用英文作為備用

#### 步驟 3：驗證翻譯結果

執行完成後，SQL 會自動顯示翻譯狀態統計。

---

### 方式二：後續補充翻譯

如果**匯入時未準備翻譯**，可以後續補充：

#### 步驟 1：填寫中文翻譯

打開 CSV 檔案，填入中文翻譯（同方式一的步驟 1）

#### 步驟 2：匯入翻譯到資料庫

##### 方法 A：使用 SQL UPDATE（推薦）

```sql
-- 先載入翻譯到臨時表
CREATE TEMPORARY TABLE temp_instrument_trans AS
SELECT * FROM (
    -- 這裡需要將 CSV 資料匯入到臨時表或直接寫在 SQL 中
    SELECT '16PF' AS instrument_en, '十六種人格因素測驗' AS instrument_zh, '' AS description
    UNION ALL
    SELECT 'BigFive', '大五人格測驗', ''
    -- ... 其他翻譯
) AS trans;

-- 更新 InstrumentCategory 的中文翻譯
UPDATE InstrumentCategory ic
INNER JOIN temp_instrument_trans trans ON ic.NameEn = trans.instrument_en
SET 
    ic.NameZh = trans.instrument_zh,
    ic.Description = NULLIF(trans.description, ''),
    ic.UpdatedAt = NOW();
```

##### 方法 B：使用 DBeaver 的 Import Data 功能

1. 建立臨時表來載入翻譯 CSV
2. 使用 UPDATE + JOIN 更新正式資料表
3. 刪除臨時表

#### 步驟 3：驗證翻譯結果

```sql
-- 檢查哪些已經有中文翻譯
SELECT 
    NameEn,
    NameZh,
    CASE WHEN NameZh = NameEn THEN '未翻譯' ELSE '已翻譯' END AS Status
FROM InstrumentCategory
ORDER BY Status, NameEn;
```

---

## 📋 範本檔案狀態

### 目前狀態

- ✅ **英文名稱**：已自動提取（36 個量表 + 246 個特質）
- ⚠️ **中文翻譯**：目前為空，需要手動填入
- ⚠️ **描述**：目前為空，可選填入

### 建議填寫方式

1. **量表翻譯**：可以參考學術文獻或官方翻譯
   - `16PF` → `十六種人格因素測驗`
   - `BigFive` → `大五人格測驗`
   - `NEO` → `NEO 人格量表`

2. **特質翻譯**：可以參考心理學術語翻譯
   - `Anxiety` → `焦慮`
   - `Openness` → `開放性`
   - `Conscientiousness` → `嚴謹性`
   - `Extraversion` → `外向性`
   - `Agreeableness` → `親和性`
   - `Neuroticism` → `神經質`

---

## ⚠️ 注意事項

1. **不是匯入必需的**：這兩個檔案是**後續補充用**，不影響初始資料匯入
2. **可以分批完成**：不需要一次填完所有翻譯，可以分批更新
3. **英文可作為暫時顯示**：如果暫時沒有中文翻譯，系統仍可正常運作（顯示英文）
4. **建議優先處理常用量表**：可以先翻譯常用的量表（如 BigFive, 16PF, NEO）

---

## 📚 相關資源

- 心理測驗中文翻譯可以參考：
  - 心理測驗專業書籍
  - 學術論文中的翻譯
  - 官方測驗手冊

---

**最後更新**：2024-12-07

