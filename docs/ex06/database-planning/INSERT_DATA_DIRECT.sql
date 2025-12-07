-- ============================================================================
-- 心理測驗題庫系統 - 資料匯入腳本
-- ============================================================================
-- 資料庫名稱: PsychometricTestDB
-- 建立日期: 2024-12-07
-- ============================================================================
-- 說明:
-- 此腳本適用於「手工合併後的單一 CSV 檔案」
-- 使用一個臨時表（temp_ipip_merged），簡化匯入流程
-- ============================================================================

USE PsychometricTestDB;

-- ============================================================================
-- 步驟 1: 建立單一匯入表（用於載入合併後的 CSV）
-- ============================================================================

DROP TABLE IF EXISTS temp_ipip_merged;
CREATE TABLE temp_ipip_merged (
    row_id INT AUTO_INCREMENT PRIMARY KEY,
    instrument VARCHAR(50) NOT NULL,
    alpha DECIMAL(5,3) NULL,
    `key` TINYINT NOT NULL,
    text_en TEXT NOT NULL COMMENT '英文題目',
    text_zh TEXT NOT NULL COMMENT '中文題目',
    label VARCHAR(100) NOT NULL,
    IPIP_item_number VARCHAR(50) NULL COMMENT 'IPIP item number（可選，可為空）',
    INDEX idx_instrument (instrument),
    INDEX idx_label (label),
    INDEX idx_text_en (text_en(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='合併後的題庫匯入表（臨時）';

-- ============================================================================
-- 步驟 2: 載入合併後的 CSV 檔案
-- ============================================================================
-- 方法 A: 使用 LOAD DATA INFILE（需要 FILE 權限）
-- 注意: 請根據實際檔案路徑調整

/*
LOAD DATA INFILE 'D:/github/learning-project/ex06/IPIP_items-merged.csv'
INTO TABLE temp_ipip_merged
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(instrument, alpha, `key`, text_en, text_zh, label, IPIP_item_number);
*/

-- 方法 B: 使用 DBeaver / MySQL Workbench 的 Import Data 功能（推薦）
-- 步驟:
-- 1. 右鍵點擊表 temp_ipip_merged → Import Data
-- 2. 選擇檔案: ex06/IPIP_items-merged.csv
-- 3. 設定: 欄位分隔符號=逗號, 文字限定符號=雙引號, 忽略第一行
-- 4. 對應欄位: instrument, alpha, key, text_en, text_zh, label, IPIP_item_number

-- 驗證資料載入
SELECT '=== 驗證合併表資料 ===' AS Status;
SELECT COUNT(*) AS Total_Rows FROM temp_ipip_merged;

-- 檢查範例資料
SELECT '=== temp_ipip_merged 範例 ===' AS Info;
SELECT * FROM temp_ipip_merged LIMIT 5;

-- ============================================================================
-- 步驟 3: 載入翻譯範本（可選，如果已準備好中文翻譯）
-- ============================================================================

-- 建立翻譯範本臨時表（如果已準備好翻譯 CSV）
DROP TABLE IF EXISTS temp_instrument_translations;
CREATE TABLE temp_instrument_translations (
    instrument_en VARCHAR(100) NOT NULL,
    instrument_zh VARCHAR(100) NULL,
    description VARCHAR(500) NULL,
    PRIMARY KEY (instrument_en)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='量表翻譯範本臨時表';

DROP TABLE IF EXISTS temp_label_translations;
CREATE TABLE temp_label_translations (
    label_en VARCHAR(100) NOT NULL,
    label_zh VARCHAR(100) NULL,
    description VARCHAR(500) NULL,
    PRIMARY KEY (label_en)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='特質翻譯範本臨時表';

-- 使用 DBeaver Import Data 匯入翻譯範本（如果已準備好）：
-- 1. 右鍵 temp_instrument_translations → Import Data
--    → 選擇檔案: ex06/instrument_translations_template.csv
--    → 對應欄位: instrument_en, instrument_zh, description
-- 2. 右鍵 temp_label_translations → Import Data
--    → 選擇檔案: ex06/label_translations_template.csv
--    → 對應欄位: label_en, label_zh, description

-- 如果未準備翻譯範本，可以跳過上述步驟，SQL 會自動使用英文作為備用

-- ============================================================================
-- 步驟 4: 匯入 InstrumentCategory（量表分類）
-- ============================================================================

SELECT '=== 開始匯入 InstrumentCategory ===' AS Status;

INSERT INTO InstrumentCategory (NameEn, NameZh, Code, Description, IsActive, CreatedAt)
SELECT DISTINCT 
    tm.instrument AS NameEn,
    -- 優先使用翻譯範本的中文，如果沒有則使用英文作為備用
    COALESCE(
        NULLIF(TRIM(trans.instrument_zh), ''),
        tm.instrument
    ) AS NameZh,
    tm.instrument AS Code,
    NULLIF(TRIM(trans.description), '') AS Description,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM temp_ipip_merged tm
LEFT JOIN temp_instrument_translations trans ON tm.instrument = trans.instrument_en
ORDER BY tm.instrument;

-- 驗證
SELECT '=== InstrumentCategory 匯入完成 ===' AS Status;
SELECT COUNT(*) AS Total FROM InstrumentCategory;
SELECT * FROM InstrumentCategory LIMIT 10;

-- ============================================================================
-- 步驟 5: 匯入 TraitCategory（特質面向分類）
-- ============================================================================

SELECT '=== 開始匯入 TraitCategory ===' AS Status;

INSERT INTO TraitCategory (NameEn, NameZh, Code, Description, IsActive, CreatedAt)
SELECT 
    NameEn,
    NameZh,
    CONCAT('TRAIT_', LPAD(row_num, 3, '0')) AS Code,
    Description,
    IsActive,
    CreatedAt
FROM (
    SELECT DISTINCT 
        tm.label AS NameEn,
        -- 優先使用翻譯範本的中文，如果沒有則使用英文作為備用
        COALESCE(
            NULLIF(TRIM(trans.label_zh), ''),
            tm.label
        ) AS NameZh,
        NULLIF(TRIM(trans.description), '') AS Description,
        1 AS IsActive,
        NOW() AS CreatedAt,
        ROW_NUMBER() OVER (ORDER BY tm.label) AS row_num
    FROM temp_ipip_merged tm
    LEFT JOIN temp_label_translations trans ON tm.label = trans.label_en
) AS distinct_traits;

-- 驗證
SELECT '=== TraitCategory 匯入完成 ===' AS Status;
SELECT COUNT(*) AS Total FROM TraitCategory;
SELECT * FROM TraitCategory ORDER BY Code LIMIT 10;

-- ============================================================================
-- 步驟 6: 匯入 QuestionBank（題庫主檔）
-- ============================================================================

SELECT '=== 開始匯入 QuestionBank ===' AS Status;

INSERT INTO QuestionBank (
    InstrumentCategoryId,
    TraitCategoryId,
    TextEn,
    TextZh,
    Alpha,
    `Key`,
    IPIPItemNumber,
    IsActive,
    CreatedAt
)
SELECT 
    ic.Id AS InstrumentCategoryId,
    tc.Id AS TraitCategoryId,
    tm.text_en AS TextEn,
    tm.text_zh AS TextZh,
    tm.alpha AS Alpha,
    tm.`key` AS `Key`,
    -- IPIPItemNumber：直接使用 CSV 的 IPIP_item_number，可為空
    NULLIF(TRIM(tm.IPIP_item_number), '') AS IPIPItemNumber,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM temp_ipip_merged tm
INNER JOIN InstrumentCategory ic ON tm.instrument = ic.NameEn
INNER JOIN TraitCategory tc ON tm.label = tc.NameEn
ORDER BY tm.row_id;

-- 驗證
SELECT '=== QuestionBank 匯入完成 ===' AS Status;

-- 總題數
SELECT COUNT(*) AS Total_Questions FROM QuestionBank;

-- 統計使用 IPIP item number 的題數
SELECT 
    'With IPIP Item Number' AS Type,
    COUNT(*) AS Count
FROM QuestionBank
WHERE IPIPItemNumber IS NOT NULL AND IPIPItemNumber != ''
UNION ALL
SELECT 
    'Without IPIP Item Number' AS Type,
    COUNT(*) AS Count
FROM QuestionBank
WHERE IPIPItemNumber IS NULL OR IPIPItemNumber = '';

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
    qb.IPIPItemNumber,
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
-- 步驟 7: 資料完整性驗證
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
    SUM(CASE WHEN NameEn IS NULL OR TRIM(NameEn) = '' THEN 1 ELSE 0 END) AS null_NameEn
FROM InstrumentCategory
UNION ALL
SELECT 
    '檢查 TraitCategory 必填欄位' AS Check_Name,
    SUM(CASE WHEN NameEn IS NULL OR TRIM(NameEn) = '' THEN 1 ELSE 0 END) AS null_NameEn
FROM TraitCategory
UNION ALL
SELECT 
    '檢查 QuestionBank 必填欄位' AS Check_Name,
    SUM(CASE WHEN TextEn IS NULL OR TRIM(TextEn) = '' THEN 1 ELSE 0 END) AS null_TextEn
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

-- 統計 IPIPItemNumber 分布（參考用，允許重複）
SELECT 
    'IPIP Item Number 統計' AS Check_Name,
    COUNT(*) AS Total_Questions,
    COUNT(IPIPItemNumber) AS Has_IPIPItemNumber,
    COUNT(*) - COUNT(IPIPItemNumber) AS Null_IPIPItemNumber,
    COUNT(DISTINCT IPIPItemNumber) AS Unique_IPIPItemNumbers
FROM QuestionBank;

-- 列出重複的 IPIPItemNumber（參考用，允許重複）
SELECT 
    '重複的 IPIP Item Number（參考用）' AS Info,
    IPIPItemNumber, 
    COUNT(*) AS Count
FROM QuestionBank
WHERE IPIPItemNumber IS NOT NULL
GROUP BY IPIPItemNumber
HAVING COUNT(*) > 1
ORDER BY Count DESC
LIMIT 10;

-- ============================================================================
-- 步驟 8: 匯入總結報告
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
-- 步驟 9: 清理臨時表（可選）
-- ============================================================================

-- 匯入成功後，可以刪除臨時表以節省空間
-- 警告：刪除前請確認資料已正確匯入！

/*
DROP TABLE IF EXISTS temp_ipip_merged;
DROP TABLE IF EXISTS temp_instrument_translations;
DROP TABLE IF EXISTS temp_label_translations;

SELECT '臨時表已清理' AS Status;
*/

-- ============================================================================
-- 完成！
-- ============================================================================

SELECT '=== 資料匯入完成 ===' AS Status;
SELECT 'IPIP 題庫已成功匯入到 PsychometricTestDB' AS Message;

-- 檢查中文翻譯狀態
SELECT 
    'InstrumentCategory 翻譯狀態' AS Check_Name,
    COUNT(*) AS Total,
    SUM(CASE WHEN NameZh != NameEn AND NameZh IS NOT NULL THEN 1 ELSE 0 END) AS Has_Chinese_Translation,
    SUM(CASE WHEN NameZh = NameEn OR NameZh IS NULL THEN 1 ELSE 0 END) AS Need_Translation
FROM InstrumentCategory
UNION ALL
SELECT 
    'TraitCategory 翻譯狀態' AS Check_Name,
    COUNT(*) AS Total,
    SUM(CASE WHEN NameZh != NameEn AND NameZh IS NOT NULL THEN 1 ELSE 0 END) AS Has_Chinese_Translation,
    SUM(CASE WHEN NameZh = NameEn OR NameZh IS NULL THEN 1 ELSE 0 END) AS Need_Translation
FROM TraitCategory;

-- 如果還有未翻譯的項目，可以使用翻譯範本 CSV 後續補充

