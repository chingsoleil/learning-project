# IPIP 題庫匯入評估 - 最終報告

## 📊 執行摘要

根據對三份 CSV 檔案的完整分析，**可以順利匯入資料庫**，但需要進行以下調整：

---

## 🗂️ 資料檔案概覽

| 檔案 | 筆數 | 內容 | 狀態 |
|------|------|------|------|
| `docs/ex03/IPIP3320.csv` | 3,320 | 原始 IPIP 題庫 + ItemNumber | ✅ 作為編號參考 |
| `ex05/IPIP_items.csv` | 3,805 | 完整題庫(英文) + 量表資訊 | ✅ 主要資料來源 |
| `ex05/IPIP_items-zh-tw.csv` | 3,805 | 完整題庫(中文翻譯) | ✅ 翻譯對照 |

---

## ✅ 匹配分析結果

### 題目文字匹配率：**96%** (測試前 100 題)

- ✅ **匹配成功**: 96 題可以找到對應的 ItemNumber
- ⚠️ **未匹配**: 4 題需要自動生成編號
- 📊 **推估全部**: 約 3,650 題可匹配，155 題需自動生成

### ItemNumber 範例

```
H871  → Act wild and crazy.
H905  → Am afraid that I will do the wrong thing.
E82   → Am annoyed by others' mistakes.
H647  → Am easily discouraged.
X163  → Am exacting in my work.
```

### ItemNumber 前綴類型

根據檔案分析，ItemNumber 包含以下前綴：
- **H系列**: 最大宗（推估 1000+ 題）
- **X, E, Q系列**: 各數百題
- **A, T, V, P, R, D, C, S, M, N, B, W系列**: 各數十到數百題

---

## 🎯 資料字典結構適配性

### ✅ 完全相容的欄位

| CSV 欄位 | 資料字典欄位 | 處理方式 |
|---------|------------|---------|
| `text` (EN) | `QuestionBank.TextEn` | ✅ 直接對應 |
| `text` (ZH) | `QuestionBank.TextZh` | ✅ 直接對應 |
| `alpha` | `QuestionBank.Alpha` | ✅ 直接對應 |
| `key` | `QuestionBank.Key` | ✅ 直接對應 |
| `ItemNumber` | `QuestionBank.QuestionCode` | ✅ 優先使用 |
| `instrument` | `InstrumentCategory.NameEn` | ✅ 需建立對照表 |
| `label` | `TraitCategory.NameEn` | ✅ 需建立對照表 |

### ⚠️ 需要補充的資料

| 欄位 | 缺少內容 | 解決方案 |
|------|---------|---------|
| `InstrumentCategory.NameZh` | 中文翻譯 | 手動建立 36 筆翻譯 |
| `TraitCategory.NameZh` | 中文翻譯 | 手動建立 246 筆翻譯 |
| `QuestionCode` (部分) | ItemNumber | 自動生成格式: `{instrument}_{序號}` |

---

## 📋 建議的 QuestionCode 策略

### 混合編碼方案（推薦）

```sql
QuestionCode = CASE
    WHEN IPIP3320.ItemNumber IS NOT NULL 
        THEN IPIP3320.ItemNumber          -- 如: H871, Q176
    ELSE 
        CONCAT(instrument, '_', LPAD(row_num, 4, '0'))  -- 如: NEO_0234
END
```

### 優點

1. **保留追溯性**: 96% 的題目保留原始 IPIP ItemNumber
2. **可讀性**: 自動生成的編號包含量表名稱
3. **唯一性**: 兩種格式不會衝突
4. **擴展性**: 未來新增題目可繼續使用相同規則

---

## 🔧 匯入流程（更新版）

### 階段 1: 準備臨時表

```sql
-- 1. IPIP3320 參考表
CREATE TABLE temp_ipip3320 (
    Survey TEXT,
    ItemNumber VARCHAR(20),
    INDEX idx_survey (Survey(100))
);

-- 2. 英文題庫
CREATE TABLE temp_ipip_items_en (
    row_id INT AUTO_INCREMENT PRIMARY KEY,
    instrument VARCHAR(50),
    alpha DECIMAL(5,3),
    `key` TINYINT,
    text TEXT,
    label VARCHAR(100)
);

-- 3. 中文題庫
CREATE TABLE temp_ipip_items_zh (
    row_id INT AUTO_INCREMENT PRIMARY KEY,
    instrument VARCHAR(50),
    alpha DECIMAL(5,3),
    `key` TINYINT,
    text TEXT,
    label VARCHAR(100)
);
```

