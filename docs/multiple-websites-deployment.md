# 多網站部署方案說明

## 🎯 **部署選項總覽**

本專案提供三種部署方式，讓您可以靈活選擇：

### 1. **獨立部署 EX01 網站** (`deploy-ex01-web.yml`)
- 只部署 `ex01/web` 資料夾
- 觸發條件：推送 `ex01/web/**` 的變更
- 適合：只更新 EX01 專案時

### 2. **獨立部署 EX02 網站** (`deploy-ex02-mockup.yml`)
- 只部署 `ex02/mockup` 資料夾
- 觸發條件：推送 `ex02/mockup/**` 的變更
- 適合：只更新 EX02 專案時

### 3. **同時部署兩個網站** (`deploy-both-websites.yml`) ⭐ **推薦**
- 同時部署兩個資料夾到不同子路徑
- 建立統一的導航頁面
- 觸發條件：推送任一資料夾的變更

## 🌐 **網站結構（使用第三種方式）**

```
https://[用戶名].github.io/learning-project/
├── /                    # 主導航頁面
├── /ex01-web/          # EX01 網站專案
└── /ex02-mockup/       # EX02 餐廳點餐系統
```

## 🚀 **推薦使用方式**

### 使用 `deploy-both-websites.yml`：

1. **推送程式碼**：
   ```bash
   git add .
   git commit -m "Update both websites"
   git push origin main
   ```

2. **自動部署**：
   - GitHub Actions 會自動觸發
   - 建立統一的網站結構
   - 兩個專案都會被部署

3. **訪問網站**：
   - 主頁：`https://[用戶名].github.io/learning-project/`
   - EX01：`https://[用戶名].github.io/learning-project/ex01-web/`
   - EX02：`https://[用戶名].github.io/learning-project/ex02-mockup/`

## 📁 **檔案結構說明**

```
learning-project/
├── .github/
│   └── workflows/
│       ├── deploy-ex01-web.yml      # 獨立部署 EX01
│       ├── deploy-ex02-mockup.yml   # 獨立部署 EX02
│       └── deploy-both-websites.yml # 同時部署兩個 ⭐
├── ex01/
│   └── web/                         # EX01 網站檔案
├── ex02/
│   └── mockup/                      # EX02 網站檔案
└── docs/
    └── multiple-websites-deployment.md
```

## ⚡ **部署觸發邏輯**

### 自動觸發：
- 修改 `ex01/web/**` → 觸發 EX01 部署
- 修改 `ex02/mockup/**` → 觸發 EX02 部署
- 修改任一資料夾 → 觸發同時部署

### 手動觸發：
- 在 GitHub Actions 頁面手動執行任一工作流程

## 🔧 **自訂和擴展**

### 新增更多網站：
1. 複製 `deploy-both-websites.yml`
2. 修改 `Create combined website structure` 步驟
3. 新增更多資料夾的複製指令

### 修改導航頁面：
- 編輯工作流程中的 HTML 內容
- 或建立獨立的 `index.html` 檔案

## 💡 **最佳實踐建議**

1. **使用 `deploy-both-websites.yml`** 作為主要部署方式
2. **保留獨立部署工作流程** 用於快速測試單一專案
3. **定期清理** 不需要的舊版本部署
4. **監控部署狀態** 在 GitHub Actions 頁面

## 🚨 **注意事項**

- 確保兩個資料夾都有 `index.html` 作為入口頁面
- 檢查相對路徑是否正確（CSS、JS、圖片等）
- 部署完成後可能需要等待幾分鐘才能訪問
- 如果遇到衝突，檢查 `concurrency` 設定
