# Identity data security and breach-radius plan

## Status

Future implementation plan. This document records the intended direction; it
does not mean that identity fields are encrypted today.

The immediate work is deliberately sized for the present deployment: 16 user
accounts, one Rails web service and one managed PostgreSQL database on Render.
A short maintenance window is preferable to building a complex online
migration or a separate identity service prematurely.

## Purpose

Reduce the likelihood that a security incident exposes a participant's
identity, and reduce the harm if one layer is breached. The most important risk
is not an email address in isolation, but the ability to associate a named
person with their opinions, answers, knowledge weights, reports and private
reflections across sensitive topics.

This plan should:

- protect readable identity data in database copies, backups and direct
  database access;
- minimise identity and security data collected or retained;
- limit who and what can read identity fields;
- preserve Devise sign-in, confirmation, recovery and account deletion;
- keep operational recovery possible without placing keys beside the data;
- avoid security theatre, such as replacing integer IDs with UUIDs or moving
  columns to another table in the same database and calling that separation;
- establish privacy boundaries before future features collect more linkable or
  intimate participant data; and
- remain proportionate to a small, single-host service while leaving a clear
  path to stronger isolation if the service grows.

## Current position

The `users` table currently stores `email`, `unconfirmed_email`, `first_name`
and `last_name` as ordinary readable strings. The unique email index also
contains the readable email. Devise stores passwords as one-way password
digests, and moderator API tokens are stored as one-way digests. Rails filters
email, password and token-shaped request parameters from application logs.

The application already has useful controls: forced HTTPS, secure HTTP-only
cookies, authentication rate limits, non-enumerating authentication responses,
limited production model inspection, self-service deletion and security checks
in CI. These should be retained and tested.

The following cannot be established from the repository alone and must be
verified in the Render and Resend control panels:

- database volume and backup encryption;
- backup availability, retention, access and deletion behaviour;
- database network exposure and operator access;
- application and platform log retention;
- Resend recipient and delivery-event retention; and
- audit and alert facilities for secret access, exports and unusual reads.

Provider encryption at rest is still required, but it protects a different
boundary from application-level encryption. It does not prevent a valid
database credential, SQL injection, an exposed logical dump or a database
administrator from reading plaintext columns.

## Threat model and limits

### Incidents this plan should materially mitigate

- a production database dump or backup is copied without the application keys;
- a read-only or runtime database credential is disclosed;
- an operator or support process queries more personal data than intended;
- production data is accidentally copied into a lower-security environment;
- logs, email-event records or operational exports retain unnecessary identity;
- one operational credential is compromised but the attacker does not also
  gain all application secrets and code-execution capability; and
- future analytical or moderation access needs participation records but not
  account identity.

### Incidents encryption alone cannot solve

An attacker controlling the running Rails process can normally use its keys and
permissions to decrypt whatever the application can decrypt. Application-level
encryption therefore complements, rather than replaces, patching, access
control, monitoring, least privilege and incident response.

If the database, application process and encryption keys are compromised
together, the encrypted columns offer little protection. Strong isolation from
that scenario eventually requires identity to be placed behind a separately
controlled boundary with separate credentials and keys. That is a later scale
trigger, not part of the first implementation.

## Decisions for the present deployment

### Encrypt identity fields in the application

Use Rails Active Record Encryption for:

- `email`, deterministically encrypted because Devise requires exact lookup and
  the database must enforce uniqueness;
- `unconfirmed_email`, deterministically encrypted for consistent Devise
  reconfirmation behaviour; and
- `first_name` and `last_name`, non-deterministically encrypted because the
  application does not search or group by them.

Continue to normalise emails by stripping whitespace and applying the same
case convention before encryption and lookup. Use Rails' encrypted-attribute
`downcase` support rather than relying on a case-insensitive uniqueness
validation, which does not provide encrypted uniqueness. The unique index will
operate on deterministic ciphertext rather than readable email. Deterministic
encryption reveals when encrypted values are equal and should not be used for
names or other fields that do not need lookup.

Do not add searchable hashes for names. Do not log ciphertext as a substitute
for a safe event identifier.

Before implementation, confirm with a focused Devise prototype that Rails 8.1
encrypted query expansion works for sign-in, registration uniqueness,
confirmation, reconfirmation, password reset and the two email-based Rake
tasks. If that compatibility is unsatisfactory, the fallback is randomized
email encryption plus a separately keyed HMAC lookup column and explicit
Devise lookup overrides. That fallback is more custom authentication code and
must not be chosen merely for architectural neatness.

