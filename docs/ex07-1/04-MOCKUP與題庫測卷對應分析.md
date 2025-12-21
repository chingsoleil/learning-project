# MOCKUP 與題庫測卷對應分析

## 現況盤點

### 已建立的資源

#### 1. 題庫資料
- **InstrumentCategory.csv**: 36個量表分類
- **TraitCategory.csv**: 246個特質面向
- **QuestionBank.csv**: 3,805題題目

#### 2. 測卷資料
- **5套測卷**已建立：
  1. 測驗1：大五人格快速評估（50題）
  2. 測驗2：職場人格評估（50題）
  3. 測驗3：情緒與人際關係（50題）
  4. 測驗4：創造力與開放性（50題）
  5. 測驗5：全面人格評估（50題）
- **INSERT SQL**: `ex07/4-INSERT-SQL/INSERT_TestPapers.sql`

#### 3. MOCKUP 頁面
- 15個完整頁面（使用者端 7個 + 管理系統 8個）
- 4個共用組件

---

## 對應關係分析

### ✅ 已對應的部分

#### 1. 測驗類型
- **MOCKUP**: 目前只實作「大五人格測驗」
- **資料庫**: 已有 5 套測卷，但 MOCKUP 只對應到測驗1
- **落差**: MOCKUP 需要擴充支援多種測驗類型

#### 2. 題目數量
- **MOCKUP**: 固定 50 題
- **測卷**: 所有測卷都是 50 題
- **狀態**: ✅ 一致

#### 3. 作答方式
- **MOCKUP**: Likert 5點量表（1-5）
- **測卷**: ResponseType = "Likert5"
- **狀態**: ✅ 一致

#### 4. 題目結構
- **MOCKUP**: 使用 `big-five-questions.json`（50題，5個維度各10題）
- **資料庫**: 題目來自 QuestionBank，透過 TestPaperDetail 關聯
- **落差**: MOCKUP 使用靜態 JSON，需要改為動態從 API 載入

#### 5. 特質維度
- **MOCKUP**: 固定 5 個維度（Openness, Conscientiousness, Extraversion, Agreeableness, Neuroticism）
- **資料庫**: 246 個特質面向，測卷可能使用不同特質組合
- **落差**: MOCKUP 假設固定 5 維度，但實際測卷可能使用不同特質

---

## 主要落差與問題

### 🔴 嚴重落差

#### 1. 測驗類型單一化
**問題**:
- MOCKUP 只實作「大五人格測驗」
- 資料庫有 5 套測卷，但 MOCKUP 無法選擇

**影響**:
- 首頁的「選擇測驗」功能無法實現
- 無法支援多種測驗類型

**解決方案**:
- 首頁改為動態載入測卷列表（從 TestPaper API）
- 測驗介紹頁改為動態顯示（依 TestPaperId）
- 答題頁改為動態載入題目（從 TestPaperDetail API）

#### 2. 題目資料來源
**問題**:
- MOCKUP 使用靜態 JSON 檔案
- 實際應從資料庫動態載入

**影響**:
- 無法使用資料庫中的 3,805 題題庫
- 無法動態調整測卷內容

**解決方案**:
- 移除 `big-five-questions.json`
- 改為從 API 載入：
  - `GET /api/testpapers/{id}/questions` → 取得測卷題目列表
  - 依 TestPaperDetail 的 QuestionOrder 排序

#### 3. 特質維度動態化
**問題**:
- MOCKUP 假設固定 5 個維度
- 實際測卷可能使用不同特質組合

**影響**:
- 測驗結果頁的雷達圖無法動態調整
- 無法支援不同特質組合的測卷

**解決方案**:
- 動態計算測卷使用的特質（從 TestPaperDetail → QuestionBank → TraitCategory）
- 雷達圖改為動態維度
- 分數計算改為依特質分組

#### 4. 分數計算邏輯
**問題**:
- MOCKUP 使用固定計算邏輯（5個維度各10題）
- 實際測卷的題目分布可能不同

**影響**:
- 分數計算不準確
- 無法正確反映各特質分數

**解決方案**:
- 實作動態分數計算：
  - 依 TestPaperDetail 取得題目
  - 依 QuestionBank.ScoringKey 處理正反向計分
  - 依 TraitCategoryId 分組計算各特質分數

### 🟡 中等落差

#### 5. 測驗時間限制
**問題**:
- MOCKUP 沒有實作時間限制功能
- 資料庫 TestPaper.TimeLimit 欄位未使用

