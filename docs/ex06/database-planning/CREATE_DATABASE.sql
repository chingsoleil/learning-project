-- ============================================================================
-- 心理測驗題庫系統 - 資料庫建立腳本
-- ============================================================================
-- 資料庫名稱: PsychometricTestDB
-- 資料庫引擎: MySQL 8.0+ / MariaDB 10.5+
-- 字元集: utf8mb4
-- 排序規則: utf8mb4_unicode_ci
-- 建立日期: 2024-12-07
-- ============================================================================
-- 說明:
-- 此腳本用於建立心理測驗題庫系統的完整資料庫結構
-- 包含 7 個主要資料表及所有索引和外鍵約束
-- ============================================================================

-- ============================================================================
-- 步驟 1: 建立資料庫
-- ============================================================================

-- 刪除既有資料庫（警告：將刪除所有資料）
-- DROP DATABASE IF EXISTS PsychometricTestDB;

-- 建立新資料庫
CREATE DATABASE IF NOT EXISTS PsychometricTestDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- 使用資料庫
USE PsychometricTestDB;

-- ============================================================================
-- 步驟 2: 建立資料表
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 表 1: InstrumentCategory（量表分類主檔）
-- ----------------------------------------------------------------------------
-- 說明: 心理測量工具的分類（如：16PF、NEO、MBTI 等）
-- 預估筆數: 36
-- ----------------------------------------------------------------------------

DROP TABLE IF EXISTS InstrumentCategory;

