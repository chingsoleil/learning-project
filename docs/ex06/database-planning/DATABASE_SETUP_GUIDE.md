# 資料庫建置指南

## 📋 檔案清單

| 檔案名稱 | 說明 | 大小 |
|---------|------|------|
| **CREATE_DATABASE.sql** | 建立資料庫結構 | ~15 KB |
| **INSERT_DATA.sql** | 匯入 CSV 資料 | ~12 KB |
| **WORK_PLAN.md** | 工作規劃文件 | ~6 KB |

---

## 🚀 快速開始

### 步驟 1: 建立資料庫結構

使用 DBeaver、MySQL Workbench 或命令列執行：

```bash
mysql -u root -p < CREATE_DATABASE.sql
```

**執行內容**:
- 建立資料庫 `PsychometricTestDB`
- 建立 7 個資料表
- 建立所有索引和外鍵約束

**預期結果**:
```
Database PsychometricTestDB created successfully!
Ready for data import.
```

---

### 步驟 2: 準備 CSV 資料

確認以下三個 CSV 檔案存在：

```
專案根目錄/
├── ex05/
│   ├── IPIP_items.csv         (3,805 題 - 英文)
│   └── IPIP_items-zh-tw.csv   (3,805 題 - 中文)
└── docs/ex03/
    └── IPIP3320.csv           (3,320 題 - ItemNumber)
```

---

### 步驟 3: 匯入資料

#### 方法 A: 使用 DBeaver（推薦）

1. 開啟 DBeaver 連接到資料庫
2. 執行 `INSERT_DATA.sql` 中的「步驟 1」建立臨時表
3. 使用 DBeaver 的 Import Data 功能：
   - 右鍵點擊 `temp_ipip_items_en` → Import Data
   - 選擇 `ex05/IPIP_items.csv`
   - 設定：欄位分隔符號=逗號, 文字限定符號=雙引號, 忽略第一行
   - 重複以上步驟匯入 `temp_ipip_items_zh` 和 `temp_ipip3320`
4. 執行 `INSERT_DATA.sql` 的其餘部分

#### 方法 B: 使用命令列

```bash
# 執行匯入腳本
mysql -u root -p PsychometricTestDB < INSERT_DATA.sql

# 注意：需要調整腳本中的 LOAD DATA INFILE 路徑
```

---

## ✅ 驗證結果

執行完成後，應該看到：

### 資料表筆數

| 資料表 | 預期筆數 | 說明 |
|--------|---------|------|
| InstrumentCategory | 36 | 量表分類 |
| TraitCategory | 246 | 特質面向 |
| QuestionBank | 3,805 | 題庫 |
| TestPaper | 0 | (稍後建立) |
| TestPaperDetail | 0 | (稍後建立) |
| TestSession | 0 | (稍後建立) |
| TestAnswer | 0 | (稍後建立) |

### 驗證查詢

```sql
-- 檢查總題數
SELECT COUNT(*) FROM QuestionBank;
-- 預期結果: 3805

-- 檢查量表數
SELECT COUNT(*) FROM InstrumentCategory;
-- 預期結果: 36

-- 檢查特質數
SELECT COUNT(*) FROM TraitCategory;
-- 預期結果: 246

-- 檢查外鍵完整性
SELECT 
    'QuestionBank' AS Table_Name,
    COUNT(*) AS Valid_Records
FROM QuestionBank qb
INNER JOIN InstrumentCategory ic ON qb.InstrumentCategoryId = ic.Id
INNER JOIN TraitCategory tc ON qb.TraitCategoryId = tc.Id;
-- 預期結果: 3805
```

---

## 📊 資料庫結構說明

### ER 關聯圖

```
InstrumentCategory (1) ──────< (N) QuestionBank
TraitCategory (1) ──────< (N) QuestionBank
TestPaper (1) ──────< (N) TestPaperDetail
QuestionBank (1) ──────< (N) TestPaperDetail
TestPaper (1) ──────< (N) TestSession
TestSession (1) ──────< (N) TestAnswer
TestPaperDetail (1) ──────< (N) TestAnswer
```

### 核心資料表

1. **InstrumentCategory**: 量表分類（如 16PF、NEO）
2. **TraitCategory**: 特質面向（如 Openness、Anxiety）
3. **QuestionBank**: 題庫主檔（3,805 題）
4. **TestPaper**: 測卷主檔
5. **TestPaperDetail**: 測卷包含的題目
6. **TestSession**: 受測者資料
7. **TestAnswer**: 作答記錄

