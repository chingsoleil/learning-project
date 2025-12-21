"""
IPIP 測驗選題腳本概念

此腳本用於從 QuestionBank.csv 中選題，生成測驗的 MD 檔和 INSERT 指令。

使用方式：
1. 讀取 QuestionBank.csv
2. 根據測驗需求篩選題目
3. 平衡正向題和反向題
4. 隨機排序
5. 生成 MD 檔和 SQL INSERT 指令
"""

import csv
import random
from collections import defaultdict

# 測驗配置
TEST_CONFIGS = {
    1: {
        'name': '大五人格快速評估',
        'code': 'BIG5_QUICK_01',
        'description': '全面評估五大人格特質',
        'instruments': [17, 26],  # Goldberg1999, NEO
        'traits': {
            64: 10,  # Extraversion
            8: 10,   # Agreeableness
            34: 10,  # Conscientiousness
            156: 10, # Neuroticism
            162: 10  # Openness To Experience
        }
    },
    # ... 其他測驗配置
}

def load_question_bank(csv_path):
    """讀取題庫CSV"""
    questions = []
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        for row in reader:
            if len(row) >= 9:
                q = {
                    'Id': int(row[0]),
                    'InstrumentCategoryId': int(row[1]),
                    'TraitCategoryId': int(row[2]),
                    'TextEn': row[3],
                    'TextZh': row[4],
                    'Alpha': float(row[5]) if row[5] else 0.0,
                    'ScoringKey': int(row[7]),
                    'IsActive': int(row[9]) == 1
                }
                if q['IsActive'] and q['Alpha'] >= 0.70:
                    questions.append(q)
    return questions

def select_questions(questions, config):
    """根據配置選題"""
    selected = []
    
    for trait_id, count in config['traits'].items():
        # 篩選符合條件的題目
        candidates = [
            q for q in questions
            if q['InstrumentCategoryId'] in config['instruments']
            and q['TraitCategoryId'] == trait_id
        ]
        
        # 按 Alpha 排序
        candidates.sort(key=lambda x: x['Alpha'], reverse=True)
        
        # 平衡正向題和反向題
        positive = [q for q in candidates if q['ScoringKey'] == 1]
        negative = [q for q in candidates if q['ScoringKey'] == -1]
        
        # 選擇題目（60-70% 正向，30-40% 反向）
        pos_count = int(count * 0.65)
        neg_count = count - pos_count
        
        selected.extend(positive[:pos_count])
        selected.extend(negative[:neg_count])
    
    # 隨機排序
    random.shuffle(selected)
    
    return selected[:50]  # 確保只有50題

def generate_md(test_id, config, selected_questions):
    """生成MD檔"""
    md_content = f"""# {config['name']}

## 測驗基本資訊

| 欄位 | 值 |
|------|-----|
| Name | {config['name']} |
| Code | {config['code']} |
| Description | {config['description']} |
| ResponseType | Likert5 |
| TimeLimit | 20 |
| TotalQuestions | 50 |
| IsActive | 1 |

## 使用的 Instruments

"""
    
    # 添加 Instruments
    for inst_id in config['instruments']:
        md_content += f"- InstrumentId: {inst_id}\n"
    
    md_content += "\n## 使用的 Traits\n\n"
    
    # 添加 Traits
    for trait_id, count in config['traits'].items():
        md_content += f"- TraitId: {trait_id} - {count}題\n"
    
    md_content += "\n## 題目清單\n\n"
    md_content += "| 順序 | QuestionBankId | 題目文字 | TraitId | InstrumentId | Alpha | ScoringKey | IsRequired |\n"
    md_content += "|------|----------------|---------|---------|-------------|-------|-----------|-----------|\n"
    
    for i, q in enumerate(selected_questions, 1):
        md_content += f"| {i} | {q['Id']} | {q['TextZh']} | {q['TraitCategoryId']} | {q['InstrumentCategoryId']} | {q['Alpha']:.3f} | {q['ScoringKey']} | 1 |\n"
    
    # 統計資訊
    positive_count = sum(1 for q in selected_questions if q['ScoringKey'] == 1)
    negative_count = sum(1 for q in selected_questions if q['ScoringKey'] == -1)
    avg_alpha = sum(q['Alpha'] for q in selected_questions) / len(selected_questions)
    min_alpha = min(q['Alpha'] for q in selected_questions)
    
    md_content += f"""
## 統計資訊

- 總題數：{len(selected_questions)}
- 正向題數：{positive_count} ({positive_count/len(selected_questions)*100:.1f}%)
- 反向題數：{negative_count} ({negative_count/len(selected_questions)*100:.1f}%)
- 平均 Alpha：{avg_alpha:.3f}
- 最低 Alpha：{min_alpha:.3f}

## SQL INSERT 指令

### TestPaper INSERT

```sql
INSERT INTO TestPaper (Name, Code, Description, ResponseType, TimeLimit, TotalQuestions, IsActive)
VALUES ('{config['name']}', '{config['code']}', '{config['description']}', 'Likert5', 20, 50, 1);
```

### TestPaperDetail INSERT

```sql
-- 假設 TestPaper 的 Id 為 @TestPaperId（需根據實際 INSERT 結果調整）
INSERT INTO TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired)
VALUES
"""
    
    for i, q in enumerate(selected_questions, 1):
        comma = "," if i < len(selected_questions) else ";"
        md_content += f"    (@TestPaperId, {q['Id']}, {i}, 1){comma}\n"
    
    md_content += "```\n"
    
    return md_content

# 主程式
if __name__ == '__main__':
    # 讀取題庫
    questions = load_question_bank('ex06/database-planning/mssql/QuestionBank.csv')
    
    # 為每個測驗選題並生成MD檔
    for test_id, config in TEST_CONFIGS.items():
        selected = select_questions(questions, config)
        md_content = generate_md(test_id, config, selected)
        
        with open(f'ex07/測驗{test_id}_{config["code"]}.md', 'w', encoding='utf-8') as f:
            f.write(md_content)
        
        print(f"已生成測驗 {test_id}: {config['name']}")