**解決方案**:
- 在答題頁加入倒數計時器
- 時間到自動提交

#### 6. 測驗說明
**問題**:
- MOCKUP 測驗介紹頁使用固定文字
- 資料庫 TestPaper.Description 未使用

**解決方案**:
- 動態載入 TestPaper.Description
- 動態顯示測驗資訊

#### 7. 題目順序
**問題**:
- MOCKUP 題目順序固定
- 資料庫 TestPaperDetail.QuestionOrder 未使用

**解決方案**:
- 依 QuestionOrder 排序題目
- 支援題目順序調整

### 🟢 輕微落差

#### 8. 題目文字顯示
**問題**:
- MOCKUP 只顯示中文題目
- 資料庫有 TextEn 和 TextZh

**解決方案**:
- 支援多語言切換（未來擴充）
- 目前使用 TextZh

#### 9. 題目信度顯示
**問題**:
- MOCKUP 不顯示 Alpha 值
- 資料庫有 Alpha 和 Alpha2

**解決方案**:
- 管理系統題目管理頁可顯示
- 使用者端不需要顯示

---

## 資料對應表

### TestPaper → MOCKUP 頁面

| 資料庫欄位 | MOCKUP 頁面 | 對應位置 | 狀態 |
|-----------|------------|---------|------|
| Name | TestIntro, TestResult | 標題 | ✅ 需動態化 |
| Code | - | - | ⚠️ 未使用 |
| Description | TestIntro | 測驗說明 | ✅ 需動態化 |
| ResponseType | Questions | 選項類型 | ✅ 需動態化 |
| TimeLimit | Questions | 倒數計時 | ❌ 未實作 |
| TotalQuestions | TestIntro, Questions | 題數顯示 | ✅ 需動態化 |
| IsActive | Home | 測驗卡片顯示 | ✅ 需動態化 |

### TestPaperDetail → MOCKUP 頁面

| 資料庫欄位 | MOCKUP 頁面 | 對應位置 | 狀態 |
|-----------|------------|---------|------|
| TestPaperId | Questions | 測驗識別 | ✅ 需動態化 |
| QuestionBankId | Questions | 題目識別 | ✅ 需動態化 |
| QuestionOrder | Questions | 題目順序 | ✅ 需動態化 |
| IsRequired | Questions | 必答標記 | ⚠️ 未使用 |

### QuestionBank → MOCKUP 頁面

| 資料庫欄位 | MOCKUP 頁面 | 對應位置 | 狀態 |
|-----------|------------|---------|------|
| TextZh | Questions | 題目文字 | ✅ 需動態化 |
| TextEn | - | - | ⚠️ 未來擴充 |
| ScoringKey | TestResult | 分數計算 | ✅ 需實作 |
| Alpha | admin/QuestionManagement | 信度顯示 | ⚠️ 可選 |

### TraitCategory → MOCKUP 頁面

| 資料庫欄位 | MOCKUP 頁面 | 對應位置 | 狀態 |
|-----------|------------|---------|------|
| NameZh | TestResult, DetailedReport | 維度名稱 | ✅ 需動態化 |
| NameEn | - | - | ⚠️ 未來擴充 |
| Description | DetailedReport | 維度說明 | ✅ 需動態化 |

---

## 實作優先順序

### 第一優先（核心功能）
1. ✅ 動態載入測卷列表（首頁）
2. ✅ 動態載入測卷題目（答題頁）
3. ✅ 動態分數計算（結果頁）
4. ✅ 動態特質維度（結果頁、詳細報告頁）

### 第二優先（功能完善）
5. ⚠️ 時間限制功能
6. ⚠️ 測驗說明動態化
7. ⚠️ 題目順序動態化

### 第三優先（優化擴充）
8. 🔵 多語言支援
9. 🔵 題目信度顯示
10. 🔵 題目必答標記

---

## 結論

### 主要問題
1. **MOCKUP 過於靜態化**：使用固定資料，需要改為動態載入
2. **測驗類型單一**：只支援一種測驗，需要擴充為多測驗支援
3. **分數計算固定**：假設固定 5 維度，需要改為動態計算

### 解決方向
1. **API 化**：所有資料改為從 API 載入
2. **參數化**：測驗類型、題目、特質都改為參數化
3. **動態化**：分數計算、維度顯示都改為動態

### 預估工作量
- **核心功能改造**：3-5 天
- **功能完善**：2-3 天
- **優化擴充**：1-2 天
- **總計**：6-10 天

