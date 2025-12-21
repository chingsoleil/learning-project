# PostgreSQL Windows 11 安裝指南

> 💡 **推薦方式**：使用 Docker 方式安裝，這是最簡單、最不容易出問題的方法。

---

## 🐳 使用 Docker 安裝 PostgreSQL

### 為什麼推薦 Docker？

- ✅ **一次安裝，永久使用**：安裝 Docker Desktop 後，任何資料庫都能輕鬆安裝
- ✅ **不會污染系統**：不會在系統留下殘留檔案
- ✅ **容易移除**：刪除容器即可，不會影響系統
- ✅ **版本管理簡單**：可以同時運行多個版本
- ✅ **跨平台一致**：Windows、Mac、Linux 都一樣

### 前置需求

1. 安裝 Docker Desktop for Windows
   - 下載：https://www.docker.com/products/docker-desktop/
   - 安裝後需要重開機
   - 確認 Docker Desktop 正在運行（系統匣有圖示）

### 安裝步驟

#### 步驟 1：建立並啟動容器

```bash
# 建立 PostgreSQL 容器（會自動下載並啟動）
docker run --name postgres-dev `
  -e POSTGRES_PASSWORD=postgres123 `
  -e POSTGRES_DB=psychometrictestdb `
  -p 5432:5432 `
  -v postgres-data:/var/lib/postgresql/data `
  -d postgres:16
```

**參數說明**：
- `--name postgres-dev`：容器名稱
- `-e POSTGRES_PASSWORD`：設定 postgres 使用者密碼（預設：`postgres123`）
- `-e POSTGRES_DB`：自動建立資料庫 `psychometrictestdb`
- `-p 5432:5432`：連接埠對應
- `-v postgres-data:/var/lib/postgresql/data`：資料持久化（重要！）
- `-d`：背景執行

#### 步驟 2：驗證安裝

```bash
# 連接到 PostgreSQL
docker exec -it postgres-dev psql -U postgres -d psychometrictestdb
```

如果看到 `psychometrictestdb=#` 提示符，表示成功！

#### 步驟 3：常用 Docker 命令

```bash
# 啟動容器
docker start postgres-dev

# 停止容器
docker stop postgres-dev

# 查看容器狀態
docker ps -a

# 查看容器日誌
docker logs postgres-dev

# 刪除容器（資料會保留在 volume 中）
docker rm postgres-dev

# 完全刪除（包括資料）
docker rm -v postgres-dev
```

#### 步驟 4：使用圖形化工具連接

**連線資訊**：
- **主機**：`localhost`
- **連接埠**：`5432`
- **資料庫**：`psychometrictestdb`
- **使用者**：`postgres`
- **密碼**：`postgres123`（或您設定的密碼）
- **JDBC URL**：`jdbc:postgresql://localhost:5432/psychometrictestdb`

**DBeaver 連接步驟**：
1. 開啟 DBeaver
2. 點擊「新增資料庫連接」
3. 選擇「PostgreSQL」
4. 填入上述連線資訊
5. 點擊「測試連接」確認無誤後，點擊「完成」

---

## 📊 推薦工具

### 1. DBeaver（強烈推薦）⭐⭐⭐
- ✅ **免費開源**的通用資料庫管理工具
- ✅ 支援多種資料庫（PostgreSQL、MySQL、MSSQL、Oracle 等）
- ✅ 介面穩定、功能強大
- ✅ 跨平台（Windows、Mac、Linux）
- ✅ 內建 SQL 編輯器、資料視覺化、匯出功能
- 📥 下載：https://dbeaver.io/

### 2. FlySpeed SQL Query
- 專業的 SQL 查詢工具
- 支援參數化查詢，建立強大的搜尋表單
- 可視化查詢建構器，結合直接 SQL 編輯
- 支援資料匯出（Excel、CSV、Text、XML 等格式）
- 支援列印和 PDF 匯出
- 📥 下載：https://www.activedbsoft.com/download-querytool.html
- 📸 截圖展示：https://www.activedbsoft.com/screenshots-querytool.html

---

## 📝 執行資料庫腳本

安裝完成並連接後，執行以下腳本：

### 步驟 1：執行結構腳本

在 DBeaver 中執行 `postgresql.sql` 建立資料表結構。

### 步驟 2：執行 INSERT 語句

在 DBeaver 中執行 `postgresql_inserts.sql` 匯入資料。

**注意**：`postgresql_inserts.sql` 已經：
- ✅ 按照外鍵依賴關係正確排序
- ✅ 所有 BOOLEAN 值已轉換為 true/false
- ✅ 每個 INSERT 語句都以分號結尾
- ✅ 日期格式已轉換為 PostgreSQL 標準格式

---

## ✅ 安裝成功檢查清單

- [ ] Docker Desktop 正在運行（系統匣有圖示）
- [ ] 容器狀態為「運行中」：`docker ps` 顯示 `postgres-dev`
- [ ] 可以連接到資料庫：`docker exec -it postgres-dev psql -U postgres`
- [ ] 可以執行 SQL 查詢：`SELECT version();`
- [ ] DBeaver 可以連接並看到資料庫

---

## 🔧 常見問題排除

### 問題 1：容器無法啟動

**解決方法**：
```bash
# 查看容器日誌
docker logs postgres-dev

# 檢查容器狀態
docker ps -a

# 重新建立容器
docker rm postgres-dev
docker run --name postgres-dev `
  -e POSTGRES_PASSWORD=postgres123 `
  -e POSTGRES_DB=psychometrictestdb `
  -p 5432:5432 `
  -v postgres-data:/var/lib/postgresql/data `
  -d postgres:16
```

### 問題 2：無法連接到資料庫

**解決方法**：
1. 確認容器正在運行：`docker ps`
2. 確認連接埠正確：`5432`
3. 確認密碼正確：`postgres123`
4. 檢查防火牆設定

### 問題 3：忘記密碼

**解決方法**：
```bash
# 停止容器
docker stop postgres-dev

# 重新建立容器並設定新密碼
docker rm postgres-dev
docker run --name postgres-dev `
  -e POSTGRES_PASSWORD=新密碼 `
  -e POSTGRES_DB=psychometrictestdb `
  -p 5432:5432 `
  -v postgres-data:/var/lib/postgresql/data `
  -d postgres:16
```

---

## 📚 延伸閱讀

- PostgreSQL 官方文件：https://www.postgresql.org/docs/
- Docker 官方文件：https://docs.docker.com/
- DBeaver 使用指南：https://dbeaver.io/docs/
