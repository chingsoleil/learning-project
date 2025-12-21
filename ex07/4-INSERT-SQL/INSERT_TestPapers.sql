-- ============================================================================
-- 心理測驗題庫系統 - 測卷資料 INSERT 指令（MSSQL 版本）
-- ============================================================================
-- 資料庫名稱: PsychometricTestDB
-- 資料庫引擎: Microsoft SQL Server 2016+
-- 建立日期: 2024-12-21
-- ============================================================================
-- 說明:
-- 為 5 份心理測驗卷建立 TestPaper 和 TestPaperDetail 資料
-- - TestPaper: 5 筆（測卷主檔）
-- - TestPaperDetail: 250 筆（測卷明細，每份測卷 50 題）
-- 總計: 255 筆 INSERT 指令
-- ============================================================================

USE PsychometricTestDB;
GO

-- ============================================================================
-- 測驗 1：大五人格快速評估（BIG5_QUICK_01）
-- ============================================================================
-- 說明: 全面評估五大人格特質，適合一般人格評估、個人成長、職業規劃
-- 題數: 50 題
-- 作答時間: 20 分鐘
-- ============================================================================

-- 插入測卷主檔
INSERT INTO dbo.TestPaper (Name, Code, Description, ResponseType, TimeLimit, TotalQuestions, IsActive)
VALUES (
    N'大五人格快速評估',
    'BIG5_QUICK_01',
    N'全面評估五大人格特質，適合一般人格評估、個人成長、職業規劃',
    'Likert5',
    20,
    50,
    1
);

-- 取得剛插入的 TestPaper Id
DECLARE @TestPaper1Id INT = SCOPE_IDENTITY();

-- 插入測卷明細（50 題）
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3120, 1, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3119, 2, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1329, 3, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1299, 4, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1292, 5, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3108, 6, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1172, 7, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1330, 8, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1302, 9, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3107, 10, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3134, 11, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1328, 12, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1298, 13, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1170, 14, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3097, 15, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3136, 16, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1305, 17, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1335, 18, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1311, 19, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1313, 20, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1180, 21, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1312, 22, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3109, 23, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1175, 24, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3126, 25, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1310, 26, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3110, 27, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1205, 28, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3137, 29, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1325, 30, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3112, 31, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3103, 32, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1214, 33, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3121, 34, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3104, 35, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3117, 36, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3127, 37, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1193, 38, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1301, 39, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1304, 40, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1331, 41, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1182, 42, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3098, 43, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1303, 44, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3118, 45, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 3116, 46, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1198, 47, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1314, 48, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1168, 49, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper1Id, 1300, 50, 1);

PRINT N'✓ 測驗 1：大五人格快速評估 - 已插入 1 筆測卷 + 50 筆題目';
GO

-- ============================================================================
-- 測驗 2：職場人格評估（WORKPLACE_PERSONALITY_01）
-- ============================================================================
-- 說明: 評估職場相關人格特質，聚焦職場表現相關特質，適合人才招募、團隊配置
-- 題數: 50 題
-- 作答時間: 20 分鐘
-- ============================================================================

-- 插入測卷主檔
INSERT INTO dbo.TestPaper (Name, Code, Description, ResponseType, TimeLimit, TotalQuestions, IsActive)
VALUES (
    N'職場人格評估',
    'WORKPLACE_PERSONALITY_01',
    N'評估職場相關人格特質，聚焦職場表現相關特質，適合人才招募、團隊配置',
    'Likert5',
    20,
    50,
    1
);

-- 取得剛插入的 TestPaper Id
DECLARE @TestPaper2Id INT = SCOPE_IDENTITY();

-- 插入測卷明細（50 題）
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3124, 1, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1351, 2, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1318, 3, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3128, 4, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3100, 5, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1321, 6, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3094, 7, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1320, 8, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1343, 9, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3114, 10, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3102, 11, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3111, 12, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1293, 13, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3371, 14, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1315, 15, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1323, 16, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1334, 17, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1317, 18, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3149, 19, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1295, 20, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1294, 21, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1349, 22, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1332, 23, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1352, 24, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 2949, 25, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1322, 26, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3129, 27, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1333, 28, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3106, 29, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3113, 30, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1308, 31, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1337, 32, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1316, 33, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3095, 34, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3122, 35, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3123, 36, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3142, 37, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1353, 38, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3105, 39, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 3133, 40, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1307, 41, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1342, 42, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1340, 43, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1319, 44, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1324, 45, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1341, 46, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1346, 47, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1354, 48, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1347, 49, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper2Id, 1336, 50, 1);

