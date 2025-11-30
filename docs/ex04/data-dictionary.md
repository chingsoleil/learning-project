# 資料字典 (Data Dictionary)

## 資料庫概述
- **資料庫名稱**: `PsychometricTestDB`
- **資料庫引擎**: MySQL 8.0+
- **字元集**: utf8mb4
- **排序規則**: utf8mb4_unicode_ci
- **應用框架**: ASP.NET Core

---

## 資料表清單

| 序號 | 表名（英文） | 表名（中文） | 說明 | 預估筆數 |
|------|-------------|-------------|------|----------|
| 1 | InstrumentCategory | 量表分類主檔 | 量表名稱分類 | 36 |
| 2 | TraitCategory | 特質面向分類主檔 | 特質面向分類 | 246 |
| 3 | QuestionBank | 題庫主檔 | 所有測驗題目 | 3,800 |
| 4 | TestPaper | 測卷主檔 | 測驗卷基本資料 | 10-50 |
| 5 | TestPaperDetail | 測卷明細檔 | 測卷包含的題目 | 1,000-5,000 |
| 6 | TestSession | 受測主檔 | 受測者資料 | 不限 |
| 7 | TestAnswer | 受測作答明細檔 | 作答記錄 | 不限 |

---

## 1. InstrumentCategory（量表分類主檔）

### 表格說明
提供題庫主檔的量表名稱列表，用於分類不同的心理測量工具。

### 欄位定義

| 欄位名稱 | 資料型別 | 長度 | NULL | 預設值 | 主鍵 | 外鍵 | 說明 |
|---------|---------|------|------|--------|------|------|------|
| Id | INT | - | NOT NULL | AUTO_INCREMENT | PK | - | 主鍵 |
| NameEn | VARCHAR | 100 | NOT NULL | - | - | - | 量表名稱（英文） |
| NameZh | NVARCHAR | 100 | NOT NULL | - | - | - | 量表名稱（中文） |
| Code | VARCHAR | 20 | NULL | - | UQ | - | 量表代碼 |
| Description | NVARCHAR | 500 | NULL | - | - | - | 量表描述 |
| IsActive | BOOLEAN | - | NOT NULL | 1 | - | - | 是否啟用 |
| CreatedAt | DATETIME | - | NOT NULL | CURRENT_TIMESTAMP | - | - | 建立時間 |
| UpdatedAt | DATETIME | - | NULL | NULL | - | - | 更新時間 |

### 索引定義
- **PRIMARY KEY**: `Id`
- **UNIQUE KEY**: `Code`
- **INDEX**: `idx_name_en` ON `NameEn`

---

## 2. TraitCategory（特質面向分類主檔）

### 表格說明
提供題庫主檔的特質面向名稱列表，用於標記題目所測量的人格特質維度。

### 欄位定義

| 欄位名稱 | 資料型別 | 長度 | NULL | 預設值 | 主鍵 | 外鍵 | 說明 |
|---------|---------|------|------|--------|------|------|------|
| Id | INT | - | NOT NULL | AUTO_INCREMENT | PK | - | 主鍵 |
| NameEn | VARCHAR | 100 | NOT NULL | - | - | - | 特質名稱（英文） |
| NameZh | NVARCHAR | 100 | NOT NULL | - | - | - | 特質名稱（中文） |
| Code | VARCHAR | 20 | NULL | - | UQ | - | 特質代碼 |
| Description | NVARCHAR | 500 | NULL | - | - | - | 特質描述 |
| IsActive | BOOLEAN | - | NOT NULL | 1 | - | - | 是否啟用 |
| CreatedAt | DATETIME | - | NOT NULL | CURRENT_TIMESTAMP | - | - | 建立時間 |
| UpdatedAt | DATETIME | - | NULL | NULL | - | - | 更新時間 |

### 索引定義
- **PRIMARY KEY**: `Id`
- **UNIQUE KEY**: `Code`
- **INDEX**: `idx_name_en` ON `NameEn`

---

## 3. QuestionBank（題庫主檔）

### 表格說明
所有測驗題目的主要資料庫，儲存題目文字、量表來源、信度係數、計分方向等資訊。

### 欄位定義