### Keep keys outside the database and repository

Generate dedicated Active Record encryption keys and a key-derivation salt.
Store them as protected Render environment secrets. They must not be stored in:

- Git or committed Rails credentials;
- PostgreSQL;
- database backups or ordinary data exports;
- issue trackers, chat, shell history or deployment logs; or
- the same recovery document as an unencrypted database backup.

Restrict secret visibility to the smallest practical operator group. Keep a
separate, access-controlled recovery copy. Document how to restore the service
when the primary deployment is unavailable and test that procedure. Losing
these keys means losing access to participant identity.

Rails supports a list of primary keys for rotating non-deterministically
encrypted fields, so old name ciphertext can remain readable while new writes
use the current primary key. Rails does not support the same built-in rotation
mechanism for deterministic encryption. Rotating the deterministic email key
therefore requires a separately rehearsed migration, such as a new encrypted
column and unique index followed by an atomic authoritative-column switch, or
the HMAC lookup design described above. Never replace the deterministic key in
place and assume old email ciphertext will remain queryable.

Any rotation is incomplete until every relevant record has been re-encrypted,
indexes and account flows have been verified, and a tested backup no longer
depends on the old key. Do not delete an old key merely because a deployment
succeeded.

### Minimise identity before adding infrastructure

Decide whether legal first and last names are genuinely necessary. The current
participant experience appears to need a greeting and email salutation, not a
verified civil identity. The preferred product change is therefore:

1. replace required first and last names with an optional display name, or use
   a neutral salutation with no stored name;
2. do not collect a new name during ordinary participation;
3. keep any legally necessary operator or moderator identity record out of
   participant-facing and moderator-facing data; and
4. delete obsolete name ciphertext after the change has been deployed and
   verified.

Encryption is not a reason to retain unnecessary data. This decision should be
made before implementing encrypted names, because removing the fields may be
safer and simpler.

### Do not pretend same-database reshaping is isolation

Participation rows currently link to `users.id`. Replacing that ID with a UUID,
adding a `participant_profiles` table in the same database, or encrypting only
the email does not prevent a whole-database breach from joining identity to
opinions and answers.

At the present scale, retain the existing relational links and reduce exposure
through encryption, data minimisation and access control. Design new services
so ordinary lists, moderation screens, API responses and analytics never load
user identity unless their purpose requires it.

Consider a true identity boundary only when a trigger in the later section is
met. True separation means a distinct datastore or service, distinct
credentials and encryption keys, a random opaque participant identifier, and
a narrowly authorised mapping operation whose use is audited.

## Availability and data-loss risk during implementation

### What “losing access to the database” could mean

This change does not encrypt the PostgreSQL database as a whole, replace its
credentials or move it to another host. A correctly scoped implementation
therefore should not make PostgreSQL itself inaccessible. Four different
failure outcomes must nevertheless be planned for:

1. **Planned application unavailability:** the site is put into maintenance
   mode while all 16 user rows are backfilled and checked.
2. **Application/database incompatibility:** PostgreSQL remains available, but
   a release cannot read a mixture of plaintext and ciphertext, cannot query
   encrypted email, or encounters an incompatible column or index.
3. **Cryptographic lockout:** PostgreSQL and all rows remain present, but the
   application lacks the correct key or salt and cannot decrypt identity or
   find users by email.
4. **Actual data loss:** a faulty migration overwrites identity with unusable
   ciphertext, a rollback restores an old whole-database backup and discards
   newer participation, or every copy of a required key or recoverable
   pre-migration value is lost.

The third outcome is the distinctive new risk introduced by application-level
encryption. From a participant's perspective, inaccessible ciphertext can be
equivalent to deleted identity even though the database is healthy.

Loss of the deterministic email key or key-derivation salt would prevent email
lookup, sign-in, confirmation and password recovery for every encrypted
account. Loss of only the non-deterministic primary key would make retained
names unreadable but need not prevent email sign-in. Opinions, answers and
other rows would still exist under user IDs, but participants could not safely
resume control of those records until identity was recovered. If names are
removed before encryption, that part of the key-loss exposure disappears.

### Quantified planning estimates

The following are engineering estimates for one carefully rehearsed migration,
not measured incident frequencies. They assume 16 users, one application host,
writes disabled for the maintenance window, a verified pre-migration backup,
separately verified keys, and an operator following the runbook. Re-estimate if
those assumptions change.

