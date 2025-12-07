-- ============================================================================
-- 心理測驗題庫系統 - 資料庫建立腳本（MSSQL 版本）
-- ============================================================================
-- 資料庫名稱: PsychometricTestDB
-- 資料庫引擎: Microsoft SQL Server 2016+
-- 定序: Chinese_Taiwan_Stroke_CI_AS
-- 建立日期: 2024-12-08
-- ============================================================================
-- 說明:
-- 建立心理測驗題庫系統資料庫結構（7個資料表）
-- 
-- 命名規範：PascalCase（資料庫、表名、欄位名）
-- 欄位名在所有環境都保持 PascalCase，與 ASP.NET/EF Core 相容 ✅
-- 從 MySQL 版本轉換而來
-- ============================================================================

-- ============================================================================
-- 步驟 1: 建立資料庫
-- ============================================================================

-- 檢查並刪除既有資料庫（警告：將刪除所有資料）
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'PsychometricTestDB')
BEGIN
    ALTER DATABASE PsychometricTestDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE PsychometricTestDB;
END
GO

-- 建立新資料庫
CREATE DATABASE PsychometricTestDB
COLLATE Chinese_Taiwan_Stroke_CI_AS;
GO

-- 使用資料庫
USE PsychometricTestDB;
GO

-- ============================================================================
-- 步驟 2: 建立資料表
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 表 1: InstrumentCategory（量表分類主檔）
-- ----------------------------------------------------------------------------
-- 說明: 心理測量工具的分類（如：16PF、NEO、MBTI 等）
-- 預估筆數: 36
-- ----------------------------------------------------------------------------

IF OBJECT_ID('dbo.InstrumentCategory', 'U') IS NOT NULL
    DROP TABLE dbo.InstrumentCategory;
GO

CREATE TABLE dbo.InstrumentCategory (
    Id INT IDENTITY(1,1) PRIMARY KEY,  -- 主鍵
    NameEn NVARCHAR(100) NOT NULL,     -- 量表名稱（英文）
    NameZh NVARCHAR(100) NULL,         -- 量表名稱（中文）
    Code NVARCHAR(100) NULL,           -- 量表代碼
    Description NVARCHAR(500) NULL,    -- 量表描述
    IsActive BIT NOT NULL DEFAULT 1,   -- 是否啟用
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),  -- 建立時間
    UpdatedAt DATETIME2 NULL,          -- 更新時間
    
    CONSTRAINT UQ_InstrumentCategory_Code UNIQUE (Code)
);
GO

-- 建立索引
CREATE INDEX IX_InstrumentCategory_NameEn ON dbo.InstrumentCategory(NameEn);
CREATE INDEX IX_InstrumentCategory_IsActive ON dbo.InstrumentCategory(IsActive);
GO

-- 添加資料表和欄位的中文註解
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'量表分類主檔',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'InstrumentCategory';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'主鍵',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'InstrumentCategory',
    @level2type = N'COLUMN', @level2name = N'Id';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'量表名稱（英文）',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'InstrumentCategory',
    @level2type = N'COLUMN', @level2name = N'NameEn';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'量表名稱（中文）',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'InstrumentCategory',
    @level2type = N'COLUMN', @level2name = N'NameZh';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'量表代碼',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'InstrumentCategory',
    @level2type = N'COLUMN', @level2name = N'Code';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'量表描述',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'InstrumentCategory',
    @level2type = N'COLUMN', @level2name = N'Description';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'是否啟用',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'InstrumentCategory',
    @level2type = N'COLUMN', @level2name = N'IsActive';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'建立時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'InstrumentCategory',
    @level2type = N'COLUMN', @level2name = N'CreatedAt';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'更新時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'InstrumentCategory',
    @level2type = N'COLUMN', @level2name = N'UpdatedAt';
GO

