# Shared fact questions across opinion banks: future plan

## Status

This document records a proposed implementation for allowing one canonical fact
question to belong to several opinion-question banks. It does not authorise a
schema migration, automatic deduplication, score changes, or immediate sharing
of any published fact.

The capability is anticipated in `MANIFEST.md` and `README.md`: when the same
self-contained fact is genuinely relevant to more than one opinion proposition,
an answer given through one bank should be capable of counting in the other.
The current schema does not implement that behaviour. Each `FactQuestion`
belongs directly to one `OpinionQuestion`, and intrinsic question content and
proposition-specific editorial assessments are stored on the same record.

The change should evolve the existing model. Existing responses and scores must
survive unchanged until an editor explicitly shares a fact with another bank.

## Purpose and limits

Literal sharing would mean that:

- a participant need not answer exactly the same fact repeatedly;
- corrections and source updates have one canonical record;
- overlapping banks avoid duplicated questions drifting apart;
- knowledge remains attached to the fact that was answered; and
- proposition-specific importance and evidential direction can still differ.

Sharing must be an explicit editorial decision. Similar wording is not enough.
Questions that differ in date, jurisdiction, population, denominator,
measurement, qualification, choices or effective difficulty are different
factual propositions and must remain separate.

## Separate canonical content from bank membership

### Canonical `FactQuestion`

The canonical record should own properties that remain the same wherever it is
presented:

- prompt and four choices;
- correct choice;
- explanation and source;
- specialist-knowledge and answerability ratings;
- canonical revision and global-retirement state; and
- participant responses.

Answerability remains canonical because every item must be self-contained and
work in isolation. If a question is materially easier only because one bank
supplies prior context, it is not independent enough to share in that form.

### `OpinionQuestionFact` membership

A join record should own properties describing the fact's use relative to one
opinion proposition:

- opinion question and fact question;
- display order;
- importance weight and rationale;
- evidential direction;
- gateway status and rationale;
- bank-specific withdrawal state and reason; and
- creation and review provenance.

Importance and valence are relationships between a fact and a proposition. A
fact may be foundational in one bank and supporting in another, or support one
proposition while countering another. Gateway status and order also depend on
the complete bank.

The proposed class name is `OpinionQuestionFact`. `FactBankMembership` is a
reasonable alternative if it proves clearer during implementation; the
underlying separation should not change.

## Proposed data model

An initial join could contain:

```text
OpinionQuestionFact
  opinion_question_id          required foreign key
  fact_question_id             required foreign key
  display_order                required integer
  importance_weight            1–3
  importance_rationale         required text
  evidence_direction           -1, 0 or 1
  gateway                      required boolean, default false
  gateway_rationale            required when gateway is true
  withdrawn_at                 nullable timestamp
  withdrawal_reason            nullable text
  created_at
  updated_at
```

Required constraints include:

- unique `(opinion_question_id, fact_question_id)`;
- unique `(opinion_question_id, display_order)`;
- range checks for importance and evidential direction;
- gateway-rationale validation;
- indexes for active membership, gateway sequencing and reverse bank lookup;
  and
- foreign keys whose deletion behaviour cannot destroy a shared fact or its
  responses when one opinion question is removed.

`FactQuestion` should eventually lose its proposition-specific columns:

```text
opinion_question_id
display_order
importance_weight
importance_rationale
evidence_direction
gateway
gateway_rationale
withdrawn_at                  after local and global retirement are separated
```

These columns must not be dropped in the first deployment. Use an expand,
backfill, verify and contract migration.

## Bank withdrawal and canonical retirement

The current `withdrawn_at` conflates two decisions.

### Bank-specific withdrawal

Set `OpinionQuestionFact.withdrawn_at` when a valid fact no longer belongs in
one bank. Its response can continue to count in every other active membership.

### Canonical retirement

Use a new canonical retirement state when the wording, choices, answer or
evidence can no longer support a valid question anywhere. A globally retired
fact is inactive in every bank. Responses remain in private history but count
in no current score.

Global retirement should require a reason and a preview of all affected banks,
participants and publication thresholds. Reinstatement should be explicit and
audited.

