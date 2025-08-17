# 範例頁面規劃
- 依照order01.md的操作流程
- 以及order02.md的資料庫欄位規劃
- 規劃一共需要幾個網頁?
- 每個欄位的操作項目資訊有哪些?
- 具體資訊
  - 網頁檔名、標題
  - 網頁內容及功能描述
  - 操作流程描述
- 網頁規格
  - tailwind+cdn
  - 手機操作模式
  - 只要靜態資料及網頁連結
  - 不要其他動態操作及複雜的資料繫結

# 細節討論
下面這些重點，建議先確認後再動工：

- 專案範圍
  - (✅可少量使用) 目標只做「純靜態示範」？是否允許少量前端 JS 只為了版面互動（不涉及資料繫結）？
  - (✅是) 頁面數與流程固定為 9 頁？是否要加「首頁/說明」或「404」？

- 資料樣本
  - (✅可) 靜態樣本資料量：每分類商品數（5–10）、選項組與選項值數量、價差/四捨五入規則。
  - (✅可) 語系/幣別/時區：zh-TW、TWD、Asia/Taipei、24 小時制可嗎？
  - (✅不用) 欄位顯示命名（中英對照）與單位格式（$、%）。

- UI/樣式
  - (✅請自行判斷) Tailwind 版本與 CDN 位址（例如 v3.x）；主色系/字體/按鈕樣式。
  - (✅480PX) 行動優先的版面規格與斷點（最大寬度 480/640px？）。
  - (✅要) 是否需要簡易步驟列、麵包屑或固定底部導覽。

- 導覽與資訊架構
  - (✅要) 每頁「返回/下一步」是否固定出現？是否提供「回到選店」快速鍵？
  - (✅單一路徑) 頁與頁之間的連結規則（固定情境：單一路徑，或多入口/多出口？）。

- 欄位與驗證（雖為靜態，仍需規範）(✅以下皆是, 需一致)
  - 必填欄位：例如 `serviceType`、`pickupAt`、`paymentMethod`。
  - 格式：`taxId`（8 碼）、`mobileCarrier` 格式、時間選擇顯示格式。
  - 枚舉值最終版：`serviceType`、`packagingOption`、`paymentMethod`、`orderStatus` 是否與 `order02.md`/`schema.sql` 完全一致。

- 檔案與目錄 (✅以下皆是, 需一致)
  - 輸出目錄建議：`ex02/mockup/` 放 9 個 HTML 檔與靜態資產，OK 嗎？
  - 檔名是否以短橫命名（已列：`store-select.html` 等）？

- 內容素材 (✅請自行判斷)
  - 圖片是否需要（商品/門市）？若缺圖可否用佔位圖服務（如 placehold.co）？
  - 文案語氣（全形/半形標點、字詞統一）。

- 可用性/可及性 (✅請自行判斷)
  - 觸控大小（至少 44px）、對比度、鍵盤焦點樣式是否要納入。

- 驗收標準 (✅請自行判斷)
  - 何謂完成：所有頁面能顯示、導覽可用、欄位與文案符合規格、手機直向瀏覽無斷行問題。
  - 是否需要簡易 Lighthouse（Performance/Accessibility）達到某門檻（雖為靜態）？

請回覆以上項目（尤其：是否完全不使用 JS、Tailwind 版本、輸出目錄、枚舉值最終版、樣本資料量）以便我依此產出 9 個最小 HTML 範本並串好導覽。

# 頁面清單
- 共 9 個頁面（純靜態、Tailwind via CDN、手機優先）
  - `store-select.html`：選取點餐門市
  - `service-type.html`：選取外帶/內用
  - `menu.html`：菜單分類與商品列表
  - `product.html`：商品詳情與選項
  - `cart.html`：購物車
  - `addons.html`：加購/包裝選擇
  - `pickup.html`：取貨與發票資訊
  - `payment.html`：進行付款
  - `order-tracking.html`：取餐進度

## 0. 選取點餐門市
- 檔名：`store-select.html`
- 標題：選取門市
- 目的/內容：依縣市/行政區篩選門市並選取
- 表單欄位：
  - 縣市 city: 下拉選單（靜態清單）
  - 區域 district: 下拉選單（依縣市過濾）
  - 門市 storeId/storeName: 清單卡片點選
- 操作流程：選縣市→選區域→點門市卡→前往 `service-type.html`
- 導覽：上一頁（無）／下一頁 `service-type.html`

