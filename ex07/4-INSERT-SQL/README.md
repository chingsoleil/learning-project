# 4-INSERT-SQL 資料夾說明

## 📁 資料夾內容

本資料夾包含用於匯入 5 份心理測驗卷的 SQL 指令：

| 檔案名稱 | 說明 | 類型 |
|---------|------|------|
| `INSERT指令說明.md` | 詳細的 INSERT SQL 指令說明文件 | 文件 |
| `INSERT_TestPapers.sql` | 完整的 INSERT SQL 指令（5 份測卷 + 250 題） | SQL 腳本 |
| `README.md` | 本說明文件 | 文件 |

---

## 🎯 INSERT_TestPapers.sql 概述

### 資料量統計

| 項目 | 數量 | 說明 |
|------|------|------|
| **測卷（TestPaper）** | 5 筆 | 5 份心理測驗卷 |
| **測卷明細（TestPaperDetail）** | 250 筆 | 每份測卷 50 題 |
| **總計** | 255 筆 | INSERT 指令總數 |

### 5 份測卷清單

| # | 測卷名稱 | 測卷代碼 | 題數 | 時間 | 說明 |
|---|---------|---------|------|------|------|
| 1 | 大五人格快速評估 | BIG5_QUICK_01 | 50 | 20分 | 全面評估五大人格特質 |
| 2 | 職場人格評估 | WORKPLACE_PERSONALITY_01 | 50 | 20分 | 評估職場相關人格特質 |
| 3 | 情緒與人際關係 | EMOTION_INTERPERSONAL_01 | 50 | 20分 | 評估情緒管理與人際互動能力 |
| 4 | 創造力與開放性 | CREATIVITY_OPENNESS_01 | 50 | 20分 | 評估創造力、學習能力與開放性 |
| 5 | 全面人格評估 | COMPREHENSIVE_PERSONALITY_01 | 50 | 20分 | 多維度全面人格評估 |

---

## 🚀 使用方式

### 方法 1：使用 SQL Server Management Studio (SSMS)

1. 開啟 SSMS 並連接到 SQL Server
2. 確認資料庫已建立並選擇 `PsychometricTestDB`
3. 開啟 `INSERT_TestPapers.sql` 檔案
4. 點擊「執行」按鈕（或按 F5）
5. 檢查訊息視窗確認執行結果

### 方法 2：使用 sqlcmd 命令列工具

```bash
# Windows PowerShell
sqlcmd -S localhost -d PsychometricTestDB -i INSERT_TestPapers.sql

# 如果需要指定使用者名稱和密碼
sqlcmd -S localhost -U sa -P YourPassword -d PsychometricTestDB -i INSERT_TestPapers.sql
```

### 方法 3：使用 Azure Data Studio

1. 開啟 Azure Data Studio
2. 連接到 SQL Server
3. 開啟 `INSERT_TestPapers.sql` 檔案
4. 點擊「執行」按鈕
5. 檢查結果面板確認執行結果

---

## ✅ 執行前檢查清單

在執行 SQL 腳本前，請確認以下事項：

- [ ] 資料庫 `PsychometricTestDB` 已建立
- [ ] 資料表結構已建立（執行過 `CREATE_DATABASE_MSSQL.sql`）
- [ ] 題庫資料已匯入（`QuestionBank` 表有 3,805 筆資料）
- [ ] 量表分類已匯入（`InstrumentCategory` 表有 36 筆資料）
- [ ] 特質分類已匯入（`TraitCategory` 表有 246 筆資料）

### 檢查指令

```sql
USE PsychometricTestDB;
GO

-- 檢查資料庫是否存在
SELECT DB_NAME() AS CurrentDatabase;

-- 檢查資料表是否存在
SELECT name FROM sys.tables WHERE name IN ('TestPaper', 'TestPaperDetail', 'QuestionBank');

-- 檢查題庫筆數
SELECT COUNT(*) AS QuestionBankCount FROM dbo.QuestionBank;
-- 預期: 3,805

-- 檢查量表分類筆數
SELECT COUNT(*) AS InstrumentCategoryCount FROM dbo.InstrumentCategory;
-- 預期: 36

-- 檢查特質分類筆數
SELECT COUNT(*) AS TraitCategoryCount FROM dbo.TraitCategory;
-- 預期: 246
```

