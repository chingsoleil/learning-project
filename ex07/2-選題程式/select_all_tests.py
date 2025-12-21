"""
Select questions for all 5 tests
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

def select_for_traits(questions, trait_configs, used_ids):
    """Select questions for multiple traits"""
    selected = []
    
    for trait_ids, count in trait_configs:
        candidates = [
            q for q in questions
            if q['TraitCategoryId'] in trait_ids
            and q['Id'] not in used_ids
        ]
        
        candidates.sort(key=lambda x: x['Alpha'], reverse=True)
        
        trait_selected = candidates[:count]
        selected.extend(trait_selected)
        used_ids.update(q['Id'] for q in trait_selected)
    
    return selected

def select_test2(questions, used_ids):
    """Test 2: Workplace Personality"""
    traits = [
        ([34, 1, 52, 206], 15),  # Conscientiousness related
        ([64, 16, 135], 10),      # Extraversion related
        ([8, 38, 235], 10),       # Agreeableness related
        ([56, 14], 10),           # Emotional Stability related
        ([162, 39], 5)            # Openness related
    ]
    
    selected = select_for_traits(questions, traits, used_ids)
    random.shuffle(selected)
    return selected[:50]

def select_test3(questions, used_ids):
    """Test 3: Emotion & Interpersonal"""
    traits = [
        ([8, 58, 9, 38, 235], 15),  # Agreeableness related
        ([156, 14, 43, 56], 15),     # Neuroticism/Emotional Stability
        ([64, 77], 10),              # Extraversion related
        ([81], 10)                   # Honesty/Integrity
    ]
    
    selected = select_for_traits(questions, traits, used_ids)
    random.shuffle(selected)
    return selected[:50]

def select_test4(questions, used_ids):
    """Test 4: Creativity & Openness"""
    traits = [
        ([162, 87, 39, 6, 99, 41], 20),  # Openness related
        ([34, 1, 206], 10),              # Conscientiousness related
        ([64, 16], 10),                  # Extraversion related
        ([8, 38], 5),                    # Agreeableness related
        ([156, 14], 5)                   # Neuroticism related
    ]
    
    selected = select_for_traits(questions, traits, used_ids)
    random.shuffle(selected)
    return selected[:50]

def select_test5(questions, used_ids):
    """Test 5: Comprehensive Personality"""
    traits = [
        ([64], 6),   # Extraversion
        ([8], 6),    # Agreeableness
        ([34], 6),   # Conscientiousness
        ([156], 6),  # Neuroticism
        ([162], 6),  # Openness
        ([81], 5),   # Honesty/Integrity
        ([150], 5),  # Modesty/Humility
        ([135, 1, 206, 77, 58, 39], 10)  # Other traits - increased to 10
    ]
    
    selected = select_for_traits(questions, traits, used_ids)
    
    # If not enough, add more from any available traits
    if len(selected) < 50:
        remaining = 50 - len(selected)
        candidates = [q for q in questions if q['Id'] not in used_ids and q['Id'] not in [s['Id'] for s in selected]]
        candidates.sort(key=lambda x: x['Alpha'], reverse=True)
        selected.extend(candidates[:remaining])
    
    random.shuffle(selected)
    return selected[:50]

def save_test(test_num, test_name, questions, filename):
    """Save test questions to file"""
    with open(filename, 'w', encoding='utf-8') as f:
        f.write(f"Test {test_num}: {test_name}\n")
        f.write(f"Total: {len(questions)} questions\n\n")
        
        for i, q in enumerate(questions, 1):
            f.write(f"{i},{q['Id']},{q['TraitCategoryId']},{q['InstrumentCategoryId']},{q['Alpha']:.3f},{q['ScoringKey']},{q['TextZh']}\n")
        
        # Statistics
        pos = sum(1 for q in questions if q['ScoringKey'] == 1)
        avg_alpha = sum(q['Alpha'] for q in questions) / len(questions)
        
        f.write(f"\nStatistics:\n")
        f.write(f"Positive: {pos} ({pos/len(questions)*100:.1f}%)\n")
        f.write(f"Average Alpha: {avg_alpha:.3f}\n")

if __name__ == '__main__':
    print("Loading questions...")
    questions = load_questions('ex06/database-planning/mssql/QuestionBank.csv')
    print(f"Total: {len(questions)} questions\n")
    
    # Track used IDs across all tests
    all_used_ids = set()
    
    # Test 1 (already done, load from file)
    print("Test 1: Loading from existing file...")
    with open('ex07/test1_selected_questions.txt', 'r', encoding='utf-8') as f:
        for line in f:
            if line.strip() and not line.startswith('Test'):
                parts = line.split(',')
                if len(parts) > 1:
                    try:
                        all_used_ids.add(int(parts[1]))
                    except:
                        pass
    print(f"Test 1: {len(all_used_ids)} questions used\n")
    
    # Test 2
    print("Selecting Test 2: Workplace Personality...")
    test2 = select_test2(questions, all_used_ids.copy())
    save_test(2, "Workplace Personality", test2, 'ex07/test2_selected_questions.txt')
    print(f"Test 2: {len(test2)} questions selected\n")
    all_used_ids.update(q['Id'] for q in test2)
    
    # Test 3
    print("Selecting Test 3: Emotion & Interpersonal...")
    test3 = select_test3(questions, all_used_ids.copy())
    save_test(3, "Emotion & Interpersonal", test3, 'ex07/test3_selected_questions.txt')
    print(f"Test 3: {len(test3)} questions selected\n")
    all_used_ids.update(q['Id'] for q in test3)
    
    # Test 4
    print("Selecting Test 4: Creativity & Openness...")
    test4 = select_test4(questions, all_used_ids.copy())
    save_test(4, "Creativity & Openness", test4, 'ex07/test4_selected_questions.txt')
    print(f"Test 4: {len(test4)} questions selected\n")
    all_used_ids.update(q['Id'] for q in test4)
    
    # Test 5
    print("Selecting Test 5: Comprehensive Personality...")
    test5 = select_test5(questions, all_used_ids.copy())
    save_test(5, "Comprehensive Personality", test5, 'ex07/test5_selected_questions.txt')
    print(f"Test 5: {len(test5)} questions selected\n")
    
    print("All tests completed!")
    print(f"Total unique questions used: {len(all_used_ids)}")