| 欄位名稱 | 資料型別 | 長度 | NULL | 預設值 | 主鍵 | 外鍵 | 說明 |
|---------|---------|------|------|--------|------|------|------|
| Id | INT | - | NOT NULL | AUTO_INCREMENT | PK | - | 主鍵 |
| InstrumentCategoryId | INT | - | NOT NULL | - | - | FK | 量表分類ID |
| TraitCategoryId | INT | - | NOT NULL | - | - | FK | 特質面向ID |
| TextEn | TEXT | - | NOT NULL | - | - | - | 題目文字（英文） |
| TextZh | TEXT | - | NOT NULL | - | - | - | 題目文字（中文） |
| Alpha | DECIMAL | 5,3 | NULL | - | - | - | 信度係數（0.000-1.000） |
| Key | TINYINT | - | NOT NULL | 1 | - | - | 計分方向（1=正向，-1=反向） |
| QuestionCode | VARCHAR | 50 | NULL | - | UQ | - | 題目編碼 |
| IsActive | BOOLEAN | - | NOT NULL | 1 | - | - | 是否啟用 |
| CreatedAt | DATETIME | - | NOT NULL | CURRENT_TIMESTAMP | - | - | 建立時間 |
| UpdatedAt | DATETIME | - | NULL | NULL | - | - | 更新時間 |

### 外鍵約束
- `FK_QuestionBank_InstrumentCategory`: `InstrumentCategoryId` → `InstrumentCategory(Id)`
- `FK_QuestionBank_TraitCategory`: `TraitCategoryId` → `TraitCategory(Id)`

### 索引定義
- **PRIMARY KEY**: `Id`
- **UNIQUE KEY**: `QuestionCode`
- **INDEX**: `idx_instrument` ON `InstrumentCategoryId`
- **INDEX**: `idx_trait` ON `TraitCategoryId`
- **INDEX**: `idx_active` ON `IsActive`

---

## 4. TestPaper（測卷主檔）

### 表格說明
定義不同的心理測驗卷（如：大五人格、MMPI、MBTI等），包含測驗名稱和作答方式。

### 欄位定義

| 欄位名稱 | 資料型別 | 長度 | NULL | 預設值 | 主鍵 | 外鍵 | 說明 |
|---------|---------|------|------|--------|------|------|------|
| Id | INT | - | NOT NULL | AUTO_INCREMENT | PK | - | 主鍵 |
| Name | NVARCHAR | 100 | NOT NULL | - | - | - | 測卷名稱 |
| Code | VARCHAR | 20 | NULL | - | UQ | - | 測卷代碼 |
| Description | NVARCHAR | 1000 | NULL | - | - | - | 測卷說明 |
| ResponseType | VARCHAR | 50 | NOT NULL | - | - | - | 作答方式（如：Likert5、Likert7） |
| TimeLimit | INT | - | NULL | - | - | - | 作答時間限制（分鐘） |
| TotalQuestions | INT | - | NOT NULL | 0 | - | - | 總題數 |
| IsActive | BOOLEAN | - | NOT NULL | 1 | - | - | 是否啟用 |
| CreatedAt | DATETIME | - | NOT NULL | CURRENT_TIMESTAMP | - | - | 建立時間 |
| UpdatedAt | DATETIME | - | NULL | NULL | - | - | 更新時間 |

### ResponseType 參考值
- `Likert5`: 五點量表（1-5）
- `Likert7`: 七點量表（1-7）
- `YesNo`: 是非題
- `MultipleChoice`: 多選題

### 索引定義
- **PRIMARY KEY**: `Id`
- **UNIQUE KEY**: `Code`
- **INDEX**: `idx_active` ON `IsActive`

---

## 5. TestPaperDetail（測卷明細檔）

### 表格說明
定義每份測卷包含哪些題目，題目來自題庫主檔。

### 欄位定義

| 欄位名稱 | 資料型別 | 長度 | NULL | 預設值 | 主鍵 | 外鍵 | 說明 |
|---------|---------|------|------|--------|------|------|------|
| Id | INT | - | NOT NULL | AUTO_INCREMENT | PK | - | 主鍵 |
| TestPaperId | INT | - | NOT NULL | - | - | FK | 測卷ID |
| QuestionBankId | INT | - | NOT NULL | - | - | FK | 題庫ID |
| QuestionOrder | INT | - | NOT NULL | - | - | - | 題目順序（1, 2, 3...） |
| IsRequired | BOOLEAN | - | NOT NULL | 1 | - | - | 是否必答 |
| CreatedAt | DATETIME | - | NOT NULL | CURRENT_TIMESTAMP | - | - | 建立時間 |

### 外鍵約束
- `FK_TestPaperDetail_TestPaper`: `TestPaperId` → `TestPaper(Id)` ON DELETE CASCADE
- `FK_TestPaperDetail_QuestionBank`: `QuestionBankId` → `QuestionBank(Id)`

