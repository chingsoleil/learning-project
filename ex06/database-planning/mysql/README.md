# 資料庫匯入操作指南

## 🚀 執行步驟

0. **（建議）執行環境檢查**：
   - 方法 A：在 DBeaver 中執行 `check_database_environment.sql`
   - 方法 B：在 PowerShell 中執行 `check_database_environment_simple.ps1`

1. **執行 `CREATE_DATABASE.sql`** → 建立資料庫結構（7個資料表）

2. **執行 `INSERT_DATA_DIRECT.sql` 的前半部分**（步驟 1-3）：
   - 會自動建立臨時表：`temp_ipip_merged`、`temp_instrument_translations`、`temp_label_translations`

3. **手動匯入 CSV 到臨時表**：

   **方法 A：使用 LOAD DATA INFILE（推薦，更快）**
   - 確認路徑正確：`D:/dev/ching/learning-project/ex06/database-planning/IPIP_items-merged.csv`
   - 直接執行 SQL，會自動匯入 3,805 題

   **方法 B：使用 DBeaver Import Data（備選）**
   - `temp_ipip_merged` ← `database-planning/IPIP_items-merged.csv`（9個欄位）
   - （可選）`temp_instrument_translations` ← `database-planning/instrument_translations_template.csv`
   - （可選）`temp_label_translations` ← `database-planning/label_translations_template.csv`

4. **繼續執行 `INSERT_DATA_DIRECT.sql` 的後半部分**（步驟 4-9）：
   - 匯入資料到正式資料表（InstrumentCategory、TraitCategory、QuestionBank）
   - 驗證資料完整性

---

## 📊 預期結果

- **InstrumentCategory**：36 個量表
- **TraitCategory**：246 個特質  
- **QuestionBank**：3,805 題

---

## 📝 CSV 規格

**`IPIP_items-merged.csv`**：
- 欄位：`instrument, alpha, alpha2, scoring_key, text_en, text_zh, label, label_zh, IPIP_item_number`
- 筆數：3,805 題
- 編碼：UTF-8
- 位置：`learning-project/ex06/database-planning/IPIP_items-merged.csv`

**翻譯範本**（已完成翻譯）：
- `instrument_translations_template.csv`：36 個量表
- `label_translations_template.csv`：246 個特質
- 位置：`learning-project/ex06/database-planning/` 資料夾

---

## ⚠️ 注意事項

- **執行順序**：必須先建立臨時表，再匯入 CSV，最後執行資料匯入
- **CSV 編碼**：UTF-8
- **執行前**：備份資料庫
- **建議**：先在測試環境執行
- **翻譯品質**：已完成品質檢查並修正（100% 準確性）
- **匯入方式**：推薦使用 LOAD DATA INFILE（已啟用，速度快）
- **大小寫說明**：
  - **SQL 腳本**：統一使用 PascalCase（`PsychometricTestDB`, `InstrumentCategory`, `QuestionBank`）
  - **欄位名**：在所有環境都保持 PascalCase（`NameEn`, `TextEn`, `InstrumentCategoryId` 等）✅
  - **表名行為**：
    - Windows MySQL (`lower_case_table_names=1`)：表名會轉為小寫儲存，但查詢時不區分大小寫
    - Linux MySQL (`lower_case_table_names=0`)：表名保持 PascalCase 儲存
  - **建立後檢查**：執行 `check_database_environment.sql` 確認實際大小寫
  - **強制 PascalCase**：參考 `mysql_pascalcase_setup.sql` 設定 MySQL（需要重啟）
  - **ASP.NET 使用**：統一使用 PascalCase 命名，與 SQL 腳本一致

---

## 📂 檔案位置說明

```
learning-project/ex06/database-planning/
├── source-csv/                            ← 原始資料檔案
│   ├── IPIP_items.csv                    ← 原始英文資料（3,805 題）
│   ├── IPIP_items-zh-tw.csv              ← 原始中文資料（3,805 題）
│   ├── IPIP3320.csv                      ← 原始 IPIP 編號（3,320 題）
│   ├── DataMerge.xlsx                    ← Excel 合併工作檔
│   └── README_CSV_PREPARATION.md         ← CSV 準備說明
├── IPIP_items-merged.csv                 ← 主要資料檔案（已完成翻譯修正）✅
├── instrument_translations_template.csv  ← 量表翻譯範本（36 個）✅
├── label_translations_template.csv       ← 特質翻譯範本（246 個）✅
├── CREATE_DATABASE.sql                   ← 建立資料庫結構
├── INSERT_DATA_DIRECT.sql                ← 資料匯入腳本
├── README.md                             ← 本檔案
├── check_file_privilege.sql              ← 權限檢查腳本
├── CSV_MERGE_GUIDE.md                    ← CSV 合併指南
├── CSV_PREPARATION_CHECKLIST.md          ← CSV 準備檢查清單
└── DATA_SOURCE_SUMMARY.md                ← 資料來源摘要
```

---

**詳細說明**：
- 原始資料準備：`source-csv/README_CSV_PREPARATION.md`
- CSV 合併指南：`CSV_MERGE_GUIDE.md`
- 其他指南文件請參閱本資料夾

**版本**：2.2（檔案結構優化，原始資料移至 source-csv/）
