# Ex06 - IPIP 心理測驗題庫專案

本專案包含 IPIP（International Personality Item Pool）題庫的探索分析與資料庫匯入規劃。

---

## 📁 專案結構

### 📊 data-exploration（題庫探索）

探索和分析 IPIP 題庫的原始資料。

| 檔案 | 說明 |
|------|------|
| `ex06-1.md` | 專案概述 |
| `data-source.md` | 資料來源說明 |
| `data-explore.md` | 資料探索主文件 |
| `data-explore-1.md` | 探索階段 1 |
| `data-explore-2.md` | 探索階段 2 |
| `data-explore-3.md` | 探索階段 3 |
| `data-explore-4.md` | 探索階段 4（完整分析） |
| `translation-process.md` | 翻譯過程記錄 |

### 🗄️ database-planning（資料庫規劃）

資料庫設計與資料匯入規劃相關文件。

| 檔案 | 說明 |
|------|------|
| `README.md` | **快速入門指南** ⭐ |
| `FINAL-IMPORT-REPORT.md` | **完整匯入報告** 📋 |
| `csv-import-analysis.md` | CSV 資料匯入評估 |
| `ipip-files-comparison.md` | 三份檔案對照分析 |
| `database-import-script.sql` | SQL 匯入腳本 |
| `generate-item-mapping.ps1` | PowerShell 對照表生成工具 |
| `instrument_translations_template.csv` | 量表翻譯範本（36 筆） |
| `label_translations_template.csv` | 特質翻譯範本（246 筆） |

---

## 🎯 專案目標

將 IPIP 公開題庫（3,805 題）匯入到 MySQL 資料庫，支援：
- 36 種心理測量量表
- 246 種人格特質面向
- 中英文雙語支援
- 完整的題目編碼對照

---

## 🚀 快速開始

### 1. 了解資料來源
📖 閱讀 `data-exploration/data-source.md`

### 2. 查看匯入評估
📋 閱讀 `database-planning/README.md` 或 `FINAL-IMPORT-REPORT.md`

### 3. 執行資料匯入
🔧 使用 `database-planning/database-import-script.sql`

---

## 📊 資料概覽

| 項目 | 數量 |
|------|------|
| 總題數 | 3,805 |
| 量表數 | 36 |
| 特質面向數 | 246 |
| 原始 IPIP 題目 | 3,320 |
| ItemNumber 匹配率 | ~96% |

---

## 📝 相關資源

- **資料字典**: `docs/ex04/data-dictionary.md`
- **專案規劃**: `docs/ex03/ex03-01.md`
- **CSV 資料**: 
  - `ex05/IPIP_items.csv` (英文)
  - `ex05/IPIP_items-zh-tw.csv` (中文)
  - `docs/ex03/IPIP3320.csv` (ItemNumber 參考)

---

## 🔗 外部連結

- [IPIP 官網](https://ipip.ori.org/)
- [OpenPsychometrics GitHub](https://github.com/haghish/openpsychometrics)

---

## 📅 建立日期

2024-12-07

---

## 👤 維護者

專案團隊