---

## 📊 執行後驗證

執行完成後，SQL 腳本會自動顯示驗證結果。您也可以手動執行以下查詢進行驗證：

### 驗證測卷數量

```sql
-- 應該有 5 筆
SELECT COUNT(*) AS TestPaperCount FROM dbo.TestPaper;
```

### 驗證測卷明細數量

```sql
-- 應該有 250 筆
SELECT COUNT(*) AS TestPaperDetailCount FROM dbo.TestPaperDetail;
```

### 驗證每份測卷的題數

```sql
SELECT 
    tp.Id AS [測卷ID],
    tp.Code AS [測卷代碼],
    tp.Name AS [測卷名稱],
    tp.TotalQuestions AS [設定題數],
    COUNT(tpd.Id) AS [實際題數],
    CASE 
        WHEN tp.TotalQuestions = COUNT(tpd.Id) THEN N'✓ 正確'
        ELSE N'✗ 不符'
    END AS [狀態]
FROM dbo.TestPaper tp
LEFT JOIN dbo.TestPaperDetail tpd ON tp.Id = tpd.TestPaperId
GROUP BY tp.Id, tp.Code, tp.Name, tp.TotalQuestions
ORDER BY tp.Id;
```

### 查看測卷詳細資訊

```sql
-- 查看所有測卷
SELECT 
    Id,
    Name,
    Code,
    Description,
    ResponseType,
    TimeLimit,
    TotalQuestions,
    IsActive,
    CreatedAt
FROM dbo.TestPaper
ORDER BY Id;
```

### 查看特定測卷的題目清單

```sql
-- 查看測驗 1 的所有題目
SELECT 
    tpd.QuestionOrder AS [順序],
    tpd.QuestionBankId AS [題庫ID],
    qb.TextZh AS [題目文字],
    tc.NameZh AS [特質名稱],
    ic.NameZh AS [量表名稱],
    qb.Alpha AS [信度係數],
    qb.ScoringKey AS [計分鍵]
FROM dbo.TestPaperDetail tpd
INNER JOIN dbo.QuestionBank qb ON tpd.QuestionBankId = qb.Id
INNER JOIN dbo.TraitCategory tc ON qb.TraitCategoryId = tc.Id
INNER JOIN dbo.InstrumentCategory ic ON qb.InstrumentCategoryId = ic.Id
WHERE tpd.TestPaperId = 1
ORDER BY tpd.QuestionOrder;
```

---

## ⚠️ 常見問題與解決方案

### 問題 1：外鍵約束錯誤

**錯誤訊息**：
```
The INSERT statement conflicted with the FOREIGN KEY constraint "FK_TestPaperDetail_QuestionBank"
```

**原因**：`QuestionBankId` 在 `QuestionBank` 表中不存在

**解決方案**：
1. 確認題庫資料已正確匯入
2. 檢查特定的 `QuestionBankId` 是否存在：
   ```sql
   SELECT Id FROM dbo.QuestionBank WHERE Id IN (3120, 3119, 1329);
   ```

### 問題 2：唯一約束錯誤

**錯誤訊息**：
```
Violation of UNIQUE KEY constraint 'UQ_TestPaper_Code'
```

**原因**：測卷代碼（Code）重複，可能是重複執行了 SQL 腳本

**解決方案**：
1. 刪除現有測卷資料：
   ```sql
   DELETE FROM dbo.TestPaper;
   ```
2. 重新執行 INSERT SQL

### 問題 3：中文顯示亂碼

**原因**：SQL 檔案編碼問題或缺少 N 前綴

**解決方案**：
1. 確認 SQL 檔案以 UTF-8 編碼儲存
2. 檢查所有中文字串前都有 N 前綴（如：`N'大五人格快速評估'`）

### 問題 4：SCOPE_IDENTITY() 返回 NULL

**原因**：INSERT 失敗，沒有插入任何資料