## 1. 選取外帶/內用
- 檔名：`service-type.html`
- 標題：用餐方式
- 目的/內容：選取外帶或內用，必要時輸入桌號與人數
- 表單欄位：
  - 用餐方式 serviceType: [TAKEOUT, DINE_IN]
  - 桌號 tableNumber: 文字（內用可填）
  - 人數 partySize: 數字（可選）
- 操作流程：選好後→前往 `menu.html`
- 導覽：返回 `store-select.html`／下一頁 `menu.html`

## 2. 菜單分類與商品列表
- 檔名：`menu.html`
- 標題：選擇餐點
- 目的/內容：顯示分類與商品卡片（圖/名/價），點選進入詳情
- 靜態資料：`categories`、`products`（對應 `categories`, `products`）
- 操作流程：點商品卡→前往 `product.html`
- 導覽：返回 `service-type.html`／下一頁 `product.html`

## 3. 商品詳情與選項
- 檔名：`product.html`
- 標題：餐點選項
- 目的/內容：顯示商品資訊、客製選項、數量與備註
- 表單欄位：
  - 商品 productId/productName/unitPrice（唯讀顯示）
  - 選項群組 optionGroupName / 是否必填 isRequired / 上限 selectionLimit（渲染用）
  - 選項值 optionValueId/optionValueName（單/多選）
  - 數量 quantity: 數字，預設 1
  - 備註 customNote: 文字
- 操作流程：加入購物車→前往 `cart.html`
- 導覽：返回 `menu.html`／下一頁 `cart.html`

## 4. 購物車
- 檔名：`cart.html`
- 標題：購物車
- 目的/內容：顯示品項清單、數量、規格摘要與金額彙總
- 顯示欄位：
  - 品項 itemId/productName/specSummary
  - 單價 unitPrice / 數量 quantity / 小計 lineTotal
  - 小計 subtotal / 折扣 discountTotal / 應付 grandTotal
- 操作流程：檢視確認→前往 `addons.html`
- 導覽：返回 `product.html`／下一頁 `addons.html`

## 5. 加購/包裝選擇
- 檔名：`addons.html`
- 標題：加購與包裝
- 目的/內容：選擇包裝或加購項（純靜態示意）
- 表單欄位：
  - 包裝選擇 packagingOption: [NONE, CUTLERY, BAG_SMALL, BAG_MEDIUM, BAG_LARGE]
  - 包裝費用 packagingFee（動態計算示意，頁面靜態顯示）
- 操作流程：選擇完成→前往 `pickup.html`
- 導覽：返回 `cart.html`／下一頁 `pickup.html`

## 6. 取貨與發票資訊
- 檔名：`pickup.html`
- 標題：取貨資訊
- 目的/內容：確認取貨門市/時間與發票資訊
- 表單欄位：
  - 取貨門市 pickupStoreId（唯讀顯示所選門市）
  - 取餐時間 pickupAt（時間選擇器或下拉）
  - 統編 taxId / 手機載具 mobileCarrier / 捐贈碼 donationCode（可選）
  - 備註 note（可選）
- 操作流程：確認→送出→前往 `payment.html`
- 導覽：返回 `addons.html`／下一頁 `payment.html`

## 7. 進行付款
- 檔名：`payment.html`
- 標題：付款
- 目的/內容：顯示應付金額與付款方式
- 表單欄位：
  - 應付金額 payableAmount（唯讀）
  - 付款方式 paymentMethod: [CASH, CARD, E_WALLET]
  - 支付提供商 paymentProvider（卡/錢包時顯示）
- 操作流程：按下「完成」→前往 `order-tracking.html`
- 導覽：返回 `pickup.html`／下一頁 `order-tracking.html`

## 8. 取餐進度
- 檔名：`order-tracking.html`
- 標題：取餐進度
- 目的/內容：顯示取餐號與狀態流轉（純靜態示意）
- 顯示欄位：
  - 訂單號 orderNumber / 取餐號 pickupNumber
  - 訂單狀態 orderStatus: [RECEIVED, PREPARING, READY, PICKED_UP, CANCELLED]
  - 估計完成時間 eta / 最後更新時間 updatedAt（示意）
- 操作流程：提供返回首頁連結
- 導覽：返回 `store-select.html`

## UI/前端規格（共通）
- 樣式：Tailwind CSS via CDN；版面以手機直向為主（最大寬度 480–640px）
- 導覽：每頁保留「返回」與「下一步」連結（純超連結，不做資料帶入）
- 元件：卡片/清單/按鈕/步驟列（純樣式，不含 JS 行為）
- 資料：頁面內以靜態假資料呈現，欄位名稱盡量對應 `order02.md` 與 `schema.sql`
