# Informed Opinion

Informed Opinion records a person's position on a question and gives that
position a topic-specific knowledge weight. The weight is the proportion of
the topic's fact questions that the person has most recently answered
correctly.

This MVP includes:

- Devise registration, sessions and password recovery
- three opinion questions: climate change, U.S. firearm background checks and
  UK membership of the European Union
- 30 sourced multiple-choice facts for each opinion question
- four plausible choices per fact, shuffled at display time
- one-question-at-a-time quizzes with immediate explanations and evidence links
- adaptive ordering that prioritises unseen questions and initially favours
  evidence closer to the user's stated position
- a live opinion weight and the option to revise an opinion at any time
- homepage distributions that sum the knowledge-weighted opinions of all users
- responsive interfaces for the public home page, opinion capture, quizzes and
  authentication

The product intent and scoring rules are in [MANIFEST.md](MANIFEST.md).

## Requirements

- Ruby 4.0.6
- SQLite 3

The repository's `.ruby-version` is understood by `mise`, `rbenv` and similar
Ruby version managers.

## Run locally

```sh
mise install
bundle install
bin/rails db:prepare
bin/rails db:seed
bin/rails server
```

Open <http://localhost:3000>, create an account, and choose any of the three
questions. Seeding is idempotent: rerunning it updates the curated content
without deleting user responses.

## Verify

```sh
bin/rails test
bin/rubocop
bin/brakeman --no-pager
```

The test suite covers scoring from the latest response and the complete
opinion → quiz → feedback → revision journey.

## Domain model

- `OpinionQuestion` owns the proposition and its five balanced responses.
- `FactQuestion` owns answer choices, the correct option, an explanation and
  primary-source attribution.
- `UserOpinion` is unique for a user and opinion question, so a position is
  revised rather than duplicated.
- `FactResponse` is unique for a user and fact question. Retaking a question
  updates that record, ensuring only the latest answer counts.
- `OpinionProgress` calculates the number answered, number correct and weight.
- `NextFactQuestion` prioritises unseen evidence while allowing completed
  quizzes to be reviewed in a new random order.
- `CollectiveOpinion` adds each user's topic weight to their latest opinion
  bucket and expresses each bucket as a share of all contributed weight. A 70%
  informed user therefore contributes `0.7`; a 0% user remains in the raw
  respondent count but does not move the informed result.

The schema permits a fact-question join model to be introduced later if one
fact needs to contribute to several opinion questions, as anticipated by the
manifest. The scoring service and response uniqueness do not assume a quiz
attempt owns the answer, so adding explicit quiz sessions later will not alter
the definition of weight.

## Curated content

Topic data lives in `db/seeds/`. Every fact includes a source name and URL.
Sources favour the IPCC, NASA, NOAA and EPA; the FBI, ATF, CDC, BJS, CRS and
Supreme Court; and the UK Electoral Commission, OBR, Parliament, UK Government
and European Commission.

`evidence_direction` is ordering metadata, not part of scoring. It describes
whether knowing the correct fact is likely to support agreement, disagreement
or neither. Correctness alone determines weight.

The curated banks deliberately distribute correct answers evenly across their
four stored positions. A seed-content test enforces four unique choices and
balanced A–D positions for every topic. The quiz then shuffles those choices
before display while posting their stable underlying identities, preventing a
fixed-position answer strategy.
