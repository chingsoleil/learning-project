-- 資料庫結構規劃
-- 依照order02.md的規劃
-- 使用ms-sql-server
-- 建立create table，並設定primary key、foreign key、index
-- 建立關聯
-- 建立範例資料：基本需求
--    5家門市，5個商品分類，5種選項名稱及相關選項值
--    20筆範例訂單，各1到5項商品內容
 
SET NOCOUNT ON;
GO

/* 1) DROP IF EXISTS */
IF OBJECT_ID('dbo.product_option_values', 'U') IS NOT NULL DROP TABLE dbo.product_option_values;
IF OBJECT_ID('dbo.product_option_groups', 'U') IS NOT NULL DROP TABLE dbo.product_option_groups;
IF OBJECT_ID('dbo.products', 'U') IS NOT NULL DROP TABLE dbo.products;
IF OBJECT_ID('dbo.categories', 'U') IS NOT NULL DROP TABLE dbo.categories;
IF OBJECT_ID('dbo.stores', 'U') IS NOT NULL DROP TABLE dbo.stores;
GO

/* 2) CREATE TABLES (part 1) */
CREATE TABLE dbo.stores (
  store_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  store_name NVARCHAR(100) NOT NULL,
  city NVARCHAR(50) NOT NULL,
  district NVARCHAR(50) NOT NULL,
  address NVARCHAR(200) NOT NULL,
  business_hours NVARCHAR(50) NULL,
  status NVARCHAR(10) NOT NULL,
  CONSTRAINT CK_stores_status CHECK (status IN (N'OPEN', N'BUSY', N'CLOSED'))
);
GO

CREATE TABLE dbo.categories (
  category_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  category_name NVARCHAR(100) NOT NULL,
  sort_order INT NOT NULL DEFAULT(0)
);
GO

CREATE TABLE dbo.products (
  product_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  category_id BIGINT NOT NULL,
  product_name NVARCHAR(100) NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  image_url VARCHAR(255) NULL,
  available BIT NOT NULL DEFAULT(1),
  CONSTRAINT FK_products_categories FOREIGN KEY (category_id) REFERENCES dbo.categories(category_id)
);
GO

CREATE TABLE dbo.product_option_groups (
  group_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  product_id BIGINT NOT NULL,
  group_name NVARCHAR(50) NOT NULL,
  is_required BIT NOT NULL DEFAULT(0),
  selection_limit INT NOT NULL DEFAULT(1),
  CONSTRAINT FK_pog_products FOREIGN KEY (product_id) REFERENCES dbo.products(product_id)
);
GO

CREATE TABLE dbo.product_option_values (
  value_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  group_id BIGINT NOT NULL,
  value_name NVARCHAR(50) NOT NULL,
  price_delta DECIMAL(10,2) NOT NULL DEFAULT(0),
  CONSTRAINT FK_pov_pog FOREIGN KEY (group_id) REFERENCES dbo.product_option_groups(group_id)
);
GO

/* Indexes (part 1) */
CREATE NONCLUSTERED INDEX IX_stores_city_district ON dbo.stores(city, district);
CREATE NONCLUSTERED INDEX IX_stores_status ON dbo.stores(status);
CREATE NONCLUSTERED INDEX IX_products_category ON dbo.products(category_id);
CREATE NONCLUSTERED INDEX IX_products_name ON dbo.products(product_name);
CREATE NONCLUSTERED INDEX IX_pog_product ON dbo.product_option_groups(product_id);
CREATE NONCLUSTERED INDEX IX_pov_group ON dbo.product_option_values(group_id);
GO

/* Seed (part 1) */
INSERT INTO dbo.stores(store_name, city, district, address, business_hours, status) VALUES
 (N'台北信義店', N'台北市', N'信義區', N'信義路五段 7 號', N'10:00-22:00', N'OPEN'),
 (N'台北中山店', N'台北市', N'中山區', N'南京東路一段 23 號', N'10:00-22:00', N'OPEN'),
 (N'新北板橋店', N'新北市', N'板橋區', N'文化路一段 100 號', N'10:00-22:00', N'OPEN'),
 (N'桃園中壢店', N'桃園市', N'中壢區', N'中正路 200 號', N'10:00-22:00', N'OPEN'),
 (N'台中西屯店', N'台中市', N'西屯區', N'台灣大道三段 300 號', N'10:00-22:00', N'OPEN');

