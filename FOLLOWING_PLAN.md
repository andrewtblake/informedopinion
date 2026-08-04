# Following and Topic Notifications Plan

## Purpose

Allow a signed-in participant to follow an opinion question and receive useful,
anonymous summaries when participation or the informed aggregate changes.

Following a question must not require the participant to register an opinion on
it. It must not introduce user-to-user communication or reveal who performed an
activity, what answer an identifiable participant gave, or an individual's
knowledge score.

## Product principles

1. Report accumulated topic activity, not individual behaviour.
2. Prefer useful digests to a notification for every action.
3. Treat a new opinion, an opinion revision and fact-question activity as
   distinct events.
4. Suppress small activity groups until the configured privacy threshold is
   reached.
5. Make following and email delivery explicitly opt-in and easy to stop.
6. Keep notification generation independent of email delivery so other channels
   can be added later.
7. Preserve the presentation through which the topic was followed, so links,
   names and language use either `informedopinion.info` or
   `whatsyourview.info` appropriately.

## Recommended first release

The first release should provide:

- Follow and unfollow controls on an opinion-question page.
- A **Following** page listing followed questions and activity since the
  participant's last visit.
- A weekly email digest, separately enabled by the participant.
- Counts of new opinions, genuine opinion revisions and unique participants who
  answered fact questions.
- Notification when the knowledge-weighted aggregate moves materially.
- Anonymous summaries subject to a minimum-group threshold.
- Secure one-click email unsubscribe links that do not require signing in.

It should not initially provide immediate per-action email, mobile push
notifications or user-configurable threshold rules.

An example digest item is:

> Since your last update: 12 people registered an opinion, 7 revised one, and
> 19 participants answered fact questions. The informed result moved from +18
> to +23.

## Definitions

### New opinion

The first opinion registered by a participant for a topic.

### Opinion revision

A saved change from one response position to a different response position.
Saving the same position again does not count. The immutable opinion-history
records are the source of truth.

### Fact-question activity

The initial implementation should report both of the following internally:

- answer submissions; and
- unique participants submitting an answer during the period.

Public notification text should normally use unique participants because
retries must not make activity appear broader than it is. It may additionally
report the number of questions answered when the distinction is clearly
worded. It must not reveal correctness or selected answers at participant
level.

### Material aggregate movement

Movement should be measured on the existing -100 to +100 informed-opinion
scale. The initial threshold should be application configuration rather than a
hard-coded value. A suggested starting value is 5 points, provided that the
underlying activity also satisfies the privacy threshold.

## Data model

### `topic_follows`

One record per participant and opinion question:

- `user_id`
- `opinion_question_id`
- `site_key`
- `email_enabled`
- `digest_frequency`
- `last_viewed_at`
- `last_notified_at`
- `created_at`
- `updated_at`

There should be a unique index on `user_id, opinion_question_id`. Deleting an
account or opinion question must delete its follows.

Although the first release supports a weekly email schedule, the data model may
permit `none`, `daily` and `weekly` so daily delivery can be introduced without
a migration.

### `topic_activity_buckets`

Store accumulated anonymous activity for a bounded period, initially one hour
or one day:

- `opinion_question_id`
- `period_started_at`
- `period_ended_at`
- `new_opinions_count`
- `revisions_count`
- `fact_answers_count`
- unique participant counts for each relevant activity type
- aggregate score at the start and end of the period
- `created_at`
- `updated_at`

A unique index should prevent duplicate buckets for a topic and period. Buckets
avoid retaining a permanent notification event for every answer and make
privacy checks and digest generation cheaper.

Exact unique-participant calculation may require short-lived activity records
or database sets during an open bucket. The implementation must not rely on
adding together per-hour unique counts when producing a weekly unique count,
because the same person may appear in several buckets.

### `notifications`

Store generated participant-facing summaries independently of email:

- `user_id`
- optional `opinion_question_id`
- `site_key`
- `kind`
- structured summary data
- first and last activity identifiers or periods included
- `read_at`
- `emailed_at`
- delivery status and idempotency key
- `created_at`
- `updated_at`

Structured data should be rendered through site-specific copy rather than
storing final prose only.

### Unsubscribe tokens

Use signed, expiring or purpose-bound Rails tokens. Do not store a reusable
plain-text token. Unsubscribing from one topic must be distinguishable from
disabling all digest email.

## Activity capture

Record activity after the relevant database transaction commits:

- Creating `UserOpinion` increments new-opinion activity.
- Creating a genuine `OpinionHistory.revision` increments revision activity.
- Creating or updating `FactResponse` increments answer activity and records
  the participant in the bucket's unique set.

Activity capture should live in a domain service called from all applicable
paths, or in carefully tested after-commit hooks, so the web interface and API
cannot produce different results. Jobs and retries must be idempotent.

The system need not reconstruct answer events that occurred before activity
tracking was introduced.

## Digest generation and delivery

Solid Queue should run scheduled jobs that:

1. Close elapsed activity buckets.
2. Select follows whose digest is due.
3. combine activity since each follow's last successful notification;
4. apply privacy and material-movement thresholds;
5. create one notification per topic, or one combined digest per recipient;
6. deliver opted-in email;
7. record successful delivery and the included activity range.

