# Editorial standard for opinion and fact questions

This document is the working editorial policy for Informed Opinion. It turns the principles in `MANIFEST.md` into testable rules for writing and reviewing content.

## Opinion questions

An opinion question must:

1. State one proposition that a respondent can evaluate on the published five-point scale.
2. Use neutral language. It must not imply that one response is normal, moral, informed or socially approved.
3. Define the material policy, factual claim, population, jurisdiction and time period wherever any of them could reasonably change the answer.
4. Avoid double-barrelled propositions. Necessary safeguards or exclusions may define a policy, but must not introduce a second policy on which a respondent could take a different position.
5. Distinguish terms that are commonly conflated, such as legalisation and decriminalisation.
6. Avoid presupposing a disputed fact. A factual proposition should say exactly what is claimed without intensifiers such as “actually” or “obviously”.
7. Use a truth scale for empirical claims and an agreement scale for normative or policy propositions.
8. Have one broad category and all useful subject and geographical tags.
9. Be consequential or of recognisable public interest, genuinely disputed by the intended audience, and capable of being informed by factual evidence.

## Fact questions

Each published bank contains at least 30 questions. Every fact question must:

1. Test a fact, not a value judgement, prediction presented as certainty, or disguised argument.
2. Be relevant to the exact opinion proposition and reasonably capable of changing or refining an informed person's view.
3. Prefer decision-relevant evidence: the current legal or factual baseline, scale, causal mechanisms, measured outcomes, material benefits, material harms, uncertainty and the strongest evidence invoked on each side.
4. Be completely self-contained. Define abbreviations and supply enough jurisdictional and temporal context to understand the question without reading another item. A question, answer choice or explanation must never refer or allude to another fact question in the bank—whether earlier, later, numbered, currently present or merely planned. It must remain coherent when presented first, last or in isolation.
5. Have one unambiguously best answer supported by the linked source and a concise explanation of why it is correct.
6. Link directly to a named primary, official or otherwise authoritative source using HTTPS. Secondary sources may be used when they are the best synthesis of contested or dispersed evidence.
7. Offer exactly four mutually distinct choices. Every wrong choice must be plausible to an intelligent non-expert and wrong for a substantive reason; joke answers, category errors and conspicuous absurdities are prohibited.
8. Avoid answer-position, answer-length and “middle answer” cues. Correct positions must be balanced across the bank, and always choosing the longest answer must score no more than 40%, both raw and importance-weighted.
9. Declare an evidential valence relative to the proposition: supports (`1`), contextual or mixed (`0`), or counters (`-1`). Valence describes the fact's likely effect, not the editor's preferred conclusion. A bank should contain all three directions where the evidence permits.
10. Publish an importance of Supporting (`1`), Significant (`2`) or Foundational (`3`) with a specific rationale. The range is deliberately narrow. A bank should normally contain 6–9 foundational items and at least 7 supporting items.
11. Avoid duplication. Two questions may use the same source only when they test materially different decision-relevant knowledge.
12. State uncertainty and limits honestly. Observational associations are not described as causal; international evidence is not assumed to transfer unchanged; absence of evidence is not evidence of absence.
13. Separate evidence from the final moral or political judgement. At least one contextual synthesis item should make clear what remains a matter of values after the facts are understood.
14. Declare a specialist-knowledge rating from 1 to 6. Assess the underlying fact, before considering the answer choices, relative to a generally well-educated adult in the jurisdiction principally addressed by the opinion question who has no specialist training in the subject:
    - General knowledge (`1`): ordinary secondary-school, civic or everyday knowledge.
    - News-informed (`2`): common among educated adults who follow mainstream news.
    - Issue-focused (`3`): requires attentive reading about the issue or an adjacent policy field.
    - Sustained study (`4`): requires sustained focused study, an undergraduate course or a professional briefing.
    - Professional or postgraduate (`5`): normally associated with relevant postgraduate study or professional work.
    - Subfield expert (`6`): highly specialised subfield expertise.