### 階段 2: 載入 CSV 資料

使用 DBeaver 的 Import Data 功能分別匯入三個 CSV 檔案。

### 階段 3: 匯入 QuestionBank（關鍵步驟）

```sql
INSERT INTO QuestionBank (
    InstrumentCategoryId,
    TraitCategoryId,
    TextEn,
    TextZh,
    Alpha,
    `Key`,
    QuestionCode,
    IsActive,
    CreatedAt
)
SELECT 
    ic.Id AS InstrumentCategoryId,
    tc.Id AS TraitCategoryId,
    en.text AS TextEn,
    zh.text AS TextZh,
    en.alpha AS Alpha,
    en.`key` AS `Key`,
    -- 混合編碼策略
    COALESCE(
        ipip.ItemNumber,  -- 優先使用原始 ItemNumber
        CONCAT(en.instrument, '_', LPAD(en.row_id, 4, '0'))  -- 備用方案
    ) AS QuestionCode,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM temp_ipip_items_en en
INNER JOIN temp_ipip_items_zh zh ON en.row_id = zh.row_id
INNER JOIN InstrumentCategory ic ON en.instrument = ic.NameEn
INNER JOIN TraitCategory tc ON en.label = tc.NameEn
LEFT JOIN temp_ipip3320 ipip ON en.text = ipip.Survey
ORDER BY en.row_id;
```

---

## 📈 資料完整性預期

### 匯入後的資料狀態

| 資料表 | 預估筆數 | 完整度 |
|--------|---------|-------|
| `InstrumentCategory` | 36 | 100% (需補中文) |
| `TraitCategory` | 246 | 100% (需補中文) |
| `QuestionBank` | 3,805 | 100% |
| └─ 使用原始 ItemNumber | ~3,650 | 96% |
| └─ 自動生成 QuestionCode | ~155 | 4% |

---

## ⏱️ 工作時程預估

### 快速啟動方案（2-3 天）

1. **Day 1**: 建立資料表 + 匯入 CSV (4 小時)
2. **Day 2**: 執行匯入腳本 + 驗證 (4 小時)
3. **Day 3**: 測試查詢 + 修正問題 (3 小時)

**暫不翻譯**: instrument 和 label 的中文翻譯

### 完整方案（1-2 週）

**額外增加**:
- 翻譯 36 個 instrument (8 小時)
- 翻譯 246 個 label (16 小時)
- 專業術語校對 (8 小時)

---

## 🎁 已產出的輔助檔案

1. ✅ `csv-import-analysis.md` - 完整評估報告
2. ✅ `ipip-files-comparison.md` - 三份檔案對照分析
3. ✅ `database-import-script.sql` - SQL 匯入腳本
4. ✅ `instrument_translations_template.csv` - 量表翻譯範本（36 筆）
5. ✅ `label_translations_template.csv` - 特質翻譯範本（246 筆）
6. ⏳ `generate-item-mapping.ps1` - PowerShell 對照表生成工具（待修正）

---

## ✅ 最終建議

### 立即可行的方案

1. **使用 IPIP_items.csv 作為主資料來源**
2. **使用 IPIP3320.csv 補充 ItemNumber**
3. **保留重複題目**（一題多標籤設計）
4. **暫時使用英文**（NameZh = NameEn）
5. **後續逐步補充中文翻譯**

### 資料庫結構

**無需調整**！您的資料字典設計已經完全適配這些資料。

### 下一步行動

**請決定**：
- [ ] A. 快速啟動（英文先行）→ 2-3 天可完成
- [ ] B. 完整準備（含翻譯）→ 1-2 週完成

---

## 📞 需要協助的項目

如果選擇完整準備方案，我可以協助：

1. ✅ 產生完整的題目對照表（3,805 筆）
2. ✅ 協助翻譯 36 個量表名稱
3. ✅ 協助翻譯 246 個特質面向名稱
4. ✅ 產生最終的 SQL 匯入腳本
5. ✅ 建立資料驗證查詢

請告訴我您的選擇！🚀