PRINT N'✓ 測驗 2：職場人格評估 - 已插入 1 筆測卷 + 50 筆題目';
GO

-- ============================================================================
-- 測驗 3：情緒與人際關係（EMOTION_INTERPERSONAL_01）
-- ============================================================================
-- 說明: 評估情緒管理與人際互動能力，深入評估情緒與人際面向，適合人際關係改善、情緒管理
-- 題數: 50 題
-- 作答時間: 20 分鐘
-- ============================================================================

-- 插入測卷主檔
INSERT INTO dbo.TestPaper (Name, Code, Description, ResponseType, TimeLimit, TotalQuestions, IsActive)
VALUES (
    N'情緒與人際關係',
    'EMOTION_INTERPERSONAL_01',
    N'評估情緒管理與人際互動能力，深入評估情緒與人際面向，適合人際關係改善、情緒管理',
    'Likert5',
    20,
    50,
    1
);

-- 取得剛插入的 TestPaper Id
DECLARE @TestPaper3Id INT = SCOPE_IDENTITY();

-- 插入測卷明細（50 題）
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3420, 1, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3456, 2, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3756, 3, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3443, 4, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 392, 5, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 521, 6, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3363, 7, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3449, 8, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3405, 9, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3445, 10, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3407, 11, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3379, 12, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 372, 13, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3917, 14, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3442, 15, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3453, 16, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3444, 17, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 513, 18, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3448, 19, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 571, 20, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3778, 21, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 450, 22, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 484, 23, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3354, 24, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3130, 25, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3447, 26, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3800, 27, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3385, 28, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3455, 29, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3452, 30, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 556, 31, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3781, 32, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3427, 33, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3406, 34, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 552, 35, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3353, 36, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3782, 37, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3450, 38, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3871, 39, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3135, 40, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 393, 41, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3389, 42, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3362, 43, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3932, 44, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3780, 45, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3809, 46, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3446, 47, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3451, 48, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3373, 49, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper3Id, 3454, 50, 1);

PRINT N'✓ 測驗 3：情緒與人際關係 - 已插入 1 筆測卷 + 50 筆題目';
GO

-- ============================================================================
-- 測驗 4：創造力與開放性（CREATIVITY_OPENNESS_01）
-- ============================================================================
-- 說明: 評估創造力、學習能力與開放性，聚焦創造力與學習相關特質，適合教育評估、創意產業
-- 題數: 50 題
-- 作答時間: 20 分鐘
-- ============================================================================

-- 插入測卷主檔
INSERT INTO dbo.TestPaper (Name, Code, Description, ResponseType, TimeLimit, TotalQuestions, IsActive)
VALUES (
    N'創造力與開放性',
    'CREATIVITY_OPENNESS_01',
    N'評估創造力、學習能力與開放性，聚焦創造力與學習相關特質，適合教育評估、創意產業',
    'Likert5',
    20,
    50,
    1
);

-- 取得剛插入的 TestPaper Id
DECLARE @TestPaper4Id INT = SCOPE_IDENTITY();

-- 插入測卷明細（50 題）
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3350, 1, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 447, 2, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3419, 3, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3036, 4, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3367, 5, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3395, 6, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3145, 7, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3430, 8, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 466, 9, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3425, 10, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3377, 11, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3099, 12, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3146, 13, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3433, 14, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3440, 15, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3434, 16, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 582, 17, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 481, 18, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 421, 19, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3148, 20, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 369, 21, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3101, 22, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3441, 23, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 453, 24, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 422, 25, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3045, 26, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3391, 27, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 420, 28, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3139, 29, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3147, 30, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 576, 31, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 387, 32, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3125, 33, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 380, 34, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 2099, 35, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3096, 36, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 449, 37, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3115, 38, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3072, 39, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 454, 40, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 486, 41, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3141, 42, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3132, 43, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 2998, 44, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3131, 45, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3144, 46, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3390, 47, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 3378, 48, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 353, 49, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper4Id, 406, 50, 1);

