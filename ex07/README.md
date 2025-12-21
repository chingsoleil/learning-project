# IPIP 測驗設計與選題 - 完整文件

## 📋 專案概述

本專案基於 IPIP（International Personality Item Pool）題庫，設計了 5 份心理測驗，每份測驗包含 50 題，總共使用 250 個不重複的題目。

---

## 📁 檔案結構

本專案按照工作流程組織成 4 個主要資料夾：

### 1️⃣ 選題計劃（1-選題計劃/）

包含測驗設計的原則、規劃與範本文件：

- **測驗設計原則文件.md** - 完整的測驗設計原則、Instruments 和 Traits 對應關係
- **選題流程說明.md** - 詳細的選題流程與策略
- **測驗選題使用指南.md** - 使用指南與操作步驟
- **題庫檢視報告.md** - 題庫資料檢視報告
- **測驗1_大五人格快速評估.md** - 測驗 1 範本（含選題條件）
- **測驗2_職場人格評估.md** - 測驗 2 範本
- **測驗3_情緒與人際關係.md** - 測驗 3 範本
- **測驗4_創造力與開放性.md** - 測驗 4 範本
- **測驗5_全面人格評估.md** - 測驗 5 範本

### 2️⃣ 選題程式（2-選題程式/）

包含自動化選題的 Python 腳本：

- **select_questions.py** - 測驗 1 選題腳本
- **select_all_tests.py** - 所有測驗選題腳本（主要腳本）
- **generate_md_files.py** - 生成 MD 檔腳本
- **選題腳本概念.py** - 選題腳本概念說明
- **實際選題.py** - 實際選題腳本（早期版本）

### 3️⃣ 選題結果（3-選題結果/）

包含選題結果與實際題目檔案：

#### 選題結果（TXT 格式）
- **test1_selected_questions.txt** - 測驗 1 選題結果
- **test2_selected_questions.txt** - 測驗 2 選題結果
- **test3_selected_questions.txt** - 測驗 3 選題結果
- **test4_selected_questions.txt** - 測驗 4 選題結果
- **test5_selected_questions.txt** - 測驗 5 選題結果

#### 實際題目檔案（MD 格式，可直接使用）✅
- **測驗1_大五人格快速評估_實際題目.md** - 測驗 1 實際題目（50 題）
- **測驗2_職場人格評估_實際題目.md** - 測驗 2 實際題目（50 題）
- **測驗3_情緒與人際關係_實際題目.md** - 測驗 3 實際題目（50 題）
- **測驗4_創造力與開放性_實際題目.md** - 測驗 4 實際題目（50 題）
- **測驗5_全面人格評估_實際題目.md** - 測驗 5 實際題目（50 題）

### 4️⃣ INSERT SQL（4-INSERT-SQL/）✨ **新增**

包含資料庫 INSERT 指令與說明文件：

- **INSERT_TestPapers.sql** - 完整的 INSERT SQL 指令（5 份測卷 + 250 題）
- **INSERT指令說明.md** - 詳細的 INSERT SQL 指令說明文件
- **README.md** - 使用指南與驗證方法

---

## 🎯 5 份測驗概覽

### 測驗 1：大五人格快速評估
- **Code**: BIG5_QUICK_01
- **題數**: 50 題
- **主題**: 全面評估五大人格特質
- **Traits**: Extraversion (10), Agreeableness (10), Conscientiousness (10), Neuroticism (10), Openness (10)
- **應用**: 個人成長、職業規劃
- **檔案**: `測驗1_大五人格快速評估_實際題目.md`

### 測驗 2：職場人格評估
- **Code**: WORKPLACE_PERSONALITY_01
- **題數**: 50 題
- **主題**: 評估職場相關人格特質
- **Traits**: Conscientiousness (14), Emotional Stability (13), Extraversion (10), Agreeableness (10), Openness (5)
- **應用**: 人才招募、團隊配置
- **檔案**: `測驗2_職場人格評估_實際題目.md`

### 測驗 3：情緒與人際關係
- **Code**: EMOTION_INTERPERSONAL_01
- **題數**: 50 題
- **主題**: 評估情緒管理與人際互動能力
- **Traits**: Depression (16), Altruism (14), Gregariousness (11), Honesty/Integrity (9)
- **應用**: 人際關係改善、情緒管理
- **檔案**: `測驗3_情緒與人際關係_實際題目.md`

### 測驗 4：創造力與開放性
- **Code**: CREATIVITY_OPENNESS_01
- **題數**: 50 題
- **主題**: 評估創造力、學習能力與開放性
- **Traits**: Openness (20), Conscientiousness (10), Extraversion (10), Agreeableness (5), Neuroticism (5)
- **應用**: 教育評估、創意產業
- **檔案**: `測驗4_創造力與開放性_實際題目.md`