15. Declare an answerability rating from 1 to 5 for the complete presented item. Straightforward (`5`) remains substantive; Accessible (`4`) requires understanding the central fact; Moderate (`3`) presents several initially credible alternatives; Demanding (`2`) requires close substantive discrimination; and Very demanding (`1`) is difficult but unequivocal. Linguistic clarity is desirable, but the answer must not be selectable without processing the fact. During an audit, `0` means that an assessed item is unfit, while a missing value means it has not yet been assessed. An unfit item must be revised or withdrawn before publication.
16. Keep importance, specialist knowledge and answerability conceptually independent. Importance measures how consequential the fact is; specialist knowledge measures prior study; answerability measures the effect of the prompt and choices. Difficulty must arise from decision-relevant distinctions rather than tricks, immaterial precision or technical vocabulary. Distractors should represent credible mistaken factual models.

## Bank-level review

Before publication, an editor checks the bank as a whole for:

- coverage of the strongest good-faith arguments and evidence on every material side;
- balance of valence, importance and correct-answer position without manufacturing false equivalence;
- consistent terminology, geographical scope and dates;
- source accessibility and continued support for the stated answer;
- duplicated facts, trivia, accidental advocacy and culturally loaded wording;
- dependencies between questions, including language such as “as established above”, “the previous finding”, “this result”, “the other question” or references to an assumed sequence;
- plausible distractors and resistance to answer-length guessing;
- specialist-knowledge and answerability distributions and their cross-tabulation, including unrated or unfit items and suspicious relationships between the ratings;
- HTML limited to approved clarification markup, never used to conceal qualifications or evidence.

A bank may range from straightforward but substantive questions to demanding but unequivocal ones. It should span the specialist-knowledge levels genuinely needed by the proposition without adding expert trivia to satisfy a quota. No published bank may contain an unrated or answerability-`0` question.

Reaching the configured minimum number of fact questions only makes an opinion question eligible for publication. It remains non-public until a moderator completes this bank-level review and explicitly marks it as live.

Content is revised when law, data or the cited evidence changes. Existing responses are handled according to the amendment classification below.

## Revisions and existing responses

An editor must classify every amendment to a fact question that already has responses. The controlling question is not whether an edit looks small, but whether it could reasonably change a respondent's selection or the difficulty of identifying the answer.

- **Cosmetic amendment — preserve responses.** Spelling, punctuation, grammar, typography, expanded initialisms and other presentation-only corrections may preserve responses when the factual proposition and all four choices remain semantically identical.
- **Non-material clarification — preserve responses after explicit review.** A wording clarification may preserve responses only when the tested fact, population, jurisdiction, date, measurement basis, four choice meanings, correct choice and effective difficulty are unchanged. It must not repair an ambiguity that could reasonably have changed an answer or add or remove a factual qualification.
- **Substantive revision — reset responses.** Responses are reset when an edit changes the tested fact, any choice's substantive meaning, a material qualification, answerability or the evidence needed to distinguish the choices. Replacing weak distractors with materially more credible ones is substantive even when the correct choice remains in the same position.
- **Answer-key correction — recalculate or invalidate.** When the unchanged prompt and choices had one clearly correct answer but the stored key was wrong, correctness may be recalculated from each retained selection. If the old item did not have one unambiguously best answer, it is withdrawn and excluded from current scoring instead.
- **Retirement — preserve history, exclude from current scoring.** A response to a withdrawn question remains part of the user's private answer history but contributes to neither the current numerator nor denominator, weighted or unweighted. A replacement is a new question and must be answered separately.

Before preserving responses to changed prompt or choice text, an editor records a specific rationale and confirms all of the following:

1. Exactly the same factual proposition is tested.
2. Each old choice has a one-to-one semantic equivalent in the same stored position.
3. The uniquely correct choice is unchanged in meaning and position.
4. No reasonable respondent would change their selection because of the amendment.
5. Effective difficulty and answer cues are not materially changed.
6. No population, jurisdiction, date, threshold, denominator or other factual qualification is added, removed or changed.
7. The cited evidence continues to support the answer.

If any condition is not met, or the editor is genuinely uncertain, the revision resets current responses. Changes only to the explanation, source metadata, importance, valence or calibration do not themselves reset responses, provided they do not reveal that the presented item was substantively defective.
