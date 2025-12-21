# INSERT SQL 指令說明文件

## 📋 概述

本文件說明如何為 5 份心理測驗卷建立 INSERT SQL 指令，用於將測卷資料匯入 `PsychometricTestDB` 資料庫。

---

## 🎯 目標資料表

### 1. TestPaper（測卷主檔）
儲存測卷的基本資訊

| 欄位 | 型別 | 說明 | 範例 |
|------|------|------|------|
| Id | INT | 主鍵（自動產生） | 1, 2, 3... |
| Name | NVARCHAR(100) | 測卷名稱 | 大五人格快速評估 |
| Code | NVARCHAR(100) | 測卷代碼（唯一） | BIG5_QUICK_01 |
| Description | NVARCHAR(1000) | 測卷說明 | 全面評估五大人格特質... |
| ResponseType | NVARCHAR(50) | 作答方式 | Likert5 |
| TimeLimit | INT | 作答時間限制（分鐘） | 20 |
| TotalQuestions | INT | 總題數 | 50 |
| IsActive | BIT | 是否啟用 | 1 |
| CreatedAt | DATETIME2 | 建立時間（自動） | - |
| UpdatedAt | DATETIME2 | 更新時間（自動） | - |

### 2. TestPaperDetail（測卷明細檔）
儲存測卷包含的題目清單

| 欄位 | 型別 | 說明 | 範例 |
|------|------|------|------|
| Id | INT | 主鍵（自動產生） | 1, 2, 3... |
| TestPaperId | INT | 測卷ID（外鍵） | 1 |
| QuestionBankId | INT | 題庫ID（外鍵） | 3120 |
| QuestionOrder | INT | 題目順序 | 1, 2, 3...50 |
| IsRequired | BIT | 是否必答 | 1 |
| CreatedAt | DATETIME2 | 建立時間（自動） | - |

---

## 📊 資料量統計

| 測卷編號 | 測卷名稱 | TestPaper | TestPaperDetail | 總計 |
|---------|---------|-----------|-----------------|------|
| 1 | 大五人格快速評估 | 1 筆 | 50 筆 | 51 筆 |
| 2 | 職場人格評估 | 1 筆 | 50 筆 | 51 筆 |
| 3 | 情緒與人際關係 | 1 筆 | 50 筆 | 51 筆 |
| 4 | 創造力與開放性 | 1 筆 | 50 筆 | 51 筆 |
| 5 | 全面人格評估 | 1 筆 | 50 筆 | 51 筆 |
| **總計** | - | **5 筆** | **250 筆** | **255 筆** |

---

## 🔧 技術要點

### 1. 使用 SCOPE_IDENTITY() 取得自動產生的 Id

```sql
-- 插入測卷
INSERT INTO dbo.TestPaper (Name, Code, ...) VALUES (...);

-- 取得剛插入的 TestPaper Id
DECLARE @TestPaper1Id INT = SCOPE_IDENTITY();

-- 使用此 Id 插入明細
INSERT INTO dbo.TestPaperDetail (TestPaperId, ...) 
VALUES (@TestPaper1Id, ...);
```

### 2. 使用 N 前綴處理中文字串

```sql
-- 正確：使用 N 前綴
INSERT INTO dbo.TestPaper (Name, Description) 
VALUES (N'大五人格快速評估', N'全面評估五大人格特質...');

-- 錯誤：沒有 N 前綴會導致中文亂碼
INSERT INTO dbo.TestPaper (Name, Description) 
VALUES ('大五人格快速評估', '全面評估五大人格特質...');
```

### 3. 使用 GO 分隔批次

```sql
-- 測驗 1
INSERT INTO dbo.TestPaper (...) VALUES (...);
-- ... 更多 INSERT

GO  -- 分隔批次

-- 測驗 2
INSERT INTO dbo.TestPaper (...) VALUES (...);
-- ... 更多 INSERT

GO
```

### 4. 使用註解標示測卷

```sql
-- ============================================================================
-- 測驗 1：大五人格快速評估（BIG5_QUICK_01）
-- ============================================================================
```

---

## 📝 測卷資訊摘要

### 測驗 1：大五人格快速評估
- **Code**: `BIG5_QUICK_01`
- **ResponseType**: `Likert5`
- **TimeLimit**: 20 分鐘
- **TotalQuestions**: 50 題
- **Description**: 全面評估五大人格特質，適合一般人格評估、個人成長、職業規劃

### 測驗 2：職場人格評估
- **Code**: `WORKPLACE_PERS_01`
- **ResponseType**: `Likert5`
- **TimeLimit**: 25 分鐘
- **TotalQuestions**: 50 題
- **Description**: 評估職場相關人格特質，包括領導力、責任心、團隊合作等

### 測驗 3：情緒與人際關係
- **Code**: `EMOTION_SOCIAL_01`
- **ResponseType**: `Likert5`
- **TimeLimit**: 20 分鐘
- **TotalQuestions**: 50 題
- **Description**: 評估情緒穩定性與人際互動能力