### 測驗 5：全面人格評估
- **Code**: COMPREHENSIVE_PERSONALITY_01
- **題數**: 50 題
- **主題**: 多維度全面人格評估
- **Traits**: 大五核心 (30) + HEXACO 特有 (10) + 細分特質 (10)
- **應用**: 深度人格分析、研究用途
- **檔案**: `測驗5_全面人格評估_實際題目.md`

---

## 📊 統計資訊

### 總體統計
- **總測驗數**: 5 份
- **每份測驗題數**: 50 題
- **總題數**: 250 題
- **不重複題數**: 200 題（5 份測驗之間不重複）
- **平均 Alpha**: 0.89（所有題目）
- **Alpha 範圍**: 0.72 - 0.93

### 題目來源
- **題庫總數**: 3,364 題（Alpha ≥ 0.70 且啟用）
- **使用比例**: 5.9%（200/3364）

### Instruments 使用情況
主要使用的 Instruments：
- NEO5-20 (Id: 27)
- BFAS (Id: 6, 7)
- NEO (Id: 26)
- ORVIS (Id: 29, 30)
- VIA (Id: 36)
- AB5C (Id: 2)

---

## ⚠️ 重要發現

### ScoringKey 全為正向題
題庫中所有題目的 `ScoringKey` 都是 1（正向題），沒有 -1（反向題）。這可能是：
1. 題庫資料的特性
2. 反向題已經在題目文字中體現（如「我不喜歡詩歌」）
3. 需要在計分時根據題目語意判斷是否反向計分

### 建議
在實際施測時，建議：
1. 所有題目都使用正向計分方式
2. 根據題目語意判斷該特質的高低
3. 某些題目（如「我容易生氣」）雖然是正向計分，但表示該特質（情緒穩定性）較低

---

## 🚀 使用方式

### 步驟 1：檢視測驗內容
開啟對應的 `測驗X_XXX_實際題目.md` 檔案，檢視：
- 測驗基本資訊
- 50 題完整題目清單（含 QuestionBankId）
- 統計資訊
- SQL INSERT 指令

### 步驟 2：執行 SQL INSERT
每個 MD 檔都包含完整的 SQL INSERT 指令：

1. **TestPaper INSERT**
```sql
INSERT INTO TestPaper (Name, Code, Description, ResponseType, TimeLimit, TotalQuestions, IsActive)
VALUES (...);
```

2. **TestPaperDetail INSERT**
```sql
INSERT INTO TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired)
VALUES
    (1, 3120, 1, 1),
    (1, 3119, 2, 1),
    -- ... 共 50 題
    (1, 1297, 50, 1);
```

### 步驟 3：驗證資料
執行 INSERT 後，查詢資料庫確認：
- TestPaper 表有 5 筆記錄
- TestPaperDetail 表有 250 筆記錄（5 × 50）
- 所有 QuestionBankId 都存在於 QuestionBank 表

---

## 📝 檔案格式說明

### 實際題目 MD 檔格式
每個實際題目 MD 檔包含：

1. **測驗基本資訊**
   - Name, Code, Description, ResponseType, TimeLimit, TotalQuestions, IsActive

2. **題目清單表格**
   - 順序、QuestionBankId、題目文字、TraitId、Trait名稱、InstrumentId、Alpha、ScoringKey

3. **統計資訊**
   - 總題數、正向/反向題數、平均 Alpha、Trait 分布、Instrument 分布

4. **SQL INSERT 指令**
   - TestPaper INSERT（可直接執行）
   - TestPaperDetail INSERT（可直接執行）

---

## 🔧 選題原則

### 1. 信度優先
- 優先選擇 Alpha ≥ 0.75 的題目
- 可接受範圍：Alpha ≥ 0.70
- 實際平均：0.89

### 2. 多樣性
- 5 份測驗之間不重複使用相同題目
- 涵蓋多個 Instruments 和 Traits

### 3. 平衡性
- 每個 trait 的題數符合規劃
- 題目順序隨機化

### 4. 實用性
- 每份測驗嚴格控制為 50 題
- 施測時間約 15-20 分鐘

---

## 📚 相關資源

### IPIP 官方資源
- IPIP 官網：https://ipip.ori.org/
- 題庫來源：`ex06/database-planning/mssql/QuestionBank.csv`
- Instruments 對應：`ex06/database-planning/mssql/InstrumentCategory.csv`
- Traits 對應：`ex06/database-planning/mssql/TraitCategory.csv`

### 專案文件
- 測驗設計原則：`測驗設計原則文件.md`
- 選題流程：`選題流程說明.md`
- 使用指南：`測驗選題使用指南.md`
- 題庫檢視：`題庫檢視報告.md`

