# PostgreSQL 資料庫腳本
Docker Desktop 已安裝並正常運作。
Docker 版本：29.1.3
Docker 命令可用
docker-desktop WSL 發行版正在運行
建立 PostgreSQL 容器。請提供一個密碼（用於 postgres 使用者），或使用預設密碼 postgres123
jdbc:postgresql://localhost:5432/psychometrictestdb

## 檔案說明

- `mssql.sql` - 原始 MSSQL 資料庫腳本（從 SQL Server 匯出，僅供參考）
- `postgresql.sql` - PostgreSQL 版本的資料庫結構腳本（包含資料表、約束、索引、視圖）
- `postgresql_inserts.sql` - PostgreSQL INSERT 語句（已按照外鍵依賴關係排序）
- `postgresql-installation-guide.md` - PostgreSQL 安裝指南
- `README.md` - 本檔案

## 使用方式

### 步驟 1：執行結構腳本

在 DBeaver 中執行 `postgresql.sql` 建立資料表結構：

```sql
-- 在 DBeaver 中開啟 postgresql.sql，然後執行
-- 或使用 psql 命令列：
psql -U postgres -d psychometrictestdb -f postgresql.sql
```

### 步驟 2：執行 INSERT 語句

在 DBeaver 中執行 `postgresql_inserts.sql` 匯入資料：

```sql
-- 在 DBeaver 中開啟 postgresql_inserts.sql，全選並執行
```

**注意**：`postgresql_inserts.sql` 已經：
- ✅ 按照外鍵依賴關係正確排序
- ✅ 所有 BOOLEAN 值已轉換為 true/false
- ✅ 每個 INSERT 語句都以分號結尾
- ✅ 日期格式已轉換為 PostgreSQL 標準格式

## INSERT 語句順序

`postgresql_inserts.sql` 已按照外鍵依賴關係排序：

1. **InstrumentCategory** (36 條) - 無外鍵依賴
2. **TraitCategory** (246 條) - 無外鍵依賴
3. **TestPaper** (5 條) - 無外鍵依賴
4. **QuestionBank** (3805 條) - 依賴 InstrumentCategory, TraitCategory
5. **TestPaperDetail** (250 條) - 依賴 TestPaper, QuestionBank
6. **TestSession** (0 條) - 依賴 TestPaper（目前無資料）
7. **TestAnswer** (0 條) - 依賴 TestSession, TestPaperDetail（目前無資料）

## 執行順序

1. 確保已連接到 `psychometrictestdb` 資料庫
2. 執行 `postgresql.sql` 建立資料表結構
3. 執行 `postgresql_inserts.sql` 匯入資料

## 注意事項

- PostgreSQL 使用雙引號 `"` 來引用識別符（表名、欄位名）
- 字串使用單引號 `'`
- PostgreSQL 的 SERIAL 類型會自動建立序列
- BOOLEAN 值使用 `true`/`false`，不是 `1`/`0`
- INSERT 語句已按照外鍵依賴關係排序，確保不會出現外鍵約束錯誤

## 驗證

執行後可以驗證：

```sql
-- 檢查資料表
\dt

-- 檢查索引
\di

-- 檢查視圖
\dv

-- 檢查資料筆數
SELECT COUNT(*) FROM "InstrumentCategory";
SELECT COUNT(*) FROM "QuestionBank";
SELECT COUNT(*) FROM "TraitCategory";
```