**解決方案**：
1. 檢查 INSERT 語句是否有語法錯誤
2. 確認必填欄位都有提供值
3. 查看錯誤訊息了解失敗原因

---

## 🔄 重新執行 SQL 腳本

如果需要重新執行 SQL 腳本，請先刪除現有資料：

### 刪除所有測卷資料

```sql
-- 刪除所有測卷（會自動刪除明細，因為有 CASCADE）
DELETE FROM dbo.TestPaper;

-- 重置 IDENTITY（讓 Id 從 1 開始）
DBCC CHECKIDENT ('dbo.TestPaper', RESEED, 0);
DBCC CHECKIDENT ('dbo.TestPaperDetail', RESEED, 0);
```

### 刪除特定測卷

```sql
-- 刪除特定測卷（會自動刪除該測卷的所有明細）
DELETE FROM dbo.TestPaper WHERE Code = 'BIG5_QUICK_01';
```

---

## 📈 進階查詢範例

### 統計每個特質的題目數量

```sql
SELECT 
    tc.NameZh AS [特質名稱],
    COUNT(DISTINCT tpd.QuestionBankId) AS [題目數量],
    COUNT(DISTINCT tpd.TestPaperId) AS [出現在幾份測卷]
FROM dbo.TestPaperDetail tpd
INNER JOIN dbo.QuestionBank qb ON tpd.QuestionBankId = qb.Id
INNER JOIN dbo.TraitCategory tc ON qb.TraitCategoryId = tc.Id
GROUP BY tc.NameZh
ORDER BY COUNT(DISTINCT tpd.QuestionBankId) DESC;
```

### 統計每個量表的題目數量

```sql
SELECT 
    ic.NameZh AS [量表名稱],
    COUNT(DISTINCT tpd.QuestionBankId) AS [題目數量],
    COUNT(DISTINCT tpd.TestPaperId) AS [出現在幾份測卷]
FROM dbo.TestPaperDetail tpd
INNER JOIN dbo.QuestionBank qb ON tpd.QuestionBankId = qb.Id
INNER JOIN dbo.InstrumentCategory ic ON qb.InstrumentCategoryId = ic.Id
GROUP BY ic.NameZh
ORDER BY COUNT(DISTINCT tpd.QuestionBankId) DESC;
```

### 檢查是否有重複的題目

```sql
-- 檢查同一份測卷中是否有重複的題目
SELECT 
    TestPaperId,
    QuestionBankId,
    COUNT(*) AS [重複次數]
FROM dbo.TestPaperDetail
GROUP BY TestPaperId, QuestionBankId
HAVING COUNT(*) > 1;
-- 應該返回 0 筆資料
```

### 檢查題目順序是否連續

```sql
-- 檢查每份測卷的題目順序是否從 1 到 50 連續
WITH QuestionOrders AS (
    SELECT 
        TestPaperId,
        QuestionOrder,
        ROW_NUMBER() OVER (PARTITION BY TestPaperId ORDER BY QuestionOrder) AS ExpectedOrder
    FROM dbo.TestPaperDetail
)
SELECT 
    TestPaperId,
    QuestionOrder,
    ExpectedOrder
FROM QuestionOrders
WHERE QuestionOrder != ExpectedOrder;
-- 應該返回 0 筆資料
```

---

## 📚 相關文件

- **資料庫結構**：`../../ex06/database-planning/mssql/CREATE_DATABASE_MSSQL.sql`
- **選題計劃**：`../1-選題計劃/`
- **選題程式**：`../2-選題程式/`
- **選題結果**：`../3-選題結果/`
- **INSERT 指令說明**：`INSERT指令說明.md`

---

## 📞 技術支援

如果在執行過程中遇到問題，請檢查：

1. **資料庫連線**：確認可以連接到 SQL Server
2. **權限**：確認有 INSERT 權限
3. **資料完整性**：確認題庫資料已完整匯入
4. **SQL 版本**：確認使用 SQL Server 2016 或更新版本

---

**建立日期**：2024-12-21  
**版本**：1.0  
**狀態**：✅ 完成