---

## ✅ 檢查清單

### 資料完整性
- [x] 5 份測驗各 50 題
- [x] 所有題目 Alpha ≥ 0.70
- [x] 所有題目有中文翻譯
- [x] 5 份測驗之間題目不重複
- [x] 所有 QuestionBankId 都存在於題庫中

### SQL 指令
- [x] TestPaper INSERT 指令完整
- [x] TestPaperDetail INSERT 指令完整
- [x] Code 唯一性確認
- [x] QuestionOrder 連續（1-50）

### 文件完整性
- [x] 5 個實際題目 MD 檔
- [x] 統計資訊完整
- [x] Trait 和 Instrument 分布清楚
- [x] 使用說明完整

---

---

## 🗄️ 資料庫匯入指南

### 步驟 1：準備資料庫

確認以下資料已匯入：

```sql
-- 檢查題庫筆數（應該有 3,805 筆）
SELECT COUNT(*) FROM dbo.QuestionBank;

-- 檢查量表分類（應該有 36 筆）
SELECT COUNT(*) FROM dbo.InstrumentCategory;

-- 檢查特質分類（應該有 246 筆）
SELECT COUNT(*) FROM dbo.TraitCategory;
```

### 步驟 2：執行 INSERT SQL

使用以下任一方式執行 `4-INSERT-SQL/INSERT_TestPapers.sql`：

#### 方法 A：使用 SSMS
1. 開啟 SQL Server Management Studio
2. 連接到資料庫
3. 開啟 `INSERT_TestPapers.sql`
4. 按 F5 執行

#### 方法 B：使用 sqlcmd
```bash
sqlcmd -S localhost -d PsychometricTestDB -i 4-INSERT-SQL/INSERT_TestPapers.sql
```

### 步驟 3：驗證結果

執行完成後會自動顯示驗證結果，或手動執行：

```sql
-- 檢查測卷數量（應該有 5 筆）
SELECT COUNT(*) FROM dbo.TestPaper;

-- 檢查測卷明細數量（應該有 250 筆）
SELECT COUNT(*) FROM dbo.TestPaperDetail;

-- 檢查每份測卷的題數
SELECT 
    tp.Name AS [測卷名稱],
    tp.TotalQuestions AS [設定題數],
    COUNT(tpd.Id) AS [實際題數]
FROM dbo.TestPaper tp
LEFT JOIN dbo.TestPaperDetail tpd ON tp.Id = tpd.TestPaperId
GROUP BY tp.Name, tp.TotalQuestions
ORDER BY tp.Id;
```

### 📊 匯入資料統計

| 項目 | 數量 | 說明 |
|------|------|------|
| TestPaper | 5 筆 | 5 份心理測驗卷 |
| TestPaperDetail | 250 筆 | 每份測卷 50 題 |
| 總 INSERT 指令 | 255 筆 | 5 + 250 |

---

## 🎉 專案完成

所有 5 份測驗的實際題目已完成選題並建立 MD 檔與 SQL 指令，可直接使用於資料庫操作。

### ✅ 已完成項目

- [x] 5 份測驗設計規劃
- [x] 自動化選題程式開發
- [x] 250 題不重複題目選題
- [x] 5 份實際題目 MD 檔
- [x] 完整的 INSERT SQL 指令
- [x] 詳細的使用說明文件

### 🚀 下一步

1. **資料庫匯入**：執行 `4-INSERT-SQL/INSERT_TestPapers.sql` 將測驗匯入資料庫
2. **系統整合**：將測驗整合到心理測驗系統
3. **施測準備**：準備測驗環境與受測者資料
4. **資料收集**：進行施測與資料收集
5. **結果分析**：分析測驗結果與信效度

---

## 📞 參考文件

### 設計與規劃
- `1-選題計劃/測驗設計原則文件.md` - 設計原則說明
- `1-選題計劃/選題流程說明.md` - 選題流程
- `1-選題計劃/測驗選題使用指南.md` - 使用指南

### 程式與腳本
- `2-選題程式/select_all_tests.py` - 選題主程式
- `2-選題程式/generate_md_files.py` - MD 檔生成程式

### 結果與資料
- `3-選題結果/測驗*_實際題目.md` - 5 份測驗實際題目
- `3-選題結果/test*_selected_questions.txt` - 選題結果原始資料

### 資料庫匯入
- `4-INSERT-SQL/INSERT_TestPapers.sql` - SQL 匯入指令
- `4-INSERT-SQL/INSERT指令說明.md` - 詳細說明文件
- `4-INSERT-SQL/README.md` - 使用指南

---

**建立日期**：2024-12-21  
**最後更新**：2024-12-21  
**版本**：v1.1  
**狀態**：✅ 完成（包含 INSERT SQL）