| Failure | Residual chance per migration | Expected interruption | Maximum immediate scope |
| --- | ---: | ---: | --- |
| Ordinary planned maintenance | Near certain | 5–15 minutes | All visitors temporarily |
| Release starts without usable keys | Low, 1–5% | 5–30 minutes; roll back configuration or release | All account functions; database remains available |
| Email query/Devise incompatibility missed by tests | Low, 1–5% | 15–60 minutes; keep maintenance mode and roll back | All encrypted accounts |
| Duplicate normalized email or invalid row stops backfill | Low, 1–5% before production preflight; below 1% after it | 15–60 minutes for manual resolution or abort | One or a few accounts; no row should be changed silently |
| Column, index or transaction failure during backfill | Very low, below 1% after rehearsal | 15–60 minutes; transaction rollback or release rollback | `users` identity fields and authentication |
| Restore is needed but the backup is not actually restorable | Material if never tested, approximately 5–20%; below 1% after a successful rehearsal of the exact procedure | Several hours or permanent loss | Up to all production data in the failed backup |
| Correct database survives but all usable encryption keys and recovery copies are lost | Very low, below 1% with two independently controlled copies; impact is nevertheless critical | Permanent unless identity can be recovered from a protected older backup | Email access for all users; names too if their key or salt is lost |
| Operator restores the whole pre-migration database over newer production data | Very low, below 1% with maintenance mode and a written restore target | 30 minutes to several hours | All writes made after the backup |

These numeric bands are deliberately broad:

- **very low** means below 1% per migration;
- **low** means 1–5%;
- **material** means 5–20%; and
- **critical impact** means that the outcome is unacceptable even when its
  probability is very low.

They are useful for choosing controls, not for claiming statistical precision.
The largest avoidable risk is an untested restore or mishandled key, not the
time needed to encrypt 16 rows. Without a rehearsal, verified backup and
separate key recovery copy, this plan must not proceed.

### Recovery objectives for this migration

Set the following initial objectives:

- **planned maintenance target:** 15 minutes;
- **abort threshold:** if encryption, verification and smoke tests have not
  completed within 30 minutes, stop and follow the rollback runbook rather than
  improvising on production;
- **recovery time objective for application/configuration failure:** 60
  minutes;
- **recovery time objective when a provider backup restore is required:** four
  hours, subject to confirmation against the actual Render plan;
- **recovery point objective during the migration:** zero acknowledged writes,
  achieved by disabling writes before taking the identified backup; and
- **acceptable irreversible loss:** zero user identity rows and zero
  participation rows.

The provider recovery objective is provisional until an actual timed Render
restore proves it. If the available hosting plan cannot restore within four
hours, record the real result rather than retaining an aspirational number.

### Controls that make the estimates credible

Before the maintenance window:

1. Verify the production user count, normalized-email uniqueness, nulls,
   maximum lengths and pending reconfirmations without printing values.
2. Run the exact schema change and backfill against a recent PostgreSQL restore,
   not only the development SQLite database.
3. Test the backup by restoring it and checking record counts and representative
   account flows. The existence of a backup job is not proof of recoverability.
4. Generate and validate the production primary key, deterministic key and salt
   before disabling writes. Verify a separately controlled recovery copy by
   comparing non-secret fingerprints, never by logging the secrets.
5. Preserve the currently running image or commit, its configuration contract
   and an explicit non-destructive rollback command.
6. Prove that the old release can still operate against the rollback database
   state. A code rollback alone is unsafe if the old model reads ciphertext as
   ordinary email.
7. Record pre-migration counts for users, opinions, responses and other
   dependent records so that recovery checks more than the `users` table.

During the maintenance window:

1. Reject writes at the application boundary before taking the backup; do not
   rely only on a banner or hidden form controls.
2. Use a transaction for the identity backfill where PostgreSQL locking and the
   tested migration method permit it. Do not combine encryption with unrelated
   schema or product changes.
3. Stop immediately on a row-count mismatch, duplicate, decryption error,
   unexpected plaintext/ciphertext state or failed account-flow smoke test.
4. Do not drop old columns, old indexes, old keys or the pre-migration backup in
   the same maintenance window.
5. Re-enable writes only after raw-storage checks and registration, sign-in,
   confirmation and recovery tests pass.

After the release:

1. Retain the protected pre-migration backup, old release and all necessary
   keys for a defined observation period, provisionally seven days.
2. Because that backup contains plaintext identity, restrict and audit access
   and delete it according to the provider's supported process once the
   observation period and a new encrypted-backup restore test have succeeded.
3. Test restoration of a post-migration encrypted backup with keys obtained
   from the separate recovery location.
4. Monitor authentication failures and decryption exceptions without logging
   submitted addresses or ciphertext.

