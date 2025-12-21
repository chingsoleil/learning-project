"""
IPIP 測驗實際選題腳本

從 QuestionBank.csv 中實際選題，生成包含真實 QuestionBankId 的測驗 MD 檔
"""

import csv
import random
from collections import defaultdict

# 讀取題庫
def load_questions(csv_path):
    questions = []
    with open(csv_path, 'r', encoding='utf-8') as f:
        reader = csv.reader(f)
        for row in reader:
            if len(row) >= 11:
                try:
                    q = {
                        'Id': int(row[0]),
                        'InstrumentCategoryId': int(row[1]),
                        'TraitCategoryId': int(row[2]),
                        'TextEn': row[3],
                        'TextZh': row[4],
                        'Alpha': float(row[5]) if row[5] else 0.0,
                        'Alpha2': float(row[6]) if row[6] else None,
                        'ScoringKey': int(row[7]),
                        'IPIPItemNumber': row[8],
                        'IsActive': int(row[9]) == 1
                    }
                    if q['IsActive'] and q['Alpha'] >= 0.70:
                        questions.append(q)
                except (ValueError, IndexError):
                    continue
    return questions

# 測驗 1：大五人格快速評估
# 使用 16PF (1), NEO (26), BFAS (6), HEXACO_PI (18) 等包含大五特質的 instruments
def select_test1(questions):
    """測驗 1：大五人格快速評估"""
    selected = []
    
    # 目標：每個大五特質 10 題
    traits = {
        64: 10,   # Extraversion
        8: 10,    # Agreeableness
        34: 10,   # Conscientiousness
        156: 10,  # Neuroticism
        162: 10   # Openness To Experience
    }
    
    # 優先使用的 instruments（實際存在的）
    preferred_instruments = [1, 26, 6, 18]
    
    for trait_id, count in traits.items():
        # 篩選符合條件的題目
        candidates = [
            q for q in questions
            if q['TraitCategoryId'] == trait_id
            and q['InstrumentCategoryId'] in preferred_instruments
        ]
        
        if len(candidates) < count:
            # 如果不足，從所有 instruments 中選
            candidates = [
                q for q in questions
                if q['TraitCategoryId'] == trait_id
            ]
        
        # 按 Alpha 排序
        candidates.sort(key=lambda x: x['Alpha'], reverse=True)
        
        # 平衡正向題和反向題
        positive = [q for q in candidates if q['ScoringKey'] == 1]
        negative = [q for q in candidates if q['ScoringKey'] == -1]
        
        # 60-70% 正向，30-40% 反向
        pos_count = int(count * 0.65)
        neg_count = count - pos_count
        
        selected.extend(positive[:pos_count])
        if len(negative) >= neg_count:
            selected.extend(negative[:neg_count])
        else:
            # 如果反向題不足，用正向題補充
            selected.extend(negative)
            selected.extend(positive[pos_count:pos_count + (neg_count - len(negative))])
    
    # 隨機排序
    random.shuffle(selected)
    
    return selected[:50]

# 主程式
if __name__ == '__main__':
    print("開始從題庫選題...")
    
    # 讀取題庫
    questions = load_questions('ex06/database-planning/mssql/QuestionBank.csv')
    print(f"題庫總數：{len(questions)} 題（Alpha >= 0.70 且啟用）")
    
    # 統計 instruments 分布
    inst_count = defaultdict(int)
    for q in questions:
        inst_count[q['InstrumentCategoryId']] += 1
    
    print("\nInstruments 分布：")
    for inst_id in sorted(inst_count.keys()):
        print(f"  InstrumentId {inst_id}: {inst_count[inst_id]} 題")
    
    # 統計 traits 分布
    trait_count = defaultdict(int)
    for q in questions:
        trait_count[q['TraitCategoryId']] += 1
    
    print("\n大五核心 Traits 分布：")
    big5_traits = {64: 'Extraversion', 8: 'Agreeableness', 34: 'Conscientiousness', 
                   156: 'Neuroticism', 162: 'Openness To Experience'}
    for trait_id, trait_name in big5_traits.items():
        print(f"  TraitId {trait_id} ({trait_name}): {trait_count[trait_id]} 題")
    
    # 測驗 1 選題
    print("\n\n=== 測驗 1：大五人格快速評估 ===")
    test1_questions = select_test1(questions)
    print(f"選題完成：{len(test1_questions)} 題")
    
    # 統計
    pos_count = sum(1 for q in test1_questions if q['ScoringKey'] == 1)
    neg_count = sum(1 for q in test1_questions if q['ScoringKey'] == -1)
    avg_alpha = sum(q['Alpha'] for q in test1_questions) / len(test1_questions)
    min_alpha = min(q['Alpha'] for q in test1_questions)
    
    print(f"正向題：{pos_count} ({pos_count/len(test1_questions)*100:.1f}%)")
    print(f"反向題：{neg_count} ({neg_count/len(test1_questions)*100:.1f}%)")
    print(f"平均 Alpha：{avg_alpha:.3f}")
    print(f"最低 Alpha：{min_alpha:.3f}")
    
    # 顯示前 10 題
    print("\n前 10 題：")
    for i, q in enumerate(test1_questions[:10], 1):
        print(f"{i}. Id={q['Id']}, Trait={q['TraitCategoryId']}, Alpha={q['Alpha']:.3f}, Key={q['ScoringKey']}")
        print(f"   {q['TextZh']}")