---

## 🔧 資料結構調整說明

### 與原始資料字典的差異

1. **NameZh 欄位改為 NULL**
   ```sql
   -- 原: NameZh VARCHAR(100) NOT NULL
   -- 改: NameZh VARCHAR(100) NULL
   ```
   **理由**: CSV 沒有中文翻譯，先使用英文，後續補充

2. **QuestionCode 處理邏輯**
   ```sql
   -- 優先使用 ItemNumber，處理逗號分隔
   COALESCE(
       SUBSTRING_INDEX(ItemNumber, ',', 1),
       CONCAT(instrument, '_', row_id)
   )
   ```
   **理由**: 部分 ItemNumber 有多個值（如 "H596, X9"）

---

## ⚠️ 注意事項

### 編碼問題
- 確保 CSV 檔案為 **UTF-8 編碼**
- 如果出現亂碼，使用文字編輯器轉換編碼

### 權限問題
- 使用 `LOAD DATA INFILE` 需要 `FILE` 權限
- 建議使用 DBeaver 的 Import Data 功能

### 效能考量
- 匯入 3,805 筆題目約需 **1-2 分鐘**
- 建議在測試環境先執行驗證

### 備份建議
- 匯入前先備份資料庫
- 保留原始 CSV 檔案

---

## 📝 後續工作

### 1. 補充中文翻譯

```sql
-- 更新量表中文名稱
UPDATE InstrumentCategory 
SET NameZh = '16種人格因子問卷'
WHERE Code = '16PF';

-- 更新特質中文名稱
UPDATE TraitCategory 
SET NameZh = '合群性'
WHERE NameEn = 'Gregariousness';
```

**範本檔案**:
- `instrument_translations_template.csv` (36 筆)
- `label_translations_template.csv` (246 筆)

### 2. 建立測卷範例

```sql
-- 建立大五人格測驗卷
INSERT INTO TestPaper (Name, Code, Description, ResponseType, TotalQuestions)
VALUES ('大五人格測驗', 'BF_TEST_01', '評估五大人格特質', 'Likert5', 50);

-- 加入題目到測卷
INSERT INTO TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder)
SELECT 1, Id, ROW_NUMBER() OVER (ORDER BY Id)
FROM QuestionBank
WHERE InstrumentCategoryId = (
    SELECT Id FROM InstrumentCategory WHERE Code = '16PF'
)
LIMIT 50;
```

---

## 🆘 疑難排解

### 問題 1: 無法建立資料庫
```sql
-- 檢查權限
SHOW GRANTS FOR CURRENT_USER;

-- 授予建立資料庫權限
GRANT ALL PRIVILEGES ON PsychometricTestDB.* TO 'your_user'@'localhost';
FLUSH PRIVILEGES;
```

### 問題 2: CSV 匯入失敗
- 檢查檔案路徑是否正確
- 確認檔案編碼為 UTF-8
- 使用 DBeaver 的 Import Data 功能

### 問題 3: 外鍵約束錯誤
```sql
-- 檢查孤立記錄
SELECT * FROM QuestionBank qb
LEFT JOIN InstrumentCategory ic ON qb.InstrumentCategoryId = ic.Id
WHERE ic.Id IS NULL;
```

### 問題 4: QuestionCode 重複
```sql
-- 查找重複的 QuestionCode
SELECT QuestionCode, COUNT(*) 
FROM QuestionBank 
GROUP BY QuestionCode 
HAVING COUNT(*) > 1;
```

---

## 📚 參考資料

- **資料字典**: `docs/ex04/data-dictionary.md`
- **工作規劃**: `WORK_PLAN.md`
- **CSV 分析報告**: `database-planning/FINAL-IMPORT-REPORT.md`

---

## 📅 版本記錄

| 版本 | 日期 | 說明 |
|------|------|------|
| 1.0 | 2024-12-07 | 初始版本 |

---

## 👤 維護者

專案團隊

---

## 📧 技術支援

如有問題，請參考：
1. `WORK_PLAN.md` - 完整工作規劃
2. `FINAL-IMPORT-REPORT.md` - 詳細評估報告
3. SQL 腳本內的註解說明