-- 建立 UpdatedAt 自動更新的 Trigger
CREATE TRIGGER TR_InstrumentCategory_UpdatedAt
ON dbo.InstrumentCategory
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.InstrumentCategory
    SET UpdatedAt = GETDATE()
    FROM dbo.InstrumentCategory ic
    INNER JOIN inserted i ON ic.Id = i.Id;
END;
GO

-- ----------------------------------------------------------------------------
-- 表 2: TraitCategory（特質面向分類主檔）
-- ----------------------------------------------------------------------------
-- 說明: 人格特質面向的分類（如：Openness、Conscientiousness 等）
-- 預估筆數: 246
-- ----------------------------------------------------------------------------

IF OBJECT_ID('dbo.TraitCategory', 'U') IS NOT NULL
    DROP TABLE dbo.TraitCategory;
GO

CREATE TABLE dbo.TraitCategory (
    Id INT IDENTITY(1,1) PRIMARY KEY,  -- 主鍵
    NameEn NVARCHAR(100) NOT NULL,     -- 特質名稱（英文）
    NameZh NVARCHAR(100) NULL,         -- 特質名稱（中文）
    Code NVARCHAR(100) NULL,           -- 特質代碼
    Description NVARCHAR(500) NULL,    -- 特質描述
    IsActive BIT NOT NULL DEFAULT 1,   -- 是否啟用
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),  -- 建立時間
    UpdatedAt DATETIME2 NULL,          -- 更新時間
    
    CONSTRAINT UQ_TraitCategory_Code UNIQUE (Code)
);
GO

-- 建立索引
CREATE INDEX IX_TraitCategory_NameEn ON dbo.TraitCategory(NameEn);
CREATE INDEX IX_TraitCategory_IsActive ON dbo.TraitCategory(IsActive);
GO

-- 添加資料表和欄位的中文註解
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'特質面向分類主檔',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TraitCategory';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'主鍵',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TraitCategory',
    @level2type = N'COLUMN', @level2name = N'Id';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'特質名稱（英文）',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TraitCategory',
    @level2type = N'COLUMN', @level2name = N'NameEn';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'特質名稱（中文）',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TraitCategory',
    @level2type = N'COLUMN', @level2name = N'NameZh';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'特質代碼',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TraitCategory',
    @level2type = N'COLUMN', @level2name = N'Code';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'特質描述',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TraitCategory',
    @level2type = N'COLUMN', @level2name = N'Description';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'是否啟用',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TraitCategory',
    @level2type = N'COLUMN', @level2name = N'IsActive';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'建立時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TraitCategory',
    @level2type = N'COLUMN', @level2name = N'CreatedAt';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'更新時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TraitCategory',
    @level2type = N'COLUMN', @level2name = N'UpdatedAt';
GO

-- 建立 UpdatedAt 自動更新的 Trigger
CREATE TRIGGER TR_TraitCategory_UpdatedAt
ON dbo.TraitCategory
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.TraitCategory
    SET UpdatedAt = GETDATE()
    FROM dbo.TraitCategory tc
    INNER JOIN inserted i ON tc.Id = i.Id;
END;
GO

-- ----------------------------------------------------------------------------
-- 表 3: QuestionBank（題庫主檔）
-- ----------------------------------------------------------------------------
-- 說明: 所有測驗題目的主要資料庫
-- 預估筆數: 3,805
-- ----------------------------------------------------------------------------

IF OBJECT_ID('dbo.QuestionBank', 'U') IS NOT NULL
    DROP TABLE dbo.QuestionBank;
GO