### 索引定義
- **PRIMARY KEY**: `Id`
- **UNIQUE KEY**: `uk_paper_question` ON (`TestPaperId`, `QuestionBankId`)
- **INDEX**: `idx_test_paper` ON `TestPaperId`
- **INDEX**: `idx_question_order` ON (`TestPaperId`, `QuestionOrder`)

---

## 6. TestSession（受測主檔）

### 表格說明
記錄每位受測者的基本資料和選擇的測卷，同一人受測多次視為多筆獨立記錄。

### 欄位定義

| 欄位名稱 | 資料型別 | 長度 | NULL | 預設值 | 主鍵 | 外鍵 | 說明 |
|---------|---------|------|------|--------|------|------|------|
| Id | INT | - | NOT NULL | AUTO_INCREMENT | PK | - | 主鍵 |
| TestPaperId | INT | - | NOT NULL | - | - | FK | 測卷ID |
| TestTakerName | NVARCHAR | 100 | NOT NULL | - | - | - | 受測者姓名 |
| Phone | VARCHAR | 20 | NULL | - | - | - | 電話 |
| Email | VARCHAR | 100 | NULL | - | - | - | Email |
| BirthDate | DATE | - | NULL | - | - | - | 生日 |
| Gender | VARCHAR | 10 | NULL | - | - | - | 性別（Male/Female/Other） |
| Status | VARCHAR | 20 | NOT NULL | 'NotStarted' | - | - | 測驗狀態 |
| StartedAt | DATETIME | - | NULL | - | - | - | 開始作答時間 |
| CompletedAt | DATETIME | - | NULL | - | - | - | 完成時間 |
| CreatedAt | DATETIME | - | NOT NULL | CURRENT_TIMESTAMP | - | - | 建立時間 |
| UpdatedAt | DATETIME | - | NULL | NULL | - | - | 更新時間 |

### Status 參考值
- `NotStarted`: 尚未開始
- `InProgress`: 作答中
- `Completed`: 已完成
- `Abandoned`: 已放棄

### 外鍵約束
- `FK_TestSession_TestPaper`: `TestPaperId` → `TestPaper(Id)`

### 索引定義
- **PRIMARY KEY**: `Id`
- **INDEX**: `idx_test_paper` ON `TestPaperId`
- **INDEX**: `idx_status` ON `Status`
- **INDEX**: `idx_created_at` ON `CreatedAt`
- **INDEX**: `idx_email` ON `Email`

---

## 7. TestAnswer（受測作答明細檔）

### 表格說明
記錄受測者對每個題目的作答內容。

### 欄位定義

| 欄位名稱 | 資料型別 | 長度 | NULL | 預設值 | 主鍵 | 外鍵 | 說明 |
|---------|---------|------|------|--------|------|------|------|
| Id | INT | - | NOT NULL | AUTO_INCREMENT | PK | - | 主鍵 |
| TestSessionId | INT | - | NOT NULL | - | - | FK | 受測ID |
| TestPaperDetailId | INT | - | NOT NULL | - | - | FK | 測卷明細ID |
| AnswerValue | INT | - | NOT NULL | - | - | - | 作答值 |
| AnswerText | NVARCHAR | 1000 | NULL | - | - | - | 文字作答（開放題） |
| AnsweredAt | DATETIME | - | NOT NULL | CURRENT_TIMESTAMP | - | - | 作答時間 |

### 外鍵約束
- `FK_TestAnswer_TestSession`: `TestSessionId` → `TestSession(Id)` ON DELETE CASCADE
- `FK_TestAnswer_TestPaperDetail`: `TestPaperDetailId` → `TestPaperDetail(Id)`

### 索引定義
- **PRIMARY KEY**: `Id`
- **UNIQUE KEY**: `uk_session_detail` ON (`TestSessionId`, `TestPaperDetailId`)
- **INDEX**: `idx_test_session` ON `TestSessionId`
- **INDEX**: `idx_answered_at` ON `AnsweredAt`

---

## 資料庫關聯圖（ER Diagram）

```
InstrumentCategory (1) ──────< (N) QuestionBank
TraitCategory (1) ──────< (N) QuestionBank
TestPaper (1) ──────< (N) TestPaperDetail
QuestionBank (1) ──────< (N) TestPaperDetail
TestPaper (1) ──────< (N) TestSession
TestSession (1) ──────< (N) TestAnswer
TestPaperDetail (1) ──────< (N) TestAnswer
```