Delivery must be safe to retry. A stable idempotency key should prevent the same
digest from being created or sent twice.

If a topic has activity below the privacy threshold, its activity should be
held for a later digest rather than reported as “one person did something.” A
maximum retention period should eventually be defined so stale sub-threshold
activity does not remain pending indefinitely.

## Email

Email should use the site identity saved on the follow:

- **Informed Opinion** language and links for the primary presentation.
- **What's Your View?** language and links for the alternative presentation.

The current verified `informedopinion.info` sending domain can serve both. The
alternative presentation may use its own display name and
`hello@whatsyourview.info` as Reply-to without adding another paid Resend
domain.

Every digest must contain:

- why the participant is receiving it;
- links to the followed topic and Following page;
- one-click unsubscribe for that topic; and
- an option to disable all digest email.

Delivery failures should be retained for operational review, without placing
participant identities into the moderator editorial workflow.

## Interface

### Opinion-question pages

Add a quiet, secondary **Follow this question** control near the aggregate
result. Once followed, it becomes **Following**, with an accessible route to
notification preferences and an unfollow action.

### Homepage cards

Homepage follow controls may be added after the topic-page interaction is
established. They should not compete visually with the primary action of
examining the question.

### Following page

The page should support dozens of follows and provide:

- search;
- ordering by recent activity, title and date followed;
- unread or new-activity state;
- the latest aggregate result;
- activity since the last visit;
- per-topic email settings; and
- unfollow controls.

It should follow each site's central styling. It is conceptually separate from
**My opinions** / **Your opinions**, because a participant can follow a topic
without expressing a view.

### Notification indicator

An in-app unread indicator can reuse the polling and visual conventions of the
moderation heartbeat, but must use a separate endpoint, controller and state.
Opening or displaying a notification should mark it read according to the same
clear rules already established for moderation notifications.

## Privacy and abuse controls

- Use the public-statistics minimum-group threshold as the default, with a
  separately configurable notification threshold if later needed.
- Do not expose names, email addresses, selected fact answers, individual
  correctness or individual knowledge weights.
- Do not permit arbitrary notification messages or user-authored content.
- Recalculate or omit summaries if account deletion changes a pending small
  group before notification generation.
- Rate-limit follow changes and unsubscribe endpoints.
- Do not use opens or tracking pixels to profile recipients.
- Record only operational delivery data needed to diagnose failures.

## Moderator and operational visibility

Moderators may see aggregate follow counts by topic and delivery-system health.
They should not need to know who follows a topic. Editorial moderators should
not receive access to recipient addresses or individual notification histories
merely by virtue of the moderator role.

Operational logs should include job identifiers, topic identifiers, counts and
delivery outcomes while avoiding full email addresses where possible.

## Configuration

Suggested settings:

```text
TOPIC_FOLLOWING_ENABLED=false
TOPIC_NOTIFICATION_MINIMUM_GROUP_SIZE=5
TOPIC_NOTIFICATION_AGGREGATE_MOVEMENT=5
TOPIC_NOTIFICATION_DEFAULT_FREQUENCY=weekly
```

The feature flag should hide controls and pages and return 404 for its public
routes while disabled. Capturing activity before the user-facing feature is
enabled is a separate decision and should use its own explicit setting if
required.

## Implementation stages

### Stage 1: foundations

- Add configuration and feature flag.
- Add `topic_follows` and associations.
- Add follow/unfollow endpoints and topic-page control.
- Add authorization, account-deletion and feature-flag tests.

### Stage 2: activity

- Add activity buckets and idempotent activity capture.
- Cover new opinions, genuine revisions and fact-answer submissions.
- Add privacy-threshold and retry tests.

### Stage 3: in-app experience

- Add notifications and the Following page.
- Add search, ordering, read state and activity summaries.
- Apply both site identities and responsive central styling.

### Stage 4: email digest

- Add scheduled Solid Queue jobs.
- Add site-aware HTML and plain-text email templates.
- Add secure unsubscribe flows and preference controls.
- Add delivery idempotency, retries and failure visibility.

### Stage 5: evaluate and extend

- Review whether weekly summaries are timely and useful.
- Consider daily delivery and homepage follow controls.
- Consider notifications for newly published or materially revised fact
  questions.
- Introduce immediate notification only if evidence shows a useful case that
  does not create noise or privacy problems.

## Acceptance criteria for the first release

- A participant can follow and unfollow a published question.
- A participant can follow without registering an opinion.
- Activity from another participant can appear only as an anonymous aggregate
  that meets the minimum threshold.
- Repeated attempts by one participant do not inflate unique-participant
  figures.
- A weekly digest cannot be sent twice for the same activity range.
- Links and copy match the site through which the question was followed.
- A participant can disable one topic or all digest email without signing in.
- Account deletion removes follows, notifications and pending recipient state.
- Disabled feature routes return 404 and controls are absent.
- Tests cover both site identities, privacy thresholds, retries and deletion.