CREATE TABLE dbo.QuestionBank (
    Id INT IDENTITY(1,1) PRIMARY KEY,           -- 主鍵
    InstrumentCategoryId INT NOT NULL,          -- 量表分類ID
    TraitCategoryId INT NOT NULL,               -- 特質面向ID
    TextEn NVARCHAR(MAX) NOT NULL,              -- 題目文字（英文）
    TextZh NVARCHAR(MAX) NOT NULL,              -- 題目文字（中文）
    Alpha DECIMAL(5,3) NULL,                    -- 信度係數（0.000-1.000，第一個值）
    Alpha2 DECIMAL(5,3) NULL,                   -- 信度係數（0.000-1.000，第二個值，部分題目有兩個 alpha 值）
    ScoringKey TINYINT NOT NULL DEFAULT 1,      -- 計分鍵：1=正向計分, -1=反向計分
    IPIPItemNumber NVARCHAR(100) NULL,          -- IPIP item number（參考用，非唯一，可能包含多個編號用逗號分隔）
    IsActive BIT NOT NULL DEFAULT 1,            -- 是否啟用
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),  -- 建立時間
    UpdatedAt DATETIME2 NULL,                   -- 更新時間
    
    CONSTRAINT FK_QuestionBank_InstrumentCategory 
        FOREIGN KEY (InstrumentCategoryId) 
        REFERENCES dbo.InstrumentCategory(Id),
    CONSTRAINT FK_QuestionBank_TraitCategory 
        FOREIGN KEY (TraitCategoryId) 
        REFERENCES dbo.TraitCategory(Id)
);
GO

-- 建立索引
CREATE INDEX IX_QuestionBank_IPIPItemNumber ON dbo.QuestionBank(IPIPItemNumber);
CREATE INDEX IX_QuestionBank_InstrumentCategoryId ON dbo.QuestionBank(InstrumentCategoryId);
CREATE INDEX IX_QuestionBank_TraitCategoryId ON dbo.QuestionBank(TraitCategoryId);
CREATE INDEX IX_QuestionBank_IsActive ON dbo.QuestionBank(IsActive);
CREATE INDEX IX_QuestionBank_ScoringKey ON dbo.QuestionBank(ScoringKey);
GO

-- 添加資料表和欄位的中文註解
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'題庫主檔',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'主鍵',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'Id';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'量表分類ID',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'InstrumentCategoryId';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'特質面向ID',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'TraitCategoryId';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'題目文字（英文）',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'TextEn';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'題目文字（中文）',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'TextZh';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'信度係數（0.000-1.000，第一個值）',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'Alpha';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'信度係數（0.000-1.000，第二個值）',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'Alpha2';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'計分鍵：1=正向計分, -1=反向計分',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'ScoringKey';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'IPIP 題目編號',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'IPIPItemNumber';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'是否啟用',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'IsActive';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'建立時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'CreatedAt';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'更新時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'QuestionBank',
    @level2type = N'COLUMN', @level2name = N'UpdatedAt';
GO

-- 建立 UpdatedAt 自動更新的 Trigger
CREATE TRIGGER TR_QuestionBank_UpdatedAt
ON dbo.QuestionBank
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.QuestionBank
    SET UpdatedAt = GETDATE()
    FROM dbo.QuestionBank qb
    INNER JOIN inserted i ON qb.Id = i.Id;
END;
GO

-- ----------------------------------------------------------------------------
-- 表 4: TestPaper（測卷主檔）
-- ----------------------------------------------------------------------------
-- 說明: 定義不同的心理測驗卷
-- 預估筆數: 10-50
-- ----------------------------------------------------------------------------

IF OBJECT_ID('dbo.TestPaper', 'U') IS NOT NULL
    DROP TABLE dbo.TestPaper;
GO

CREATE TABLE dbo.TestPaper (
    Id INT IDENTITY(1,1) PRIMARY KEY,           -- 主鍵
    Name NVARCHAR(100) NOT NULL,                -- 測卷名稱
    Code NVARCHAR(100) NULL,                    -- 測卷代碼
    Description NVARCHAR(1000) NULL,            -- 測卷說明
    ResponseType NVARCHAR(50) NOT NULL,         -- 作答方式：Likert5, Likert7, YesNo, MultipleChoice
    TimeLimit INT NULL,                         -- 作答時間限制（分鐘）
    TotalQuestions INT NOT NULL DEFAULT 0,      -- 總題數
    IsActive BIT NOT NULL DEFAULT 1,            -- 是否啟用
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),  -- 建立時間
    UpdatedAt DATETIME2 NULL,                   -- 更新時間
    
    CONSTRAINT UQ_TestPaper_Code UNIQUE (Code)
);
GO