---

# MySQL DDL 語句

## 建立資料庫

```sql
-- 建立資料庫
CREATE DATABASE IF NOT EXISTS PsychometricTestDB
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE PsychometricTestDB;
```

## 建立資料表

### 1. InstrumentCategory（量表分類主檔）

```sql
CREATE TABLE InstrumentCategory (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NameEn VARCHAR(100) NOT NULL,
    NameZh NVARCHAR(100) NOT NULL,
    Code VARCHAR(20) NULL,
    Description NVARCHAR(500) NULL,
    IsActive BOOLEAN NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_code (Code),
    INDEX idx_name_en (NameEn)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='量表分類主檔';
```

### 2. TraitCategory（特質面向分類主檔）

```sql
CREATE TABLE TraitCategory (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    NameEn VARCHAR(100) NOT NULL,
    NameZh NVARCHAR(100) NOT NULL,
    Code VARCHAR(20) NULL,
    Description NVARCHAR(500) NULL,
    IsActive BOOLEAN NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_code (Code),
    INDEX idx_name_en (NameEn)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='特質面向分類主檔';
```

### 3. QuestionBank（題庫主檔）

```sql
CREATE TABLE QuestionBank (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    InstrumentCategoryId INT NOT NULL,
    TraitCategoryId INT NOT NULL,
    TextEn TEXT NOT NULL,
    TextZh TEXT NOT NULL,
    Alpha DECIMAL(5,3) NULL COMMENT '信度係數',
    `Key` TINYINT NOT NULL DEFAULT 1 COMMENT '計分方向: 1=正向, -1=反向',
    QuestionCode VARCHAR(50) NULL,
    IsActive BOOLEAN NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_question_code (QuestionCode),
    INDEX idx_instrument (InstrumentCategoryId),
    INDEX idx_trait (TraitCategoryId),
    INDEX idx_active (IsActive),
    CONSTRAINT FK_QuestionBank_InstrumentCategory 
        FOREIGN KEY (InstrumentCategoryId) 
        REFERENCES InstrumentCategory(Id),
    CONSTRAINT FK_QuestionBank_TraitCategory 
        FOREIGN KEY (TraitCategoryId) 
        REFERENCES TraitCategory(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='題庫主檔';
```

### 4. TestPaper（測卷主檔）

```sql
CREATE TABLE TestPaper (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Code VARCHAR(20) NULL,
    Description NVARCHAR(1000) NULL,
    ResponseType VARCHAR(50) NOT NULL COMMENT 'Likert5, Likert7, YesNo, MultipleChoice',
    TimeLimit INT NULL COMMENT '作答時間限制（分鐘）',
    TotalQuestions INT NOT NULL DEFAULT 0,
    IsActive BOOLEAN NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY uk_code (Code),
    INDEX idx_active (IsActive)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='測卷主檔';
```

### 5. TestPaperDetail（測卷明細檔）

```sql
CREATE TABLE TestPaperDetail (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    TestPaperId INT NOT NULL,
    QuestionBankId INT NOT NULL,
    QuestionOrder INT NOT NULL COMMENT '題目順序',
    IsRequired BOOLEAN NOT NULL DEFAULT 1,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_paper_question (TestPaperId, QuestionBankId),
    INDEX idx_test_paper (TestPaperId),
    INDEX idx_question_order (TestPaperId, QuestionOrder),
    CONSTRAINT FK_TestPaperDetail_TestPaper 
        FOREIGN KEY (TestPaperId) 
        REFERENCES TestPaper(Id) 
        ON DELETE CASCADE,
    CONSTRAINT FK_TestPaperDetail_QuestionBank 
        FOREIGN KEY (QuestionBankId) 
        REFERENCES QuestionBank(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='測卷明細檔';
```

### 6. TestSession（受測主檔）

```sql
CREATE TABLE TestSession (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    TestPaperId INT NOT NULL,
    TestTakerName NVARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NULL,
    Email VARCHAR(100) NULL,
    BirthDate DATE NULL,
    Gender VARCHAR(10) NULL COMMENT 'Male, Female, Other',
    Status VARCHAR(20) NOT NULL DEFAULT 'NotStarted' COMMENT 'NotStarted, InProgress, Completed, Abandoned',
    StartedAt DATETIME NULL,
    CompletedAt DATETIME NULL,
    CreatedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_test_paper (TestPaperId),
    INDEX idx_status (Status),
    INDEX idx_created_at (CreatedAt),
    INDEX idx_email (Email),
    CONSTRAINT FK_TestSession_TestPaper 
        FOREIGN KEY (TestPaperId) 
        REFERENCES TestPaper(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='受測主檔';
```

