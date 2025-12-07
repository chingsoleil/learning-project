# 資料來源總結

## 📊 資料表分類

資料庫共有 **7 個資料表**，根據資料來源分為兩類：

---

## ✅ 需要事先準備資料的表（來自 3805 題 CSV）

這 **3 個表**的資料都來自您的 **3805 題 CSV 檔案**：

| 資料表 | 資料來源 | 資料量 | 提取方式 |
|--------|---------|--------|----------|
| **InstrumentCategory** | 3805 題 CSV 的 `instrument` 欄位 | 36 個（不重複） | `SELECT DISTINCT instrument` |
| **TraitCategory** | 3805 題 CSV 的 `label` 欄位 | 246 個（不重複） | `SELECT DISTINCT label` |
| **QuestionBank** | 3805 題 CSV 的每一列 | 3,805 題 | 直接匯入所有列 |

### 📝 詳細說明

#### 1. InstrumentCategory（量表分類）
- **資料來源**：從 3805 題的 CSV 中提取 `instrument` 欄位的**不重複值**
- **數量**：36 個（如：16PF, BigFive, NEO, HEXACO_PI, MMPI 等）
- **匯入邏輯**：
  ```sql
  SELECT DISTINCT instrument FROM temp_ipip_merged
  ```
- **欄位對應**：
  - `instrument` → `NameEn`（英文名稱）
  - （可選）從翻譯範本 CSV 取得 `NameZh`（中文名稱）

#### 2. TraitCategory（特質面向分類）
- **資料來源**：從 3805 題的 CSV 中提取 `label` 欄位的**不重複值**
- **數量**：246 個（如：Anxiety, Openness, Conscientiousness, Extraversion 等）
- **匯入邏輯**：
  ```sql
  SELECT DISTINCT label FROM temp_ipip_merged
  ```
- **欄位對應**：
  - `label` → `NameEn`（英文名稱）
  - （可選）從翻譯範本 CSV 取得 `NameZh`（中文名稱）
  - 自動產生 `Code`（如：TRAIT_001, TRAIT_002...）

#### 3. QuestionBank（題庫主檔）
- **資料來源**：3805 題 CSV 的**每一列**
- **數量**：3,805 題
- **匯入邏輯**：直接匯入所有列，並透過 JOIN 取得分類表的 ID
  ```sql
  FROM temp_ipip_merged tm
  INNER JOIN InstrumentCategory ic ON tm.instrument = ic.NameEn
  INNER JOIN TraitCategory tc ON tm.label = tc.NameEn
  ```
- **欄位對應**：
  - `text_en` → `TextEn`（英文題目）
  - `text_zh` → `TextZh`（中文題目）
  - `alpha` → `Alpha`（信度係數）
  - `key` → `Key`（計分方向）
  - `IPIP_item_number` → `IPIPItemNumber`（參考用）
  - `instrument` → 透過 JOIN 取得 `InstrumentCategoryId`（FK）
  - `label` → 透過 JOIN 取得 `TraitCategoryId`（FK）

---

## ❌ 不需要事先準備資料的表（系統運作時動態產生）

這 **4 個表**不需要從 CSV 匯入，會在**系統運作時動態產生**資料：

| 資料表 | 用途 | 資料來源 | 說明 |
|--------|------|---------|------|
| **TestPaper** | 測卷主檔 | 管理員手動建立 | 定義不同的測驗卷（如：大五人格測驗、16PF測驗） |
| **TestPaperDetail** | 測卷明細檔 | 管理員手動建立 | 定義每份測卷包含哪些題目（從 QuestionBank 選取） |
| **TestSession** | 受測主檔 | 使用者進行測驗時自動產生 | 記錄受測者的基本資料和測驗資訊 |
| **TestAnswer** | 受測作答明細檔 | 使用者作答時自動產生 | 記錄受測者對每個題目的作答內容 |

### 📝 詳細說明

#### 4. TestPaper（測卷主檔）
- **用途**：定義不同的心理測驗卷
- **資料來源**：管理員透過系統後台手動建立
- **範例**：
  - 測卷名稱：「大五人格測驗」
  - 作答方式：Likert5（五點量表）
  - 時間限制：30 分鐘
  - 總題數：50 題

#### 5. TestPaperDetail（測卷明細檔）
- **用途**：定義每份測卷包含哪些題目
- **資料來源**：管理員從 `QuestionBank` 中選取題目，建立測卷明細
- **關聯**：連結 `TestPaper` 和 `QuestionBank`
- **範例**：
  - 測卷 ID：1（大五人格測驗）
  - 題目 ID：100（來自 QuestionBank）
  - 題目順序：1

#### 6. TestSession（受測主檔）
- **用途**：記錄每位受測者的基本資料和測驗資訊
- **資料來源**：使用者開始進行測驗時自動建立
- **範例**：
  - 受測者姓名：張三
  - 測卷 ID：1（大五人格測驗）
  - 狀態：InProgress（進行中）

#### 7. TestAnswer（受測作答明細檔）
- **用途**：記錄受測者對每個題目的作答內容
- **資料來源**：使用者作答時自動記錄
- **範例**：
  - 受測 ID：100（張三的測驗）
  - 測卷明細 ID：1（第一題）
  - 作答值：4（五點量表中的 4 分）

---

## 📋 資料流程圖

```
3805 題 CSV 檔案
│
├─→ InstrumentCategory（36個）
│   └─ 提取 DISTINCT instrument
│
├─→ TraitCategory（246個）
│   └─ 提取 DISTINCT label
│
└─→ QuestionBank（3805題）
    ├─ 每一列的題目資料
    ├─ FK → InstrumentCategory (透過 instrument 欄位匹配)
    └─ FK → TraitCategory (透過 label 欄位匹配)

QuestionBank（已匯入）
│
├─→ TestPaper（管理員手動建立）
│   └─→ TestPaperDetail（管理員從 QuestionBank 選題）
│       │
│       └─→ TestSession（使用者開始測驗）
│           └─→ TestAnswer（使用者作答記錄）
```

---

## ✅ 總結

### 需要事先準備的資料

1. ✅ **3805 題的合併 CSV 檔案**（`IPIP_items-merged.csv`）
   - 包含：instrument, label, text_en, text_zh, alpha, key, IPIP_item_number

2. ✅ **（可選）翻譯範本 CSV 檔案**
   - `instrument_translations_template.csv`（36個量表中文翻譯）
   - `label_translations_template.csv`（246個特質中文翻譯）

### 不需要事先準備的資料

- ❌ TestPaper（測卷）
- ❌ TestPaperDetail（測卷明細）
- ❌ TestSession（受測記錄）
- ❌ TestAnswer（作答記錄）

這些表會在系統運作時，由管理員和使用者動態產生資料。

---

**最後更新**：2024-12-07

