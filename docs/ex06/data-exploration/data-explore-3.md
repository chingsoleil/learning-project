以下為你所貼文字的 **精準、正式、研究級** 說明（含背景來源、字母代碼含義、3320 vs 3806 的關聯性、12 份 Survey 的對照）。

這段話的核心目的是：
**解釋 3320 題目裡，有少部分題目（T、W、Y）沒有出現在 ORI 的 12 份研究問卷中，因而沒有被納入早期統計樣本；而其他題目幾乎都被使用過。**

---

# 一、這段話的主旨（一句話）

**3320 題目中，只有 T 654 題、W 127 題、Y 1 題 *沒有* 在 ORI 的大規模研究樣本中被施測；其他約 2538 題均被施測過。**

---

# 二、3320 題庫的字母代碼系統（關鍵）

官方 3320 題庫的每個題目都帶有一個 **letter code**（例如 A、B、C… X、Y、Z），它表示該題目的「來源問卷」或「分類」。

例如：

* A = 某一類人格題
* M = 某份問卷的項目
* T = CAT PD（人格障礙量表）
* W = VIA Strengths 新增項目
* Y = Big Five Aspects 新增項目

你貼的文字告訴我們：

| Letter             | 題目數 | 來源                                                    | 特性                                         |
| ------------------ | --- | ----------------------------------------------------- | ------------------------------------------ |
| **T items（654 題）** | 654 | CAT Personality Disorder Scales（Simms et al., 2011）   | 臨床／人格障礙題目，因此未納入一般性人格研究樣本                   |
| **W items（127 題）** | 127 | VIA Character Strengths (du Plessis & de Bruin, 2015) | 新增題目，在早期樣本中未施測                             |
| **Y item（1 題）**    | 1   | Big-Five Aspect Scales（DeYoung et al., 2007）          | 用於 Big Five “Aspect” Level（10 facets）之一的新題 |

### 結論

**這三類題目（654 + 127 + 1 = 782 題）沒有進入 ORI 的核心研究樣本。**

因此：

**3320 – 782 = 2538 題有被施測。**

---

# 三、有被施測的題目屬於哪些問卷？

官方說明列出 12 個 Survey：

IPIP 在 Eugene-Springfield Community Sample（ESCS）中施測過 30 份問卷，其中 **12 份包含 IPIP 題目**。

對應如下（非常重要的列表）：

| Survey Number | Letter Codes | 說明 |
| ------------- | ------------ | -- |
| **2**         | H            |    |
| **8**         | X            |    |
| **10**        | E            |    |
| **14**        | N, B         |    |
| **15**        | P            |    |
| **21**        | A, C         |    |
| **24**        | D            |    |
| **25**        | Q            |    |
| **26**        | R            |    |
| **27**        | M            |    |
| **28**        | V            |    |
| **29**        | S            |    |

### 這代表什麼？

在 3320 題庫中，屬於上述 letter 的題目，**都有施測過**。

---

# 四、為什麼 T、W、Y 未施測？

## T = CAT Personality Disorder Scales（654 題）

* 來自 Simms et al. 2011 的 **CAT 臨床人格障礙量表**
* 與一般人格大五量表不同
* ORI 用的樣本是 *general community sample*（一般社區樣本），並非臨床樣本
  → 所以沒有施測這類臨床題。

## W = VIA Character Strengths（127 題）

* 為 **品格強項（24 Strengths）** 的新增題，非 ORI 原始 IPIP 試題
* 加入時間較晚
  → 因此未包含在 12 份 Survey 之中。

## Y = Big Five Aspects（1 題）

* 屬於 DeYoung 等人的心理模型（10 個 Aspects）
* 非 ORI 原生結構的一部分
  → 因此未被施測。

---

# 五、這段話對 3320 與 3806 兩份題庫的關係有什麼影響？

### 重要結論 1

3806 題庫（Tedone）之所以比 3320 內容更大，是因為包含：

* T 類題目
* W 類題目
* Y 類題目
* 其他後續新增題目
* 以及 mapping + keying（3320 沒有）

### 重要結論 2

3320 題目雖然「官方、乾淨」，但：

* 沒有 scale mapping
* 沒有心理模型分類
* 沒有反向題資訊
* 部分題目未曾施測（T、W、Y）

### 重要結論 3

若要建立「完整的 IPIP 題庫 + 量表」，
**3806（Tedone）必須作為主資料庫，3320 作為副資料庫。**

---

