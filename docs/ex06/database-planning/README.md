# 資料庫規劃與匯入指南

## 📋 檔案說明

### 核心 SQL 腳本

| 檔案名稱 | 說明 |
|---------|------|
| **CREATE_DATABASE.sql** | 建立資料庫結構（7個資料表） |
| **INSERT_DATA_DIRECT.sql** | 資料匯入腳本 - 使用合併後的單一 CSV |

### 使用指南

| 檔案名稱 | 說明 |
|---------|------|
| **CSV_MERGE_GUIDE.md** | CSV 合併指南 |

### 翻譯範本

| 檔案名稱 | 說明 |
|---------|------|
| **instrument_translations_template.csv** | 36個量表中文翻譯範本 |
| **label_translations_template.csv** | 246個特質中文翻譯範本 |

---

## 🚀 快速開始

### 資料匯入步驟

1. **執行 CREATE_DATABASE.sql** 建立資料庫結構
2. **合併 CSV 檔案** → 參考 `CSV_MERGE_GUIDE.md`
   - 將三個原始 CSV 合併成一個 `IPIP_items-merged.csv`
3. **執行 INSERT_DATA_DIRECT.sql** 匯入資料

**優點**：
- ✅ 流程簡單，只需一個 CSV 檔案
- ✅ 只需要一個臨時表（簡化流程）
- ✅ 更符合設計理念（中英文在同一列）
- ✅ 支援翻譯範本功能

---

## 📊 資料庫結構

### 主要資料表

1. **InstrumentCategory** - 量表分類（36個）
2. **TraitCategory** - 特質面向分類（246個）
3. **QuestionBank** - 題庫主檔（3,805題）

### 關聯關係

```
InstrumentCategory (1) ──────< (N) QuestionBank
TraitCategory (1) ──────< (N) QuestionBank
```

---

## 📝 匯入前準備

### 需要的 CSV 檔案

- `IPIP_items-merged.csv` (合併後的單一檔案，7個欄位)
  - 包含欄位：`instrument`, `alpha`, `key`, `text_en`, `text_zh`, `label`, `IPIP_item_number`
  - 詳細合併步驟請參考：`CSV_MERGE_GUIDE.md`

### 檢查清單

- [ ] CSV 檔案編碼為 UTF-8
- [ ] 確認資料筆數正確（3,805題）
- [ ] 檢查中英文題目對應關係

---

## 🔧 後續工作

### 1. 補充中文翻譯（可選，建議在匯入前準備）

**方式一：匯入時直接使用**（推薦 ✨）
- 在執行 `INSERT_DATA_DIRECT.sql` 前，先填入翻譯範本 CSV 的中文
- 匯入時會自動使用中文翻譯，不需要後續更新

**方式二：後續補充**
- 如果匯入時未準備翻譯，可以後續使用翻譯範本更新

使用翻譯範本 CSV 檔案：
- `instrument_translations_template.csv` (36個量表)
- `label_translations_template.csv` (246個特質)

**詳細說明**：請參考 `TRANSLATION_GUIDE.md`

### 2. 建立測卷

匯入完成後，可以建立測卷（TestPaper）並加入題目。

---

## 📚 詳細文件

- **CSV 合併指南**：`CSV_MERGE_GUIDE.md`
- **翻譯範本使用指南**：`TRANSLATION_GUIDE.md`
- **完整使用說明**：`docs/ex06/ex06-02.md`

---

## ⚠️ 注意事項

1. **備份資料庫**：執行前請先備份
2. **測試環境**：建議先在測試環境執行
3. **編碼問題**：確保所有 CSV 為 UTF-8 編碼
4. **權限檢查**：確認資料庫使用者有足夠權限

---

**最後更新**：2024-12-07  
**版本**：2.0
