# Fact-question knowledge and answerability plan

## Purpose

Fact questions need two additional editorial assessments that are independent of
their importance and evidential direction:

- **Specialist knowledge** measures how much topic-specific study a person would
  normally need to know the underlying fact before seeing the answer choices.
- **Answerability** measures how readily the correct answer can be identified
  from the particular prompt and choices presented.

These properties must remain separate. An obscure fact can be easy to guess when
the distractors are absurd, while a generally familiar fact can be tested through
several close but consequential distinctions.

The ratings will support editorial review, reveal gaps within a bank and inform
question sequencing. They do not replace `importance_weight`, which records how
consequential a fact is to evaluating the opinion proposition.

## Reference population

Assess specialist knowledge relative to:

> A generally well-educated adult in the jurisdiction principally addressed by
> the opinion question, without specialist training in the subject.

The assessment is made before the person sees the answer choices. Where an
opinion question is global, the editor should use a generally well-educated adult
rather than assume knowledge specific to one country.

## Proposed scales

### Specialist knowledge: 1–6

| Rating | Expected prior knowledge |
| ---: | --- |
| 1 | Ordinary secondary-school, civic or everyday knowledge |
| 2 | Common among educated adults who follow mainstream news |
| 3 | Requires attentive reading about the issue or an adjacent policy field |
| 4 | Requires sustained focused study, an undergraduate course or a professional briefing |
| 5 | Normally associated with relevant postgraduate study or professional work |
| 6 | Highly specialised subfield expertise |

The rating belongs to the underlying fact, not to its wording or distractors.

### Answerability: 0–5

Higher passing values mean that the presented question is easier to answer.

| Rating | Presented question |
| ---: | --- |
| 0 | Unfit: the item does not provide a valid, meaningful test |
| 1 | Very demanding but unequivocal |
| 2 | Demanding and requiring close substantive discrimination |
| 3 | Moderate, with several alternatives initially credible |
| 4 | Accessible but requiring understanding of the central fact |
| 5 | Straightforward but still requiring substantive reading |

`0` is a review outcome rather than the difficult end of the continuum. It can
identify either of two extremes:

- the answer can be selected without processing the fact because distractors are
  absurd, irrelevant, malformed or conspicuously weaker; or
- the alternatives are so finely distinguished or ambiguous that the source does
  not establish one unequivocal answer.

Other reasons for a zero include multiple defensible answers, answer-length or
wording cues, unnecessary trivia, technical language that tests vocabulary rather
than the intended fact, and numerical distinctions unsupported by the source.

Rating `5` is the easiest acceptable form. It must still require the respondent to
take in the central information. Linguistic clarity is desirable; bypassing
substantive thought is not.

In storage, `NULL` means **not yet assessed**, whereas `0` means **assessed and
found unfit**.

## Editorial principles

The published editorial standard should establish that:

1. Importance, specialist knowledge and answerability measure different
   properties.
2. Specialist knowledge is assessed against the stated reference population and
   before the choices are shown.
3. Answerability concerns the complete presented item: prompt, choices and the
   cues created by their wording.
4. Wrong choices should represent credible mistaken factual models. They must not
   merely surround the answer with conspicuous nonsense.
5. Difficulty should arise from decision-relevant distinctions, not tricks,
   obscure wording or immaterial precision.
6. A bank may deliberately vary answerability from straightforward but
   substantive to demanding but unequivocal.
7. Every published item must have an answerability rating from 1 to 5. A zero-rated
   item must be revised or withdrawn before publication.
8. Banks should span specialist-knowledge levels appropriate to their proposition.
   There should be no quota for expert questions where the subject does not need
   them.
9. Bank-level review should examine each distribution and their cross-tabulation.
   It should detect, for example, whether all specialist facts have been made
   artificially easy or all familiar facts unnecessarily difficult.
10. The complete bank should remain accessible to an educated non-specialist while
    including whatever focused knowledge is genuinely necessary for an informed
    view.

Rigid distribution targets should not be introduced until the existing corpus has
been audited. The audit will provide a defensible empirical baseline for future
guidance.

## Operating model

The exhaustive first assessment is performed in bulk by AI. The moderator's role
is supervisory rather than manually rating every question:

```text
AI rates the complete corpus
        ↓
automatic validation and distribution analysis
        ↓
moderator reviews targeted and representative samples
        ↓
moderator accepts, overrides or requests reassessment
        ↓
accepted ratings become available for sequencing
```

AI assessment must include concise rationales, confidence ratings, provenance,
and a diagnosis and proposed remedy for every unfit question. These are retained
as durable assessment history. The accepted numeric ratings are also copied onto
the fact question for efficient reporting and sequencing.

