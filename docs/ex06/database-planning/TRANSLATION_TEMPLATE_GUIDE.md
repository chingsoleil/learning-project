# 翻譯範本 CSV 產生指南

## ✅ 問題 1：可以用 Excel 從 3805 題自行 GROUP 出來嗎？

**答案：是的！** 您可以用 Excel 的「移除重複值」功能來產生這兩個翻譯範本 CSV。

---

## 📋 步驟說明

### 方法一：使用 Excel 的「移除重複值」功能

#### 1. 產生 `instrument_translations_template.csv`

**從 `IPIP_items-merged.csv` 提取不重複的 `instrument`：**

1. 開啟 `IPIP_items-merged.csv`（或 `IPIP_items.csv`）
2. 選取 `instrument` 欄位（A 欄）
3. 複製該欄位到新的工作表
4. 選取資料 → **資料** → **移除重複值**
5. 排序（選用）
6. 建立標題列：`instrument_en,instrument_zh,description`
7. 建立三欄：
   - `instrument_en`：不重複的 instrument 值（36 個）
   - `instrument_zh`：留空，等待填入中文翻譯
   - `description`：留空，等待填入描述
8. 另存為 `instrument_translations_template.csv`（CSV UTF-8 格式）

**結果：** 36 個不重複的量表名稱（如：16PF, BigFive, NEO...）

---

#### 2. 產生 `label_translations_template.csv`

**從 `IPIP_items-merged.csv` 提取不重複的 `label`：**

1. 開啟 `IPIP_items-merged.csv`（或 `IPIP_items.csv`）
2. 選取 `label` 欄位（F 欄，如果使用 merged CSV）
3. 複製該欄位到新的工作表
4. 選取資料 → **資料** → **移除重複值**
5. 排序（選用）
6. 建立標題列：`label_en,label_zh,description`
7. 建立三欄：
   - `label_en`：不重複的 label 值（246 個）
   - `label_zh`：留空，等待填入中文翻譯
   - `description`：留空，等待填入描述
8. 另存為 `label_translations_template.csv`（CSV UTF-8 格式）

**結果：** 246 個不重複的特質名稱（如：Anxiety, Openness, Conscientiousness...）

---

### 方法二：使用 SQL 產生（如果您已匯入資料）

如果您已經將資料匯入到資料庫，也可以使用 SQL 查詢來產生：

```sql
-- 產生 Instrument 翻譯範本
SELECT DISTINCT 
    instrument AS instrument_en,
    '' AS instrument_zh,
    '' AS description
FROM temp_ipip_merged
ORDER BY instrument;

-- 產生 Label 翻譯範本
SELECT DISTINCT 
    label AS label_en,
    '' AS label_zh,
    '' AS description
FROM temp_ipip_merged
ORDER BY label;
```

將結果匯出為 CSV 即可。

---

## ✅ 問題 2：匯入時會自動產生 PK/FK 嗎？

**答案：是的！** PK 和 FK 都會在匯入時自動處理，但方式不同。

---

## 🔑 PK（Primary Key）自動產生

### 說明

所有資料表的 `Id` 欄位都使用 `AUTO_INCREMENT`，**插入資料時自動產生遞增的 ID**。

### 範例

```sql
-- InstrumentCategory 表的定義
CREATE TABLE InstrumentCategory (
    Id INT AUTO_INCREMENT PRIMARY KEY,  -- ← 自動遞增
    NameEn VARCHAR(100) NOT NULL,
    ...
);
```

**匯入時：**
```sql
INSERT INTO InstrumentCategory (NameEn, NameZh, ...)
SELECT DISTINCT instrument AS NameEn, ...
FROM temp_ipip_merged;
```

**結果：**
- 第 1 筆：`Id = 1`, `NameEn = '16PF'`
- 第 2 筆：`Id = 2`, `NameEn = '6FPQ'`
- 第 3 筆：`Id = 3`, `NameEn = '7FACTOR'`
- ...（依此類推）

**您不需要手動指定 `Id`，資料庫會自動產生！**

---

## 🔗 FK（Foreign Key）自動對應

### 說明

FK 的值是透過 **JOIN** 操作自動取得的，不是直接匯入 CSV 的值。

### 流程說明

#### 步驟 1：先匯入分類表（產生 PK）

```sql
-- 匯入 InstrumentCategory（產生 PK）
INSERT INTO InstrumentCategory (NameEn, NameZh, Code, ...)
SELECT DISTINCT 
    tm.instrument AS NameEn,  -- ← CSV 的 instrument 文字
    ...
FROM temp_ipip_merged tm;

-- 結果範例：
-- Id | NameEn | NameZh | Code
-- 1  | 16PF   | 16PF   | 16PF
-- 2  | BigFive| BigFive| BigFive
-- 3  | NEO    | NEO    | NEO
```

