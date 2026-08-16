# Internal-stat fact questions: deferred plan

## Status

This document records a possible design for future consideration. It does not
authorise implementation, publication of internal-stat fact questions, or use of
participant data for a new purpose.

The feature is deferred because internally derived facts create unusual risks:
the service would be both evidence producer and publisher; live statistics can
change; definitions and denominators are easy to misunderstand; small groups
can create privacy risks; and revisions could unfairly alter users' scores.
External, independently produced evidence should remain the normal basis of fact
questions.

## Possible purpose and limits

If reconsidered, internal statistics should be used only when they illuminate a
decision-relevant claim that cannot be answered adequately by external evidence.
Suitable subjects might include completion, knowledge change, calibration,
retention or changes in stated opinion. Traffic, popularity and engagement
figures are not evidence that the service is beneficial and should not be used
as substitutes for meaningful outcomes.

An internal statistic must not be used to establish the site's value by itself.
Any bank about the service should also cover external research, rival
explanations, selection effects, measurement limitations, accessibility,
privacy and the distinction between learning and changing political views.

## Publication standard

An internal-stat item would remain subject to the complete editorial standard.
In addition, it should:

1. Identify itself prominently as based on Informed Opinion / What's Your View
   internal data.
2. Ask about a closed, dated observation period rather than a continually
   changing value.
3. Define the eligible population, metric, denominator, exclusions and treatment
   of missing or incomplete records in the question or concise methodology.
4. State the sample size and calculation date.
5. Link to a durable methodology and results page rather than to an unpublished
   dashboard.
6. Describe material uncertainty, selection effects and limits on
   generalisation.
7. Use privacy thresholds and disclosure controls agreed before analysis.
8. Be reproducible from a reviewed query or analysis and an immutable source
   snapshot.
9. Receive independent editorial or methodological review from someone who did
   not produce the analysis.
10. Avoid claims of causation unless the study design supports them.

A suitable form would be:

> Among eligible users who completed the Veganism fact bank between 1 January
> and 30 June 2026, what proportion changed their stated position by at least one
> point between the recorded pre- and post-question responses?

The wording is illustrative only. Terms such as `eligible`, `completed`,
`recorded response` and the handling of repeat attempts would need explicit
definitions.

## Immutable statistic snapshots

A published question should refer to an immutable statistical snapshot, not run
against live application data. A possible record would contain:

```text
metric identifier and version
population and eligibility definition
period start and end
sample size and suppression status
value, units and uncertainty
exclusions and missing-data treatment
calculation timestamp
analysis/query version and reproducibility reference
methodological review and approval
privacy review and approval
superseding or correction relationship
```

Refreshing an internal dashboard must never silently change a published fact or
its answer key. A later period, revised population or revised metric definition
would normally create a new snapshot and a new fact question.

The retained reproducibility material must minimise access to participant-level
data. An immutable aggregate and a versioned analysis are preferable to copying
raw participant data into editorial records.

## Revisions and user scores

The existing editorial revision policy remains controlling. Internal data does
not justify silently rewriting the fact a user was asked.

| Event | Treatment of the fact question and existing responses |
| --- | --- |
| New observations arrive after a closed period | No change: the historical fact and scores stand. |
| A newer observation period is published | Create a new question; retire the old question if it no longer belongs in the current bank. |
| Population, denominator, metric or material method changes | Create a new question; do not reinterpret old responses. |
| Cosmetic edit or strictly non-material clarification | Preserve responses only after the existing seven-point editorial review and a recorded rationale. |
| Corrected statistic leaves every choice meaning and the correct choice unchanged | Scores may stand after documented review; disclose the correction in the methodology and revision history. |
| Corrected statistic changes the correct key while prompt and choices remain semantically unchanged | Recalculate correctness only when every stored selection can still be interpreted reliably under the corrected key. |
| Correction changes choice meanings, ranges, difficulty or the proposition tested | Reset responses or retire and replace the item. |
| Analysis is found unreliable or privacy-inappropriate | Withdraw the item, preserve private answer history and exclude it from current scores. |

Retired answers should follow the current score-history design: they remain
available through the user's non-front-facing expandable history but contribute
to neither the current numerator nor denominator. A replacement must be answered
afresh.

Recalculation after a changed key should be exceptional. It is defensible only
when the original four selections have exactly the same meanings and the only
error was which unchanged selection was marked correct. Otherwise the stored
selection is not reliable evidence of what the user would have answered to the
revised item.

## Privacy and governance prerequisites

Before any pilot, the project would need to decide and document:

- whether existing consent and privacy information cover the proposed analysis;
- minimum cell and cohort sizes, including protection against differencing
  related aggregates;
- which sensitive attributes and subgroup comparisons are prohibited;
- retention periods for reproducibility data;
- who may run, inspect, approve and reproduce analyses;
- how staff, test, duplicate, automated and suspicious accounts are treated;
- whether a data-protection impact assessment or other external review is
  required; and
- how corrections, withdrawals and conflicts of interest are disclosed.

Public methodology should be detailed enough to assess the result without
exposing personal data, security-sensitive queries or protections against abuse.

## Possible future delivery stages

### Stage 0: decision and independent review

Do not build storage or editorial tooling yet. First select one plausible
decision-relevant statistic, write its complete proposed methodology, conduct a
privacy review and ask an independent reviewer whether publication would add
more value than risk. Abandon the feature if the result cannot be explained
clearly or reproduced safely.

### Stage 1: offline, unpublished pilot

Produce one aggregate snapshot outside the fact-question workflow. Draft an
unpublished item and test whether reviewers can identify the population,
denominator, time period, uncertainty and limitations correctly. Do not expose
the item to participant scoring.

### Stage 2: minimal data model and audit trail

Only after a successful pilot, introduce immutable snapshot records, approval
states, provenance, supersession and correction links. Require a snapshot ID for
every internal-stat fact question and record both methodological and privacy
approval in the audit history.

### Stage 3: publication safeguards

Add validation that blocks publication when the period is open, required
methodology is absent, privacy thresholds fail, review is incomplete or a
question points to a mutable statistic. Exercise the existing response-handling
paths with snapshot corrections, replacement and retirement.

### Stage 4: limited publication and evaluation

Publish at most a small number of independently reviewed items. Monitor reader
comprehension, corrections, privacy incidents and editorial workload. Expansion
would require an explicit subsequent decision; it must not follow automatically
from technically successful publication.

## Tests required before publication

At minimum, automated and editorial tests should establish that:

- a published question cannot change when a dashboard or later observation is
  updated;
- every internal-stat item resolves to an immutable, approved snapshot;
- open periods and suppressed or unapproved aggregates cannot be published;
- correction and supersession histories are append-only and visible to editors;
- retirement excludes responses from current weighted and unweighted scores but
  retains private history;
- recalculation is impossible unless prompts and choice meanings are unchanged;
- unauthorised users cannot access analysis material or disclosive aggregates;
  and
- methodology links remain available after a question is retired.

## Decision gates

Future work should proceed only if all of these questions can be answered yes:

1. Is the proposed statistic materially relevant to an opinion proposition?
2. Is internal evidence necessary rather than merely convenient or promotional?
3. Can the population, metric and limitations be explained self-containedly?
4. Can the result be reproduced and independently reviewed?
5. Can it be published without unreasonable privacy or re-identification risk?
6. Is the observation period closed and the published snapshot immutable?
7. Is the likely editorial value proportionate to the continuing maintenance,
   correction and scoring burden?

Unless and until these gates are met, the preferred course is not to publish
internal-stat fact questions.