-- 建立索引
CREATE INDEX IX_TestPaper_IsActive ON dbo.TestPaper(IsActive);
CREATE INDEX IX_TestPaper_ResponseType ON dbo.TestPaper(ResponseType);
GO

-- 添加資料表和欄位的中文註解
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'測卷主檔',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaper';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'主鍵',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaper',
    @level2type = N'COLUMN', @level2name = N'Id';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'測卷名稱',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaper',
    @level2type = N'COLUMN', @level2name = N'Name';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'測卷代碼',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaper',
    @level2type = N'COLUMN', @level2name = N'Code';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'測卷說明',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaper',
    @level2type = N'COLUMN', @level2name = N'Description';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'作答方式：Likert5, Likert7, YesNo, MultipleChoice',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaper',
    @level2type = N'COLUMN', @level2name = N'ResponseType';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'作答時間限制（分鐘）',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaper',
    @level2type = N'COLUMN', @level2name = N'TimeLimit';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'總題數',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaper',
    @level2type = N'COLUMN', @level2name = N'TotalQuestions';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'是否啟用',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaper',
    @level2type = N'COLUMN', @level2name = N'IsActive';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'建立時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaper',
    @level2type = N'COLUMN', @level2name = N'CreatedAt';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'更新時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaper',
    @level2type = N'COLUMN', @level2name = N'UpdatedAt';
GO

-- 建立 UpdatedAt 自動更新的 Trigger
CREATE TRIGGER TR_TestPaper_UpdatedAt
ON dbo.TestPaper
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.TestPaper
    SET UpdatedAt = GETDATE()
    FROM dbo.TestPaper tp
    INNER JOIN inserted i ON tp.Id = i.Id;
END;
GO

-- ----------------------------------------------------------------------------
-- 表 5: TestPaperDetail（測卷明細檔）
-- ----------------------------------------------------------------------------
-- 說明: 定義每份測卷包含哪些題目
-- 預估筆數: 1,000-5,000
-- ----------------------------------------------------------------------------

IF OBJECT_ID('dbo.TestPaperDetail', 'U') IS NOT NULL
    DROP TABLE dbo.TestPaperDetail;
GO

CREATE TABLE dbo.TestPaperDetail (
    Id INT IDENTITY(1,1) PRIMARY KEY,           -- 主鍵
    TestPaperId INT NOT NULL,                   -- 測卷ID
    QuestionBankId INT NOT NULL,                -- 題庫ID
    QuestionOrder INT NOT NULL,                 -- 題目順序（1, 2, 3...）
    IsRequired BIT NOT NULL DEFAULT 1,          -- 是否必答
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),  -- 建立時間
    
    CONSTRAINT UQ_TestPaperDetail_PaperQuestion UNIQUE (TestPaperId, QuestionBankId),
    CONSTRAINT FK_TestPaperDetail_TestPaper 
        FOREIGN KEY (TestPaperId) 
        REFERENCES dbo.TestPaper(Id) 
        ON DELETE CASCADE,
    CONSTRAINT FK_TestPaperDetail_QuestionBank 
        FOREIGN KEY (QuestionBankId) 
        REFERENCES dbo.QuestionBank(Id)
);
GO

-- 建立索引
CREATE INDEX IX_TestPaperDetail_TestPaperId ON dbo.TestPaperDetail(TestPaperId);
CREATE INDEX IX_TestPaperDetail_QuestionBankId ON dbo.TestPaperDetail(QuestionBankId);
CREATE INDEX IX_TestPaperDetail_QuestionOrder ON dbo.TestPaperDetail(TestPaperId, QuestionOrder);
GO

