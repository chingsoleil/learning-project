-- ============================================================================
-- IPIP 題庫資料匯入腳本
-- ============================================================================
-- 資料庫: PsychometricTestDB
-- 資料來源: ex05/IPIP_items.csv (3,805 題)
-- 建立日期: 2024-12-07
-- ============================================================================

USE PsychometricTestDB;

-- ============================================================================
-- 步驟 1: 建立臨時匯入表（用於載入 CSV 資料）
-- ============================================================================

-- 英文題庫臨時表
DROP TABLE IF EXISTS temp_ipip_items_en;
CREATE TABLE temp_ipip_items_en (
    row_id INT AUTO_INCREMENT PRIMARY KEY,
    instrument VARCHAR(50),
    alpha DECIMAL(5,3),
    `key` TINYINT,
    text TEXT,
    label VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 中文題庫臨時表
DROP TABLE IF EXISTS temp_ipip_items_zh;
CREATE TABLE temp_ipip_items_zh (
    row_id INT AUTO_INCREMENT PRIMARY KEY,
    instrument VARCHAR(50),
    alpha DECIMAL(5,3),
    `key` TINYINT,
    text TEXT,
    label VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- 步驟 2: 載入 CSV 檔案到臨時表
-- ============================================================================
-- 注意：需要根據您的實際檔案路徑調整
-- 在 DBeaver 中可以使用 Import Data 功能

-- 方法 1：使用 LOAD DATA INFILE（需要 FILE 權限）
/*
LOAD DATA INFILE 'D:/github/learning-project/ex05/IPIP_items.csv'
INTO TABLE temp_ipip_items_en
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(instrument, alpha, `key`, text, label);

LOAD DATA INFILE 'D:/github/learning-project/ex05/IPIP_items-zh-tw.csv'
INTO TABLE temp_ipip_items_zh
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(instrument, alpha, `key`, text, label);
*/

-- 方法 2：使用 DBeaver 的 Import Data 功能（推薦）
-- 右鍵點擊表 → Import Data → 選擇 CSV 檔案

-- ============================================================================
-- 步驟 3: 資料驗證
-- ============================================================================

-- 檢查匯入的資料筆數
SELECT 'English CSV' AS source, COUNT(*) AS row_count FROM temp_ipip_items_en
UNION ALL
SELECT 'Chinese CSV' AS source, COUNT(*) AS row_count FROM temp_ipip_items_zh;

-- 檢查是否有缺失值
SELECT 
    'English CSV' AS source,
    SUM(CASE WHEN instrument IS NULL THEN 1 ELSE 0 END) AS null_instrument,
    SUM(CASE WHEN label IS NULL THEN 1 ELSE 0 END) AS null_label,
    SUM(CASE WHEN text IS NULL OR TRIM(text) = '' THEN 1 ELSE 0 END) AS null_text
FROM temp_ipip_items_en
UNION ALL
SELECT 
    'Chinese CSV' AS source,
    SUM(CASE WHEN instrument IS NULL THEN 1 ELSE 0 END) AS null_instrument,
    SUM(CASE WHEN label IS NULL THEN 1 ELSE 0 END) AS null_label,
    SUM(CASE WHEN text IS NULL OR TRIM(text) = '' THEN 1 ELSE 0 END) AS null_text
FROM temp_ipip_items_zh;

-- 統計各量表題數
SELECT instrument, COUNT(*) AS question_count
FROM temp_ipip_items_en
GROUP BY instrument
ORDER BY question_count DESC;

-- 統計各特質題數（前 20）
SELECT label, COUNT(*) AS question_count
FROM temp_ipip_items_en
GROUP BY label
ORDER BY question_count DESC
LIMIT 20;

-- 檢查重複題目
SELECT 
    COUNT(*) AS total_rows,
    COUNT(DISTINCT text) AS unique_questions,
    COUNT(*) - COUNT(DISTINCT text) AS duplicate_count
FROM temp_ipip_items_en;

-- ============================================================================
-- 步驟 4: 建立翻譯對照表（需要手動填寫）
-- ============================================================================

-- Instrument 翻譯對照表
DROP TABLE IF EXISTS temp_instrument_translations;
CREATE TABLE temp_instrument_translations (
    instrument_en VARCHAR(50) PRIMARY KEY,
    instrument_zh VARCHAR(100),
    description VARCHAR(500)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入翻譯資料（部分範例，需要完整補充）
INSERT INTO temp_instrument_translations (instrument_en, instrument_zh, description) VALUES
('16PF', '16種人格因子問卷', 'Cattell 16 Personality Factors'),
('NEO', 'NEO人格量表', 'NEO Personality Inventory'),
('VIA', 'VIA性格優勢量表', 'Values in Action Inventory of Strengths'),
('HEXACO_PI', 'HEXACO人格量表', 'HEXACO Personality Inventory'),
('AB5C', 'AB5C大五人格量表', 'AB5C Big Five Personality'),
('6FPQ', '六因子人格問卷', 'Six Factor Personality Questionnaire'),
('TCI', '氣質與性格量表', 'Temperament and Character Inventory'),
('CPI', '加州心理量表', 'California Psychological Inventory'),
('BFAS', '大五人格面向量表', 'Big Five Aspect Scale'),
('JPI', 'Jackson人格量表', 'Jackson Personality Inventory'),
('MPQ', '多維度人格問卷', 'Multidimensional Personality Questionnaire'),
('HPI', 'Hogan人格量表', 'Hogan Personality Inventory'),
('BIS_BAS', '行為抑制/激活系統量表', 'Behavioral Inhibition/Activation System'),
('BIDR', '社會期許量表', 'Balanced Inventory of Desirable Responding')
-- ... 其他 22 個需要補充
;

-- Label 翻譯對照表（範例）
DROP TABLE IF EXISTS temp_label_translations;
CREATE TABLE temp_label_translations (
    label_en VARCHAR(100) PRIMARY KEY,
    label_zh VARCHAR(100),
    description VARCHAR(500)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 插入常見特質翻譯（部分範例，需要完整補充 246 個）
INSERT INTO temp_label_translations (label_en, label_zh, description) VALUES
('Gregariousness', '合群性', '喜歡與他人互動和社交的傾向'),
('Anxiety', '焦慮', '容易擔心和感到緊張的傾向'),
('Emotionality', '情緒性', '情緒反應的強度和頻率'),
('Emotional Stability', '情緒穩定性', '保持情緒平穩的能力'),
('Orderliness', '條理性', '組織和整理的傾向'),
('Reserve', '保守性', '對自我揭露的謹慎程度'),
('Dominance', '支配性', '領導和掌控的傾向'),
('Assertiveness', '自信堅定', '表達自己意見的能力'),
('Complexity', '複雜性', '對複雜概念和理論的興趣'),
('Warmth', '熱情', '對他人友善和關懷的程度'),
('Friendliness', '友善', '容易與人建立關係的傾向'),
('Distrust', '不信任', '對他人動機的懷疑程度'),
('Dutifulness', '盡責性', '遵守規則和履行義務的傾向'),
('Intellect', '智力', '認知能力和學習興趣'),
('Sensitivity', '敏感性', '對美學和情感的敏銳度'),
('Introversion', '內向性', '偏好獨處和安靜環境的傾向'),
('Imagination', '想像力', '創造性思維和幻想的傾向'),
('Conscientiousness', '盡責性', '自律和目標導向的程度'),
('Agreeableness', '親和性', '合作和同情他人的傾向'),
('Neuroticism', '神經質', '情緒不穩定和負面情緒的傾向'),
('Extraversion', '外向性', '社交活躍和尋求刺激的傾向'),
('Openness', '開放性', '對新經驗和觀念的接受度')
-- ... 其他 224 個需要補充
;

-- ============================================================================
-- 步驟 5: 匯入 InstrumentCategory（量表分類主檔）
-- ============================================================================

INSERT INTO InstrumentCategory (NameEn, NameZh, Code, Description, IsActive, CreatedAt)
SELECT DISTINCT 
    en.instrument AS NameEn,
    COALESCE(tr.instrument_zh, en.instrument) AS NameZh,  -- 如果沒有翻譯，使用英文
    en.instrument AS Code,
    tr.description AS Description,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM temp_ipip_items_en en
LEFT JOIN temp_instrument_translations tr ON en.instrument = tr.instrument_en
ORDER BY en.instrument;

-- 驗證
SELECT * FROM InstrumentCategory ORDER BY Code;

-- ============================================================================
-- 步驟 6: 匯入 TraitCategory（特質面向分類主檔）
-- ============================================================================

INSERT INTO TraitCategory (NameEn, NameZh, Code, Description, IsActive, CreatedAt)
SELECT DISTINCT 
    en.label AS NameEn,
    COALESCE(tr.label_zh, en.label) AS NameZh,  -- 如果沒有翻譯，使用英文
    CONCAT('TRAIT_', LPAD((@row_num := @row_num + 1), 3, '0')) AS Code,
    tr.description AS Description,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM temp_ipip_items_en en
LEFT JOIN temp_label_translations tr ON en.label = tr.label_en
CROSS JOIN (SELECT @row_num := 0) AS init
ORDER BY en.label;

-- 驗證
SELECT COUNT(*) AS total_traits FROM TraitCategory;
SELECT * FROM TraitCategory ORDER BY NameEn LIMIT 20;

-- ============================================================================
-- 步驟 7: 匯入 QuestionBank（題庫主檔）
-- ============================================================================

-- 方案 A：保留重複題目（推薦）
-- 同一題目在不同量表/特質中視為不同的題目記錄

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
    CONCAT(
        en.instrument, '_',
        SUBSTRING(REPLACE(REPLACE(en.label, '/', '_'), ' ', '_'), 1, 10), '_',
        LPAD(en.row_id, 4, '0')
    ) AS QuestionCode,
    1 AS IsActive,
    NOW() AS CreatedAt
FROM temp_ipip_items_en en
INNER JOIN temp_ipip_items_zh zh ON en.row_id = zh.row_id
INNER JOIN InstrumentCategory ic ON en.instrument = ic.NameEn
INNER JOIN TraitCategory tc ON en.label = tc.NameEn
ORDER BY en.row_id;

-- 驗證
SELECT COUNT(*) AS total_questions FROM QuestionBank;

-- 檢查各量表的題數
SELECT 
    ic.NameZh AS 量表名稱,
    ic.Code AS 量表代碼,
    COUNT(*) AS 題數
FROM QuestionBank qb
INNER JOIN InstrumentCategory ic ON qb.InstrumentCategoryId = ic.Id
GROUP BY ic.Id, ic.NameZh, ic.Code
ORDER BY 題數 DESC;

-- 檢查各特質的題數（前 20）
SELECT 
    tc.NameZh AS 特質名稱,
    tc.Code AS 特質代碼,
    COUNT(*) AS 題數
FROM QuestionBank qb
INNER JOIN TraitCategory tc ON qb.TraitCategoryId = tc.Id
GROUP BY tc.Id, tc.NameZh, tc.Code
ORDER BY 題數 DESC
LIMIT 20;

-- 檢查中英文對應
SELECT 
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
-- 步驟 8: 資料完整性驗證
-- ============================================================================

-- 檢查外鍵關聯
SELECT 
    'QuestionBank → InstrumentCategory' AS relation,
    COUNT(*) AS invalid_count
FROM QuestionBank qb
LEFT JOIN InstrumentCategory ic ON qb.InstrumentCategoryId = ic.Id
WHERE ic.Id IS NULL

UNION ALL

SELECT 
    'QuestionBank → TraitCategory' AS relation,
    COUNT(*) AS invalid_count
FROM QuestionBank qb
LEFT JOIN TraitCategory tc ON qb.TraitCategoryId = tc.Id
WHERE tc.Id IS NULL;

-- 檢查必填欄位
SELECT 
    'InstrumentCategory' AS table_name,
    SUM(CASE WHEN NameEn IS NULL OR TRIM(NameEn) = '' THEN 1 ELSE 0 END) AS null_NameEn,
    SUM(CASE WHEN NameZh IS NULL OR TRIM(NameZh) = '' THEN 1 ELSE 0 END) AS null_NameZh
FROM InstrumentCategory

UNION ALL

SELECT 
    'TraitCategory' AS table_name,
    SUM(CASE WHEN NameEn IS NULL OR TRIM(NameEn) = '' THEN 1 ELSE 0 END) AS null_NameEn,
    SUM(CASE WHEN NameZh IS NULL OR TRIM(NameZh) = '' THEN 1 ELSE 0 END) AS null_NameZh
FROM TraitCategory

UNION ALL

SELECT 
    'QuestionBank' AS table_name,
    SUM(CASE WHEN TextEn IS NULL OR TRIM(TextEn) = '' THEN 1 ELSE 0 END) AS null_TextEn,
    SUM(CASE WHEN TextZh IS NULL OR TRIM(TextZh) = '' THEN 1 ELSE 0 END) AS null_TextZh
FROM QuestionBank;

-- 檢查 Key 值的分布
SELECT 
    `Key`,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM QuestionBank), 2) AS percentage
FROM QuestionBank
GROUP BY `Key`;

-- 檢查 Alpha 值的範圍
SELECT 
    MIN(Alpha) AS min_alpha,
    MAX(Alpha) AS max_alpha,
    AVG(Alpha) AS avg_alpha,
    COUNT(*) AS total_with_alpha
FROM QuestionBank
WHERE Alpha IS NOT NULL;

-- ============================================================================
-- 步驟 9: 清理臨時表
-- ============================================================================

-- 確認資料匯入成功後，可以刪除臨時表
-- DROP TABLE IF EXISTS temp_ipip_items_en;
-- DROP TABLE IF EXISTS temp_ipip_items_zh;
-- DROP TABLE IF EXISTS temp_instrument_translations;
-- DROP TABLE IF EXISTS temp_label_translations;

-- ============================================================================
-- 完成！
-- ============================================================================

SELECT 
    '資料匯入完成' AS status,
    (SELECT COUNT(*) FROM InstrumentCategory) AS instruments,
    (SELECT COUNT(*) FROM TraitCategory) AS traits,
    (SELECT COUNT(*) FROM QuestionBank) AS questions;