Supervisory review should always include unfit questions, extreme ratings,
low-confidence ratings, cross-bank inconsistencies and questions changed after
assessment. It should add a stratified sample from ordinary rating combinations
and a random sample from every bank. A purely random sample is insufficient.

## Delivery stages

### Stage 1: publish the definitions

Update the editorial standard with:

- the operational definitions and reference population;
- both rating scales;
- the distinction between clear prose and an answer that can be guessed without
  processing the fact;
- the requirement for credible, substantively wrong distractors;
- the permissible range from straightforward but substantive to demanding but
  unequivocal;
- the treatment of unrated and zero-rated questions; and
- bank-level distribution and cross-tabulation checks.

Update the moderator API and MCP documentation at the same time so content authors
receive the same definitions as human moderators.

### Stage 2: add nullable storage throughout the editorial workflow

Add nullable integer columns to both `fact_questions` and
`fact_question_proposals`:

```text
specialist_knowledge  1–6 or NULL
answerability         0–5 or NULL
```

Database constraints and model validations should enforce those ranges when a
value is present. Existing records must not receive invented default ratings.

Carry the fields through every relevant path:

- direct API creation and update;
- atomic bulk creation;
- API serialization and audit events;
- MCP creation and update schemas;
- reader fact-question proposals;
- moderator proposal editing and approval;
- publication of an approved proposal;
- moderation fact-bank display and editing;
- seed helpers and seed records; and
- model, API, integration, MCP and seed tests.

Once deployed, ratings should be required for newly generated or approved fact
questions. Existing records may remain `NULL` only until the corpus audit is
complete.

The moderation interface should show both values on each item and summarise each
bank, including unrated and zero-rated totals. For example:

```text
Specialist knowledge: 1: 4 · 2: 10 · 3: 9 · 4: 5 · 5: 2 · 6: 0
Answerability:         0: 3 · 1: 1  · 2: 5 · 3: 13 · 4: 7 · 5: 1
Unrated: 0
```

### Stage 3: build a repeatable audit workflow

The audit must cover two related but non-identical corpora:

1. fact-question definitions in the seed catalogue; and
2. current draft and live production records.

Production must not be reconstructed from seeds. Seed reruns intentionally
preserve existing editorial content, and production questions may have been
created or changed through moderation.

For every question, the audit output should record:

- its production ID or stable seed location;
- opinion-question title and jurisdiction;
- specialist-knowledge rating;
- answerability rating;
- a concise reason for each assessment;
- a failure category and remediation suggestion when answerability is zero; and
- whether the production and seed versions materially differ.

Suggested zero-rating categories are:

- absurd, irrelevant or non-parallel distractors;
- answer exposed by wording, length, qualification or specificity;
- more than one defensible answer;
- distinction too fine for the cited evidence;
- trivia rather than decision-relevant knowledge;
- unnecessary technical vocabulary;
- misleading numerical alternatives; and
- another question-construction defect.

The two numeric values belong on the question records. Assessment reasons should
also be retained in a reviewable audit report or migration data file so that a
zero does not lose its diagnosis.

Generate per-bank distributions and cross-tabulations. Flag extreme values,
unrated questions, zero-rated questions, narrow distributions and unusually strong
relationships between specialist knowledge, answerability and importance.

The repository provides three read-only interchange tasks. They operate on the
database selected by the Rails environment and never apply ratings:

```sh
bin/rails fact_questions:calibration:export OUTPUT=tmp/fact-question-calibration.json
bin/rails fact_questions:calibration:validate INPUT=tmp/fact-question-calibration.json
bin/rails fact_questions:calibration:report INPUT=tmp/fact-question-calibration.json
```

The exported JSON is an AI interchange format, not a worksheet that moderators
are expected to edit. It contains the full question, a content fingerprint and
empty assessment fields. Validation requires both ratings, confidence values and concise reasons for every item,
checks the fingerprint against the current database, and requires a recognised
failure category and remediation proposal for every zero-rated item. Reporting
works on either an assessed interchange file or the current database and emits per-bank
distributions, cross-tabulations, unused levels, and unrated and unfit IDs.

Export the seed catalogue from a freshly seeded local database. Export production
from the production environment rather than assuming that it still matches the
seed catalogue. Rating persistence remains a separate, explicit and audited
operation.

### Stage 4: submit bulk AI assessments without rewriting questions

Assess and submit one bank at a time:

1. Read the exact opinion proposition and establish its reference population.
2. Have the AI rate each underlying fact for specialist knowledge without considering its
   answer choices.
3. Have the AI rate the complete presented item for answerability.
4. Assign zero where the item fails and record the reason.
5. Record confidence, model or assessor identity, run identity, rationales,
   failure diagnosis and proposed remediation.
6. Compare ratings within the bank and with analogous questions in other banks.
7. Validate fingerprints and submit exactly one assessment for every question in
   the bank through an atomic, audited operation.
