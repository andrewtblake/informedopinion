"""Audit the second editorial revision without network or database writes."""
import collections
import json
import pathlib
import re
import statistics

ROOT = pathlib.Path(__file__).resolve().parents[2]
PATH = ROOT / 'docs/editorial/gaza-genocide-2026-10-17/revision-2'
bank = json.loads((PATH / 'bank.json').read_text())
facts = bank['facts']
sources = json.loads((PATH / 'sources.json').read_text())
assert len(facts) == 50 and len({f['key'] for f in facts}) == 50
allowed_initialisms = {'II', 'ICJ', 'ICC', 'ICRC', 'IDF', 'IPC', 'WHO', 'UN', 'US', 'OCHA', 'OHCHR'}
for f in facts:
    assert len(f['options']) == len(set(f['options'])) == 4
    assert all(o.strip() == o and o for o in f['options'])
    assert f['correct_option'] in range(4)
    assert f['source_url'].startswith('https://')
    assert sources[f['source_key']]['url'] == f['source_url']
    assert 1 <= f['specialist_knowledge'] <= 6 and 1 <= f['answerability'] <= 5
    assert f['importance_weight'] in (1, 2, 3) and f['evidence_direction'] in (-1, 0, 1)
    assert f['knowledge_rationale'] and f['answerability_rationale'] and f['importance_rationale']
    assert not f['gateway'] or f['gateway_rationale']
    text = ' '.join([f['prompt'], *f['options'], f['explanation'], f['source_name']])
    assert not re.search(r'previous question|as established above|other question|next question', text, re.I)
    assert not re.search(r'<[^>]+>', text)
    assert set(re.findall(r'\b[A-Z][A-Z0-9]{1,}\b', text)) <= allowed_initialisms
positions = collections.Counter(f['correct_option'] for f in facts)
assert max(positions.values()) - min(positions.values()) <= 1
weights = collections.Counter(f['importance_weight'] for f in facts)
assert 6 <= weights[3] <= 9 and weights[1] >= 7
assert len({f['knowledge_rationale'] for f in facts}) == 50
assert len({f['answerability_rationale'] for f in facts}) == 50
points = sum(f['importance_weight'] for f in facts)
heuristics = {}
for unit, measure in [('characters', len), ('words', lambda s: len(s.split()))]:
    for rank in range(4):
        strategies = {'first_tie': [], 'random_tie_expectation': [], 'all_ties_credit': []}
        for f in facts:
            values = list(map(measure, f['options']))
            value = sorted(values)[rank]
            hit = int(values[f['correct_option']] == value)
            strategies['first_tie'].append(int(values.index(value) == f['correct_option']))
            strategies['random_tie_expectation'].append(hit / values.count(value))
            strategies['all_ties_credit'].append(hit)
        result = {}
        for strategy, scores in strategies.items():
            raw = sum(scores) / len(facts)
            weighted = sum(s * f['importance_weight'] for s, f in zip(scores, facts)) / points
            result[strategy] = {'raw': raw, 'importance_weighted': weighted}
            # Intermediate all-ties credit is diagnostic, not a realizable strategy.
            # Shortest and longest checks conservatively credit every tie.
            if strategy != 'all_ties_credit' or rank in (0, 3):
                assert raw <= .4 and weighted <= .4, (unit, rank, strategy, raw, weighted)
        heuristics[f'{unit}_rank_{rank + 1}'] = result
result = {
    'questions': len(facts), 'importance_points': points, 'correct_positions': dict(positions),
    'importance': dict(weights),
    'evidence_direction': dict(collections.Counter(f['evidence_direction'] for f in facts)),
    'specialist_knowledge': dict(collections.Counter(f['specialist_knowledge'] for f in facts)),
    'answerability': dict(collections.Counter(f['answerability'] for f in facts)),
    'gateway_count': sum(f['gateway'] for f in facts),
    'mean_explanation_words': statistics.mean(len(f['explanation'].split()) for f in facts),
    'length_heuristics': heuristics,
    'limitations': 'Mechanical checks cannot establish source truth, plausible distractors, human difficulty, or agreement about the final genocide inference.'
}
(PATH / 'audit.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps({k: v for k, v in result.items() if k != 'length_heuristics'}, indent=2))
print('All shortest/longest, rank-based and answer-position checks pass.')
