# 🚀 GitHub Pages 發布指南

## 📋 **快速開始**

### 1. **推送程式碼**
```bash
git add .
git commit -m "Add GitHub Pages deployment"
git push origin main
```

### 2. **啟用 GitHub Pages**
- 前往 GitHub 專案頁面
- 點擊 **Settings** → **Pages**
- 選擇 **GitHub Actions** 作為來源

### 3. **等待自動部署**
- 前往 **Actions** 標籤查看進度
- 部署完成後即可訪問網站

## 🌐 **網站網址**

```
https://[您的GitHub用戶名].github.io/learning-project/
├── /                    # 🏠 主導航頁面
├── /ex01-web/          # 📚 EX01 網站專案
└── /ex02-mockup/       # 🍽️ EX02 餐廳點餐系統
```

## ⚡ **自動部署觸發**

- 修改 `ex01/web/**` → 自動部署 EX01 網站
- 修改 `ex02/mockup/**` → 自動部署 EX02 網站
- 修改任一資料夾 → 同時部署兩個網站

## 🔧 **手動觸發部署**

1. 前往 **Actions** 標籤
2. 選擇想要的工作流程
3. 點擊 **Run workflow**
4. 選擇分支並執行

## 📁 **工作流程檔案**

- `deploy-ex01-web.yml` - 部署 EX01 網站
- `deploy-ex02-mockup.yml` - 部署 EX02 網站
- `deploy-both-websites.yml` - 同時部署兩個網站 ⭐

## 💡 **最佳實踐**

1. **使用 `deploy-both-websites.yml`** 作為主要部署方式
2. **每次推送後檢查 Actions** 頁面的部署狀態
3. **等待 2-3 分鐘** 讓部署完成後再訪問網站
4. **檢查相對路徑** 確保 CSS、JS、圖片等資源正確載入

## 🚨 **常見問題**

### 網站無法顯示？
- 檢查 Actions 頁面的部署狀態
- 確認 GitHub Pages 已啟用
- 等待幾分鐘讓部署完成

### 部署失敗？
- 檢查錯誤訊息
- 確認工作流程檔案格式正確
- 檢查檔案路徑是否存在

## 📚 **詳細說明**

更多詳細資訊請參考：
- `docs/github-pages-deployment.md` - 完整部署說明
- `docs/multiple-websites-deployment.md` - 多網站部署方案