Existing withdrawn records should initially become withdrawn memberships, not
automatically globally defective facts. That conservative interpretation
preserves current scoring and does not invent a broader editorial decision.

## Participant answer semantics

### One latest answer per canonical fact

Retain the unique `(user_id, fact_question_id)` response. If a fact is active in
three banks, a participant has one latest selection and correctness result.

Consequently:

- answering through bank A marks the fact answered in banks B and C;
- correctness contributes using each membership's importance weight;
- re-answering through B replaces the canonical latest answer and may change
  the participant's scores in A, B and C; and
- withdrawing it from A does not erase the answer or remove it from B and C.

The interface should explain this when a participant first encounters a shared
fact and before a re-answer that can affect several topic scores. It should not
claim that general expertise transfers between topics: the exact same fact is
being reused.

### Sequencing and existing answers

`NextFactQuestion` should select active memberships and join canonical
responses. A shared fact answered elsewhere should:

- contribute immediately to progress and weight;
- be absent from the unseen pool;
- remain available through the ordinary review cycle; and
- use this bank's valence and gateway metadata for ordering.

Every item remains self-contained; sharing must not introduce sequence
dependencies.

### Before-and-after weight context

`FactResponse.weight_before` and `weight_after` currently describe the topic
through which the latest response was submitted. Sharing makes that context
ambiguous unless it is stored.

The minimum compatible change is a
`last_answered_through_opinion_question_id` foreign key. The two weights then
describe that topic only and remain suitable for immediate quiz feedback.

Before implementation, decide whether durable attempt history is required. If
so, add an append-only `FactResponseAttempt` containing the user, canonical
fact, topic through which it was answered, selection, correctness, before and
after weights, and answer time. `FactResponse` remains the authoritative latest
answer. Do not add attempt history merely because sharing makes it conceivable.

### Scores and retired history

`OpinionProgress` and `CollectiveOpinion` must calculate available and earned
importance through active memberships. A correct canonical answer contributes
the weight stored on the membership being calculated.

Retirement becomes contextual:

- locally withdrawn in A and active in B: retired history for A, current in B;
- globally retired: retired history in every former bank; and
- removed from all banks but canonically retained: preserved response and
  editorial history, but no current score contribution.

The existing non-front-facing retired-answer disclosure should continue. A
canonical fact cannot count twice within one bank because membership is unique.
Opinion-history snapshots remain historical snapshots and are not rewritten
when a later shared answer changes current weights.

## Revision and response handling

The existing editorial revision standard remains controlling, but canonical
scope increases the impact of content changes.

Before a canonical edit, moderation should show:

- every active and withdrawn membership;
- importance and valence in each bank;
- affected response count;
- banks that could fall below their publication threshold; and
- the proposed response-handling classification.

A substantive prompt or choice change resets the canonical response set once,
not once per bank. An eligible answer-key correction recalculates that one
response set. Cosmetic and non-material clarification preservation still
requires the existing documented review.

Changes only to importance, rationale, valence, gateway status, order or local
withdrawal do not change what was asked and do not reset canonical responses.
They can change current scores and sequencing, so they remain audited bank-level
editorial decisions.

If a change would make the question suitable for one bank but not another, do
not edit the shared fact in place. Provide a `clone and detach` operation that:

1. copies canonical content and calibration into a new fact;
2. creates a new membership for the selected bank;
3. withdraws that bank's old membership where history requires it;
4. records the relationship and reason; and
5. does not copy participant answers to the substantively different fact.

## Reports and moderation scope

A report made from a bank must retain both the canonical fact and its exact
membership context.

- Inaccuracy, outdated evidence, an ambiguous answer or unsupported source
  normally concerns canonical content.
- Irrelevance, wrong valence, wrong importance or unsuitable gateway status
  concerns one membership.
- Biased wording may concern canonical presentation, membership metadata or
  both and must be classified during review.

The reviewer should choose `canonical`, `this membership`, or `all
memberships` before resolving a report. A local relevance report must never
globally retire a valid fact accidentally. Audit events must record the
canonical fact ID, membership ID, opinion-question ID and decision scope.

## Proposals and reuse