-- 添加資料表和欄位的中文註解
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'測卷明細檔',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaperDetail';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'主鍵',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaperDetail',
    @level2type = N'COLUMN', @level2name = N'Id';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'測卷ID',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaperDetail',
    @level2type = N'COLUMN', @level2name = N'TestPaperId';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'題庫ID',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaperDetail',
    @level2type = N'COLUMN', @level2name = N'QuestionBankId';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'題目順序',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaperDetail',
    @level2type = N'COLUMN', @level2name = N'QuestionOrder';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'是否必答',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaperDetail',
    @level2type = N'COLUMN', @level2name = N'IsRequired';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'建立時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestPaperDetail',
    @level2type = N'COLUMN', @level2name = N'CreatedAt';
GO

-- ----------------------------------------------------------------------------
-- 表 6: TestSession（受測主檔）
-- ----------------------------------------------------------------------------
-- 說明: 記錄每位受測者的基本資料和測驗資訊
-- 預估筆數: 不限
-- ----------------------------------------------------------------------------

IF OBJECT_ID('dbo.TestSession', 'U') IS NOT NULL
    DROP TABLE dbo.TestSession;
GO

CREATE TABLE dbo.TestSession (
    Id INT IDENTITY(1,1) PRIMARY KEY,           -- 主鍵
    TestPaperId INT NOT NULL,                   -- 測卷ID
    TestTakerName NVARCHAR(100) NOT NULL,       -- 受測者姓名
    Phone NVARCHAR(20) NULL,                    -- 電話
    Email NVARCHAR(100) NULL,                   -- Email
    BirthDate DATE NULL,                        -- 生日
    Gender NVARCHAR(10) NULL,                   -- 性別：Male, Female, Other
    Status NVARCHAR(20) NOT NULL DEFAULT 'NotStarted',  -- 測驗狀態：NotStarted, InProgress, Completed, Abandoned
    StartedAt DATETIME2 NULL,                   -- 開始作答時間
    CompletedAt DATETIME2 NULL,                 -- 完成時間
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),  -- 建立時間
    UpdatedAt DATETIME2 NULL,                   -- 更新時間
    
    CONSTRAINT FK_TestSession_TestPaper 
        FOREIGN KEY (TestPaperId) 
        REFERENCES dbo.TestPaper(Id)
);
GO

-- 建立索引
CREATE INDEX IX_TestSession_TestPaperId ON dbo.TestSession(TestPaperId);
CREATE INDEX IX_TestSession_Status ON dbo.TestSession(Status);
CREATE INDEX IX_TestSession_CreatedAt ON dbo.TestSession(CreatedAt);
CREATE INDEX IX_TestSession_Email ON dbo.TestSession(Email);
CREATE INDEX IX_TestSession_CompletedAt ON dbo.TestSession(CompletedAt);
GO

-- 添加資料表和欄位的中文註解
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'受測主檔',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'主鍵',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'Id';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'測卷ID',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'TestPaperId';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'受測者姓名',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'TestTakerName';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'電話',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'Phone';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'Email',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'Email';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'生日',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'BirthDate';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'性別：Male, Female, Other',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'Gender';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'測驗狀態：NotStarted, InProgress, Completed, Abandoned',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'Status';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'開始作答時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'StartedAt';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'完成時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'CompletedAt';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'建立時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'CreatedAt';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'更新時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestSession',
    @level2type = N'COLUMN', @level2name = N'UpdatedAt';
GO

-- 建立 UpdatedAt 自動更新的 Trigger
CREATE TRIGGER TR_TestSession_UpdatedAt
ON dbo.TestSession
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE dbo.TestSession
    SET UpdatedAt = GETDATE()
    FROM dbo.TestSession ts
    INNER JOIN inserted i ON ts.Id = i.Id;
END;
GO

-- ----------------------------------------------------------------------------
-- 表 7: TestAnswer（受測作答明細檔）
-- ----------------------------------------------------------------------------
-- 說明: 記錄受測者對每個題目的作答內容
-- 預估筆數: 不限
-- ----------------------------------------------------------------------------

