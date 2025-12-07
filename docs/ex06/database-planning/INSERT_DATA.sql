-- ============================================================================
-- 心理測驗題庫系統 - 資料匯入腳本
-- ============================================================================
-- 資料庫名稱: PsychometricTestDB
-- 建立日期: 2024-12-07
-- ============================================================================
-- 說明:
-- 此腳本用於匯入 IPIP 題庫的三份 CSV 資料
-- 1. ex05/IPIP_items.csv (3,805 題 - 英文)
-- 2. ex05/IPIP_items-zh-tw.csv (3,805 題 - 中文)
-- 3. docs/ex03/IPIP3320.csv (3,320 題 - ItemNumber 參考)
-- ============================================================================

USE PsychometricTestDB;

-- ============================================================================
-- 步驟 1: 建立臨時匯入表
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 臨時表 1: 英文題庫
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS temp_ipip_items_en;
CREATE TABLE temp_ipip_items_en (
    row_id INT AUTO_INCREMENT PRIMARY KEY,
    instrument VARCHAR(50) NOT NULL,
    alpha DECIMAL(5,3) NULL,
    `key` TINYINT NOT NULL,
    text TEXT NOT NULL,
    label VARCHAR(100) NOT NULL,
    INDEX idx_text (text(100)),
    INDEX idx_instrument (instrument),
    INDEX idx_label (label)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='英文題庫臨時表';

-- ----------------------------------------------------------------------------
-- 臨時表 2: 中文題庫
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS temp_ipip_items_zh;
CREATE TABLE temp_ipip_items_zh (
    row_id INT AUTO_INCREMENT PRIMARY KEY,
    instrument VARCHAR(50) NOT NULL,
    alpha DECIMAL(5,3) NULL,
    `key` TINYINT NOT NULL,
    text TEXT NOT NULL,
    label VARCHAR(100) NOT NULL,
    INDEX idx_row_id (row_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='中文題庫臨時表';

-- ----------------------------------------------------------------------------
-- 臨時表 3: IPIP3320 ItemNumber 參考表
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS temp_ipip3320;
CREATE TABLE temp_ipip3320 (
    Survey TEXT NOT NULL,
    ItemNumber VARCHAR(50) NULL,
    INDEX idx_survey (Survey(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='IPIP3320 ItemNumber 參考表';

-- ============================================================================
-- 步驟 2: 載入 CSV 資料
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 方法 A: 使用 LOAD DATA INFILE（需要 FILE 權限）
-- ----------------------------------------------------------------------------
-- 注意: 請根據實際檔案路徑調整

/*
-- 載入英文題庫
LOAD DATA INFILE 'D:/github/learning-project/ex05/IPIP_items.csv'
INTO TABLE temp_ipip_items_en
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(instrument, alpha, `key`, text, label);

-- 載入中文題庫
LOAD DATA INFILE 'D:/github/learning-project/ex05/IPIP_items-zh-tw.csv'
INTO TABLE temp_ipip_items_zh
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(instrument, alpha, `key`, text, label);

-- 載入 IPIP3320 參考表
LOAD DATA INFILE 'D:/github/learning-project/docs/ex03/IPIP3320.csv'
INTO TABLE temp_ipip3320
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(Survey, ItemNumber);
*/

-- ----------------------------------------------------------------------------
-- 方法 B: 使用 DBeaver / MySQL Workbench 的 Import Data 功能（推薦）
-- ----------------------------------------------------------------------------
-- 步驟:
-- 1. 右鍵點擊表 temp_ipip_items_en → Import Data
-- 2. 選擇檔案: ex05/IPIP_items.csv
-- 3. 設定: 欄位分隔符號=逗號, 文字限定符號=雙引號, 忽略第一行
-- 4. 重複以上步驟匯入其他兩個表

-- 驗證資料載入
SELECT '=== 驗證臨時表資料 ===' AS Status;
SELECT 'temp_ipip_items_en' AS Table_Name, COUNT(*) AS Row_Count FROM temp_ipip_items_en
UNION ALL
SELECT 'temp_ipip_items_zh' AS Table_Name, COUNT(*) AS Row_Count FROM temp_ipip_items_zh
UNION ALL
SELECT 'temp_ipip3320' AS Table_Name, COUNT(*) AS Row_Count FROM temp_ipip3320;

-- 檢查範例資料
SELECT '=== temp_ipip_items_en 範例 ===' AS Info;
SELECT * FROM temp_ipip_items_en LIMIT 5;

SELECT '=== temp_ipip_items_zh 範例 ===' AS Info;
SELECT * FROM temp_ipip_items_zh LIMIT 5;

SELECT '=== temp_ipip3320 範例 ===' AS Info;
SELECT * FROM temp_ipip3320 LIMIT 5;

-- ============================================================================
-- 步驟 3: 匯入 InstrumentCategory（量表分類）
-- ============================================================================

SELECT '=== 開始匯入 InstrumentCategory ===' AS Status;

INSERT INTO InstrumentCategory (NameEn, NameZh, Code, IsActive, CreatedAt)
SELECT DISTINCT 
    en.instrument AS NameEn,
    en.instrument AS NameZh,  -- 暫時使用英文，後續補充中文
    en.instrument AS Code,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM temp_ipip_items_en en
ORDER BY en.instrument;

-- 驗證
SELECT '=== InstrumentCategory 匯入完成 ===' AS Status;
SELECT COUNT(*) AS Total, 
       SUM(CASE WHEN NameZh != NameEn THEN 1 ELSE 0 END) AS Has_Chinese_Translation
FROM InstrumentCategory;

-- 顯示前 10 筆
SELECT * FROM InstrumentCategory LIMIT 10;

-- ============================================================================
-- 步驟 4: 匯入 TraitCategory（特質面向分類）
-- ============================================================================

SELECT '=== 開始匯入 TraitCategory ===' AS Status;

INSERT INTO TraitCategory (NameEn, NameZh, Code, IsActive, CreatedAt)
SELECT DISTINCT 
    en.label AS NameEn,
    en.label AS NameZh,  -- 暫時使用英文，後續補充中文
    CONCAT('TRAIT_', LPAD((@row_num := @row_num + 1), 3, '0')) AS Code,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM temp_ipip_items_en en
CROSS JOIN (SELECT @row_num := 0) AS init
ORDER BY en.label;

-- 驗證
SELECT '=== TraitCategory 匯入完成 ===' AS Status;
SELECT COUNT(*) AS Total,
       SUM(CASE WHEN NameZh != NameEn THEN 1 ELSE 0 END) AS Has_Chinese_Translation
FROM TraitCategory;

-- 顯示前 10 筆
SELECT * FROM TraitCategory ORDER BY Code LIMIT 10;

-- ============================================================================
-- 步驟 5: 匯入 QuestionBank（題庫主檔）
-- ============================================================================

SELECT '=== 開始匯入 QuestionBank ===' AS Status;

-- 建立臨時變數
SET @row_counter = 0;

-- 匯入題目
INSERT INTO QuestionBank (
    InstrumentCategoryId,
    TraitCategoryId,
    TextEn,
    TextZh,
    Alpha,
    `Key`,
    QuestionCode,
    IsActive,
    CreatedAt
)
SELECT 
    ic.Id AS InstrumentCategoryId,
    tc.Id AS TraitCategoryId,
    en.text AS TextEn,
    zh.text AS TextZh,
    en.alpha AS Alpha,
    en.`key` AS `Key`,
    -- QuestionCode 生成邏輯：優先使用 ItemNumber，處理逗號分隔，無則自動生成
    COALESCE(
        NULLIF(TRIM(SUBSTRING_INDEX(ipip.ItemNumber, ',', 1)), ''),  -- 取第一個 ItemNumber
        CONCAT(en.instrument, '_', LPAD(en.row_id, 4, '0'))  -- 自動生成
    ) AS QuestionCode,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM temp_ipip_items_en en
INNER JOIN temp_ipip_items_zh zh ON en.row_id = zh.row_id
INNER JOIN InstrumentCategory ic ON en.instrument = ic.NameEn
INNER JOIN TraitCategory tc ON en.label = tc.NameEn
LEFT JOIN temp_ipip3320 ipip ON en.text = ipip.Survey
ORDER BY en.row_id;

-- 驗證
SELECT '=== QuestionBank 匯入完成 ===' AS Status;

-- 總題數
SELECT COUNT(*) AS Total_Questions FROM QuestionBank;

-- 統計使用 ItemNumber 的題數
SELECT 
    'With Original ItemNumber' AS Type,
    COUNT(*) AS Count
FROM QuestionBank
WHERE QuestionCode REGEXP '^[A-Z][0-9]+'
UNION ALL
SELECT 
    'Auto Generated Code' AS Type,
    COUNT(*) AS Count
FROM QuestionBank
WHERE QuestionCode LIKE '%_%';

-- 按量表統計題數
SELECT 
    ic.NameEn AS Instrument,
    ic.Code,
    COUNT(qb.Id) AS Question_Count
FROM InstrumentCategory ic
LEFT JOIN QuestionBank qb ON ic.Id = qb.InstrumentCategoryId
GROUP BY ic.Id, ic.NameEn, ic.Code
ORDER BY Question_Count DESC;

-- 按特質統計題數（前 20）
SELECT 
    tc.NameEn AS Trait,
    tc.Code,
    COUNT(qb.Id) AS Question_Count
FROM TraitCategory tc
LEFT JOIN QuestionBank qb ON tc.Id = qb.TraitCategoryId
GROUP BY tc.Id, tc.NameEn, tc.Code
ORDER BY Question_Count DESC
LIMIT 20;

-- 顯示範例題目
SELECT 
    qb.Id,
    qb.QuestionCode,
    ic.NameEn AS Instrument,
    tc.NameEn AS Trait,
    qb.TextEn,
    qb.TextZh,
    qb.Alpha,
    qb.`Key`
FROM QuestionBank qb
INNER JOIN InstrumentCategory ic ON qb.InstrumentCategoryId = ic.Id
INNER JOIN TraitCategory tc ON qb.TraitCategoryId = tc.Id
LIMIT 10;

-- ============================================================================
-- 步驟 6: 資料完整性驗證
-- ============================================================================

SELECT '=== 資料完整性驗證 ===' AS Status;

-- 檢查外鍵完整性
SELECT 
    '檢查 QuestionBank 外鍵' AS Check_Name,
    COUNT(*) AS Invalid_Count
FROM QuestionBank qb
LEFT JOIN InstrumentCategory ic ON qb.InstrumentCategoryId = ic.Id
WHERE ic.Id IS NULL
UNION ALL
SELECT 
    '檢查 QuestionBank 特質外鍵' AS Check_Name,
    COUNT(*) AS Invalid_Count
FROM QuestionBank qb
LEFT JOIN TraitCategory tc ON qb.TraitCategoryId = tc.Id
WHERE tc.Id IS NULL;

-- 檢查必填欄位
SELECT 
    '檢查 InstrumentCategory 必填欄位' AS Check_Name,
    SUM(CASE WHEN NameEn IS NULL OR TRIM(NameEn) = '' THEN 1 ELSE 0 END) AS Null_NameEn
FROM InstrumentCategory
UNION ALL
SELECT 
    '檢查 TraitCategory 必填欄位' AS Check_Name,
    SUM(CASE WHEN NameEn IS NULL OR TRIM(NameEn) = '' THEN 1 ELSE 0 END) AS Null_NameEn
FROM TraitCategory
UNION ALL
SELECT 
    '檢查 QuestionBank 必填欄位' AS Check_Name,
    SUM(CASE WHEN TextEn IS NULL OR TRIM(TextEn) = '' THEN 1 ELSE 0 END) AS Null_TextEn
FROM QuestionBank;

-- 檢查 Key 值分布
SELECT 
    `Key`,
    COUNT(*) AS Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM QuestionBank), 2) AS Percentage
FROM QuestionBank
GROUP BY `Key`
ORDER BY `Key`;

-- 檢查 Alpha 值範圍
SELECT 
    MIN(Alpha) AS Min_Alpha,
    MAX(Alpha) AS Max_Alpha,
    AVG(Alpha) AS Avg_Alpha,
    COUNT(*) AS Total_With_Alpha,
    SUM(CASE WHEN Alpha IS NULL THEN 1 ELSE 0 END) AS Null_Alpha
FROM QuestionBank;

-- 檢查 QuestionCode 唯一性
SELECT 
    '檢查 QuestionCode 重複' AS Check_Name,
    COUNT(*) - COUNT(DISTINCT QuestionCode) AS Duplicate_Count
FROM QuestionBank;

-- 列出重複的 QuestionCode（如果有）
SELECT QuestionCode, COUNT(*) AS Count
FROM QuestionBank
WHERE QuestionCode IS NOT NULL
GROUP BY QuestionCode
HAVING COUNT(*) > 1;

-- ============================================================================
-- 步驟 7: 匯入總結報告
-- ============================================================================

SELECT '=== 匯入總結報告 ===' AS Title;

SELECT 
    'InstrumentCategory' AS Table_Name,
    COUNT(*) AS Row_Count,
    '量表分類' AS Description
FROM InstrumentCategory
UNION ALL
SELECT 
    'TraitCategory' AS Table_Name,
    COUNT(*) AS Row_Count,
    '特質面向' AS Description
FROM TraitCategory
UNION ALL
SELECT 
    'QuestionBank' AS Table_Name,
    COUNT(*) AS Row_Count,
    '題庫' AS Description
FROM QuestionBank;

-- 顯示資料庫大小
SELECT 
    TABLE_NAME,
    TABLE_ROWS,
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) AS 'Size_MB'
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'PsychometricTestDB'
AND TABLE_NAME IN ('InstrumentCategory', 'TraitCategory', 'QuestionBank')
ORDER BY TABLE_ROWS DESC;

-- ============================================================================
-- 步驟 8: 清理臨時表（可選）
-- ============================================================================

-- 匯入成功後，可以刪除臨時表以節省空間
-- 警告：刪除前請確認資料已正確匯入！

/*
DROP TABLE IF EXISTS temp_ipip_items_en;
DROP TABLE IF EXISTS temp_ipip_items_zh;
DROP TABLE IF EXISTS temp_ipip3320;

SELECT '臨時表已清理' AS Status;
*/

-- ============================================================================
-- 完成！
-- ============================================================================

SELECT '=== 資料匯入完成 ===' AS Status;
SELECT 'IPIP 題庫已成功匯入到 PsychometricTestDB' AS Message;
SELECT '下一步: 補充 InstrumentCategory 和 TraitCategory 的中文翻譯' AS Next_Step;