INSERT INTO dbo.categories(category_name, sort_order) VALUES
 (N'主餐', 1),
 (N'配菜', 2),
 (N'飲品', 3),
 (N'甜點', 4),
 (N'加購', 5);

-- 修正：每個分類各5到10項餐點
INSERT INTO dbo.products(category_id, product_name, unit_price, image_url, available) VALUES
 (1, N'招牌牛肉飯', 120.00, NULL, 1),
 (1, N'雞腿便當',   110.00, NULL, 1),
 (2, N'酥炸豆腐',    50.00, NULL, 1),
 (2, N'涼拌小黃瓜',  45.00, NULL, 1),
 (3, N'紅茶',        30.00, NULL, 1),
 (3, N'綠茶',        30.00, NULL, 1),
 (3, N'奶茶',        40.00, NULL, 1),
 (4, N'布丁',        35.00, NULL, 1),
 (4, N'奶酪',        35.00, NULL, 1),
 (5, N'加購雞塊',    60.00, NULL, 1);

-- 修正：依照各分類商品設計適合的選項
INSERT INTO dbo.product_option_groups(product_id, group_name, is_required, selection_limit) VALUES
 (5, N'尺寸', 1, 1),
 (5, N'冰塊', 0, 1),
 (5, N'甜度', 0, 1),
 (6, N'尺寸', 1, 1),
 (7, N'尺寸', 1, 1);

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta FROM dbo.product_option_groups g
CROSS APPLY (VALUES (N'大杯', 5.00), (N'中杯', 0.00)) v(value_name, price_delta)
WHERE g.group_name = N'尺寸' AND g.product_id = 5;

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta FROM dbo.product_option_groups g
CROSS APPLY (VALUES (N'正常冰', 0.00), (N'少冰', 0.00), (N'去冰', 0.00)) v(value_name, price_delta)
WHERE g.group_name = N'冰塊' AND g.product_id = 5;

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta FROM dbo.product_option_groups g
CROSS APPLY (VALUES (N'全糖', 0.00), (N'半糖', 0.00), (N'無糖', 0.00)) v(value_name, price_delta)
WHERE g.group_name = N'甜度' AND g.product_id = 5;

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta FROM dbo.product_option_groups g
CROSS APPLY (VALUES (N'大杯', 5.00), (N'中杯', 0.00)) v(value_name, price_delta)
WHERE g.group_name = N'尺寸' AND g.product_id = 6;

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta FROM dbo.product_option_groups g
CROSS APPLY (VALUES (N'大杯', 10.00), (N'中杯', 0.00)) v(value_name, price_delta)
WHERE g.group_name = N'尺寸' AND g.product_id = 7;
GO

-- 追加商品與選項補充
-- 修正：每個分類各5到10項餐點
INSERT INTO dbo.products(category_id, product_name, unit_price, image_url, available) VALUES
 (1, N'香煎雞胸', 115.00, NULL, 1),
 (1, N'和風豬排', 125.00, NULL, 1),
 (1, N'蔬食咖哩飯', 100.00, NULL, 1),
 (2, N'滷蛋', 15.00, NULL, 1),
 (2, N'滷白菜', 35.00, NULL, 1),
 (2, N'海帶芽', 25.00, NULL, 1),
 (3, N'美式咖啡', 45.00, NULL, 1),
 (3, N'檸檬紅茶', 40.00, NULL, 1),
 (4, N'起司蛋糕', 65.00, NULL, 1),
 (4, N'提拉米蘇', 70.00, NULL, 1),
 (4, N'芒果奶酪', 45.00, NULL, 1),
 (5, N'薯條', 40.00, NULL, 1),
 (5, N'雞翅', 55.00, NULL, 1),
 (5, N'熱湯', 30.00, NULL, 1),
 (5, N'白飯加大', 10.00, NULL, 1);

