"""
IPIP Test Question Selection Script
From QuestionBank.csv, select actual questions for 5 tests
"""

import csv
import random
from collections import defaultdict

def load_questions(csv_path):
    """Load questions from CSV"""
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
                        'ScoringKey': int(row[7]),
                        'IsActive': int(row[9]) == 1
                    }
                    if q['IsActive'] and q['Alpha'] >= 0.70:
                        questions.append(q)
                except (ValueError, IndexError):
                    continue
    return questions

def select_for_trait(questions, trait_ids, count, preferred_instruments=None, used_ids=None):
    """Select questions for specific traits"""
    if used_ids is None:
        used_ids = set()
    
    # Filter candidates
    if preferred_instruments:
        candidates = [
            q for q in questions
            if q['TraitCategoryId'] in trait_ids
            and q['InstrumentCategoryId'] in preferred_instruments
            and q['Id'] not in used_ids
        ]
    else:
        candidates = [
            q for q in questions
            if q['TraitCategoryId'] in trait_ids
            and q['Id'] not in used_ids
        ]
    
    # If not enough, expand to all instruments
    if len(candidates) < count:
        candidates = [
            q for q in questions
            if q['TraitCategoryId'] in trait_ids
            and q['Id'] not in used_ids
        ]
    
    # Sort by Alpha
    candidates.sort(key=lambda x: x['Alpha'], reverse=True)
    
    # Balance positive and negative
    positive = [q for q in candidates if q['ScoringKey'] == 1]
    negative = [q for q in candidates if q['ScoringKey'] == -1]
    
    pos_count = int(count * 0.65)
    neg_count = count - pos_count
    
    selected = []
    selected.extend(positive[:pos_count])
    
    if len(negative) >= neg_count:
        selected.extend(negative[:neg_count])
    else:
        selected.extend(negative)
        remaining = count - len(selected)
        selected.extend(positive[pos_count:pos_count + remaining])
    
    return selected[:count]

def select_test1(questions):
    """Test 1: Big Five Quick Assessment"""
    selected = []
    used_ids = set()
    
    # Big Five traits: 10 questions each
    traits = [
        ([64], 10),   # Extraversion
        ([8], 10),    # Agreeableness
        ([34], 10),   # Conscientiousness
        ([156], 10),  # Neuroticism
        ([162], 10)   # Openness To Experience
    ]
    
    preferred_instruments = [1, 26, 6, 18]
    
    for trait_ids, count in traits:
        trait_questions = select_for_trait(questions, trait_ids, count, preferred_instruments, used_ids)
        selected.extend(trait_questions)
        used_ids.update(q['Id'] for q in trait_questions)
    
    random.shuffle(selected)
    return selected[:50]

if __name__ == '__main__':
    print("Loading questions from QuestionBank.csv...")
    questions = load_questions('ex06/database-planning/mssql/QuestionBank.csv')
    print(f"Total questions (Alpha >= 0.70, Active): {len(questions)}")
    
    # Statistics
    inst_count = defaultdict(int)
    for q in questions:
        inst_count[q['InstrumentCategoryId']] += 1
    
    print("\nInstrument distribution:")
    for inst_id in sorted(inst_count.keys())[:10]:
        print(f"  Instrument {inst_id}: {inst_count[inst_id]} questions")
    
    # Test 1
    print("\n=== Test 1: Big Five Quick Assessment ===")
    test1 = select_test1(questions)
    print(f"Selected: {len(test1)} questions")
    
    pos = sum(1 for q in test1 if q['ScoringKey'] == 1)
    neg = sum(1 for q in test1 if q['ScoringKey'] == -1)
    avg_alpha = sum(q['Alpha'] for q in test1) / len(test1)
    
    print(f"Positive: {pos} ({pos/len(test1)*100:.1f}%)")
    print(f"Negative: {neg} ({neg/len(test1)*100:.1f}%)")
    print(f"Average Alpha: {avg_alpha:.3f}")
    
    print("\nFirst 10 questions:")
    for i, q in enumerate(test1[:10], 1):
        print(f"{i}. ID={q['Id']}, Trait={q['TraitCategoryId']}, Alpha={q['Alpha']:.3f}, Key={q['ScoringKey']}")
        print(f"   {q['TextZh'][:50]}...")
    
    # Save to file
    output_file = 'ex07/test1_selected_questions.txt'
    with open(output_file, 'w', encoding='utf-8') as f:
        for i, q in enumerate(test1, 1):
            f.write(f"{i},{q['Id']},{q['TraitCategoryId']},{q['InstrumentCategoryId']},{q['Alpha']},{q['ScoringKey']},{q['TextZh']}\n")
    
    print(f"\nSaved to {output_file}")

