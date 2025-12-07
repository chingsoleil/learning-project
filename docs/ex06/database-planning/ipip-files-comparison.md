# IPIP 題庫對照分析補充

## 📊 發現新的資料來源

### 新增檔案：`docs/ex03/IPIP3320.csv`

這份檔案提供了 **3,320 題的原始 IPIP 題庫**，包含：
- **Survey**：題目文字（英文）
- **ItemNumber**：題目編號（如 H1131, Q176, A18 等）

## 🔄 三份檔案的關聯性

### 檔案比較

| 檔案 | 筆數 | 欄位 | 用途 |
|------|------|------|------|
| `docs/ex03/IPIP3320.csv` | 3,320 | Survey, ItemNumber | **原始題庫** + 題號對照表 |
| `ex05/IPIP_items.csv` | 3,805 | instrument, alpha, key, text, label | **擴充題庫**（含量表資訊） |
| `ex05/IPIP_items-zh-tw.csv` | 3,805 | instrument, alpha, key, text, label | 中文翻譯版本 |

### 關鍵發現

#### 1. **題目數量差異**
- IPIP3320.csv：**3,320 題**（原始 IPIP 公開題庫）
- IPIP_items.csv：**3,805 題**（多了 485 題）

#### 2. **ItemNumber 的價值**
- ItemNumber 是**唯一識別碼**，可用於：
  - 作為 `QuestionBank.QuestionCode`
  - 建立與原始 IPIP 題庫的對照關係
  - 追溯題目來源

#### 3. **題目文字對照**
讓我檢查兩份檔案的題目文字是否一致：

```csv
IPIP3320.csv:
- "Act wild and crazy." → H871

IPIP_items.csv:
- "Act wild and crazy." → 出現在多個 instrument 中
```

---

## 🔍 檔案對照分析

### 測試：IPIP3320.csv 的題目是否都在 IPIP_items.csv 中？

需要比對：
1. IPIP3320.csv 的 Survey (題目文字)
2. IPIP_items.csv 的 text (題目文字)

### ItemNumber 編碼規則

從樣本分析：
- **H系列**：H1131, H133, H554... (最大宗)
- **Q系列**：Q176, Q253, Q27...
- **A系列**：A18
- **T系列**：T17, T19...
- **V系列**：V207
- **P系列**：P342
- **R系列**：R1, R44...
- **其他**：X, W, E, D, C, S, M, N, B...

**推測**：可能對應不同的量表或研究來源

---

## 💡 資料整合策略

### 方案 A：以 IPIP_items.csv 為主（推薦）

**優點**：
- 已有完整的 instrument 和 label 資訊
- 已有中文翻譯版本
- 資料更完整（3,805 題）

**整合步驟**：
1. 使用 IPIP_items.csv 作為主資料來源
2. 使用 IPIP3320.csv 補充 ItemNumber
3. 通過題目文字（text）進行比對

```sql
-- 匯入策略
INSERT INTO QuestionBank (
    InstrumentCategoryId,
    TraitCategoryId,
    TextEn,
    TextZh,
    Alpha,
    Key,
    QuestionCode,  -- 優先使用 ItemNumber
    ...
)
SELECT 
    ic.Id,
    tc.Id,
    items.text,
    items_zh.text,
    items.alpha,
    items.key,
    COALESCE(ipip3320.ItemNumber, 
             CONCAT(items.instrument, '_', ROW_NUMBER())) AS QuestionCode,
    ...
FROM IPIP_items items
LEFT JOIN IPIP3320 ipip3320 ON items.text = ipip3320.Survey
...
```

### 方案 B：建立完整的對照關係

建立額外的對照表：

```sql
CREATE TABLE ItemNumberMapping (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    ItemNumber VARCHAR(20) NOT NULL UNIQUE,
    TextEn TEXT NOT NULL,
    QuestionBankId INT NULL,
    INDEX idx_item_number (ItemNumber),
    CONSTRAINT FK_Mapping_QuestionBank 
        FOREIGN KEY (QuestionBankId) 
        REFERENCES QuestionBank(Id)
);
```

---

## 📋 更新後的匯入流程

### 階段 1：準備對照數據

1. **匯入 IPIP3320.csv 到臨時表**
```sql
CREATE TABLE temp_ipip3320 (
    Survey TEXT,
    ItemNumber VARCHAR(20)
);
```

2. **建立題目文字對照**
   - 比對 IPIP_items.csv 和 IPIP3320.csv 的題目文字
   - 找出可以匹配的 ItemNumber

### 階段 2：匯入主要資料

使用更新後的 QuestionCode 生成規則：

```sql
-- 優先使用 ItemNumber，如果沒有則自動生成
QuestionCode = COALESCE(
    ipip3320.ItemNumber,  -- 優先使用原始題號
    CONCAT(instrument, '_', LPAD(row_id, 4, '0'))  -- 備用方案
)
```

### 階段 3：驗證對照關係

```sql
-- 檢查有多少題目成功匹配到 ItemNumber
SELECT 
    COUNT(*) AS total,
    SUM(CASE WHEN QuestionCode LIKE 'H%' OR 
                  QuestionCode LIKE 'Q%' OR 
                  QuestionCode LIKE 'A%' 
         THEN 1 ELSE 0 END) AS with_item_number,
    SUM(CASE WHEN QuestionCode LIKE CONCAT(instrument, '%') 
         THEN 1 ELSE 0 END) AS generated_code
FROM QuestionBank;
```

---

## 🎯 建議的 QuestionCode 格式

根據新資料，建議採用混合策略：

### 格式 1：使用 ItemNumber（如果有）
```
H1131, Q176, A18, T17, V207
```

### 格式 2：自動生成（如果沒有 ItemNumber）
```
16PF_Gregariousness_0001
NEO_Openness_0234
```

### 優點：
1. **保留原始資料追溯性**（ItemNumber）
2. **人類可讀性**（自動生成格式）
3. **唯一性**（兩種格式不會衝突）

---

## 📝 需要產出的對照表

### 1. ItemNumber 到 QuestionBank 的對照

```csv
ItemNumber,TextEn,InstrumentCategory,TraitCategory
H1131,Abuse people's confidences.,?,?
H133,Accept apologies easily.,?,?
...
```

### 2. 缺少 ItemNumber 的題目清單

統計哪些題目（3,805 - 3,320 = 485 題）沒有 ItemNumber：
- 可能是新增的題目
- 可能是題目文字有差異無法匹配

---

## ⚠️ 需要確認的問題

1. **題目文字是否完全一致？**
   - IPIP3320.csv 和 IPIP_items.csv 的題目文字可能有細微差異
   - 需要模糊匹配或標準化處理

2. **485 題的來源？**
   - 是否為其他量表的題目？
   - 是否需要單獨處理？

3. **ItemNumber 的完整性？**
   - 是否所有 ItemNumber 格式都一致？
   - 是否有重複的 ItemNumber？

---

## 🔧 下一步行動

需要我協助：

1. ✅ **比對題目文字**
   - 產生 IPIP3320 與 IPIP_items 的對照表
   - 找出完全匹配的題目
   - 識別差異題目

2. ✅ **產生匯入腳本（更新版）**
   - 整合 ItemNumber
   - 處理三份檔案的關聯

3. ✅ **建立驗證查詢**
   - 確認資料完整性
   - 驗證對照關係

請告訴我您希望先進行哪一項！

