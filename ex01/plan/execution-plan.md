## 餐廳網站執行計畫（Execution Plan)

### 1. 目標與範圍
- 目標: 依 `docs/` 企劃完成一個資訊清晰、可及性良好的餐廳網站原型。
- 範圍: 靜態前端（HTML/CSS/JS），不含後端。頁面包含 Home / About / Menu / Gallery / Reservations / Contact。

### 2. 依據文件
- 導覽清單: `docs/site-nav.md`
- 頁面企劃: `docs/pages/*.md`（home, about, menu, gallery, reservations, contact）
- 風格與可及性基準: `ex01/index01.html` 現有色彩變數與對比策略

### 3. 里程碑（Milestones）
1) 企劃確認（已完成）
2) 設計基線整理（色票/字體/間距/CSS 變數）
3) 首頁 Home 實作與驗收
4) 菜單 Menu 實作與驗收
5) 關於 About、環境 Gallery、訂位 Reservations、聯絡 Contact 實作與驗收
6) 全站導覽/頁腳、無障礙與對比檢查、內容校對
7) 打包與交付（README、使用方式）

### 4. 實作順序與任務清單（每頁通用）
- 版面：依企劃建立區塊結構與 RWD（手機優先 → 平板 → 桌機）。
- 元件：導覽列、CTA 按鈕、卡片、表單欄位（能重用者抽成樣式）。
- 內容：從 `docs/pages/<page>.md` 填入標題、段落、清單與圖說文案。
- 風格：使用 CSS 變數（深橘/亮橘/文字對比），維持 AA 對比。
- SEO：title、meta description、語意標籤（`nav`/`section`/`footer`）。
- 無障礙：替代文字、label 對應、錯誤訊息不只用顏色表達。
- 測試：視覺在常見寬度斷點，互動（連結/按鈕/捲動）正常。

建議頁面順序與重點
- Home：Hero、精選菜色、社會證明、快速資訊與 CTA。
- Menu：類別區塊與品項卡片，標示（辣/素/堅果）要有文字。
- About：品牌故事、主廚介紹、里程碑/時間軸。
- Gallery：圖片網格 + alt 文案；CTA 導向訂位/聯絡。
- Reservations：表單欄位與注意事項；提交行為後續可暫以假流程。
- Contact：地址/電話/營業時間/交通，`tel:` 連結與地圖連結。

### 5. 驗收標準（Definition of Done）
- 結構：各頁區塊與內容對齊企劃，導覽與頁腳完整。
- 樣式：RWD 正常；深橘背景+白字、亮橘重點在黑/白底達 AA 對比。
- 互動：平滑捲動、hover 效果、CTA 可導向正確頁面（或錨點）。
- 無障礙：圖片 alt、表單 label、鍵盤可用性基本無阻。
- SEO：title/description 填寫；語意標籤使用正確。
- 文件：更新 `README` 使用方式與檔案結構。

### 6. 工時與節奏（可依實際調整）
- M1–M2：規格凍結與設計基線（0.5 天）
- M3：Home（0.5–1 天）
- M4：Menu（0.5–1 天）
- M5：About/Gallery/Reservations/Contact（1–1.5 天）
- M6–M7：整合、檢查、交付（0.5 天）

### 7. 角色與責任
- 您：確認企劃與文案、提供圖片/品牌素材、審核每個里程碑。
- 我：前端實作、可及性與對比檢查、文件維護。

### 8. 風險與對策
- 文案/圖片延遲：以暫用文/示意圖先行，後續可替換。
- 對比不足：以深橘/亮橘雙軌與白/黑字組合測試調整。
- 行動版溢出：建立常見斷點測試與滾動/換行保護。

### 9. 待您確認（Checklist）
- [ ] `docs/site-nav.md` 導覽 OK
- [ ] `docs/pages/*.md` 內容 OK（尤其 Reservations 注意事項/政策）
- [ ] 品牌字體/Logo（如有）
- [ ] 上線與交付格式需求（僅本地/需部署）