PRINT N'✓ 測驗 4：創造力與開放性 - 已插入 1 筆測卷 + 50 筆題目';
GO

-- ============================================================================
-- 測驗 5：全面人格評估（COMPREHENSIVE_PERSONALITY_01）
-- ============================================================================
-- 說明: 多維度全面人格評估，最全面的人格評估，涵蓋多個理論模型，適合深度人格分析、研究用途
-- 題數: 50 題
-- 作答時間: 20 分鐘
-- ============================================================================

-- 插入測卷主檔
INSERT INTO dbo.TestPaper (Name, Code, Description, ResponseType, TimeLimit, TotalQuestions, IsActive)
VALUES (
    N'全面人格評估',
    'COMPREHENSIVE_PERSONALITY_01',
    N'多維度全面人格評估，最全面的人格評估，涵蓋多個理論模型，適合深度人格分析、研究用途',
    'Likert5',
    20,
    50,
    1
);

-- 取得剛插入的 TestPaper Id
DECLARE @TestPaper5Id INT = SCOPE_IDENTITY();

-- 插入測卷明細（50 題）
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3143, 1, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 2111, 2, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3422, 3, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1465, 4, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 581, 5, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 2108, 6, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1466, 7, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 592, 8, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 605, 9, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 622, 10, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1462, 11, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 590, 12, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1460, 13, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3374, 14, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3413, 15, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 2129, 16, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 623, 17, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1459, 18, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3381, 19, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 588, 20, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 2109, 21, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3421, 22, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 603, 23, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 586, 24, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 614, 25, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3934, 26, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 610, 27, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3138, 28, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3140, 29, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1464, 30, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3383, 31, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1226, 32, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3418, 33, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1222, 34, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 2128, 35, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3414, 36, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 625, 37, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 598, 38, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 600, 39, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 609, 40, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3393, 41, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1463, 42, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 599, 43, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1467, 44, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 604, 45, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3963, 46, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1461, 47, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 3412, 48, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 1217, 49, 1);
INSERT INTO dbo.TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired) VALUES (@TestPaper5Id, 613, 50, 1);

PRINT N'✓ 測驗 5：全面人格評估 - 已插入 1 筆測卷 + 50 筆題目';
GO

-- ============================================================================
-- 驗證資料
-- ============================================================================

PRINT '';
PRINT N'========================================';
PRINT N'驗證資料插入結果';
PRINT N'========================================';

-- 檢查測卷數量
DECLARE @TestPaperCount INT;
SELECT @TestPaperCount = COUNT(*) FROM dbo.TestPaper;
PRINT N'TestPaper 總筆數: ' + CAST(@TestPaperCount AS NVARCHAR(10)) + N' (預期: 5)';

-- 檢查測卷明細數量
DECLARE @TestPaperDetailCount INT;
SELECT @TestPaperDetailCount = COUNT(*) FROM dbo.TestPaperDetail;
PRINT N'TestPaperDetail 總筆數: ' + CAST(@TestPaperDetailCount AS NVARCHAR(10)) + N' (預期: 250)';

PRINT '';
PRINT N'各測卷題數統計:';
PRINT N'----------------------------------------';

-- 顯示每份測卷的題數
SELECT 
    tp.Id AS [測卷ID],
    tp.Code AS [測卷代碼],
    tp.Name AS [測卷名稱],
    tp.TotalQuestions AS [設定題數],
    COUNT(tpd.Id) AS [實際題數],
    CASE 
        WHEN tp.TotalQuestions = COUNT(tpd.Id) THEN N'✓ 正確'
        ELSE N'✗ 不符'
    END AS [狀態]
FROM dbo.TestPaper tp
LEFT JOIN dbo.TestPaperDetail tpd ON tp.Id = tpd.TestPaperId
GROUP BY tp.Id, tp.Code, tp.Name, tp.TotalQuestions
ORDER BY tp.Id;

PRINT '';
PRINT N'========================================';
PRINT N'資料插入完成！';
PRINT N'========================================';
GO