### 測驗 4：創造力與開放性
- **Code**: `CREATIVITY_OPEN_01`
- **ResponseType**: `Likert5`
- **TimeLimit**: 20 分鐘
- **TotalQuestions**: 50 題
- **Description**: 評估創造力、想像力、藝術興趣等開放性特質

### 測驗 5：全面人格評估
- **Code**: `COMPREHENSIVE_01`
- **ResponseType**: `Likert5`
- **TimeLimit**: 30 分鐘
- **TotalQuestions**: 50 題
- **Description**: 綜合評估多種人格特質，適合深入了解個人特質

---

## 🚀 執行步驟

### 1. 確認資料庫已建立
```sql
USE PsychometricTestDB;
GO
```

### 2. 確認題庫資料已匯入
```sql
-- 檢查題庫筆數
SELECT COUNT(*) FROM dbo.QuestionBank;
-- 應該有 3,805 筆

-- 檢查特定題目是否存在
SELECT Id, TextZh FROM dbo.QuestionBank WHERE Id IN (3120, 3119, 1329);
```

### 3. 執行 INSERT SQL 檔案
```bash
# 使用 sqlcmd 執行
sqlcmd -S localhost -d PsychometricTestDB -i INSERT_TestPapers.sql

# 或在 SSMS 中直接開啟並執行
```

### 4. 驗證資料
```sql
-- 檢查測卷數量
SELECT COUNT(*) FROM dbo.TestPaper;
-- 應該有 5 筆

-- 檢查測卷明細數量
SELECT COUNT(*) FROM dbo.TestPaperDetail;
-- 應該有 250 筆

-- 檢查每份測卷的題數
SELECT 
    tp.Name,
    tp.Code,
    tp.TotalQuestions,
    COUNT(tpd.Id) AS ActualQuestions
FROM dbo.TestPaper tp
LEFT JOIN dbo.TestPaperDetail tpd ON tp.Id = tpd.TestPaperId
GROUP BY tp.Name, tp.Code, tp.TotalQuestions
ORDER BY tp.Id;
```

---

## ⚠️ 注意事項

### 1. 外鍵約束
- `TestPaperDetail.QuestionBankId` 必須存在於 `QuestionBank.Id`
- 如果題庫資料未匯入，INSERT 會失敗

### 2. 唯一約束
- `TestPaper.Code` 必須唯一
- 重複執行 SQL 會導致錯誤，需先刪除舊資料

### 3. 刪除測卷資料
```sql
-- 刪除所有測卷（會自動刪除明細，因為有 CASCADE）
DELETE FROM dbo.TestPaper;

-- 或刪除特定測卷
DELETE FROM dbo.TestPaper WHERE Code = 'BIG5_QUICK_01';
```

### 4. 重置 IDENTITY
```sql
-- 如果需要重置 Id 從 1 開始
DBCC CHECKIDENT ('dbo.TestPaper', RESEED, 0);
DBCC CHECKIDENT ('dbo.TestPaperDetail', RESEED, 0);
```

---

## 📁 相關檔案

- `INSERT_TestPapers.sql` - 完整的 INSERT SQL 指令
- `../3-選題結果/測驗1_大五人格快速評估_實際題目.md` - 測驗 1 選題結果
- `../3-選題結果/測驗2_職場人格評估_實際題目.md` - 測驗 2 選題結果
- `../3-選題結果/測驗3_情緒與人際關係_實際題目.md` - 測驗 3 選題結果
- `../3-選題結果/測驗4_創造力與開放性_實際題目.md` - 測驗 4 選題結果
- `../3-選題結果/測驗5_全面人格評估_實際題目.md` - 測驗 5 選題結果

---

## 📞 疑難排解

### 問題 1：中文亂碼
**原因**：沒有使用 N 前綴  
**解決**：在所有中文字串前加 N

### 問題 2：外鍵約束錯誤
**原因**：QuestionBankId 不存在  
**解決**：確認題庫資料已正確匯入

### 問題 3：唯一約束錯誤
**原因**：Code 重複  
**解決**：先刪除舊資料或修改 Code

### 問題 4：SCOPE_IDENTITY() 返回 NULL
**原因**：INSERT 失敗  
**解決**：檢查 INSERT 語句是否有錯誤

---

## ✅ 完成檢查清單

- [ ] 資料庫已建立（PsychometricTestDB）
- [ ] 題庫資料已匯入（3,805 筆）
- [ ] INSERT SQL 檔案已準備
- [ ] 執行 INSERT SQL
- [ ] 驗證 TestPaper 有 5 筆
- [ ] 驗證 TestPaperDetail 有 250 筆
- [ ] 驗證每份測卷都有 50 題
- [ ] 測試查詢測卷資料

---

**建立日期**: 2024-12-21  
**版本**: 1.0  
**狀態**: ✅ 完成

