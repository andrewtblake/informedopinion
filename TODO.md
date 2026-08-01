# Moderation at scale

## Objectives and governing constraints

Scale moderation beyond a single account without losing consistency,
accountability or the project's deliberately minimal user-to-user communication.

The system should provide:

- equitable distribution of reports, proposals, editorial preparation and peer
  reviews;
- sufficient independence that moderators can review and challenge one another;
- discussion attached to editorial cases, not a general social or messaging
  system;
- an append-only history of assignments, edits, decisions, reviews, discussions,
  recusals and reversals;
- stable pseudonyms so moderators are distinguishable in discussions without
  seeing one another's names, email addresses or participant profiles;
- a defined, reviewable method of handling disagreement;
- protection against one moderator quietly controlling a topic or repeatedly
  reviewing the same colleague.

“Anonymous from each other” should not mean unaccountable to the service. A
restricted identity mapping must remain available to a very small number of
authorised administrators for security, legal requests and investigation of
moderator abuse. Ordinary moderators must never have access to that mapping.

## 1. Separate identity from moderator identity

Introduce a `ModeratorIdentity` associated with a user account. It should have:

- a randomly generated, non-semantic public handle such as `Moderator K7M4`;
- an immutable internal identifier;
- active, suspended and retired states;
- availability and assignment-capacity settings;
- timestamps for appointment, suspension and retirement;
- no name, email address, biography, avatar, location or link to the user's
  participant activity in moderator-visible responses.

The handle should be stable so discussions and history remain intelligible.
Retired handles must not be recycled. A moderator must see their own handle but
not any facility for discovering another handle's underlying account.

The restricted account-to-handle mapping should be accessible only through a
separate administrative permission, not merely the moderator role. Access to
the mapping must itself create an audit event. Database exports intended for
moderator analysis should omit the mapping.

Avoid direct moderator-to-moderator messages. Discussion should occur only in a
case thread, under moderator handles, where it becomes part of the case record.
Warn moderators not to disclose personal identity in discussion text and allow
an authorised administrator to redact accidentally disclosed personal data
without erasing the existence and reason for the redaction.

## 2. Represent work as moderation cases

Create a common `ModerationCase` abstraction around:

- fact-question reports;
- opinion-question proposals;
- fact-question proposals;
- questions being prepared for publication;
- peer reviews of completed decisions;
- requests to reopen or reconsider earlier decisions;
- later editorial work such as importance or bias reviews.

Each case should record its type, subject, state, priority, complexity points,
creation time, response target, current assignment, conflict status and final
outcome. Suggested states are:

1. `unassigned`
2. `assigned`
3. `under_review`
4. `awaiting_peer_review`
5. `changes_requested`
6. `resolved`
7. `dismissed`
8. `withdrawn`
9. `escalated`
10. `closed`

Do not force every case type through irrelevant states, but require every final
state to have a reason and an actor.

## 3. Distribute work equitably

### Assignment method

Start with automatic weighted least-load assignment rather than first-come,
first-served claiming. For each eligible moderator, calculate current load as
the sum of complexity points for open assignments, adjusted for declared
capacity. Assign the next case randomly among the least-loaded eligible group.

Eligibility should take account of:

- active status and stated availability;
- capacity, including part-time or temporary reduced capacity;
- case-type qualification where specialist knowledge is genuinely required;
- recusal and declared conflicts;
- whether the moderator made the decision now being reviewed;
- recent assignment concentration by topic and by fellow reviewer;
- overdue work already held by the moderator.

Cases should receive simple published complexity points rather than being counted
as if all work were equal. For example, dismissing a duplicate report should not
carry the same workload value as editing a full proposed opinion question.

### Leases and reassignment

Assignments should be leases with an acknowledgement period and a due date. A
moderator may accept, recuse with a structured reason, or return an item to the
queue. Unacknowledged or overdue work should be automatically reassigned after
warning, without penalising legitimate absence.

Permit temporary manual assignment only to a pseudonymous moderation coordinator,
requiring a reason that becomes part of the audit history. Manual assignment
must not silently bypass conflict rules.

### Fairness monitoring

Provide a workload dashboard showing, by pseudonym:

- open complexity points;
- completed points over recent periods;
- median time to first action and resolution;
- returned, recused and overdue assignments;
- distribution across case and topic types;
- peer-review pair concentration.

Use these figures to detect imbalance, not to create speed-based league tables.
Quality, care and legitimate recusal must not be discouraged. Periodically test
the allocator with simulations and retain an explanation of why each assignment
was made.

## 4. Require proportionate peer review

No moderator may peer-review their own decision or edit. Assignment of peer
reviews should use the same equitable allocator and avoid repeatedly pairing the
same two handles.

Require peer review before publication or permanent closure for high-impact
actions, including:

- publishing a new opinion question;
- publishing or materially rewriting a fact question;
- withdrawing a fact question;
- changing importance or evidence direction;
- reinstating withdrawn material;
- closing a substantiated bias or inaccuracy report;
- changing the homepage through a large editorial override.

For routine, low-risk dismissals, begin with a random audit sample rather than
requiring a second moderator every time. Increase the sample for new moderators,
unusual decision patterns or case types with a high reversal rate.

A peer reviewer should be able to:

- approve the decision;
- request specified changes;
- return it for further evidence;
- escalate a substantive disagreement;
- flag a procedural or conduct concern separately from the editorial case.

The original decision and proposed edits must remain visible as immutable
versions even after changes are accepted.

## 5. Case-bound moderator discussion

Add a discussion thread to each moderation case. Posts should show the stable
moderator handle and time, and should never be editable in place. Corrections
should be new posts linked to the superseded post. Administrative redaction
should replace only sensitive text, preserving author, time, redaction reason
and the fact that a redaction occurred.

Support structured post types where useful:

- proposed decision;
- evidence or source;
- requested change;
- objection;
- response to objection;
- recusal disclosure;
- escalation summary;
- final rationale.

Allow links to sources and references to exact content versions. Do not add
private messages, follower relationships, reactions, reputation scores or a
general moderator forum. Notifications should point moderators back to the case
record.

Discussion should be civil, concise and directed at the proposition, fact,
source or procedure. A conduct policy and a separate pseudonymous conduct-review
route will be needed, with accused moderators excluded from that review.

## 6. Maintain complete, append-only history

Introduce a `ModerationEvent` ledger. Every significant action should append an
event containing:

- case and subject identifiers;
- event type and timestamp;
- acting moderator identity ID and display handle at the time;
- previous and new state;
- structured reason and linked discussion post where applicable;
- assignment or peer-review identifiers;
- before and after content versions, or references to immutable snapshots;
- request ID and software version/deployment identifier;
- references to supporting sources;
- whether the event was automatic, moderator-initiated or administrator-initiated.

Events should cover creation, assignment, acknowledgement, return, recusal,
comment, proposed edit, saved edit, decision, peer-review outcome, reopening,
withdrawal, reinstatement, escalation, redaction and restricted identity lookup.

Do not rely on mutable `reviewer_id`, `reviewed_at` and notes columns as the
history. They may remain as convenient current-state fields, but the event ledger
is authoritative. Content edits should create immutable versions and a field-level
diff; never overwrite the only copy of earlier wording, choices, answer keys,
importance, valence, explanations or sources.

Protect the ledger at several levels:

- application models should expose no update or delete path;
- database permissions should prevent the normal application role altering
  existing events where practical;
- link events with hashes or periodic signed checkpoints so silent alteration is
  detectable;
- include the ledger and content versions in tested backups;
- define retention and lawful-redaction rules before launch.

## 7. Browse, search and inspect moderation history

Build a moderator history area separate from the pending-work dashboard. It
should support:

- full-text search over titles, propositions, fact wording, reasons and discussion;
- filters for date, case type, topic, category, tag, state, action, outcome,
  priority and pseudonymous moderator;
- filtering for corrected, withdrawn, reinstated, reversed and escalated work;
- direct lookup by case, proposal, report, opinion-question or fact-question ID;
- a chronological case timeline;
- before/after and field-level diffs;
- links from the current published item to its complete editorial history;
- export in a documented machine-readable format, subject to permissions.

Search results should never reveal participant identities, reporter identities
or the restricted mapping behind moderator handles. Log searches and exports
that touch restricted or unusually broad data.

## 8. Conflict and disagreement resolution

### Ordinary editorial disagreement

1. The first reviewer records a proposed decision and rationale.
2. The peer reviewer identifies the precise disputed claim, standard or evidence
   and proposes an alternative.
3. Both moderators receive one structured opportunity to respond in the case
   thread and may agree a revised outcome.
4. If they agree, the revised outcome still records both earlier positions and
   requires peer approval.
5. If they do not agree, the case becomes `escalated`; neither moderator may
   decide it alone or select the deciding panel.

### Escalation panel

Assign three eligible moderators randomly, excluding everyone who previously
acted on the case, anyone recused and moderators with a declared conflict. The
panel sees the complete case history under pseudonyms.

Each panel member records an independent proposed outcome and rationale before
seeing the others' final votes, reducing conformity pressure. After discussion,
a two-thirds decision closes the escalation. The final rationale must state the
controlling evidence and editorial standard and acknowledge material minority
reasoning. Do not expose how named real people voted.

If fewer than three independent moderators are available, keep the item pending
or seek a pre-approved external subject adviser rather than pretending the
original pair constitutes an independent appeal. External advisers should also
receive case-scoped pseudonyms, declare conflicts and create auditable events.