### Rollback choices and their consequences

Prefer the least destructive recovery:

1. **Bad release, unchanged database:** deploy the old release or correct the
   secret/configuration. Expected data loss: none.
2. **Backfill transaction failed and rolled back:** deploy the old release
   against the verified plaintext state. Expected data loss: none.
3. **Ciphertext is valid but the release is faulty:** retain the database and
   deploy the tested encryption-capable predecessor or fix. Do not point a
   plaintext-only release at ciphertext.
4. **Identity columns are unusable but current participation data is sound:**
   restore the pre-migration backup into an isolated temporary database,
   recover only the required user identity records under controlled handling,
   and re-encrypt them into the current database. Do not overwrite the whole
   current database merely to recover 16 identity rows.
5. **Whole database is corrupt or unavailable:** restore the identified backup
   to a new database, verify it, then switch the application connection. This
   is the last resort and is the only path that risks losing post-backup writes;
   maintenance mode should make that number zero for this migration.

No rollback step should use a destructive in-place reset, drop or overwrite
without first resolving the exact database target and retaining the failed
state for investigation. A successful rollback restores account ownership and
participation counts, not merely a green health endpoint.

## Delivery plan

### Stage 0: inventory, decisions and rehearsal

1. Count production users and confirm whether any have a pending email change.
2. Decide whether to remove names, replace them with one optional display name,
   or encrypt the existing fields temporarily.
3. Inventory every identity read and lookup, including Devise, mailers, account
   pages, moderator provisioning, API token issuance, tests, exports and
   operational scripts.
4. Verify Render and Resend controls listed under Current position and record
   the actual settings in the private deployment records.
5. Define an authorised operator and recovery location for encryption keys.
6. Add characterization tests for all affected account flows.
7. Restore a recent production backup into a restricted temporary environment,
   run the migration rehearsal, and verify rollback while the old keys and
   backup remain available.

Do not print production email addresses, plaintext names, ciphertext or keys in
the migration output. Report counts and record IDs only where a record requires
manual attention.

### Stage 1: introduce and test encryption configuration

1. Add explicit Active Record Encryption configuration read from protected
   deployment secrets.
2. Add model declarations for the chosen fields.
3. Increase column capacity before encryption so ciphertext cannot be
   truncated. Preserve an enforceable maximum plaintext email length at the
   model boundary.
4. Retain the unique email index and prove that it no longer contains readable
   addresses after backfill.
5. In non-production tests, cover plaintext compatibility only for the
   migration interval; steady-state tests must fail if newly written identity
   remains plaintext.
6. Add a boot-time failure for production when encryption keys are absent. Do
   not silently fall back to plaintext.

The implementation should use the smallest compatibility window possible.
Support for reading unencrypted records is a migration tool, not a permanent
configuration.

### Stage 2: small-dataset maintenance migration

Because there are few users and one application host, use an announced short
maintenance window:

1. disable sign-up, sign-in, password reset, confirmation and other writes;
2. take and identify a restorable pre-migration backup;
3. deploy the encryption-capable release with all required keys present;
4. run a repeatable, transaction-aware backfill over every user;
5. verify the expected count, no blank or duplicate normalized emails, and no
   pending fields left unprocessed;
6. inspect raw PostgreSQL values through a restricted session and confirm that
   known emails and names are absent from the table and indexes;
7. run account-flow smoke tests using a dedicated test account;
8. re-enable traffic; and
9. retain the rollback release, pre-migration backup and keys until the defined
   observation period has passed.

With 16 records, dual-writing old and new columns across several deployments
would add failure states without meaningful availability benefit. If the
production count or topology has grown substantially by the time this is
implemented, revisit that decision.

The backfill must be idempotent or detect already-encrypted values safely. It
must stop on any invalid or duplicate email rather than silently changing an
account identity.

### Stage 3: close the compatibility window

1. Disable support for reading unencrypted identity values.
2. Run an automated database audit asserting that every non-null protected
   value has the expected encrypted form.
3. Search logs, jobs, cache entries, exception reporting and email tooling for
   unintended identity leakage.
4. Update the privacy notice accurately: say that account identity is
   application-encrypted, while explaining that authorised application
   functions and email providers necessarily process it.
5. Update production-security and recovery documentation with key ownership,
   rotation and restore checks without including secrets.
6. Set a date for the first restore and rotation exercise.

Do not describe password hashing as encryption and do not promise that an
application compromise cannot expose identity.

### Stage 4: reduce routine access and retention

1. Review moderator HTML, JSON, API and MCP serializers to ensure participant
   identity is absent by default.