A proposed fact remains attached to the topic for which it was submitted.
Approval should offer two reviewed paths:

1. create a canonical fact and its first membership; or
2. attach an existing canonical fact by creating only a membership.

The second path requires confirmation that the existing prompt, choices, key,
explanation, source, jurisdiction, date and measurement are exactly suitable.
Search can suggest possible matches, but the system must not merge facts by
normalized text, fuzzy similarity or shared source URL.

`FactQuestionProposal` can continue to collect intrinsic and membership fields
together for reader simplicity. Approval should record both the canonical fact
ID and resulting membership ID so provenance remains unambiguous.

## API and MCP design

The moderator API should distinguish canonical operations from membership
operations while retaining a convenient complete-bank representation. Possible
resources are:

```text
GET/PATCH /api/v1/fact_questions/:id
GET/POST/PATCH /api/v1/opinion_questions/:id/fact_memberships
POST /api/v1/opinion_questions/:id/fact_memberships/bulk
```

A complete item should separate its payload:

```json
{
  "fact_question": {
    "prompt": "...",
    "options": ["..."],
    "correct_option": 1,
    "explanation": "...",
    "source_name": "...",
    "source_url": "...",
    "specialist_knowledge": 2,
    "answerability": 4
  },
  "bank_membership": {
    "importance_weight": 3,
    "importance_rationale": "...",
    "evidence_direction": -1,
    "gateway": true,
    "gateway_rationale": "...",
    "display_order": 4
  }
}
```

Tools should support explicit `attach_existing_fact` and `clone_fact` actions.
No canonical edit should proceed without exposing every affected bank. During
transition, compatibility fields may remain in read responses, but
contradictory intrinsic and membership values must be rejected.

## Seeds and editorial content

Seed banks should distinguish reusable canonical definitions from membership
metadata without forcing every one-off fact into a distant global registry.
Shared facts need stable editorial keys; identity must never be inferred from
prompt text.

For example:

```text
FACTS[:independent_legal_duties] = {
  prompt: ...,
  options: ...,
  correct_option: ...,
  explanation: ...,
  source: ...,
  specialist_knowledge: 2,
  answerability: 4
}

GAZA_JUSTIFICATION_BANK = [
  membership(:independent_legal_duties,
    importance: 3, direction: 0, gateway: true, order: 8)
]

GAZA_CULPABILITY_BANK = [
  membership(:independent_legal_duties,
    importance: 3, direction: 0, gateway: true, order: 6)
]
```

Production remains authoritative and must not be rebuilt destructively from
seeds. Tests should verify that each shared key has one intrinsic definition
and valid, independently assessed memberships.

## Publication and bank review

Publication eligibility should count active memberships. The existing minimum
continues to mean distinct presented questions in that bank.

Bank review should additionally verify that:

- a canonical fact appears no more than once in a bank;
- importance, valence and gateway rationales were assessed for this proposition;
- the bank remains coherent if a participant answered shared items elsewhere;
- shared items do not make two opinion propositions editorially redundant; and
- apparent breadth is not inflated by several versions of one underlying fact.

The system should report overlap between banks, but no universal maximum should
be imposed before real examples are reviewed. A warning and editorial rationale
are preferable to an arbitrary quota.

Unpublishing or deleting an opinion question must remove or retire memberships,
not cascade-delete a shared fact, responses used elsewhere or editorial history.
Only an explicit reviewed task may clean up unlinked, never-answered facts.

## Safe migration

### Stage 0: characterize and rehearse

Add or confirm tests for current individual and collective scores, sequencing,
retired history, revision handling, publication thresholds, proposal approval,
report resolution and API/MCP serialization. Rehearse against a recent
production backup using PostgreSQL.

### Stage 1: expand

Add `opinion_question_facts` without changing reads. Initially permit one
membership per canonical fact. Add response topic context if retaining the
before/after fields, and add a distinct canonical retirement field. Keep all
legacy columns.

### Stage 2: backfill

For every existing fact, create one membership by copying its opinion question,
order, importance, rationale, valence, gateway assessment and withdrawal time.
Backfill response topic context from the legacy owner where needed. Do not
alter response IDs, selections, correctness, attempts or timestamps.

