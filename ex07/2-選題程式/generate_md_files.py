"""
Generate complete MD files for all 5 tests
"""

# Test configurations
TEST_CONFIGS = {
    2: {
        'name': '職場人格評估',
        'code': 'WORKPLACE_PERSONALITY_01',
        'description': '評估職場相關人格特質，聚焦職場表現相關特質，適合人才招募、團隊配置',
        'file': 'ex07/test2_selected_questions.txt',
        'output': 'ex07/測驗2_職場人格評估_實際題目.md'
    },
    3: {
        'name': '情緒與人際關係',
        'code': 'EMOTION_INTERPERSONAL_01',
        'description': '評估情緒管理與人際互動能力，深入評估情緒與人際面向，適合人際關係改善、情緒管理',
        'file': 'ex07/test3_selected_questions.txt',
        'output': 'ex07/測驗3_情緒與人際關係_實際題目.md'
    },
    4: {
        'name': '創造力與開放性',
        'code': 'CREATIVITY_OPENNESS_01',
        'description': '評估創造力、學習能力與開放性，聚焦創造力與學習相關特質，適合教育評估、創意產業',
        'file': 'ex07/test4_selected_questions.txt',
        'output': 'ex07/測驗4_創造力與開放性_實際題目.md'
    },
    5: {
        'name': '全面人格評估',
        'code': 'COMPREHENSIVE_PERSONALITY_01',
        'description': '多維度全面人格評估，最全面的人格評估，涵蓋多個理論模型，適合深度人格分析、研究用途',
        'file': 'ex07/test5_selected_questions.txt',
        'output': 'ex07/測驗5_全面人格評估_實際題目.md'
    }
}

# Trait names mapping
TRAIT_NAMES = {
    1: 'Achievement-striving',
    8: 'Agreeableness',
    9: 'Altruism',
    14: 'Anxiety',
    16: 'Assertiveness',
    34: 'Conscientiousness',
    38: 'Cooperation',
    39: 'Creativity/Originality',
    43: 'Depression',
    56: 'Emotional Stability',
    58: 'Empathy',
    64: 'Extraversion',
    77: 'Gregariousness',
    81: 'Honesty/Integrity/Authenticity',
    135: 'Leadership',
    150: 'Modesty/Humility',
    156: 'Neuroticism',
    162: 'Openness To Experience',
    206: 'Self-discipline',
    235: 'Trust'
}

def load_test_questions(filename):
    """Load questions from test file"""
    questions = []
    with open(filename, 'r', encoding='utf-8') as f:
        for line in f:
            if line.strip() and not line.startswith('Test') and not line.startswith('Total') and not line.startswith('Statistics'):
                parts = line.strip().split(',', 6)
                if len(parts) >= 7:
                    try:
                        q = {
                            'order': int(parts[0]),
                            'id': int(parts[1]),
                            'trait_id': int(parts[2]),
                            'inst_id': int(parts[3]),
                            'alpha': float(parts[4]),
                            'key': int(parts[5]),
                            'text': parts[6]
                        }
                        questions.append(q)
                    except:
                        pass
    return questions

def generate_md(test_num, config, questions):
    """Generate MD file content"""
    md = f"""# 測驗 {test_num}：{config['name']}

## 測驗基本資訊

| 欄位 | 值 |
|------|-----|
| Name | {config['name']} |
| Code | {config['code']} |
| Description | {config['description']} |
| ResponseType | Likert5 |
| TimeLimit | 20 |
| TotalQuestions | {len(questions)} |
| IsActive | 1 |

## 題目清單

| 順序 | QuestionBankId | 題目文字 | TraitId | Trait名稱 | InstrumentId | Alpha | ScoringKey |
|------|----------------|---------|---------|----------|-------------|-------|-----------|
"""
    
    for q in questions:
        trait_name = TRAIT_NAMES.get(q['trait_id'], f"Trait_{q['trait_id']}")
        md += f"| {q['order']} | {q['id']} | {q['text']} | {q['trait_id']} | {trait_name} | {q['inst_id']} | {q['alpha']:.3f} | {q['key']} |\n"
    
    # Statistics
    pos_count = sum(1 for q in questions if q['key'] == 1)
    avg_alpha = sum(q['alpha'] for q in questions) / len(questions)
    min_alpha = min(q['alpha'] for q in questions)
    max_alpha = max(q['alpha'] for q in questions)
    
    # Trait distribution
    from collections import Counter
    trait_dist = Counter(q['trait_id'] for q in questions)
    inst_dist = Counter(q['inst_id'] for q in questions)
    
    md += f"""
## 統計資訊

- **總題數**：{len(questions)}
- **正向題數**：{pos_count} ({pos_count/len(questions)*100:.1f}%)
- **反向題數**：{len(questions)-pos_count} ({(len(questions)-pos_count)/len(questions)*100:.1f}%)
- **平均 Alpha**：{avg_alpha:.3f}
- **最低 Alpha**：{min_alpha:.3f}
- **最高 Alpha**：{max_alpha:.3f}

### Trait 分布
"""
    
    for trait_id, count in sorted(trait_dist.items(), key=lambda x: x[1], reverse=True):
        trait_name = TRAIT_NAMES.get(trait_id, f"Trait_{trait_id}")
        md += f"- {trait_name} ({trait_id}): {count} 題\n"
    
    md += "\n### Instrument 分布\n"
    for inst_id, count in sorted(inst_dist.items(), key=lambda x: x[1], reverse=True):
        md += f"- InstrumentId {inst_id}: {count} 題\n"
    
    # SQL INSERT
    md += f"""
## SQL INSERT 指令

### TestPaper INSERT

```sql
INSERT INTO TestPaper (Name, Code, Description, ResponseType, TimeLimit, TotalQuestions, IsActive)
VALUES (
    '{config['name']}',
    '{config['code']}',
    '{config['description']}',
    'Likert5',
    20,
    {len(questions)},
    1
);
```

### TestPaperDetail INSERT

```sql
-- 假設 TestPaper 的 Id 為 {test_num}（需根據實際 INSERT 結果調整）
INSERT INTO TestPaperDetail (TestPaperId, QuestionBankId, QuestionOrder, IsRequired)
VALUES
"""
    
    for i, q in enumerate(questions):
        comma = "," if i < len(questions) - 1 else ";"
        md += f"    ({test_num}, {q['id']}, {q['order']}, 1){comma}\n"
    
    md += "```\n"
    
    return md

if __name__ == '__main__':
    for test_num, config in TEST_CONFIGS.items():
        print(f"Generating Test {test_num}: {config['name']}...")
        
        questions = load_test_questions(config['file'])
        md_content = generate_md(test_num, config, questions)
        
        with open(config['output'], 'w', encoding='utf-8') as f:
            f.write(md_content)
        
        print(f"  Saved to {config['output']}")
        print(f"  Questions: {len(questions)}\n")
    
    print("All MD files generated!")