-- 修正：依照各分類商品設計適合的選項
-- 主餐：辣度 / 加飯 / 醬汁
INSERT INTO dbo.product_option_groups(product_id, group_name, is_required, selection_limit)
SELECT p.product_id, N'辣度', 0, 1 FROM dbo.products p WHERE p.product_name IN (N'招牌牛肉飯', N'雞腿便當', N'蔬食咖哩飯');

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta
FROM dbo.product_option_groups g
JOIN dbo.products p ON p.product_id = g.product_id
CROSS APPLY (VALUES (N'不辣',0.00),(N'小辣',0.00),(N'中辣',0.00),(N'大辣',0.00)) v(value_name, price_delta)
WHERE g.group_name = N'辣度' AND p.product_name IN (N'招牌牛肉飯', N'雞腿便當', N'蔬食咖哩飯');

INSERT INTO dbo.product_option_groups(product_id, group_name, is_required, selection_limit)
SELECT p.product_id, N'加飯', 0, 1 FROM dbo.products p WHERE p.product_name IN (N'招牌牛肉飯', N'雞腿便當', N'蔬食咖哩飯');

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta
FROM dbo.product_option_groups g
JOIN dbo.products p ON p.product_id = g.product_id
CROSS APPLY (VALUES (N'正常',0.00),(N'加飯',10.00)) v(value_name, price_delta)
WHERE g.group_name = N'加飯' AND p.product_name IN (N'招牌牛肉飯', N'雞腿便當', N'蔬食咖哩飯');

INSERT INTO dbo.product_option_groups(product_id, group_name, is_required, selection_limit)
SELECT p.product_id, N'醬汁', 0, 1 FROM dbo.products p WHERE p.product_name IN (N'招牌牛肉飯', N'雞腿便當');

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta
FROM dbo.product_option_groups g
JOIN dbo.products p ON p.product_id = g.product_id
CROSS APPLY (VALUES (N'正常',0.00),(N'少',0.00),(N'多',0.00)) v(value_name, price_delta)
WHERE g.group_name = N'醬汁' AND p.product_name IN (N'招牌牛肉飯', N'雞腿便當');

-- 飲品：美式咖啡（尺寸）、檸檬紅茶（尺寸/冰塊/甜度）
INSERT INTO dbo.product_option_groups(product_id, group_name, is_required, selection_limit)
SELECT p.product_id, N'尺寸', 1, 1 FROM dbo.products p WHERE p.product_name IN (N'美式咖啡', N'檸檬紅茶');

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta
FROM dbo.product_option_groups g
JOIN dbo.products p ON p.product_id = g.product_id
CROSS APPLY (VALUES (N'大杯', 10.00), (N'中杯', 0.00)) v(value_name, price_delta)
WHERE g.group_name = N'尺寸' AND p.product_name IN (N'美式咖啡', N'檸檬紅茶');

INSERT INTO dbo.product_option_groups(product_id, group_name, is_required, selection_limit)
SELECT p.product_id, N'冰塊', 0, 1 FROM dbo.products p WHERE p.product_name IN (N'檸檬紅茶');

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta
FROM dbo.product_option_groups g
JOIN dbo.products p ON p.product_id = g.product_id
CROSS APPLY (VALUES (N'正常冰',0.00),(N'少冰',0.00),(N'去冰',0.00)) v(value_name, price_delta)
WHERE g.group_name = N'冰塊' AND p.product_name IN (N'檸檬紅茶');

INSERT INTO dbo.product_option_groups(product_id, group_name, is_required, selection_limit)
SELECT p.product_id, N'甜度', 0, 1 FROM dbo.products p WHERE p.product_name IN (N'檸檬紅茶');

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta
FROM dbo.product_option_groups g
JOIN dbo.products p ON p.product_id = g.product_id
CROSS APPLY (VALUES (N'全糖',0.00),(N'半糖',0.00),(N'無糖',0.00)) v(value_name, price_delta)
WHERE g.group_name = N'甜度' AND p.product_name IN (N'檸檬紅茶');

-- 甜點：加配料
INSERT INTO dbo.product_option_groups(product_id, group_name, is_required, selection_limit)
SELECT p.product_id, N'加配料', 0, 2 FROM dbo.products p WHERE p.product_name IN (N'奶酪', N'芒果奶酪');

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta
FROM dbo.product_option_groups g
JOIN dbo.products p ON p.product_id = g.product_id
CROSS APPLY (VALUES (N'珍珠',10.00),(N'椰果',10.00)) v(value_name, price_delta)
WHERE g.group_name = N'加配料' AND p.product_name IN (N'奶酪', N'芒果奶酪');

