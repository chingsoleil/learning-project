# 資料庫匯入操作指南

## 🚀 執行步驟

1. **執行 `CREATE_DATABASE.sql`** → 建立資料庫結構
2. **匯入 CSV**：
   - `temp_ipip_merged` ← `learning-project/ex06/IPIP_items-merged.csv`（9個欄位）
   - （可選）`temp_instrument_translations` ← `learning-project/ex06/instrument_translations_template.csv`
   - （可選）`temp_label_translations` ← `learning-project/ex06/label_translations_template.csv`
3. **執行 `INSERT_DATA_DIRECT.sql`** → 匯入資料

---

## 📊 預期結果

- **InstrumentCategory**：36 個量表
- **TraitCategory**：246 個特質  
- **QuestionBank**：3,805 題

---

## 📝 CSV 規格

**`IPIP_items-merged.csv`**：
- 欄位：`instrument, alpha, alpha2, key, text_en, text_zh, label, label_zh, IPIP_item_number`
- 筆數：3,805 題
- 編碼：UTF-8
- 位置：`learning-project/ex06/IPIP_items-merged.csv`

**翻譯範本**（已完成翻譯）：
- `instrument_translations_template.csv`：36 個量表
- `label_translations_template.csv`：246 個特質
- 位置：`learning-project/ex06/` 資料夾

---

## ⚠️ 注意事項

- CSV 編碼：UTF-8
- 執行前：備份資料庫
- 建議：先在測試環境執行
- 翻譯品質：已完成品質檢查並修正（100% 準確性）

---

## 📂 檔案位置說明

```
learning-project/
├── ex06/
│   ├── IPIP_items-merged.csv              ← 主要資料檔案（已完成翻譯修正）
│   ├── instrument_translations_template.csv ← 量表翻譯範本（已完成）
│   ├── label_translations_template.csv      ← 特質翻譯範本（已完成）
│   └── database-planning/
│       ├── CREATE_DATABASE.sql            ← 建立資料庫結構
│       ├── INSERT_DATA_DIRECT.sql         ← 資料匯入腳本
│       ├── README.md                      ← 本檔案
│       ├── CSV_MERGE_GUIDE.md
│       ├── CSV_PREPARATION_CHECKLIST.md
│       └── DATA_SOURCE_SUMMARY.md
```

---

**詳細說明**：請參考其他指南文件

**版本**：2.1（已更新檔案路徑說明）
