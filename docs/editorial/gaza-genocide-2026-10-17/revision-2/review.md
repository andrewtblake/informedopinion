# Broader editorial revision: Gaza genocide

Prepared on 18 October 2026 following the instruction to implement the
[broader review](../broader-review.md). The proposition and its conduct period
remain unchanged. The bank contains fifty questions and must stay unpublished.

## Coverage and selection

Eight replacement topics make room for a more coherent factual baseline and
an open synthesis question. The retained topics were also rewritten, with
revised choices, explanations and calibration. The records are reordered to
introduce the definition, scale, military aims, death-record limitations and
effective relief early. All questions remain independently understandable.

| Removed standalone topic | Where the important distinction now appears | Replacement coverage |
| --- | --- | --- |
| M02: a news report qualifying an Israeli fighter-death claim | M01 distinguishes death enumeration from combatant classification; none of the new totals is called civilian-only | B01: scale of the October 7 killings |
| P07: March 2025 mechanism deliveries | P06 links the supply decision and its documented operational effect | B02: approximate number abducted |
| R02: northern aid expansion in April 2024 | R01 retains substantial actual relief in 2024; C02 and R04 cover subsequent distribution and improvement | B03: population-wide displacement |
| M04: capture–recapture estimate | M05 tests a separate evidence method and sampling limits; the earlier modelling source remains in the research archive | B04: dated recorded death total near the end of 2025 |
| L05: explicit-plan requirement | L04 explains that an express written plan is not indispensable | B05: population denominator |
| D06: recall of the Commission’s intent conclusion | P01, C01, P06 and C05 test actual policies, warnings and subsequent decisions | B06: overall satellite-assessed structural damage |
| M03: verified subset versus representative sample | M05’s explanation retains that distinction; a separate quiz point is not awarded for it | K01: continued lethal ground fighting in July 2025 |
| D07: recall of Amnesty’s intent argument | S01 tests the actual legal distinction between a military purpose and additional destructive intent | S01: the inference left for the respondent to assess |

Consolidation deliberately gives up some separately scored details. It does
not claim that the mortality survey replaces every other evidence method or
that one relief episode establishes adequate access throughout the war.

The factual additions use rounded magnitudes, attributed sources and explicit
dates. The death total concerns 29 December, not an exact end-of-period count;
it is neither a civilian-only tally nor all direct and indirect mortality.
The displacement estimate concerns people displaced at some point, not a sum
of repeated movements. The satellite estimate includes possibly damaged
structures and lacks field validation. The ground-attack account remains
attributed to its reporting and official sources.

Selection was not governed by a partisan balance target. Valence is now
15 supporting, 10 countering and 25 contextual or mixed. The substantive
question of genocide remains outside the answer key. Historical findings do
not substitute for evidence about Gaza, and other crimes are not excused by
failure to establish genocide.

## Readability and substantive choices

Prompts foreground the observation or legal distinction when attribution is
not essential. Attributed intelligence assessments, inquiries and disputed
findings remain explicitly attributed. Repeated report-conclusion recall is
reduced, and several case names move into the explanation or source.

The three identified answer leaks have been rewritten. C04 no longer tells
the reader the initial account to contradict. M05 names neither the survey
nor household sampling in its prompt. H02 asks about victim selection rather
than supplying the answer that genocide and war occurred together. D05 now
summarises the statement whose qualification is tested.

Wrong choices represent different causal accounts, measurements, policy
scopes or legal tests. The aim is credible alternatives rather than equal
lengths or more obscure vocabulary. Each item has separate, specific
knowledge and answerability rationales. All fifty are passing editorial
proposals; these are not empirically estimated participant difficulties.

## Checks

All fifty records pass Rails model validation in an isolated local test
database without saving records. The expanded mechanical audit checks four
distinct choices, balanced key positions, required fields, ratings, sources,
self-containment flags, unsupported initialisms and length-based strategies.

Correct positions are distributed 13, 13, 12 and 12. Shortest and longest
strategies are checked using both character and word counts, conservatively
crediting ties. Fixed choices of each length rank, and expected scores with
random tie-breaking, also remain at or below 40% raw and importance-weighted.
Intermediate-rank all-ties credit is recorded as a diagnostic rather than a
realizable strategy. The complete results are in [audit.json](audit.json).

These checks address obvious cues but cannot establish that every possible
reading strategy performs at chance. They do not replace editorial review or
supervisory sampling. No artificial knowledge-level or answerability quotas
were applied. Nine items are foundational, twenty-four significant and
seventeen supporting, for ninety-two available importance points.

## Sources and glossary

New population, death, displacement, structural damage, hostage and historical
material was checked against the linked primary documents. Download hashes
and verification details are recorded in [source-verification.json](source-verification.json).
The new ground-attack report was checked through indexed Associated Press
text, with the five deaths corroborated by the IDF’s 8 July briefing; direct
Associated Press retrieval returned 403. This limitation is retained.
The detention item now links directly to the downloaded primary report and
its Gaza-specific paragraphs, rather than relying on a wider press summary.

The production glossary endpoint still returns 404. Only the supported
initialisms are used, with other organisation names written out. No custom
HTML or application deployment is required.

## Application

The user confirms that there are no participant answers to preserve. Updates
use substantive-reset handling, with the before snapshot, replacement map and
server API audit retaining the editorial history. Existing question IDs are
reused; no additional questions or withdrawals are needed. New fingerprinted
calibration proposals require supervisory review. Publication is not requested.

See [all revised questions](questions.md), [the replacement map](replacement-map.json)
and [the source ledger](sources.json).

## Verified saved result

All fifty existing records were updated through the moderator API. No records
were added or withdrawn. Fresh reads before and after the calibration
submission verified every saved editorial field, record identity, order and
unchanged proposition. The topic remains `live: false` with no publication
timestamp. Fifty new fingerprint-matched calibration proposals await
supervisory review; earlier assessments remain in their audit history.

The [application record](applied.json) identifies each current question and
its content fingerprint. Development remains on `main`; no deployment was
needed for the editorial changes.