-- 加購：份量
INSERT INTO dbo.product_option_groups(product_id, group_name, is_required, selection_limit)
SELECT p.product_id, N'份量', 1, 1 FROM dbo.products p WHERE p.product_name IN (N'薯條', N'雞翅');

INSERT INTO dbo.product_option_values(group_id, value_name, price_delta)
SELECT g.group_id, v.value_name, v.price_delta
FROM dbo.product_option_groups g
JOIN dbo.products p ON p.product_id = g.product_id
CROSS APPLY (VALUES (N'一般',0.00),(N'大份',20.00)) v(value_name, price_delta)
WHERE g.group_name = N'份量' AND p.product_name IN (N'薯條', N'雞翅');

/* 2) CREATE TABLES (part 2) */
IF OBJECT_ID('dbo.cart_item_options', 'U') IS NOT NULL DROP TABLE dbo.cart_item_options;
IF OBJECT_ID('dbo.cart_items', 'U') IS NOT NULL DROP TABLE dbo.cart_items;
IF OBJECT_ID('dbo.carts', 'U') IS NOT NULL DROP TABLE dbo.carts;
IF OBJECT_ID('dbo.order_item_options', 'U') IS NOT NULL DROP TABLE dbo.order_item_options;
IF OBJECT_ID('dbo.order_items', 'U') IS NOT NULL DROP TABLE dbo.order_items;
IF OBJECT_ID('dbo.order_status_history', 'U') IS NOT NULL DROP TABLE dbo.order_status_history;
IF OBJECT_ID('dbo.payments', 'U') IS NOT NULL DROP TABLE dbo.payments;
IF OBJECT_ID('dbo.orders', 'U') IS NOT NULL DROP TABLE dbo.orders;
GO

CREATE TABLE dbo.carts (
  cart_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  store_id BIGINT NOT NULL,
  service_type NVARCHAR(10) NOT NULL,
  table_number NVARCHAR(20) NULL,
  party_size INT NULL,
  promo_code NVARCHAR(50) NULL,
  subtotal DECIMAL(10,2) NOT NULL DEFAULT(0),
  discount_total DECIMAL(10,2) NOT NULL DEFAULT(0),
  grand_total DECIMAL(10,2) NOT NULL DEFAULT(0),
  created_at DATETIME NOT NULL DEFAULT(GETDATE()),
  updated_at DATETIME NOT NULL DEFAULT(GETDATE()),
  CONSTRAINT CK_carts_service_type2 CHECK (service_type IN (N'TAKEOUT', N'DINE_IN')),
  CONSTRAINT FK_carts_stores2 FOREIGN KEY (store_id) REFERENCES dbo.stores(store_id)
);
GO

CREATE TABLE dbo.cart_items (
  item_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  cart_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  product_name NVARCHAR(100) NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  spec_summary NVARCHAR(200) NULL,
  line_total DECIMAL(10,2) NOT NULL,
  CONSTRAINT FK_cart_items_carts2 FOREIGN KEY (cart_id) REFERENCES dbo.carts(cart_id),
  CONSTRAINT FK_cart_items_products2 FOREIGN KEY (product_id) REFERENCES dbo.products(product_id)
);
GO

CREATE TABLE dbo.cart_item_options (
  item_option_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  item_id BIGINT NOT NULL,
  group_id BIGINT NOT NULL,
  value_id BIGINT NOT NULL,
  group_name NVARCHAR(50) NOT NULL,
  value_name NVARCHAR(50) NOT NULL,
  price_delta DECIMAL(10,2) NOT NULL DEFAULT(0),
  CONSTRAINT FK_cio_items2 FOREIGN KEY (item_id) REFERENCES dbo.cart_items(item_id),
  CONSTRAINT FK_cio_group2 FOREIGN KEY (group_id) REFERENCES dbo.product_option_groups(group_id),
  CONSTRAINT FK_cio_value2 FOREIGN KEY (value_id) REFERENCES dbo.product_option_values(value_id)
);
GO

