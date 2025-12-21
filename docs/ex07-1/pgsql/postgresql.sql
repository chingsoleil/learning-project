-- ============================================================================
-- 心理測驗題庫系統 - PostgreSQL 版本
-- ============================================================================
-- 資料庫名稱: psychometrictestdb
-- 資料庫引擎: PostgreSQL 16+
-- 字元集: UTF8
-- 建立日期: 2025-12-21
-- ============================================================================
-- 說明:
-- 從 MSSQL 版本轉換而來
-- 命名規範：PascalCase（資料庫、表名、欄位名）
-- ============================================================================

-- ============================================================================
-- 步驟 1: 連接到資料庫（如果尚未連接）
-- ============================================================================
-- \c psychometrictestdb

-- ============================================================================
-- 步驟 2: 建立資料表
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 表 1: InstrumentCategory（量表分類主檔）
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "InstrumentCategory" (
    "Id" SERIAL PRIMARY KEY,
    "NameEn" VARCHAR(100) NOT NULL,
    "NameZh" VARCHAR(100),
    "Code" VARCHAR(100),
    "Description" VARCHAR(500),
    "IsActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 表 2: TraitCategory（特質面向分類主檔）
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "TraitCategory" (
    "Id" SERIAL PRIMARY KEY,
    "NameEn" VARCHAR(100) NOT NULL,
    "NameZh" VARCHAR(100),
    "Code" VARCHAR(100),
    "Description" VARCHAR(500),
    "IsActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 表 3: QuestionBank（題庫主檔）
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "QuestionBank" (
    "Id" SERIAL PRIMARY KEY,
    "InstrumentCategoryId" INTEGER NOT NULL,
    "TraitCategoryId" INTEGER NOT NULL,
    "TextEn" TEXT NOT NULL,
    "TextZh" TEXT NOT NULL,
    "Alpha" DECIMAL(5, 3),
    "Alpha2" DECIMAL(5, 3),
    "ScoringKey" SMALLINT NOT NULL DEFAULT 1,
    "IPIPItemNumber" VARCHAR(100),
    "IsActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 表 4: TestPaper（測卷主檔）
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "TestPaper" (
    "Id" SERIAL PRIMARY KEY,
    "Name" VARCHAR(100) NOT NULL,
    "Code" VARCHAR(100),
    "Description" VARCHAR(1000),
    "ResponseType" VARCHAR(50) NOT NULL,
    "TimeLimit" INTEGER,
    "TotalQuestions" INTEGER NOT NULL DEFAULT 0,
    "IsActive" BOOLEAN NOT NULL DEFAULT TRUE,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 表 5: TestPaperDetail（測卷明細檔）
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "TestPaperDetail" (
    "Id" SERIAL PRIMARY KEY,
    "TestPaperId" INTEGER NOT NULL,
    "QuestionBankId" INTEGER NOT NULL,
    "QuestionOrder" INTEGER NOT NULL,
    "IsRequired" BOOLEAN NOT NULL DEFAULT TRUE,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 表 6: TestSession（測驗會話檔）
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "TestSession" (
    "Id" SERIAL PRIMARY KEY,
    "TestPaperId" INTEGER NOT NULL,
    "TestTakerName" VARCHAR(100) NOT NULL,
    "Phone" VARCHAR(20),
    "Email" VARCHAR(100),
    "BirthDate" DATE,
    "Gender" VARCHAR(10),
    "Status" VARCHAR(20) NOT NULL DEFAULT 'NotStarted',
    "StartedAt" TIMESTAMP,
    "CompletedAt" TIMESTAMP,
    "CreatedAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "UpdatedAt" TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 表 7: TestAnswer（測驗答案檔）
-- ----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS "TestAnswer" (
    "Id" SERIAL PRIMARY KEY,
    "TestSessionId" INTEGER NOT NULL,
    "TestPaperDetailId" INTEGER NOT NULL,
    "AnswerValue" INTEGER NOT NULL,
    "AnswerText" VARCHAR(1000),
    "AnsweredAt" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- 步驟 3: 建立唯一約束
-- ============================================================================

ALTER TABLE "InstrumentCategory" ADD CONSTRAINT "UQ_InstrumentCategory_Code" UNIQUE ("Code");
ALTER TABLE "TraitCategory" ADD CONSTRAINT "UQ_TraitCategory_Code" UNIQUE ("Code");
ALTER TABLE "TestPaper" ADD CONSTRAINT "UQ_TestPaper_Code" UNIQUE ("Code");
ALTER TABLE "TestPaperDetail" ADD CONSTRAINT "UQ_TestPaperDetail_PaperQuestion" UNIQUE ("TestPaperId", "QuestionBankId");
ALTER TABLE "TestAnswer" ADD CONSTRAINT "UQ_TestAnswer_SessionDetail" UNIQUE ("TestSessionId", "TestPaperDetailId");

-- ============================================================================
-- 步驟 4: 建立外鍵約束
-- ============================================================================

ALTER TABLE "QuestionBank" 
    ADD CONSTRAINT "FK_QuestionBank_InstrumentCategory" 
    FOREIGN KEY ("InstrumentCategoryId") 
    REFERENCES "InstrumentCategory"("Id");

ALTER TABLE "QuestionBank" 
    ADD CONSTRAINT "FK_QuestionBank_TraitCategory" 
    FOREIGN KEY ("TraitCategoryId") 
    REFERENCES "TraitCategory"("Id");

ALTER TABLE "TestPaperDetail" 
    ADD CONSTRAINT "FK_TestPaperDetail_TestPaper" 
    FOREIGN KEY ("TestPaperId") 
    REFERENCES "TestPaper"("Id");

ALTER TABLE "TestPaperDetail" 
    ADD CONSTRAINT "FK_TestPaperDetail_QuestionBank" 
    FOREIGN KEY ("QuestionBankId") 
    REFERENCES "QuestionBank"("Id");

ALTER TABLE "TestSession" 
    ADD CONSTRAINT "FK_TestSession_TestPaper" 
    FOREIGN KEY ("TestPaperId") 
    REFERENCES "TestPaper"("Id");

ALTER TABLE "TestAnswer" 
    ADD CONSTRAINT "FK_TestAnswer_TestSession" 
    FOREIGN KEY ("TestSessionId") 
    REFERENCES "TestSession"("Id");

ALTER TABLE "TestAnswer" 
    ADD CONSTRAINT "FK_TestAnswer_TestPaperDetail" 
    FOREIGN KEY ("TestPaperDetailId") 
    REFERENCES "TestPaperDetail"("Id");

-- ============================================================================
-- 步驟 5: 建立索引
-- ============================================================================

CREATE INDEX IF NOT EXISTS "IX_InstrumentCategory_IsActive" ON "InstrumentCategory"("IsActive");
CREATE INDEX IF NOT EXISTS "IX_InstrumentCategory_NameEn" ON "InstrumentCategory"("NameEn");
CREATE INDEX IF NOT EXISTS "IX_QuestionBank_InstrumentCategoryId" ON "QuestionBank"("InstrumentCategoryId");
CREATE INDEX IF NOT EXISTS "IX_QuestionBank_IPIPItemNumber" ON "QuestionBank"("IPIPItemNumber");
CREATE INDEX IF NOT EXISTS "IX_QuestionBank_IsActive" ON "QuestionBank"("IsActive");
CREATE INDEX IF NOT EXISTS "IX_QuestionBank_ScoringKey" ON "QuestionBank"("ScoringKey");
CREATE INDEX IF NOT EXISTS "IX_QuestionBank_TraitCategoryId" ON "QuestionBank"("TraitCategoryId");
CREATE INDEX IF NOT EXISTS "IX_TestAnswer_AnsweredAt" ON "TestAnswer"("AnsweredAt");
CREATE INDEX IF NOT EXISTS "IX_TestAnswer_TestPaperDetailId" ON "TestAnswer"("TestPaperDetailId");
CREATE INDEX IF NOT EXISTS "IX_TestAnswer_TestSessionId" ON "TestAnswer"("TestSessionId");
CREATE INDEX IF NOT EXISTS "IX_TestPaper_IsActive" ON "TestPaper"("IsActive");
CREATE INDEX IF NOT EXISTS "IX_TestPaperDetail_QuestionBankId" ON "TestPaperDetail"("QuestionBankId");
CREATE INDEX IF NOT EXISTS "IX_TestPaperDetail_TestPaperId" ON "TestPaperDetail"("TestPaperId");
CREATE INDEX IF NOT EXISTS "IX_TestSession_CreatedAt" ON "TestSession"("CreatedAt");
CREATE INDEX IF NOT EXISTS "IX_TestSession_Email" ON "TestSession"("Email");
CREATE INDEX IF NOT EXISTS "IX_TestSession_Status" ON "TestSession"("Status");
CREATE INDEX IF NOT EXISTS "IX_TestSession_TestPaperId" ON "TestSession"("TestPaperId");
CREATE INDEX IF NOT EXISTS "IX_TraitCategory_IsActive" ON "TraitCategory"("IsActive");
CREATE INDEX IF NOT EXISTS "IX_TraitCategory_NameEn" ON "TraitCategory"("NameEn");

-- ============================================================================
-- 步驟 6: 建立視圖
-- ============================================================================

CREATE OR REPLACE VIEW "View_1" AS
SELECT 
    tp."Id",
    tp."Code",
    tp."Name",
    tp."Description",
    tpd."QuestionOrder",
    qb."TextZh",
    qb."Alpha",
    qb."ScoringKey",
    qb."IPIPItemNumber",
    ic."NameEn" AS "InstrumentNameEn",
    ic."NameZh" AS "InstrumentNameZh",
    ic."Description" AS "InstrumentDescription",
    tc."NameEn" AS "TraitNameEn",
    tc."NameZh" AS "TraitNameZh",
    tc."Description" AS "TraitDescription"
FROM "TestPaper" tp
INNER JOIN "TestPaperDetail" tpd ON tp."Id" = tpd."TestPaperId"
INNER JOIN "QuestionBank" qb ON tpd."QuestionBankId" = qb."Id"
INNER JOIN "InstrumentCategory" ic ON qb."InstrumentCategoryId" = ic."Id"
INNER JOIN "TraitCategory" tc ON qb."TraitCategoryId" = tc."Id"
ORDER BY tp."Id", tpd."QuestionOrder";

-- ============================================================================
-- 步驟 7: 插入資料
-- ============================================================================
-- 注意：由於資料量很大，INSERT 語句需要從 MSSQL 版本轉換
-- 
-- 轉換規則：
-- 1. [dbo].[TableName] → "TableName"
-- 2. [ColumnName] → "ColumnName"
-- 3. CAST(... AS DateTime2) → CAST(... AS TIMESTAMP)
-- 4. N'...' → '...' (PostgreSQL 支援 Unicode，N 前綴可選)
-- 5. 移除 SET IDENTITY_INSERT ... ON/OFF
-- 6. 如果使用 SERIAL，需要先設定序列值：SELECT setval('"TableName_Id_seq"', max_id);
--
-- 範例轉換：
-- MSSQL: INSERT [dbo].[InstrumentCategory] ([Id], [NameEn], ...) VALUES (1, N'16PF', ...)
-- PostgreSQL: INSERT INTO "InstrumentCategory" ("Id", "NameEn", ...) VALUES (1, '16PF', ...)
--
-- 或者使用 COPY 命令從 CSV 匯入（更快速）：
-- COPY "InstrumentCategory" ("Id", "NameEn", "NameZh", "Code", "Description", "IsActive", "CreatedAt", "UpdatedAt")
-- FROM '/path/to/data.csv' WITH (FORMAT csv, HEADER true);
--
-- 如果需要手動轉換，可以使用以下 Python 腳本或手動處理