### 7. TestAnswer（受測作答明細檔）

```sql
CREATE TABLE TestAnswer (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    TestSessionId INT NOT NULL,
    TestPaperDetailId INT NOT NULL,
    AnswerValue INT NOT NULL,
    AnswerText NVARCHAR(1000) NULL COMMENT '文字作答（開放題）',
    AnsweredAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uk_session_detail (TestSessionId, TestPaperDetailId),
    INDEX idx_test_session (TestSessionId),
    INDEX idx_answered_at (AnsweredAt),
    CONSTRAINT FK_TestAnswer_TestSession 
        FOREIGN KEY (TestSessionId) 
        REFERENCES TestSession(Id) 
        ON DELETE CASCADE,
    CONSTRAINT FK_TestAnswer_TestPaperDetail 
        FOREIGN KEY (TestPaperDetailId) 
        REFERENCES TestPaperDetail(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='受測作答明細檔';
```

---

# ASP.NET Core Entity Classes

## 1. InstrumentCategory.cs

```csharp
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PsychometricTest.Models
{
    [Table("InstrumentCategory")]
    public class InstrumentCategory
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string NameEn { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string NameZh { get; set; } = string.Empty;

        [MaxLength(20)]
        public string? Code { get; set; }

        [MaxLength(500)]
        public string? Description { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public DateTime? UpdatedAt { get; set; }

        // Navigation Properties
        public virtual ICollection<QuestionBank> QuestionBanks { get; set; } = new List<QuestionBank>();
    }
}
```

## 2. TraitCategory.cs

```csharp
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PsychometricTest.Models
{
    [Table("TraitCategory")]
    public class TraitCategory
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string NameEn { get; set; } = string.Empty;

        [Required]
        [MaxLength(100)]
        public string NameZh { get; set; } = string.Empty;

        [MaxLength(20)]
        public string? Code { get; set; }

        [MaxLength(500)]
        public string? Description { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public DateTime? UpdatedAt { get; set; }

        // Navigation Properties
        public virtual ICollection<QuestionBank> QuestionBanks { get; set; } = new List<QuestionBank>();
    }
}
```

## 3. QuestionBank.cs

```csharp
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PsychometricTest.Models
{
    [Table("QuestionBank")]
    public class QuestionBank
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        public int InstrumentCategoryId { get; set; }

        [Required]
        public int TraitCategoryId { get; set; }

        [Required]
        [Column(TypeName = "TEXT")]
        public string TextEn { get; set; } = string.Empty;

        [Required]
        [Column(TypeName = "TEXT")]
        public string TextZh { get; set; } = string.Empty;

        [Column(TypeName = "decimal(5,3)")]
        public decimal? Alpha { get; set; }

        [Required]
        [Column("Key")]
        public sbyte Key { get; set; } = 1; // 1=正向, -1=反向

        [MaxLength(50)]
        public string? QuestionCode { get; set; }

        [Required]
        public bool IsActive { get; set; } = true;

        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public DateTime? UpdatedAt { get; set; }

        // Navigation Properties
        [ForeignKey("InstrumentCategoryId")]
        public virtual InstrumentCategory InstrumentCategory { get; set; } = null!;

        [ForeignKey("TraitCategoryId")]
        public virtual TraitCategory TraitCategory { get; set; } = null!;

        public virtual ICollection<TestPaperDetail> TestPaperDetails { get; set; } = new List<TestPaperDetail>();
    }
}
```

## 4. TestPaper.cs

```csharp
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PsychometricTest.Models
{
    [Table("TestPaper")]
    public class TestPaper
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        [MaxLength(100)]
        public string Name { get; set; } = string.Empty;

        [MaxLength(20)]
        public string? Code { get; set; }

        [MaxLength(1000)]
        public string? Description { get; set; }

        [Required]
        [MaxLength(50)]
        public string ResponseType { get; set; } = string.Empty; // Likert5, Likert7, YesNo, MultipleChoice

        public int? TimeLimit { get; set; }

        [Required]
        public int TotalQuestions { get; set; } = 0;

        [Required]
        public bool IsActive { get; set; } = true;

        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public DateTime? UpdatedAt { get; set; }

        // Navigation Properties
        public virtual ICollection<TestPaperDetail> TestPaperDetails { get; set; } = new List<TestPaperDetail>();
        public virtual ICollection<TestSession> TestSessions { get; set; } = new List<TestSession>();
    }
}
```