#### 步驟 2：匯入 QuestionBank 時透過 JOIN 取得 FK

```sql
-- 匯入 QuestionBank（自動取得 FK）
INSERT INTO QuestionBank (
    InstrumentCategoryId,  -- ← FK（自動取得）
    TraitCategoryId,       -- ← FK（自動取得）
    TextEn,
    TextZh,
    ...
)
SELECT 
    ic.Id AS InstrumentCategoryId,  -- ← 透過 JOIN 取得 PK
    tc.Id AS TraitCategoryId,       -- ← 透過 JOIN 取得 PK
    tm.text_en AS TextEn,
    tm.text_zh AS TextZh,
    ...
FROM temp_ipip_merged tm
INNER JOIN InstrumentCategory ic ON tm.instrument = ic.NameEn  -- ← 文字匹配
INNER JOIN TraitCategory tc ON tm.label = tc.NameEn;           -- ← 文字匹配
```

### 詳細對應過程

**CSV 資料（temp_ipip_merged）：**
```csv
instrument,label,text_en,text_zh,...
16PF,Gregariousness,Act wild and crazy.,行為狂野瘋狂。,... 
16PF,Anxiety,Am afraid that I will do the wrong thing.,我擔心自己會做錯事。,... 
```

**匯入過程：**

1. **第一列資料：**
   - `instrument = '16PF'`, `label = 'Gregariousness'`
   - 透過 JOIN 找到 `InstrumentCategory` 中 `NameEn = '16PF'` 的記錄，取得 `Id = 1`
   - 透過 JOIN 找到 `TraitCategory` 中 `NameEn = 'Gregariousness'` 的記錄，取得 `Id = 15`（假設）
   - 插入 `QuestionBank`：`InstrumentCategoryId = 1`, `TraitCategoryId = 15`

2. **第二列資料：**
   - `instrument = '16PF'`, `label = 'Anxiety'`
   - 透過 JOIN 找到 `InstrumentCategory` 中 `NameEn = '16PF'` 的記錄，取得 `Id = 1`（相同）
   - 透過 JOIN 找到 `TraitCategory` 中 `NameEn = 'Anxiety'` 的記錄，取得 `Id = 8`（假設）
   - 插入 `QuestionBank`：`InstrumentCategoryId = 1`, `TraitCategoryId = 8`

**結果：**
```
QuestionBank 表：
Id | InstrumentCategoryId | TraitCategoryId | TextEn                    | TextZh
1  | 1                    | 15              | Act wild and crazy.       | 行為狂野瘋狂。
2  | 1                    | 8               | Am afraid that I will...  | 我擔心自己會做錯事。
```

---

## 📊 完整流程圖

```
3805 題 CSV
│
├─→ 步驟 1：提取不重複值（Excel 移除重複值）
│   ├─→ instrument → 36 個不重複值 → instrument_translations_template.csv
│   └─→ label → 246 個不重複值 → label_translations_template.csv
│
└─→ 步驟 2：匯入資料庫
    │
    ├─→ InstrumentCategory（PK 自動產生）
    │   └─ Id: 1, 2, 3... (AUTO_INCREMENT)
    │
    ├─→ TraitCategory（PK 自動產生）
    │   └─ Id: 1, 2, 3... (AUTO_INCREMENT)
    │
    └─→ QuestionBank（PK 自動產生，FK 透過 JOIN 取得）
        ├─ Id: 1, 2, 3... (AUTO_INCREMENT) ← PK
        ├─ InstrumentCategoryId: 透過 JOIN instrument = NameEn 取得 ← FK
        └─ TraitCategoryId: 透過 JOIN label = NameEn 取得 ← FK
```

---

## ✅ 總結

### 翻譯範本 CSV 產生方式

1. ✅ **可以用 Excel 從 3805 題自行 GROUP 出來**
   - 使用「移除重複值」功能
   - `instrument` → 36 個不重複值
   - `label` → 246 個不重複值

2. ✅ **填入中文翻譯**
   - 在 `instrument_zh` 和 `label_zh` 欄位填入中文
   - 在 `description` 欄位填入描述（選填）

### PK/FK 自動產生

1. ✅ **PK（主鍵）自動產生**
   - 使用 `AUTO_INCREMENT`
   - 插入時自動產生遞增的 ID

2. ✅ **FK（外鍵）自動對應**
   - 透過 `JOIN` 操作將文字值（instrument, label）轉換為 ID
   - 不需要手動指定 FK 值

**您只需要準備 CSV 資料，SQL 會自動處理 PK/FK 的對應！**

---

**最後更新**：2024-12-07

