"""Validate the dated editorial artifact; no network or database writes."""
import collections
import json
import pathlib
import re

ROOT = pathlib.Path(__file__).resolve().parents[2]
PATH = ROOT / 'docs/editorial/gaza-genocide-2026-10-17'
bank = json.loads((PATH / 'bank.json').read_text())
facts = bank['facts']
sources = json.loads((PATH / 'sources.json').read_text())
research = json.loads((PATH / 'research.json').read_text())
assert len(facts) == 50
assert len({f['key'] for f in facts}) == 50
longest = []
for f in facts:
    assert len(f['options']) == len(set(f['options'])) == 4
    assert all(x.strip() for x in f['options'])
    assert 0 <= f['correct_option'] <= 3
    assert f['source_url'].startswith('https://')
    assert f['source_key'] in sources
    assert 1 <= f['specialist_knowledge'] <= 6
    assert 1 <= f['answerability'] <= 5
    assert f['importance_weight'] in (1, 2, 3)
    assert f['evidence_direction'] in (-1, 0, 1)
    assert f['importance_rationale'] and f['knowledge_rationale']
    assert f['answerability_rationale'] and f['explanation']
    assert not f['gateway'] or f['gateway_rationale']
    text = ' '.join([f['prompt'], *f['options'], f['explanation']])
    assert not re.search(r'previous question|as established above|other question|next question', text, re.I)
    sizes = [len(o) for o in f['options']]
    if sizes[f['correct_option']] == max(sizes):
        longest.append(f)
positions = collections.Counter(f['correct_option'] for f in facts)
assert max(positions.values()) - min(positions.values()) <= 1
weights = collections.Counter(f['importance_weight'] for f in facts)
assert 6 <= weights[3] <= 9 and weights[1] >= 7
raw = len(longest) / len(facts)
weighted = sum(f['importance_weight'] for f in longest) / sum(f['importance_weight'] for f in facts)
assert raw <= .4 and weighted <= .4
comparison = json.loads((PATH / 'forty-item-comparison.json').read_text())
assert len(comparison['core_keys']) == 40
assert set(comparison['core_keys']) <= {f['key'] for f in facts}
assert len(research['sequences']) == 12
# The inventory includes selected items and documented rejected candidates.
arrays = [v for v in research.values() if isinstance(v, list)]
assert any(len(v) == 70 for v in arrays)
result = {'questions': len(facts), 'correct_positions': dict(positions),
          'importance': dict(weights),
          'evidence_direction': dict(collections.Counter(f['evidence_direction'] for f in facts)),
          'longest_answer_raw': raw, 'longest_answer_weighted': weighted,
          'gateway_count': sum(f['gateway'] for f in facts),
          'candidate_count': 70, 'evidence_sequences': 12,
          'limitations': 'Mechanical checks do not establish source accuracy, reader difficulty or independent expert agreement.'}
(PATH / 'audit.json').write_text(json.dumps(result, indent=2) + '\n')
print(json.dumps(result, indent=2))