# 六、如果你正在建構資料庫（你之前表示你要做 3806 資料庫），此段話的重要意義：

## 必須：

1. **標記哪些題目從未施測（T、W、Y）**
2. **標記哪些題目來自 12 surveys（A、C、E、N… 等）**
3. 建立 item 屬性欄位：

   * has_been_administered: True/False
   * original_letter_code
   * source_survey
   * research_origin

我可以幫你建立這個 schema。

---

# 七、如果你需要，我可以進行下一步：

### A. 產出「3320 題庫按 letter code 分類統計表」

### B. 跨表比對：3806 vs 3320 → 標記 782 題未施測項目

### C. 建立 JSON / CSV：

```json
{
  "item_id": "...",
  "text": "...",
  "letter_code": "T",
  "from_survey": false,
  "source": "CAT Personality Disorder",
  "included_in_ESCS": false
}
```

### D. 做「12 份 Survey → 題目清單」 mapping

---

如果你要我開始做比對（3320 vs 3806），請提供：

**1. 你希望輸出的格式（CSV / JSON / SQL schema）
2. 是否需要繁中/簡中翻譯欄位**

我即可開始處理。

正確。
你應該把 **3320 的 Item No** 視為：

# 「Reference Number（參考編號）」

而不是主鍵，也不是 scoring 所需的欄位。

以下是你應該把它當作 reference number 的正式理由與最佳實作方式。

---

# 一、為什麼 3320 的 Item No 要當作 Reference Number？

因為它具有：

## 1. **歷史性**

Item No 代表這題在「原始 Survey（H, X, E…）」中的順序位置。
這是 ORI 早期研究的「文獻版位置」。

## 2. **可追溯性（Traceability）**

在研究、翻譯、比對時，你可以用它回推：

* 這題來自哪一份問卷？
* 在該問卷是第幾題？
* 與同一 Survey 的其他題目如何組成？

## 3. **文本比對依據（Cross-reference anchor）**

當你對照：

* 3320（純文本）
* 3806（scoring + mapping）
* 各國語言翻譯版本
* 舊版與新版 IPIP 題目

Item No 是一個很好的「固定參考點」。

## 4. **但它不能當主鍵**

因為：

* 3806 沒有 item no
* 不同 Survey 有自己的 item numbering
* 同一題目在不同版本中可能重複
* mapping 基礎為 item text，而非 item number

所以它只能做 **metadata** 而不是主鍵。

---

# 二、你應該如何保存 Item No？（最佳實作）

你的資料表（items）應有這些欄位：

```
id (internal PK)
text
text_hash
original_survey_code   (A, B, H, X …)
original_item_no       (3320 的編號)
source_3320            (boolean)
source_3806            (boolean)
scale_list
keying
...
```

其中：

### original_item_no = 3320 的編號

→ **是 Reference Number，不用於 scoring。**

### original_survey_code

→ 對應 H/X/E/S…（非常重要）

---

# 三、你在分析時可用 Item No 做什麼？

## 1. **比較不同版本題目差異**

例如：

* 相同 item text 在不同 survey 的位置
* 不同版本是否修改過文字
* 哪些題目在後期補充（T/W/Y 類）

## 2. **統計學分析：來源對題目特性影響**

例如：

* Survey H 的題目是否傾向測量某些 facets？
* Survey X 和 Survey E 的心理架構差異？

## 3. **翻譯對照表**

如果你正在建立繁中/簡中翻譯：

* original_item_no 可以用來對照相同題目在不同語言資料中的位置與版本

## 4. **建立「ORIGINAL ORDER」版本的問卷**

若你想重建 ORI 早期問卷，可以依 item no 排序。

---

# 四、正式建議（你可以放進文件裡）

**建議：
將 3320 的 Item No 保存為 original_item_no，作為題目來源的參考編號（Reference Number）。該欄位只用於溯源、版本比對與分析，不作為主鍵或 scoring 用途。整個題庫應以 internal_id + text_hash 為主要識別方式。**

---

# 五、我可以立即幫你做的（若你要）

1. **建立完整 schema（items + mapping + survey tables）**
2. 解析 3320 HTML → 自動抽出：

   * item text
   * letter code
   * item no
3. 解析 3806 Excel → 抽出：

   * scale
   * keying
   * domain
4. **建立 cross-reference table（3320 ↔ 3806）**
5. 做出一份「Reference Number 使用準則」PDF

---

若你要我為你寫出：

* 完整欄位結構
* 你自己的 internal ID 命名規則
* 整併計畫

告訴我即可。