2. Replace email-based operational commands with internal user IDs or a
   purpose-built lookup command whose access and invocation are controlled.
   Avoid placing addresses in shell history.
3. Use internal event IDs and request IDs in logs and support notes.
4. Verify that production data is prohibited from development and test unless
   irreversibly anonymised under a documented process.
5. Configure and record actual log, backup and Resend retention.
6. Review inactive accounts periodically, as already required by the privacy
   operations checklist, and define notice and deletion rules.
7. Test that account deletion removes live identity and dependent
   participation, and document what remains temporarily in immutable backups.
8. Restrict and periodically review Render, PostgreSQL, Resend, domain and
   source-repository access. Require strong MFA where the provider supports it.

### Stage 5: incident readiness

Create a concise private runbook covering:

- how to revoke database, Render, Resend, Rails and moderator API credentials;
- how to determine whether application encryption keys were also exposed;
- how to preserve necessary evidence without copying unnecessary personal data;
- how to identify affected records, backups, logs and providers;
- who assesses notification duties and contacts participants or regulators;
- how to deploy rotated encryption schemes and re-encrypt affected data; and
- how to verify restored backups and reapply account deletions where
  practicable.

Exercise one scenario in which only a database backup leaks and another in
which the application secrets leak. The response and likely impact differ
substantially.

## Relationship to other future plans

### Topic discovery and a larger topic catalogue

The topic-discovery-at-scale plan is mainly orthogonal and need not wait for
identity encryption. Its scalable catalogue query work can proceed in
parallel. However:

- regional interest must remain topic metadata or an explicit presentation
  preference, not inferred residence or a hidden demographic profile;
- any saved regional preference becomes participant data and must receive an
  explicit purpose, retention period, deletion path and exposure review;
- popularity, controversy and recent-activity collections must continue to use
  aggregates and minimum-group protections; and
- query and cache design must not embed user emails, names or stable individual
  histories in public or shared cache keys.

Complete Stages 0–3 of this plan before adding new persistent personalisation
to topic discovery.

### Shared fact questions across opinion banks

The shared-fact plan changes editorial and scoring relationships, not account
identity, so its one-to-one membership migration can proceed independently.
It nevertheless increases cross-topic linkability: one canonical answer may
contribute to several topic scores and a whole-database breach can reveal a
broader participation profile.

Therefore:

- complete identity encryption before the controlled multi-bank sharing pilot;
- include cross-topic linkability in the sharing pilot's privacy review;
- keep participant identity out of canonical-fact moderation and overlap
  reports;
- ensure account deletion reaches canonical responses and any later attempt
  history; and
- do not add `FactResponseAttempt` without a specific need and retention rule,
  because append-only answer history increases breach impact.

The shared-fact schema should use opaque user foreign keys and must not copy
identity fields into memberships, responses, audit events or analytical tables.

### Helping participants engage with counterevidence

The existing counterevidence-receptivity plan correctly treats private
reflections, confidence and perspective-taking answers as potentially
sensitive. Non-persistent prompts can be trialled without waiting for this
plan. Before storing any such response:

- complete identity encryption and the data-minimisation decision;
- define whether the response needs to be linked to an account at all;
- prefer structured choices over free text;
- provide participant visibility and item-level deletion;
- prohibit moderator access to identifiable responses;
- set retention and minimum aggregate thresholds; and
- conduct a privacy and safeguarding review of free text separately.

These records may reveal identity, beliefs, uncertainty, trust and emotional
vulnerability more directly than an ordinary quiz answer. They should not be
added to a general-purpose event stream or retained merely because storage is
cheap.

### Anonymous public reasons for participants' opinions

Allow a participant, when first giving or later revising an opinion, to add a
concise reason for that opinion. An opinion-question page may then show
published reasons anonymously, in descending order of the participant's
current knowledge weight for that opinion question. This can make an important
minority view intelligible: for example, readers could see why a highly
informed participant disagrees with the majority rather than seeing only the
aggregate position.

The interface and documentation must call this **topic knowledge weight**, not
an expert score or proof that the reason is correct. The weight measures correct
answers to this site's selected fact questions. It does not verify professional
credentials, reasoning quality, representativeness or moral authority. Reasons
must not themselves affect knowledge weight or the collective result.

#### Participant and publication semantics

- The reason is optional. Giving or revising an opinion must remain possible
  without writing or publishing one.
- Publication must be an explicit choice separate from saving the opinion. A
  private draft must never become public because of a preselected checkbox.