### Urgent cases

Permit one moderator to impose a temporary, prominently recorded withdrawal when
leaving material live creates a plausible immediate risk, such as a dangerous
falsehood or malicious link. Temporary withdrawal must trigger expedited peer
review and expire automatically unless confirmed within a defined period.

### Reconsideration and appeal

Allow a closed case to be reopened for new evidence, a changed source, a factual
error in the decision, or a material procedural failure. Disagreement alone is
not sufficient after a panel decision. A reopened case must be assigned to
moderators who did not determine the previous outcome where staffing permits.

Limit repeated reconsideration requests unless genuinely new grounds are given.
Record reversals without rewriting the earlier decision. Periodically review
reversals to improve the editorial standard and moderator training.

### Conduct or allocator disputes

Keep moderator-conduct complaints separate from the editorial merits of a case.
The moderator complained about, close collaborators and anyone able to identify
the complainant through the underlying account must be excluded. Serious cases
may require the restricted administrator role or an independent trustee.

## 9. Permissions and safeguards

Split the present all-purpose moderator role into capabilities, for example:

- review reports;
- edit fact questions;
- review proposals;
- peer-review decisions;
- participate in escalation panels;
- coordinate assignments;
- inspect and export history;
- reinstate withdrawn content;
- administer moderator accounts and restricted identity mappings.

Use least privilege. New moderators should begin with supervised case types and
enhanced peer-review sampling. Sensitive capabilities should require tenure,
training and explicit appointment rather than being earned solely through quiz
participation.

Enforce recusals for personal involvement, significant prior advocacy, financial
interest or close connection to a source or organisation. Recusal reasons may
need a moderator-visible general category and a separately protected detailed
record so the explanation does not defeat anonymity.

Add optimistic locking or equivalent conflict protection to editable content so
two moderators cannot unknowingly overwrite one another. Show stale-version
conflicts as diffs requiring an explicit new edit.

## 10. Delivery phases

### Phase A — foundations

- Add stable pseudonymous moderator identities and restricted mapping access.
- Introduce moderation cases, assignments, immutable content versions and the
  append-only event ledger.
- Route all existing moderation actions through case services that write events
  transactionally with state changes.
- Backfill legacy actions honestly, marking unavailable detail as legacy rather
  than inventing history.

### Phase B — fair queue and history

- Add capacity, complexity points, assignment leases, recusal and reassignment.
- Build pending, assigned-to-me and overdue queue views.
- Build searchable history, timelines and diffs.
- Add fairness and concentration reporting.

### Phase C — collaboration and peer review

- Add case-bound pseudonymous discussion.
- Add mandatory and sampled peer-review policies.
- Add changes-requested and reopening workflows.
- Add notification preferences without creating direct messaging.

### Phase D — conflict governance

- Implement random independent escalation panels and independent initial votes.
- Add temporary emergency withdrawal with expiry.
- Add reconsideration, conduct review and external-adviser procedures.
- Publish the moderator editorial and conduct policies.

### Phase E — assurance

- Test assignment fairness under uneven capacities and absences.
- Test that no moderator can review their own work or infer another moderator's
  account through normal endpoints, HTML, exports or logs.
- Test event immutability, transactional completeness, version diffs and restore.
- Conduct a privacy review and threat model for pseudonym linkage.
- Run periodic audits of workload balance, reversal rates, pair concentration,
  unresolved age, emergency actions and access to restricted mappings.

## 11. Decisions to make before implementation

- Which case types and actions receive which complexity points?
- What capacity scale and assignment acknowledgement period are reasonable?
- Which actions require mandatory peer review, and what sample rate applies to
  routine decisions?
- How long may an emergency withdrawal remain unconfirmed?
- Who holds the restricted administrator permission and how is its use overseen?
- When is an external adviser necessary and how are advisers selected?
- Which parts of the audit history should eventually be public, moderator-only,
  or restricted to administrators?
- What retention and lawful-redaction policy applies to discussions and events?
- How should the service respond when the moderator pool is too small to provide
  genuinely independent review?

## 12. Acceptance criteria

- Assignment simulations show workload proportional to declared capacity and
  complexity, without persistent topic or reviewer-pair concentration.
- A moderator cannot receive their own peer review or an item from which they
  are recused.
- Moderators see stable handles but cannot retrieve another moderator's account,
  participant history, name or email.
- Every state or content change produces a matching immutable event and version
  in the same transaction.
- A moderator can reconstruct and search the complete history of any case,
  including earlier wording and reversed decisions.
- Correcting, withdrawing, dismissing, reinstating, escalating and reopening all
  have distinct recorded meanings.
- A two-moderator deadlock cannot silently become a final decision.
- Emergency action is time-limited and independently reviewed.
- Backup restoration preserves cases, versions, discussions, pseudonyms and the
  event ledger.