Verify identical:

- active and withdrawn bank counts;
- per-user answered, correct, raw and weighted scores;
- collective distributions and weighted scores;
- publication eligibility; and
- next-question candidate sets.

Also verify exactly one membership per legacy fact and no duplicate bank/order
pairs. Abort the transition if any invariant differs.

### Stage 3: dual-compatible release

Introduce membership-aware associations and writes while legacy columns remain.
If dual writes are needed, disagreement must be a hard error with a repeatable
consistency audit. Do not enable multi-bank sharing yet. Deploy the one-to-one
join model and compare production results.

### Stage 4: switch authoritative reads

Move scoring, aggregation, sequencing, quiz lookup, fact counts, statistics,
publication, moderation, reports, proposals, API, MCP and seeds to membership
joins.

Use explicit names such as `fact_memberships`, `active_fact_memberships` and
`published_facts`. Score calculations should visibly take weight from the join
rather than conceal it behind a `has_many :through` collection.

### Stage 5: controlled sharing pilot

After a stable one-to-one deployment, permit moderators to attach an existing
fact to a second unpublished bank. Pilot a few unequivocal overlaps. Preview
score effects and verify the experience of arriving with facts already
answered before publishing the second bank.

### Stage 6: contract

After audits find no legacy reads or writes:

1. make membership constraints fully non-null;
2. remove compatibility code and dual writes;
3. archive a final ownership-to-membership mapping;
4. drop proposition-specific columns from `fact_questions`; and
5. update schema and recovery documentation.

Column removal must be later than the authoritative-read switch so rollback
remains possible.

## Tests required before sharing

Automated tests should establish that:

- migration gives every legacy fact one equivalent membership;
- all pre-migration scores and collective results remain identical;
- one answer can contribute different weights in two banks;
- one fact can have different valence and gateway status in each bank;
- answering in A marks it answered and scored in B;
- re-answering in B updates every active bank using it;
- feedback uses B's before/after topic context;
- local withdrawal affects only one membership;
- global retirement affects every bank but preserves private history;
- membership edits never reset canonical responses;
- canonical substantive revisions reset responses exactly once;
- eligible key corrections recalculate the canonical response set;
- clone-and-detach does not copy responses;
- deleting or unpublishing a bank cannot delete a fact used elsewhere;
- publication rejects duplicate facts and orders;
- sequencing uses bank-specific valence and gateway metadata;
- reports retain bank context and cannot apply local outcomes globally;
- API, MCP, moderation, proposals and audit events preserve both identities; and
- seed reconciliation uses explicit shared keys.

Performance tests should cover facts with many responses and several
memberships. Query counts must not multiply per user and membership.

## Editorial pilot

The first shared facts should be unquestionably identical, not merely
convenient to reuse. A self-contained rule of international humanitarian law
material to two unpublished Gaza propositions may be suitable.

Reviewers should independently confirm:

1. the same prompt, choices, key, explanation, source, scope and date fit both
   banks;
2. each bank has separately reasoned importance and valence;
3. the item remains independent in either sequence;
4. a prior answer is fairly interpretable in the second bank; and
5. foreseeable revisions are likely to apply to both uses.

Do not begin with a frequently refreshed statistic or a claim whose
qualification differs subtly between propositions.

## Decisions before implementation

1. Should the join be `OpinionQuestionFact` or `FactBankMembership`?
2. Is `FactResponseAttempt` needed, or is latest response plus latest topic
   context sufficient?
3. How should the interface explain cross-bank effects of re-answering?
4. Should global retirement automatically unpublish every bank falling below
   the minimum?
5. Which report categories default to canonical or membership scope?
6. How much overlap should trigger a bank-level warning?
7. Must every shared canonical edit receive multi-bank review?
8. What stable keys should identify shared seed facts and later versions?
9. How long should the compatible deployment remain before legacy columns are
   removed?

Implementation should begin with characterization tests and the one-to-one join
migration. No fact should be attached to a second bank until score equivalence,
retirement semantics, moderation scope and participant explanations have been
verified in the deployed join model.