- Show a just-in-time warning that public free text can identify its author
  through names, workplaces, personal experiences or writing style even when
  the site omits account identity.
- Publish no name, email, account/profile link, participant handle, user ID,
  answer history or cross-topic history with a reason. Do not provide a stable
  public pseudonym or any facility for grouping one participant's reasons
  across opinion questions.
- A participant must be able to preview, edit, unpublish and delete their
  reason. Account deletion must remove it from the live service.
- Keep at most one current reason for each participant and opinion question.
  Do not expose superseded text publicly or retain a permanent participant-
  visible revision archive without a separately justified need.
- When the participant changes opinion position, require them to confirm,
  replace or remove the old reason before it can remain published. Do not
  silently present old reasoning as support for a new position.
- A weight change caused by later fact answers may reorder a published reason
  automatically. Explain this when the participant publishes and on the public
  list.

The first implementation should model the reason separately from
`UserOpinion`, with a one-to-one relationship, rather than add public-text and
moderation lifecycle fields to the scoring record. Suggested fields are:

```text
opinion_reasons
  user_opinion_id          unique, required foreign key
  body                     required text with a conservative length limit
  publication_state        private, pending, published, hidden
  published_at
  participant_edited_at
  moderation_state         clear, flagged, hidden
  moderation_reason        restricted; required when hidden
  created_at / updated_at
```

Do not copy the participant's email, name, opinion position or calculated
weight into the reason row. Join to the current opinion and calculate current
weight through `OpinionProgress` when constructing the public result. If
performance later requires a cached weight, treat it as derived data with a
clear invalidation rule whenever a relevant response, fact importance,
membership or retirement state changes.

#### Public display and ordering

For each live opinion question, provide a **Reasons participants gave** view
that can be filtered by the five opinion positions. Each item may show:

- the current opinion position;
- the reason text;
- the participant's current topic knowledge weight, with a link to the
  methodology; and
- the date the reason was last substantively revised.

Order eligible reasons by exact current topic knowledge weight descending, then
by reason revision time descending, then by an opaque stable record ID so ties
are deterministic. Do not use reactions, popularity, moderator preference or
the degree of agreement with the aggregate as hidden ranking factors. Clearly
state that ranking reflects demonstrated topic knowledge, not endorsement of
the argument.

Do not label an individual as an “expert” solely from this ordering. Product
copy may say that a reason comes from a participant with a high topic knowledge
weight. A later verified-credentials feature, if ever justified, would require
its own evidence, privacy and conflict-of-interest design.

The list should represent disagreement honestly. Provide an easy position
filter and consider a small, clearly labelled sample from each populated
position before the full ranked list so that a low-weight majority cannot make
a high-weight minority impossible to find, and a high-weight minority cannot
be mistaken for the numerically common view. Continue to show the aggregate
distribution separately.

#### Safety, moderation and abuse controls

Public reasons are user-generated content and create risks that encrypted
account fields do not address. Before launch:

- define content rules covering personal data, threats, harassment, unlawful
  content, impersonation, spam and unsupported allegations about identifiable
  people;
- render as escaped plain text in the first release; do not accept HTML or
  automatically embed remote media;
- impose a conservative length limit and rate-limit creation and revision;
- provide a report action that does not reveal the author;
- allow moderators to hide a reason with a recorded category and rationale,
  while allowing the participant to see its status and appeal route;
- prevent ordinary moderators from resolving the reason to a user's identity;
- ensure moderation queues, notifications, search indexes, caches and logs do
  not acquire copied account identity;
- decide whether pre-publication review is proportionate while the community
  is very small, switching to post-publication reporting only when moderation
  coverage is reliable; and
- cover public-reason moderation in the moderation-at-scale case and audit
  model rather than building an unaudited parallel moderation system.

The public presentation is anonymous by design because it withholds author
identity and cross-topic linkage. However, the small present population creates
a high likelihood that a distinctive reason, precise weight or stated
experience can still allow a reader who already knows the participant to infer
authorship. Minimum-group thresholds cannot prevent that inference for an
individually published statement. The publication explanation must state this
limit plainly and obtain explicit consent; it must not promise that
re-identification is impossible.

#### Relationship to counterevidence receptivity

Opinion reasons can help participants articulate assumptions, values and
evidence, and can help readers encounter the strongest reasoning behind a
minority position. They can also make people defend a written position more
strongly, invite performative argument, or confuse persuasive prose with
factual knowledge.

The initial release should therefore:

- use a neutral prompt such as “What is the main reason for your view?”;
- avoid asking participants to persuade, defeat or rebut another group;
- distinguish empirical claims, value judgements and uncertainty where the
  participant chooses to do so, without forcing a rigid template;
- show reasons only after the reader has stated an opinion, or explicitly
  measure whether seeing them first anchors later responses;
- never infer `evidence_direction` or change quiz ordering from reason text;
- never send a participant's reason to another participant for direct debate;
  and
- evaluate whether publishing a reason affects willingness to revise an
  opinion, confidence or reason later.

This feature is distinct from the counterevidence plan's private reflection on
what might change one's mind. Do not publish that private reflection, and do
not combine the two fields merely because both contain explanatory text.

#### Delivery gate and acceptance criteria

Complete identity-encryption Stages 0–3 and the name-minimisation decision
before publishing opinion reasons. On the current small service, an unpublished
prototype can be tested earlier with synthetic content.

Before public launch, tests must establish that:

- saving an opinion never requires or implicitly publishes a reason;
- one participant has at most one current reason per opinion question;
- changing position cannot leave an unconfirmed reason attached publicly to
  the new position;
- later fact answers reorder reasons using current topic weight;
- ties have a deterministic order;
- hidden, private, deleted-account and non-live-topic reasons never appear;
- no public response, URL, HTML metadata, cache key or report response exposes
  the reason author's user ID, name, email or cross-topic activity;
- text is safely escaped and length and rate limits are enforced;
- reporting, hiding, participant editing, unpublishing and deletion are
  audited and behave consistently; and
- the privacy notice, terms, methodology and current site copy are revised
  before launch, because they presently promise not to display an individual's
  opinion record.

### Following and email notifications

Following adds delivery preferences, unsubscribe credentials and email-provider
metadata. Complete Stages 0–3 before the email-digest stage of that plan.
Following-page work without email may proceed earlier if its records use only
user IDs and observe deletion and aggregate thresholds.

The digest implementation must:

- decrypt an address only at the delivery boundary;
- avoid copying email addresses into notification-event tables or job
  arguments where a user ID will do;
- use expiring or revocable purpose-bound unsubscribe tokens stored as
  digests, not plaintext bearer tokens;
- avoid recipient addresses and sensitive topic names in routine logs;
- document Resend's recipient/event retention; and
- make deletion and global email opt-out remove pending delivery state.

### Moderation at scale

The moderation plan already calls for stable pseudonymous moderator identities
and a restricted account-to-handle mapping. This security plan provides a
prerequisite but not the complete isolation described there.

Before multiple moderators are given production access:

- encrypt account identity and minimise stored names;
- ensure moderator screens and APIs use pseudonymous handles;
- separate ordinary moderator permission from the rare permission to resolve a
  handle to an account;
- audit every identity-resolution event; and
- avoid direct database access as a normal moderation tool.

At larger scale, the moderator mapping and participant identity mapping should
be considered together rather than creating two incompatible identity vaults.

### Fact-question calibration and internal statistics

Calibration can proceed independently where it assesses editorial content.
Bulk assessment payloads must exclude participant records and identity.

The deferred internal-stat-fact-questions plan can expose information derived
from participant activity as new editorial facts. Its stated privacy and
governance gates remain controlling. Application encryption does not make a
small-group statistic anonymous; aggregation thresholds, immutable provenance
and independent review are still required.

### Hosting, recovery and production operations

The hosting plan's backup, recovery, monitoring and deployment discipline are
direct dependencies. Application encryption makes key recovery part of backup
recovery. A database backup that cannot be decrypted is not a successful
backup; a backup stored beside its keys does not provide the intended breach
boundary.

The production privacy checklist should become an evidenced recurring control,
not only a statement of intent. Record dates, owners, provider settings and the
result of restore/deletion tests in private deployment records.

## Suggested roadmap order

The plans do not require one serial mega-project. Use these gates:

1. **Now:** decide whether names are needed; verify provider controls; add
   characterization tests; encrypt and backfill identity; close plaintext
   compatibility.
2. **In parallel:** continue editorial calibration, topic catalogue query work
   and the one-to-one part of the shared-fact migration, none of which needs new
   participant identity data.
3. **After identity encryption:** pilot multi-bank fact sharing; add on-site
   following; improve pseudonymous moderation boundaries.
4. **After feature-specific privacy review:** publish anonymous opinion
   reasons; store counterevidence reflections, regional preferences or detailed
   activity histories; and deliver email digests.
5. **At demonstrated scale or risk:** consider a separately controlled identity
   boundary, stronger database-role separation, automated access auditing and
   dedicated security monitoring.