CREATE TABLE dbo.orders (
  order_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  order_number VARCHAR(30) NOT NULL UNIQUE,
  store_id BIGINT NOT NULL,
  service_type NVARCHAR(10) NOT NULL,
  table_number NVARCHAR(20) NULL,
  pickup_number VARCHAR(20) NULL UNIQUE,
  pickup_at DATETIME NULL,
  tax_id NVARCHAR(10) NULL,
  mobile_carrier NVARCHAR(20) NULL,
  donation_code NVARCHAR(20) NULL,
  packaging_option NVARCHAR(20) NOT NULL DEFAULT(N'NONE'),
  packaging_fee DECIMAL(10,2) NOT NULL DEFAULT(0),
  status NVARCHAR(12) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL DEFAULT(0),
  discount_total DECIMAL(10,2) NOT NULL DEFAULT(0),
  grand_total DECIMAL(10,2) NOT NULL DEFAULT(0),
  created_at DATETIME NOT NULL DEFAULT(GETDATE()),
  updated_at DATETIME NOT NULL DEFAULT(GETDATE()),
  CONSTRAINT CK_orders_service_type2 CHECK (service_type IN (N'TAKEOUT', N'DINE_IN')),
  CONSTRAINT CK_orders_packaging2 CHECK (packaging_option IN (N'NONE', N'CUTLERY', N'BAG_SMALL', N'BAG_MEDIUM', N'BAG_LARGE')),
  CONSTRAINT CK_orders_status2 CHECK (status IN (N'RECEIVED', N'PREPARING', N'READY', N'PICKED_UP', N'CANCELLED')),
  CONSTRAINT FK_orders_stores2 FOREIGN KEY (store_id) REFERENCES dbo.stores(store_id)
);
GO

CREATE TABLE dbo.order_items (
  order_item_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  order_id BIGINT NOT NULL,
  product_id BIGINT NOT NULL,
  product_name NVARCHAR(100) NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  spec_summary NVARCHAR(200) NULL,
  line_total DECIMAL(10,2) NOT NULL,
  CONSTRAINT FK_order_items_orders2 FOREIGN KEY (order_id) REFERENCES dbo.orders(order_id),
  CONSTRAINT FK_order_items_products2 FOREIGN KEY (product_id) REFERENCES dbo.products(product_id)
);
GO

CREATE TABLE dbo.order_item_options (
  order_item_option_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  order_item_id BIGINT NOT NULL,
  group_id BIGINT NOT NULL,
  value_id BIGINT NOT NULL,
  group_name NVARCHAR(50) NOT NULL,
  value_name NVARCHAR(50) NOT NULL,
  price_delta DECIMAL(10,2) NOT NULL DEFAULT(0),
  CONSTRAINT FK_oio_items2 FOREIGN KEY (order_item_id) REFERENCES dbo.order_items(order_item_id),
  CONSTRAINT FK_oio_group2 FOREIGN KEY (group_id) REFERENCES dbo.product_option_groups(group_id),
  CONSTRAINT FK_oio_value2 FOREIGN KEY (value_id) REFERENCES dbo.product_option_values(value_id)
);
GO

CREATE TABLE dbo.payments (
  payment_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  order_id BIGINT NOT NULL,
  payable_amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(3) NOT NULL,
  payment_method NVARCHAR(10) NOT NULL,
  payment_provider NVARCHAR(50) NULL,
  transaction_id VARCHAR(100) NULL,
  payment_status NVARCHAR(12) NOT NULL,
  paid_at DATETIME NULL,
  refunded_at DATETIME NULL,
  CONSTRAINT CK_payments_method2 CHECK (payment_method IN (N'CASH', N'CARD', N'E_WALLET')),
  CONSTRAINT CK_payments_status2 CHECK (payment_status IN (N'PENDING','AUTHORIZED','PAID','FAILED','REFUNDED')),
  CONSTRAINT FK_payments_orders2 FOREIGN KEY (order_id) REFERENCES dbo.orders(order_id)
);
GO

CREATE UNIQUE NONCLUSTERED INDEX UX_payments_transaction2
  ON dbo.payments(transaction_id)
  WHERE transaction_id IS NOT NULL;
GO

CREATE TABLE dbo.order_status_history (
  history_id BIGINT IDENTITY(1,1) PRIMARY KEY,
  order_id BIGINT NOT NULL,
  status NVARCHAR(12) NOT NULL,
  changed_at DATETIME NOT NULL DEFAULT(GETDATE()),
  CONSTRAINT CK_osh_status2 CHECK (status IN (N'RECEIVED', N'PREPARING', N'READY', N'PICKED_UP', N'CANCELLED')),
  CONSTRAINT FK_osh_orders2 FOREIGN KEY (order_id) REFERENCES dbo.orders(order_id)
);
GO