## 5. TestPaperDetail.cs

```csharp
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PsychometricTest.Models
{
    [Table("TestPaperDetail")]
    public class TestPaperDetail
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        public int TestPaperId { get; set; }

        [Required]
        public int QuestionBankId { get; set; }

        [Required]
        public int QuestionOrder { get; set; }

        [Required]
        public bool IsRequired { get; set; } = true;

        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        // Navigation Properties
        [ForeignKey("TestPaperId")]
        public virtual TestPaper TestPaper { get; set; } = null!;

        [ForeignKey("QuestionBankId")]
        public virtual QuestionBank QuestionBank { get; set; } = null!;

        public virtual ICollection<TestAnswer> TestAnswers { get; set; } = new List<TestAnswer>();
    }
}
```

## 6. TestSession.cs

```csharp
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PsychometricTest.Models
{
    [Table("TestSession")]
    public class TestSession
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        public int TestPaperId { get; set; }

        [Required]
        [MaxLength(100)]
        public string TestTakerName { get; set; } = string.Empty;

        [MaxLength(20)]
        public string? Phone { get; set; }

        [MaxLength(100)]
        [EmailAddress]
        public string? Email { get; set; }

        [DataType(DataType.Date)]
        public DateTime? BirthDate { get; set; }

        [MaxLength(10)]
        public string? Gender { get; set; } // Male, Female, Other

        [Required]
        [MaxLength(20)]
        public string Status { get; set; } = "NotStarted"; // NotStarted, InProgress, Completed, Abandoned

        public DateTime? StartedAt { get; set; }

        public DateTime? CompletedAt { get; set; }

        [Required]
        public DateTime CreatedAt { get; set; } = DateTime.Now;

        public DateTime? UpdatedAt { get; set; }

        // Navigation Properties
        [ForeignKey("TestPaperId")]
        public virtual TestPaper TestPaper { get; set; } = null!;

        public virtual ICollection<TestAnswer> TestAnswers { get; set; } = new List<TestAnswer>();
    }
}
```

## 7. TestAnswer.cs

```csharp
using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PsychometricTest.Models
{
    [Table("TestAnswer")]
    public class TestAnswer
    {
        [Key]
        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        public int Id { get; set; }

        [Required]
        public int TestSessionId { get; set; }

        [Required]
        public int TestPaperDetailId { get; set; }

        [Required]
        public int AnswerValue { get; set; }

        [MaxLength(1000)]
        public string? AnswerText { get; set; }

        [Required]
        public DateTime AnsweredAt { get; set; } = DateTime.Now;

        // Navigation Properties
        [ForeignKey("TestSessionId")]
        public virtual TestSession TestSession { get; set; } = null!;

        [ForeignKey("TestPaperDetailId")]
        public virtual TestPaperDetail TestPaperDetail { get; set; } = null!;
    }
}
```

---

## DbContext 設定

### PsychometricTestDbContext.cs