This order treats identity encryption as a small foundational change, not as a
reason to block unrelated editorial and catalogue work.

## Triggers for a separate identity boundary

Reassess the single-database design when any of the following becomes true:

- the participant population or topic sensitivity makes a whole-database join
  materially more harmful;
- staff, contractors, researchers or several moderators require production
  data access;
- identifiable exports or analytics become routine;
- the application is split across several hosts or services;
- stored opinion reasons, reflective, confidence, regional or other free-text
  data expand the participant profile;
- contractual, insurer, funder or regulatory requirements demand stronger
  segregation; or
- incident exercises show that application and database access cannot be
  independently contained.

The reassessment should compare a small identity service or separate database
against operational cost, availability, deletion, recovery and key-management
risk. It should not assume that another service is automatically safer.

## Tests and acceptance criteria

Before the encryption migration is considered complete:

- raw production-like database values and indexes contain no known plaintext
  email or retained name;
- registration accepts a new normalized email and rejects the same email with
  case or surrounding whitespace differences;
- sign-in works with the supported email case variants;
- confirmation, reconfirmation and password reset find and mail the correct
  account;
- account mailers receive decrypted values only at delivery time;
- account display and permitted profile updates still work;
- moderator promotion and API-token issuance work without logging an address;
- duplicate emails remain impossible under concurrent registration;
- absent encryption keys prevent production boot or identity writes;
- old non-deterministic ciphertext remains readable during a rehearsed primary
  key rotation and all affected rows can be re-encrypted;
- a separately rehearsed deterministic-email key migration preserves lookup
  and uniqueness without an in-place key replacement;
- the migration can be rerun safely or stops with a clear non-sensitive error;
- account deletion removes the live encrypted identity and dependent records;
- logs and exception output do not contain test email addresses, decrypted
  names, reset/confirmation secrets or encryption keys;
- a restored backup works only when the separately held correct keys are
  supplied; and
- Rails tests, RuboCop, Brakeman, Bundler Audit and the production smoke checks
  pass.

For steady state:

- no plaintext-read compatibility remains enabled;
- key and database access are reviewed on a recorded schedule;
- backup restore and key rotation are exercised at least annually and after a
  material hosting change;
- provider retention settings are checked against the privacy notice;
- new persistent participant fields require purpose, access, retention,
  deletion and aggregation decisions; and
- a security incident can be triaged differently depending on whether the
  database, application keys or both were exposed.

## Decisions required before implementation

1. Are first and last names necessary, or should the service use no name or one
   optional display name?
2. Are any production accounts currently awaiting reconfirmation?
3. Does a focused Rails 8.1 and Devise 5 prototype validate deterministic
   encrypted email lookup for every account flow?
4. Who may access the encryption keys, and where is the separate recovery copy
   held?
5. What maintenance window and rollback observation period are acceptable?
6. What are the actual Render backup, log and database-access settings, and the
   actual Resend event-retention settings?
7. How long should inactive accounts be retained, and what notice precedes
   deletion?
8. Which events merit alerts with the facilities available on the current
   hosting plan?
9. What growth or sensitivity threshold will trigger a formal review of true
   identity separation?

Implementation should begin with the name-minimisation decision and a focused
encrypted-email compatibility spike. It should not begin by introducing a new
service or changing participant IDs.

The implementation spike should use the current official Rails
`Active Record Encryption` guide as the controlling technical reference,
particularly its sections on deterministic queries, encrypted uniqueness,
migrating unencrypted data, previous schemes and the limitation on rotating
deterministic keys.

## Existing plan inventory

This plan was reviewed against the future work currently recorded in the
repository:

- `docs/topic-discovery-at-scale-plan.md`;
- `docs/shared-fact-questions-plan.md`;
- `COUNTEREVIDENCE_RECEPTIVITY.md`;
- `FOLLOWING_PLAN.md`;
- `TODO.md`, which currently contains the moderation-at-scale plan;
- `docs/fact-question-calibration-plan.md`;
- `docs/internal-stat-fact-questions-plan.md`;
- `HOSTING_PLAN.md`;
- `docs/privacy-operations.md` and `docs/production-security.md`;
- `docs/site-presentations.md`;
- `docs/evidence-essay-standard.md` and `docs/editorial-standard.md`; and
- `MANIFEST.md`, which defines the core product and scoring intent.

The repository currently spreads plans between its root, `docs/` and `TODO.md`.
A later documentation-only change should consolidate future plans under one
convention and replace moved files with links where useful. That reorganisation
is intentionally outside this security change so it does not obscure content
history.
