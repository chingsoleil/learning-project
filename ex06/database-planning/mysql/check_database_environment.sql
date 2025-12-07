-- ============================================================================
-- 資料庫環境與大小寫一致性檢查腳本
-- ============================================================================
-- 用途：檢查 MySQL 環境設定和大小寫一致性
-- 執行：在建立資料庫前後都可以執行
-- 注意：已優化為單一結果集，避免產生多個分頁
-- ============================================================================

-- ============================================================================
-- 1. 環境設定檢查（合併為單一結果集）
-- ============================================================================

SELECT 
    '環境設定檢查' AS Category,
    'MySQL 大小寫設定' AS Check_Item,
    @@lower_case_table_names AS Value,
    CASE 
        WHEN @@lower_case_table_names = 0 
        THEN '✅ 大小寫敏感（Linux 預設）- 表名會保持 PascalCase'
        WHEN @@lower_case_table_names = 1 
        THEN '⚠️ 表名轉為小寫（Windows 預設）- 表名會變成小寫，欄位名保持 PascalCase'
        ELSE '混合模式'
    END AS Description
UNION ALL
SELECT 
    '環境設定檢查',
    'secure_file_priv',
    NULL,
    COALESCE(@@secure_file_priv, 'NULL') AS Description
UNION ALL
SELECT 
    '環境設定檢查',
    'FILE 權限',
    NULL,
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM information_schema.USER_PRIVILEGES 
            WHERE GRANTEE LIKE CONCAT('%', CURRENT_USER(), '%')
            AND (PRIVILEGE_TYPE = 'FILE' OR PRIVILEGE_TYPE = 'ALL PRIVILEGES')
        ) THEN '✅ 有 FILE 權限（可使用 LOAD DATA INFILE）'
        ELSE '❌ 無 FILE 權限（需使用 DBeaver Import Data）'
    END AS Description
UNION ALL
SELECT 
    '環境設定檢查',
    'MySQL 版本',
    NULL,
    VERSION() AS Description;

-- ============================================================================
-- 2. 資料庫檢查（如果已建立）
-- ============================================================================

SELECT 
    '資料庫檢查' AS Category,
    '資料庫名稱' AS Check_Item,
    NULL AS Value,
    SCHEMA_NAME AS Description
FROM information_schema.SCHEMATA 
WHERE SCHEMA_NAME LIKE '%psychometric%'
UNION ALL
SELECT 
    '資料庫檢查',
    '表名列表',
    NULL,
    TABLE_NAME AS Description
FROM information_schema.TABLES
WHERE TABLE_SCHEMA LIKE '%psychometric%'
ORDER BY Category, Check_Item, Description;

-- ============================================================================
-- 3. 欄位名檢查（如果已建立）- QuestionBank 表
-- ============================================================================

SELECT 
    '欄位名檢查' AS Category,
    'QuestionBank 欄位' AS Check_Item,
    NULL AS Value,
    COLUMN_NAME AS Description
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA LIKE '%psychometric%'
  AND TABLE_NAME LIKE '%questionbank%'
ORDER BY ORDINAL_POSITION
LIMIT 10;

-- ============================================================================
-- 4. 檢查總結
-- ============================================================================

SELECT 
    '檢查總結' AS Category,
    '環境狀態' AS Check_Item,
    @@lower_case_table_names AS Value,
    CASE 
        WHEN @@lower_case_table_names = 0 
        THEN '✅ 大小寫敏感：表名和欄位名都會保持 PascalCase'
        WHEN @@lower_case_table_names = 1 
        THEN '✅ 表名轉為小寫，欄位名保持 PascalCase（Windows 預設，可接受）'
        ELSE '❓ 未知設定'
    END AS Description
UNION ALL
SELECT 
    '檢查總結',
    '說明',
    NULL,
    CASE 
        WHEN @@lower_case_table_names = 1 
        THEN '✅ 欄位名保持 PascalCase，與 EF Core 相容。表名可在 EF Core 中使用 [Table] 指定'
        ELSE '✅ 當前設定已完全支援 PascalCase'
    END AS Description;