```csharp
using Microsoft.EntityFrameworkCore;

namespace PsychometricTest.Data
{
    public class PsychometricTestDbContext : DbContext
    {
        public PsychometricTestDbContext(DbContextOptions<PsychometricTestDbContext> options)
            : base(options)
        {
        }

        public DbSet<InstrumentCategory> InstrumentCategories { get; set; }
        public DbSet<TraitCategory> TraitCategories { get; set; }
        public DbSet<QuestionBank> QuestionBanks { get; set; }
        public DbSet<TestPaper> TestPapers { get; set; }
        public DbSet<TestPaperDetail> TestPaperDetails { get; set; }
        public DbSet<TestSession> TestSessions { get; set; }
        public DbSet<TestAnswer> TestAnswers { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // InstrumentCategory
            modelBuilder.Entity<InstrumentCategory>(entity =>
            {
                entity.HasIndex(e => e.Code).IsUnique();
                entity.HasIndex(e => e.NameEn);
            });

            // TraitCategory
            modelBuilder.Entity<TraitCategory>(entity =>
            {
                entity.HasIndex(e => e.Code).IsUnique();
                entity.HasIndex(e => e.NameEn);
            });

            // QuestionBank
            modelBuilder.Entity<QuestionBank>(entity =>
            {
                entity.HasIndex(e => e.QuestionCode).IsUnique();
                entity.HasIndex(e => e.InstrumentCategoryId);
                entity.HasIndex(e => e.TraitCategoryId);
                entity.HasIndex(e => e.IsActive);

                entity.HasOne(d => d.InstrumentCategory)
                    .WithMany(p => p.QuestionBanks)
                    .HasForeignKey(d => d.InstrumentCategoryId)
                    .OnDelete(DeleteBehavior.Restrict);

                entity.HasOne(d => d.TraitCategory)
                    .WithMany(p => p.QuestionBanks)
                    .HasForeignKey(d => d.TraitCategoryId)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            // TestPaper
            modelBuilder.Entity<TestPaper>(entity =>
            {
                entity.HasIndex(e => e.Code).IsUnique();
                entity.HasIndex(e => e.IsActive);
            });

            // TestPaperDetail
            modelBuilder.Entity<TestPaperDetail>(entity =>
            {
                entity.HasIndex(e => new { e.TestPaperId, e.QuestionBankId }).IsUnique();
                entity.HasIndex(e => e.TestPaperId);
                entity.HasIndex(e => new { e.TestPaperId, e.QuestionOrder });

                entity.HasOne(d => d.TestPaper)
                    .WithMany(p => p.TestPaperDetails)
                    .HasForeignKey(d => d.TestPaperId)
                    .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(d => d.QuestionBank)
                    .WithMany(p => p.TestPaperDetails)
                    .HasForeignKey(d => d.QuestionBankId)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            // TestSession
            modelBuilder.Entity<TestSession>(entity =>
            {
                entity.HasIndex(e => e.TestPaperId);
                entity.HasIndex(e => e.Status);
                entity.HasIndex(e => e.CreatedAt);
                entity.HasIndex(e => e.Email);

                entity.HasOne(d => d.TestPaper)
                    .WithMany(p => p.TestSessions)
                    .HasForeignKey(d => d.TestPaperId)
                    .OnDelete(DeleteBehavior.Restrict);
            });

            // TestAnswer
            modelBuilder.Entity<TestAnswer>(entity =>
            {
                entity.HasIndex(e => new { e.TestSessionId, e.TestPaperDetailId }).IsUnique();
                entity.HasIndex(e => e.TestSessionId);
                entity.HasIndex(e => e.AnsweredAt);

                entity.HasOne(d => d.TestSession)
                    .WithMany(p => p.TestAnswers)
                    .HasForeignKey(d => d.TestSessionId)
                    .OnDelete(DeleteBehavior.Cascade);

                entity.HasOne(d => d.TestPaperDetail)
                    .WithMany(p => p.TestAnswers)
                    .HasForeignKey(d => d.TestPaperDetailId)
                    .OnDelete(DeleteBehavior.Restrict);
            });
        }
    }
}
```

---

## appsettings.json 設定

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=PsychometricTestDB;User=root;Password=your_password;CharSet=utf8mb4;"
  },
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    }
  },
  "AllowedHosts": "*"
}
```

---

## Program.cs 設定

```csharp
using Microsoft.EntityFrameworkCore;
using PsychometricTest.Data;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