/* Seed (part 2): 產生 20 筆訂單（每筆 1–5 品項） */
DECLARE @numOrders INT = 20;
DECLARE @numProducts INT = (SELECT COUNT(*) FROM dbo.products);
DECLARE @i INT = 1;

WHILE @i <= @numOrders
BEGIN
  DECLARE @storeId BIGINT = ((@i - 1) % 5) + 1;
  DECLARE @serviceType NVARCHAR(10) = CASE WHEN @i % 2 = 0 THEN N'DINE_IN' ELSE N'TAKEOUT' END;
  DECLARE @orderNumber VARCHAR(30) = CONCAT('ORD', FORMAT(GETDATE(), 'yyyyMMdd'), RIGHT('0000' + CAST(@i AS VARCHAR(4)), 4));

  INSERT INTO dbo.orders (
    order_number, store_id, service_type, table_number, pickup_number, pickup_at,
    tax_id, mobile_carrier, donation_code, packaging_option, packaging_fee,
    status, subtotal, discount_total, grand_total, created_at, updated_at
  ) VALUES (
    @orderNumber, @storeId, @serviceType, NULL, NULL, DATEADD(MINUTE, 30, GETDATE()),
    NULL, NULL, NULL, N'NONE', 0,
    N'RECEIVED', 0, 0, 0, GETDATE(), GETDATE()
  );

  DECLARE @orderId BIGINT = SCOPE_IDENTITY();
  UPDATE dbo.orders
    SET pickup_number = CONCAT('P', RIGHT('0000' + CAST(@orderId AS VARCHAR(4)), 4))
  WHERE order_id = @orderId;

  DECLARE @itemCount INT = (@i % 5) + 1;
  DECLARE @j INT = 1;

  WHILE @j <= @itemCount
  BEGIN
    DECLARE @productId BIGINT = ((@i + @j - 1) % @numProducts) + 1;
    DECLARE @productName NVARCHAR(100) = (SELECT product_name FROM dbo.products WHERE product_id = @productId);
    DECLARE @unitPrice DECIMAL(10,2) = (SELECT unit_price FROM dbo.products WHERE product_id = @productId);
    DECLARE @qty INT = ((@i + @j) % 3) + 1;
    DECLARE @lineTotal DECIMAL(10,2) = @unitPrice * @qty;

    INSERT INTO dbo.order_items (order_id, product_id, product_name, unit_price, quantity, spec_summary, line_total)
    VALUES (@orderId, @productId, @productName, @unitPrice, @qty, NULL, @lineTotal);

    SET @j = @j + 1;
  END

  DECLARE @subtotal DECIMAL(10,2) = (SELECT SUM(line_total) FROM dbo.order_items WHERE order_id = @orderId);
  UPDATE dbo.orders SET subtotal = @subtotal, discount_total = 0, grand_total = @subtotal WHERE order_id = @orderId;

  INSERT INTO dbo.payments (order_id, payable_amount, currency, payment_method, payment_provider, transaction_id, payment_status, paid_at)
  VALUES (
    @orderId, @subtotal, 'TWD', CASE WHEN @i % 2 = 0 THEN N'CARD' ELSE N'CASH' END,
    CASE WHEN @i % 2 = 0 THEN N'ECPay' ELSE NULL END,
    CONCAT('TXN', RIGHT('000000' + CAST(@orderId AS VARCHAR(6)), 6)), N'PAID', GETDATE()
  );

  INSERT INTO dbo.order_status_history(order_id, status, changed_at)
  VALUES (@orderId, N'RECEIVED', DATEADD(MINUTE, 0, GETDATE()));
  INSERT INTO dbo.order_status_history(order_id, status, changed_at)
  VALUES (@orderId, N'READY', DATEADD(MINUTE, 15, GETDATE()));
  INSERT INTO dbo.order_status_history(order_id, status, changed_at)
  VALUES (@orderId, N'PICKED_UP', DATEADD(MINUTE, 30, GETDATE()));

  SET @i = @i + 1;
END
GO