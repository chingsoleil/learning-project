# GitHub Pages 部署說明

## 概述

本專案已設定自動部署 `ex02/mockup` 資料夾到 GitHub Pages，作為靜態網站展示。

## 部署流程

### 1. 自動部署（推薦）

當您推送程式碼到 `main` 或 `master` 分支時，GitHub Actions 會自動：

1. 檢查 `ex02/mockup` 資料夾的變更
2. 將該資料夾內容上傳為 GitHub Pages 的靜態檔案
3. 自動部署到 GitHub Pages

### 2. 手動觸發部署

您也可以在 GitHub 的 Actions 頁面手動觸發部署。

## 設定步驟

### 步驟 1：啟用 GitHub Pages

1. 前往您的 GitHub 專案頁面
2. 點擊 **Settings** 標籤
3. 在左側選單中點擊 **Pages**
4. 在 **Source** 部分選擇 **GitHub Actions**

### 步驟 2：推送程式碼

```bash
git add .
git commit -m "Add GitHub Pages deployment workflow"
git push origin main
```

### 步驟 3：檢查部署狀態

1. 前往 **Actions** 標籤查看部署進度
2. 部署完成後，您的網站將在以下網址可用：
   `https://[您的GitHub用戶名].github.io/learning-project/`

## 檔案結構

```
learning-project/
├── .github/
│   └── workflows/
│       └── deploy-mockup.yml    # 部署工作流程
├── ex02/
│   └── mockup/                  # 要部署的靜態網站
│       ├── index.html           # 首頁
│       ├── menu.html            # 菜單頁面
│       ├── cart.html            # 購物車頁面
│       └── ...                  # 其他頁面
└── docs/
    └── github-pages-deployment.md  # 本說明文件
```

## 自訂網址

如果您想要自訂網址，可以：

1. 購買網域
2. 在 GitHub Pages 設定中新增自訂網域
3. 設定 DNS 記錄

## 疑難排解

### 部署失敗

1. 檢查 Actions 頁面的錯誤訊息
2. 確認 `.github/workflows/deploy-mockup.yml` 檔案格式正確
3. 確認 GitHub Pages 已啟用

### 網站無法顯示

1. 等待幾分鐘讓部署完成
2. 檢查 Actions 頁面的部署狀態
3. 確認 GitHub Pages 設定正確

## 更新網站

每次修改 `ex02/mockup` 資料夾中的檔案並推送到 GitHub 後，網站會自動更新。
