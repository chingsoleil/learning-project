-- ============================================================================
-- 心理測驗題庫系統 - 資料匯入腳本
-- ============================================================================
-- 說明: 使用臨時表匯入 CSV 資料，再寫入正式資料表
-- 注意：表名, 欄位大小寫, 在asp.net的處理
-- ============================================================================

USE PsychometricTestDB;

-- ============================================================================
-- 步驟 1: 建立 3 個臨時表
-- ============================================================================

DROP TABLE IF EXISTS temp_ipip_merged;
CREATE TABLE temp_ipip_merged (
    row_id INT AUTO_INCREMENT PRIMARY KEY,
    instrument VARCHAR(50) NOT NULL DEFAULT '',
    alpha DECIMAL(5,3) NULL,
    alpha2 DECIMAL(5,3) NULL,
    scoring_key TINYINT NOT NULL DEFAULT 1,
    text_en TEXT NULL,
    text_zh TEXT NULL,
    label VARCHAR(100) NOT NULL DEFAULT '',
    label_zh VARCHAR(100) NULL,
    IPIP_item_number VARCHAR(100) NULL,
    INDEX idx_instrument (instrument),
    INDEX idx_label (label)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS temp_instrument_translations;
CREATE TABLE temp_instrument_translations (
    row_id INT AUTO_INCREMENT PRIMARY KEY,
    instrument_en VARCHAR(100) NOT NULL,
    instrument_zh VARCHAR(100) NULL,
    description VARCHAR(500) NULL,
    INDEX idx_instrument_en (instrument_en)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS temp_label_translations;
CREATE TABLE temp_label_translations (
    row_id INT AUTO_INCREMENT PRIMARY KEY,
    label_en VARCHAR(100) NOT NULL,
    label_zh VARCHAR(100) NULL,
    description VARCHAR(500) NULL,
    INDEX idx_label_en (label_en)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 步驟 2: 手動匯入 3 個 CSV（使用 DBeaver Import Data）
-- ============================================================================
-- ⚠️ 執行完步驟1後，依序匯入以下 3 個 CSV：
-- 
-- 1. temp_ipip_merged ← IPIP_items-merged.csv（3805 筆）
--    右鍵表 → Import Data → 選擇檔案
--    欄位對應: instrument, alpha, alpha2, scoring_key, text_en, text_zh, label, label_zh, IPIP_item_number
--    空值處理: alpha, alpha2, text_en, text_zh, label_zh, IPIP_item_number 設為 NULL
-- 
-- 2. temp_instrument_translations ← instrument_translations_template.csv（36 筆）
--    右鍵表 → Import Data → 選擇檔案
--    欄位對應: instrument_en, instrument_zh, description
-- 
-- 3. temp_label_translations ← label_translations_template.csv（246 筆）
--    右鍵表 → Import Data → 選擇檔案
--    欄位對應: label_en, label_zh, description
-- 
-- 匯入設定: 欄位分隔符號=逗號, 文字限定符號=雙引號, 忽略第一行
-- 匯入完成後，繼續執行步驟 3
-- ============================================================================

-- ============================================================================
-- 步驟 3: 匯入 InstrumentCategory（量表分類）
-- ============================================================================

INSERT INTO InstrumentCategory (NameEn, NameZh, Code, Description, IsActive, CreatedAt)
SELECT 
    instrument AS NameEn,
    NameZh,
    instrument AS Code,
    Description,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM (
    SELECT DISTINCT 
        tm.instrument,
        -- 優先使用翻譯範本的中文，如果沒有則使用英文作為備用
        COALESCE(
            (SELECT NULLIF(TRIM(trans.instrument_zh), '') 
             FROM temp_instrument_translations trans 
             WHERE trans.instrument_en = tm.instrument 
             LIMIT 1),
            tm.instrument
        ) AS NameZh,
        (SELECT NULLIF(TRIM(trans.description), '') 
         FROM temp_instrument_translations trans 
         WHERE trans.instrument_en = tm.instrument 
         LIMIT 1) AS Description
    FROM temp_ipip_merged tm
    WHERE tm.instrument IS NOT NULL AND TRIM(tm.instrument) != ''
) AS distinct_instruments
ORDER BY instrument;

-- 驗證
SELECT * FROM InstrumentCategory;

-- ============================================================================
-- 步驟 4: 匯入 TraitCategory（特質面向分類）
-- ============================================================================

INSERT INTO TraitCategory (NameEn, NameZh, Code, Description, IsActive, CreatedAt)
SELECT 
    label AS NameEn,
    NameZh,
    label AS Code,
    Description,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM (
    SELECT DISTINCT 
        tm.label,
        -- 優先使用 CSV 中的 label_zh（取第一個非空值），其次使用翻譯範本，最後使用英文作為備用
        COALESCE(
            (SELECT NULLIF(TRIM(label_zh), '') 
             FROM temp_ipip_merged 
             WHERE label = tm.label AND label_zh IS NOT NULL AND TRIM(label_zh) != ''
             LIMIT 1),
            (SELECT NULLIF(TRIM(trans.label_zh), '') 
             FROM temp_label_translations trans 
             WHERE trans.label_en = tm.label 
             LIMIT 1),
            tm.label
        ) AS NameZh,
        (SELECT NULLIF(TRIM(trans.description), '') 
         FROM temp_label_translations trans 
         WHERE trans.label_en = tm.label 
         LIMIT 1) AS Description
    FROM temp_ipip_merged tm
    WHERE tm.label IS NOT NULL AND TRIM(tm.label) != ''
) AS distinct_labels
ORDER BY label;

-- 驗證
SELECT * FROM TraitCategory;


-- ============================================================================
-- 步驟 5: 匯入 QuestionBank（題庫主檔）
-- ============================================================================

INSERT INTO QuestionBank (
    InstrumentCategoryId,
    TraitCategoryId,
    TextEn,
    TextZh,
    Alpha,
    Alpha2,
    ScoringKey,
    IPIPItemNumber,
    IsActive,
    CreatedAt
)
SELECT 
    ic.Id AS InstrumentCategoryId,
    tc.Id AS TraitCategoryId,
    tm.text_en AS TextEn,
    tm.text_zh AS TextZh,
    -- Alpha 值已分離，直接使用
    tm.alpha AS Alpha,
    -- Alpha2 值已分離，直接使用
    tm.alpha2 AS Alpha2,
    tm.scoring_key AS ScoringKey,
    -- IPIPItemNumber：直接使用 CSV 的 IPIP_item_number，可為空
    NULLIF(TRIM(tm.IPIP_item_number), '') AS IPIPItemNumber,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM temp_ipip_merged tm
INNER JOIN InstrumentCategory ic ON tm.instrument = ic.NameEn
INNER JOIN TraitCategory tc ON tm.label = tc.NameEn
ORDER BY tm.row_id;

-- 驗證

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

--📌 顯示範例題目
SELECT 
    qb.Id,
    qb.IPIPItemNumber,
    ic.NameEn AS Instrument,
    tc.NameEn AS Trait,
    qb.TextEn,
    qb.TextZh,
    qb.Alpha,
    qb.Alpha2,
    qb.ScoringKey
FROM QuestionBank qb
INNER JOIN InstrumentCategory ic ON qb.InstrumentCategoryId = ic.Id
INNER JOIN TraitCategory tc ON qb.TraitCategoryId = tc.Id;

-- ============================================================================
-- 步驟 6: 資料完整性驗證
-- ============================================================================

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

-- 檢查 ScoringKey 值分布
SELECT 
    ScoringKey,
    COUNT(*) AS Count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM QuestionBank), 2) AS Percentage
FROM QuestionBank
GROUP BY ScoringKey
ORDER BY ScoringKey;

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
-- 步驟 7: 匯入總結報告
-- ============================================================================

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

DROP TABLE IF EXISTS temp_ipip_merged;
DROP TABLE IF EXISTS temp_instrument_translations;
DROP TABLE IF EXISTS temp_label_translations;

SELECT '臨時表已清理' AS Status;

-- ============================================================================
-- 步驟 9: 完成！
-- ============================================================================

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