CREATE TABLE InstrumentCategory (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    NameEn VARCHAR(100) NOT NULL COMMENT '量表名稱（英文）',
    NameZh VARCHAR(100) NULL COMMENT '量表名稱（中文）',
    Code VARCHAR(20) NULL COMMENT '量表代碼',
    Description VARCHAR(500) NULL COMMENT '量表描述',
    IsActive BOOLEAN NOT NULL DEFAULT 1 COMMENT '是否啟用',
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    UpdatedAt DATETIME NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
    
    UNIQUE KEY uk_code (Code),
    INDEX idx_name_en (NameEn),
    INDEX idx_active (IsActive)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='量表分類主檔';

-- ----------------------------------------------------------------------------
-- 表 2: TraitCategory（特質面向分類主檔）
-- ----------------------------------------------------------------------------
-- 說明: 人格特質面向的分類（如：Openness、Conscientiousness 等）
-- 預估筆數: 246
-- ----------------------------------------------------------------------------

DROP TABLE IF EXISTS TraitCategory;

CREATE TABLE TraitCategory (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    NameEn VARCHAR(100) NOT NULL COMMENT '特質名稱（英文）',
    NameZh VARCHAR(100) NULL COMMENT '特質名稱（中文）',
    Code VARCHAR(20) NULL COMMENT '特質代碼',
    Description VARCHAR(500) NULL COMMENT '特質描述',
    IsActive BOOLEAN NOT NULL DEFAULT 1 COMMENT '是否啟用',
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    UpdatedAt DATETIME NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
    
    UNIQUE KEY uk_code (Code),
    INDEX idx_name_en (NameEn),
    INDEX idx_active (IsActive)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='特質面向分類主檔';

-- ----------------------------------------------------------------------------
-- 表 3: QuestionBank（題庫主檔）
-- ----------------------------------------------------------------------------
-- 說明: 所有測驗題目的主要資料庫
-- 預估筆數: 3,805
-- ----------------------------------------------------------------------------

DROP TABLE IF EXISTS QuestionBank;

CREATE TABLE QuestionBank (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    InstrumentCategoryId INT NOT NULL COMMENT '量表分類ID',
    TraitCategoryId INT NOT NULL COMMENT '特質面向ID',
    TextEn TEXT NOT NULL COMMENT '題目文字（英文）',
    TextZh TEXT NOT NULL COMMENT '題目文字（中文）',
    Alpha DECIMAL(5,3) NULL COMMENT '信度係數（0.000-1.000）',
    `Key` TINYINT NOT NULL DEFAULT 1 COMMENT '計分方向：1=正向, -1=反向',
    QuestionCode VARCHAR(50) NULL COMMENT '題目編碼',
    IsActive BOOLEAN NOT NULL DEFAULT 1 COMMENT '是否啟用',
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    UpdatedAt DATETIME NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
    
    UNIQUE KEY uk_question_code (QuestionCode),
    INDEX idx_instrument (InstrumentCategoryId),
    INDEX idx_trait (TraitCategoryId),
    INDEX idx_active (IsActive),
    INDEX idx_key (`Key`),
    
    CONSTRAINT FK_QuestionBank_InstrumentCategory 
        FOREIGN KEY (InstrumentCategoryId) 
        REFERENCES InstrumentCategory(Id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE,
    CONSTRAINT FK_QuestionBank_TraitCategory 
        FOREIGN KEY (TraitCategoryId) 
        REFERENCES TraitCategory(Id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='題庫主檔';

-- ----------------------------------------------------------------------------
-- 表 4: TestPaper（測卷主檔）
-- ----------------------------------------------------------------------------
-- 說明: 定義不同的心理測驗卷
-- 預估筆數: 10-50
-- ----------------------------------------------------------------------------

DROP TABLE IF EXISTS TestPaper;

CREATE TABLE TestPaper (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    Name VARCHAR(100) NOT NULL COMMENT '測卷名稱',
    Code VARCHAR(20) NULL COMMENT '測卷代碼',
    Description VARCHAR(1000) NULL COMMENT '測卷說明',
    ResponseType VARCHAR(50) NOT NULL COMMENT '作答方式：Likert5, Likert7, YesNo, MultipleChoice',
    TimeLimit INT NULL COMMENT '作答時間限制（分鐘）',
    TotalQuestions INT NOT NULL DEFAULT 0 COMMENT '總題數',
    IsActive BOOLEAN NOT NULL DEFAULT 1 COMMENT '是否啟用',
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    UpdatedAt DATETIME NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
    
    UNIQUE KEY uk_code (Code),
    INDEX idx_active (IsActive),
    INDEX idx_response_type (ResponseType)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='測卷主檔';

-- ----------------------------------------------------------------------------
-- 表 5: TestPaperDetail（測卷明細檔）
-- ----------------------------------------------------------------------------
-- 說明: 定義每份測卷包含哪些題目
-- 預估筆數: 1,000-5,000
-- ----------------------------------------------------------------------------

DROP TABLE IF EXISTS TestPaperDetail;

CREATE TABLE TestPaperDetail (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    TestPaperId INT NOT NULL COMMENT '測卷ID',
    QuestionBankId INT NOT NULL COMMENT '題庫ID',
    QuestionOrder INT NOT NULL COMMENT '題目順序（1, 2, 3...）',
    IsRequired BOOLEAN NOT NULL DEFAULT 1 COMMENT '是否必答',
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    
    UNIQUE KEY uk_paper_question (TestPaperId, QuestionBankId),
    INDEX idx_test_paper (TestPaperId),
    INDEX idx_question_bank (QuestionBankId),
    INDEX idx_question_order (TestPaperId, QuestionOrder),
    
    CONSTRAINT FK_TestPaperDetail_TestPaper 
        FOREIGN KEY (TestPaperId) 
        REFERENCES TestPaper(Id) 
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_TestPaperDetail_QuestionBank 
        FOREIGN KEY (QuestionBankId) 
        REFERENCES QuestionBank(Id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='測卷明細檔';

-- ----------------------------------------------------------------------------
-- 表 6: TestSession（受測主檔）
-- ----------------------------------------------------------------------------
-- 說明: 記錄每位受測者的基本資料和測驗資訊
-- 預估筆數: 不限
-- ----------------------------------------------------------------------------

DROP TABLE IF EXISTS TestSession;

CREATE TABLE TestSession (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    TestPaperId INT NOT NULL COMMENT '測卷ID',
    TestTakerName VARCHAR(100) NOT NULL COMMENT '受測者姓名',
    Phone VARCHAR(20) NULL COMMENT '電話',
    Email VARCHAR(100) NULL COMMENT 'Email',
    BirthDate DATE NULL COMMENT '生日',
    Gender VARCHAR(10) NULL COMMENT '性別：Male, Female, Other',
    Status VARCHAR(20) NOT NULL DEFAULT 'NotStarted' COMMENT '測驗狀態：NotStarted, InProgress, Completed, Abandoned',
    StartedAt DATETIME NULL COMMENT '開始作答時間',
    CompletedAt DATETIME NULL COMMENT '完成時間',
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '建立時間',
    UpdatedAt DATETIME NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新時間',
    
    INDEX idx_test_paper (TestPaperId),
    INDEX idx_status (Status),
    INDEX idx_created_at (CreatedAt),
    INDEX idx_email (Email),
    INDEX idx_completed_at (CompletedAt),
    
    CONSTRAINT FK_TestSession_TestPaper 
        FOREIGN KEY (TestPaperId) 
        REFERENCES TestPaper(Id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='受測主檔';

-- ----------------------------------------------------------------------------
-- 表 7: TestAnswer（受測作答明細檔）
-- ----------------------------------------------------------------------------
-- 說明: 記錄受測者對每個題目的作答內容
-- 預估筆數: 不限
-- ----------------------------------------------------------------------------

DROP TABLE IF EXISTS TestAnswer;

CREATE TABLE TestAnswer (
    Id INT AUTO_INCREMENT PRIMARY KEY COMMENT '主鍵',
    TestSessionId INT NOT NULL COMMENT '受測ID',
    TestPaperDetailId INT NOT NULL COMMENT '測卷明細ID',
    AnswerValue INT NOT NULL COMMENT '作答值',
    AnswerText VARCHAR(1000) NULL COMMENT '文字作答（開放題）',
    AnsweredAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作答時間',
    
    UNIQUE KEY uk_session_detail (TestSessionId, TestPaperDetailId),
    INDEX idx_test_session (TestSessionId),
    INDEX idx_test_paper_detail (TestPaperDetailId),
    INDEX idx_answered_at (AnsweredAt),
    
    CONSTRAINT FK_TestAnswer_TestSession 
        FOREIGN KEY (TestSessionId) 
        REFERENCES TestSession(Id) 
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT FK_TestAnswer_TestPaperDetail 
        FOREIGN KEY (TestPaperDetailId) 
        REFERENCES TestPaperDetail(Id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='受測作答明細檔';

-- ============================================================================
-- 步驟 3: 驗證資料庫結構
-- ============================================================================

-- 顯示所有資料表
SHOW TABLES;

-- 顯示資料庫資訊
SELECT 
    TABLE_NAME AS 'Table',
    TABLE_ROWS AS 'Rows',
    ROUND(((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024), 2) AS 'Size (MB)',
    ENGINE,
    TABLE_COLLATION AS 'Collation'
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'PsychometricTestDB'
ORDER BY TABLE_NAME;

-- 顯示外鍵關聯
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'PsychometricTestDB'
AND REFERENCED_TABLE_NAME IS NOT NULL
ORDER BY TABLE_NAME, COLUMN_NAME;

-- ============================================================================
-- 完成！
-- ============================================================================

SELECT 'Database PsychometricTestDB created successfully!' AS Status;
SELECT 'Ready for data import.' AS NextStep;