// Add DbContext
builder.Services.AddDbContext<PsychometricTestDbContext>(options =>
    options.UseMySql(
        builder.Configuration.GetConnectionString("DefaultConnection"),
        ServerVersion.AutoDetect(builder.Configuration.GetConnectionString("DefaultConnection"))
    )
);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
```

---

## 必要的 NuGet 套件

在專案中執行以下命令安裝必要套件：

```bash
dotnet add package Microsoft.EntityFrameworkCore
dotnet add package Microsoft.EntityFrameworkCore.Design
dotnet add package Pomelo.EntityFrameworkCore.MySql
dotnet add package Microsoft.EntityFrameworkCore.Tools
```

---

## 資料庫遷移（Migration）

### 建立初始遷移

```bash
dotnet ef migrations add InitialCreate
```

### 更新資料庫

```bash
dotnet ef database update
```

---

## 資料驗證與業務規則

### 1. 資料完整性約束
- 所有主鍵使用 `AUTO_INCREMENT`
- 外鍵必須存在對應的主鍵值
- 唯一性約束防止重複資料

### 2. 作答流程驗證
- 受測者必須先建立 TestSession
- 只能作答該測卷包含的題目
- 每題只能作答一次（UNIQUE 約束）

### 3. 狀態管理
- TestSession.Status 追蹤測驗進度
- StartedAt 記錄第一次作答時間
- CompletedAt 記錄完成時間

---

## 範例資料插入（Sample Data）

### 插入量表分類

```sql
INSERT INTO InstrumentCategory (NameEn, NameZh, Code) VALUES
('Big Five Personality', '大五人格', 'BF'),
('16PF', '16PF人格測驗', '16PF'),
('MMPI', '明尼蘇達多相人格測驗', 'MMPI'),
('MBTI', 'MBTI人格類型指標', 'MBTI');
```

### 插入特質面向

```sql
INSERT INTO TraitCategory (NameEn, NameZh, Code) VALUES
('Openness', '開放性', 'O'),
('Conscientiousness', '盡責性', 'C'),
('Extraversion', '外向性', 'E'),
('Agreeableness', '親和性', 'A'),
('Neuroticism', '神經質', 'N');
```

### 插入題目

```sql
INSERT INTO QuestionBank (InstrumentCategoryId, TraitCategoryId, TextEn, TextZh, Alpha, `Key`, QuestionCode) VALUES
(1, 1, 'I am full of ideas.', '我充滿創意。', 0.85, 1, 'BF_O_001'),
(1, 2, 'I am always prepared.', '我總是做好準備。', 0.82, 1, 'BF_C_001'),
(1, 3, 'I am the life of the party.', '我是派對的焦點。', 0.88, 1, 'BF_E_001'),
(1, 4, 'I sympathize with others feelings.', '我能同理他人的感受。', 0.79, 1, 'BF_A_001'),
(1, 5, 'I get stressed out easily.', '我容易感到壓力。', 0.81, 1, 'BF_N_001');
```

### 插入測卷

```sql
INSERT INTO TestPaper (Name, Code, Description, ResponseType, TimeLimit, TotalQuestions) VALUES
('大五人格測驗', 'BF_TEST_01', '評估個體在五大人格特質上的表現', 'Likert5', 30, 50);
```

### 插入測卷明細

```sql
INSERT INTO TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder) VALUES
(1, 1, 1),
(1, 2, 2),
(1, 3, 3),
(1, 4, 4),
(1, 5, 5);
```

---

## 查詢範例

### 1. 取得測卷的所有題目

```sql
SELECT 
    tpd.QuestionOrder,
    qb.TextZh,
    tc.NameZh AS TraitName,
    ic.NameZh AS InstrumentName
FROM TestPaperDetail tpd
INNER JOIN QuestionBank qb ON tpd.QuestionBankId = qb.Id
INNER JOIN TraitCategory tc ON qb.TraitCategoryId = tc.Id
INNER JOIN InstrumentCategory ic ON qb.InstrumentCategoryId = ic.Id
WHERE tpd.TestPaperId = 1
ORDER BY tpd.QuestionOrder;
```

### 2. 取得受測者的作答記錄

```sql
SELECT 
    ts.TestTakerName,
    qb.TextZh AS Question,
    ta.AnswerValue,
    ta.AnsweredAt
FROM TestAnswer ta
INNER JOIN TestSession ts ON ta.TestSessionId = ts.Id
INNER JOIN TestPaperDetail tpd ON ta.TestPaperDetailId = tpd.Id
INNER JOIN QuestionBank qb ON tpd.QuestionBankId = qb.Id
WHERE ts.Id = 1
ORDER BY tpd.QuestionOrder;
```

### 3. 統計測卷完成率

```sql
SELECT 
    tp.Name,
    COUNT(DISTINCT ts.Id) AS TotalSessions,
    SUM(CASE WHEN ts.Status = 'Completed' THEN 1 ELSE 0 END) AS CompletedSessions,
    ROUND(SUM(CASE WHEN ts.Status = 'Completed' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT ts.Id), 2) AS CompletionRate
FROM TestPaper tp
INNER JOIN TestSession ts ON tp.Id = ts.TestPaperId
GROUP BY tp.Id, tp.Name;
```

---

## 注意事項

1. **字元編碼**: 使用 `utf8mb4` 以支援完整的 Unicode 字元（包括表情符號）
2. **時區處理**: 建議在應用程式層統一使用 UTC 時間
3. **軟刪除**: 使用 `IsActive` 欄位實現軟刪除，避免直接刪除資料
4. **索引優化**: 根據查詢頻率建立適當索引
5. **資料備份**: 定期備份資料庫，特別是在 Production 環境
6. **安全性**: 使用參數化查詢防止 SQL Injection
7. **效能考量**: 對於大量資料查詢，考慮使用分頁和快取機制

---

## 版本記錄

| 版本 | 日期 | 說明 | 作者 |
|------|------|------|------|
| 1.0 | 2025-11-30 | 初始版本 | System |

---