8. Preserve each submitted assessment as history and mark it as awaiting
   supervisory review.
9. Persist accepted ratings in the seed catalogue and verify that no current
   question remains unrated.

This stage changes ratings only. Keeping diagnosis separate from remediation
preserves an honest baseline and makes the scale easier to calibrate consistently.

The moderator interface should construct a supervisory sample containing:

- every answerability-0 assessment;
- all specialist-knowledge ratings of 1, 5 or 6;
- all answerability ratings of 0, 1 or 5;
- all low-confidence assessments;
- questions whose ratings differ sharply from analogous questions;
- every bank with a conspicuously narrow distribution;
- surprising differences between questions needing similar professional or legal
  knowledge; and
- strong correlations between importance, specialist knowledge and answerability;
- a stratified sample from each populated rating combination; and
- a random sample from every bank.

For each assessment the moderator may accept it, override either rating with a
note, or request reassessment. These decisions must retain the original AI values
and be auditable. Moderators are not expected to inspect every ordinary rating
individually.

The moderator calibration interface provides a bank overview and per-bank views
for the supervisory sample, all pending assessments, all unfit assessments and
complete assessment history. Sampling deterministically includes mandatory
extremes and low-confidence cases, one representative from each populated rating
combination, and an additional stable sample. The interface displays the complete
question, source, AI rationales, confidence, provenance, failure diagnosis and
remediation proposal. Acceptance, override and reassessment decisions are
fingerprint-protected and recorded in the audit log. An override stores reviewed
values separately so the original AI assessment remains intact.

### Stage 5: remediate failures and substantive gaps

Review the audit before changing content. For each zero-rated item, decide whether
to:

- replace implausible distractors with credible misconceptions;
- make choices parallel in form, scope and specificity;
- clarify the prompt;
- widen a distinction that the cited source cannot resolve reliably;
- remove an immaterial numerical or technical detail;
- split an item containing two factual tests;
- replace the question; or
- withdraw it when no worthwhile formulation exists.

Reassess both ratings after every substantive rewrite. The underlying fact may
retain the same specialist rating even when the question's answerability changes.

Treat distribution gaps as review prompts rather than quotas:

- a lack of ratings 5–6 is not a defect when expert knowledge is unnecessary;
- a bank dominated by 4–6 may be inaccessible or overly dependent on professional
  or foreign detail;
- a bank containing only 1–2 may be superficial;
- a narrow answerability range may be monotonous without being invalid; and
- no fact should be added merely to make a histogram look balanced.

After this stage, no published bank should contain an unrated or zero-rated item.

### Stage 6: introduce rating-informed sequencing

The current sequencing service prioritises evidential direction relative to the
user's opinion. Do not replace that with a simple easy-to-hard sort. Combine:

- the existing valence progression;
- an editorial gateway assessment identifying the small set of facts that
  establish the proposition's principal considerations;
- a gradual introduction of more specialist knowledge;
- answerability pacing;
- avoidance of long runs of demanding questions; and
- controlled variation so the sequence does not become mechanical.

Gateway status must not be inferred mechanically from the numeric ratings: an
easy fact can be peripheral, while an important orientation fact may require
moderate difficulty. Editors should record the designation during whole-bank
review, with a concise rationale. Opening questions should normally favour
gateway facts with specialist ratings 1–3 and answerability ratings 3–5. More
specialised and demanding questions can be introduced progressively while
counter-attitudinal evidence follows the existing pattern. A gateway item below
answerability 3 may still appear within the first third when it supplies material
counterevidence, but should not normally occupy an opening slot.

Within the direction required for a sequence position, gateway status should be
a bounded preference rather than an absolute order. Once the opening phase has
passed, unanswered gateway facts should return to the ordinary candidate pool.
The design must avoid making later questions dependent upon having seen a
gateway item.

Do not expose rating labels to participants without a separate product decision.
Labels such as "expert-level" or "easy" could change confidence, effort and answer
behaviour.

Test sequencing statistically over repeated generated orders, as well as through
unit cases, to verify that valence, knowledge progression and answerability pacing
all remain effective.

## Completion criteria

The project is complete when:

- the definitions are part of the published editorial standard;
- storage, validation and serialization cover fact questions and proposals;
- every creation, moderation and publication path preserves both ratings;
- seed and production questions have been assessed;
- the audit report explains every zero rating and identifies material gaps;
- every published question has a passing answerability rating;
- remediated questions have been reassessed and source-checked;
- moderation displays useful per-bank distributions; and
- sequencing uses the ratings without defeating the existing evidential-valence
  design; and
- editors can designate gateway facts and the opening sequence gives them a
  bounded preference within the required evidential direction.