IF OBJECT_ID('dbo.TestAnswer', 'U') IS NOT NULL
    DROP TABLE dbo.TestAnswer;
GO

CREATE TABLE dbo.TestAnswer (
    Id INT IDENTITY(1,1) PRIMARY KEY,           -- 主鍵
    TestSessionId INT NOT NULL,                 -- 受測ID
    TestPaperDetailId INT NOT NULL,             -- 測卷明細ID
    AnswerValue INT NOT NULL,                   -- 作答值
    AnswerText NVARCHAR(1000) NULL,             -- 文字作答（開放題）
    AnsweredAt DATETIME2 NOT NULL DEFAULT GETDATE(),  -- 作答時間
    
    CONSTRAINT UQ_TestAnswer_SessionDetail UNIQUE (TestSessionId, TestPaperDetailId),
    CONSTRAINT FK_TestAnswer_TestSession 
        FOREIGN KEY (TestSessionId) 
        REFERENCES dbo.TestSession(Id) 
        ON DELETE CASCADE,
    CONSTRAINT FK_TestAnswer_TestPaperDetail 
        FOREIGN KEY (TestPaperDetailId) 
        REFERENCES dbo.TestPaperDetail(Id)
);
GO

-- 建立索引
CREATE INDEX IX_TestAnswer_TestSessionId ON dbo.TestAnswer(TestSessionId);
CREATE INDEX IX_TestAnswer_TestPaperDetailId ON dbo.TestAnswer(TestPaperDetailId);
CREATE INDEX IX_TestAnswer_AnsweredAt ON dbo.TestAnswer(AnsweredAt);
GO

-- 添加資料表和欄位的中文註解
EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'受測作答明細檔',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestAnswer';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'主鍵',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestAnswer',
    @level2type = N'COLUMN', @level2name = N'Id';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'受測ID',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestAnswer',
    @level2type = N'COLUMN', @level2name = N'TestSessionId';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'測卷明細ID',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestAnswer',
    @level2type = N'COLUMN', @level2name = N'TestPaperDetailId';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'作答值',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestAnswer',
    @level2type = N'COLUMN', @level2name = N'AnswerValue';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'文字作答（開放題）',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestAnswer',
    @level2type = N'COLUMN', @level2name = N'AnswerText';
GO

EXEC sys.sp_addextendedproperty 
    @name = N'MS_Description', @value = N'作答時間',
    @level0type = N'SCHEMA', @level0name = N'dbo',
    @level1type = N'TABLE', @level1name = N'TestAnswer',
    @level2type = N'COLUMN', @level2name = N'AnsweredAt';
GO

-- ============================================================================
-- 步驟 3: 驗證資料庫結構
-- ============================================================================

-- 顯示所有資料表
SELECT 
    name AS TableName,
    create_date AS CreateDate,
    modify_date AS ModifyDate
FROM sys.tables
WHERE type = 'U'
ORDER BY name;
GO

-- 顯示資料表詳細資訊
SELECT 
    t.name AS [Table],
    p.rows AS [Rows],
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00), 2) AS NUMERIC(36, 2)) AS [Size (MB)],
    s.name AS [Schema]
FROM sys.tables t
INNER JOIN sys.indexes i ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
WHERE t.is_ms_shipped = 0
GROUP BY t.name, p.rows, s.name
ORDER BY t.name;
GO

-- 顯示外鍵關聯
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS TableName,
    COL_NAME(fkc.parent_object_id, fkc.parent_column_id) AS ColumnName,
    OBJECT_NAME(fk.referenced_object_id) AS ReferencedTable,
    COL_NAME(fkc.referenced_object_id, fkc.referenced_column_id) AS ReferencedColumn
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
ORDER BY TableName, ColumnName;
GO

-- ============================================================================
-- 完成！
-- ============================================================================

SELECT 'Database PsychometricTestDB created successfully!' AS Status;
SELECT 'Ready for data import.' AS NextStep;
GO
