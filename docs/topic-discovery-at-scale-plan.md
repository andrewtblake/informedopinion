# Topic discovery at scale and regional relevance: future plan

## Status

This document records a proposed direction for future implementation. It does
not authorise collection of visitor location, automatic geolocation, creation
of regional editions, or a change to the prominence of currently published
questions.

The present catalogue is appropriate for a small corpus. When the service has
hundreds of opinion questions, showing each question as an equally prominent
homepage card—even with pagination—will make discovery difficult and will give
old or already popular subjects too much structural advantage. The same larger
corpus is also likely to contain questions principally relevant to different
countries. Visitors should be able to emphasise the regions that interest them
without losing access to global or other regional material.

This plan treats scale and regional relevance as one discovery problem. The
site presentation (`informed_opinion` or `whats_your_view`) remains independent
of the selected content region.

## Objectives

The future discovery system should:

1. Remain intelligible with approximately 400 published opinion questions and
   continue to scale beyond that number.
2. Give new, important and under-explored questions a route to discovery rather
   than ranking only by lifetime popularity.
3. Let a visitor emphasise questions relevant to regions that interest them,
   while keeping all published questions searchable and browsable.
4. Avoid treating an inferred network location as a person's residence,
   nationality or political community.
5. Keep the two public presentations capable of using different language and
   emphasis without duplicating discovery logic or regional content.
6. Preserve stable, shareable and indexable category, region and catalogue
   URLs.
7. Bound homepage work and database queries so performance does not deteriorate
   in proportion to the total number of questions.
8. Make editorial influence and automated ranking understandable and
   reviewable.

## Governing principles

### Discovery is not a league table

Popularity is useful evidence of current reader interest, but it is not a
measure of importance, quality or truth. Lifetime participation must not become
the default ranking: it would permanently favour older questions and reinforce
their existing exposure. Discovery should blend editorial selection, regional
relevance, freshness, recent participation and controlled rotation.

### Regional interest is not residence

The useful question is:

> Which regions' questions would you like the site to emphasise?

It is not necessary to ask where a person lives. The preference should be
optional, coarse and changeable. A person in one country may reasonably select
another country or `All regions`.

### Emphasis must not become exclusion

A regional preference changes relative prominence and default ordering. It
must not hide other questions from search, category browsing or the complete
catalogue. Globally relevant questions should remain visible in every regional
view, and a small rotating selection can expose significant questions from
elsewhere.

### Presentation and selection remain separate

Informed Opinion and What's Your View use the same questions, classifications,
rankings and participant records. Their homepages may label, order or render
the same discovery sections differently. Region selection must be data-driven,
not implemented as additional Rails site variants such as `io_uk`, `wyv_us`
and so on.

## Proposed information architecture

### Homepage

The homepage should become a bounded discovery page rather than the complete
catalogue. A suitable structure is:

```text
Search questions, subjects or places

Continue where you left off                 signed-in users only
  up to three recent or unfinished topics

Explore by category
  category tiles with two or three selected questions each

Recently added
Popular now
Under-explored questions                    optional rotating collection

Browse all questions
```

The page should show a fixed maximum number of question previews regardless of
whether the corpus contains 40 or 400 questions.

The IO presentation can give greater prominence to evidence essays, editorially
featured banks and substantial updates. WYV can give greater prominence to
accessible discovery, recent activity and continuing a participant's existing
topics. Both should consume the same discovery results rather than maintain
independent rankings.

### Category tiles

Each category tile should contain:

- category name and short description;
- the number of matching published questions under the current regional view;
- two or three question previews selected from different signals; and
- a link to the complete category page.

A default selection could include one editorially featured question, one
recently published question and one recently popular or under-explored
question. These are roles, not rigid quotas: the selector should avoid
duplicates and fall back sensibly when a category is small.

The tile should not embed three full current homepage cards. Compact title-led
previews are preferable so categories remain the primary visual objects.

### Category pages

A category should become a genuine landing page rather than only a query
filter. It should provide:

- an introduction and matching question count;
- a small featured section;
- prominent tags or subject filters within that category;
- search and sorting limited to the category; and
- a compact, paginated question catalogue.

Frequently used tags can act as subdivisions until the corpus demonstrates a
need for formal subcategories. Subcategories should not be invented in advance
merely to fill a hierarchy.

### Complete catalogue

`Browse all questions` should lead to a dedicated catalogue with database-backed
search, filtering, sorting and pagination. Filters should eventually include:

- category;
- region;
- tag or subject;
- recently published or updated;
- current activity;
- title A–Z; and
- for signed-in users, unanswered, in progress and completed.

Catalogue results should use compact cards or rows. Rich aggregate panels are
valuable for a handful of selected questions but become repetitive and
space-intensive in a long result list.

### Search

Search should cover title, proposition, category, tags and structured region
names. The initial interface can remain a submitted form. Suggestions for
matching questions, categories, tags and regions should be considered only
after ordinary search quality and accessibility are satisfactory.

Search results must not be restricted to the preferred region unless the user
explicitly applies a region filter. Regional relevance can influence ranking,
but a strong textual match elsewhere should remain discoverable.

## Regional classification

### Structured model

Geography should not be inferred from display tags or the proposal's free-text
`geographic_scope`. Introduce explicit regional records and a join such as:

```text
Region
  code                         stable code, normally ISO 3166-1 alpha-2
  name
  kind                         country, macro-region or global
  active

OpinionQuestionRegion
  opinion_question_id
  region_id
  relevance                    primary, secondary or global
  editorial rationale
```

Country records should remain distinct even when the interface initially
groups them. Australia and New Zealand, for example, may appear together while
their catalogues are small, but should be stored as `AU` and `NZ` rather than
as an irreversible combined classification. Likely initial records include
`GB`, `US`, `CA`, `AU`, `NZ`, `IE` and a documented global scope. Broader
regional records should be added only when they improve real discovery.

The model must support questions with several relationships. A question about
United States foreign policy may be primarily about the US and also globally
relevant; an ECHR question may be primarily British and secondarily European;
climate change or veganism may be global.

The current free-text geographical scope remains useful in proposals. A
moderator translates it into structured relationships before publication.

### Classification rules

Editorial guidance should define:

- `primary`: the proposition principally concerns this jurisdiction or its
  institutions;
- `secondary`: the proposition has material, specific consequences or context
  for the region but is not principally about it; and
- `global`: the proposition is not usefully assigned to one national audience
  or is directly material across regions.

Every published question should receive at least one reviewed classification.
Classifications affect discovery only; they must not alter answers, knowledge
weights or aggregate opinion calculations.

### Region selector

The interface should offer a visible control such as:

> Showing: United Kingdom · Change · All regions

Recommended behaviour:

1. Default to `All regions` unless an existing explicit preference is present.
2. Store a visitor's selection in a first-party cookie or equivalent local
   preference.
3. Optionally store the same preference on an account so it follows a signed-in
   user across devices.
4. Allow an account preference to be overridden for the current browse session.
5. Provide stable URLs carrying the region selection for shareable catalogue
   and category views.
6. Make `All regions` permanently available.

The first version should not use IP geolocation. Browser locale could support a
non-blocking suggestion, but it must not silently assert a region and should be
omitted if it complicates consent, caching or testing.

No exact location, postcode or coordinates are needed. Do not describe a
content preference as the participant's residence.

### Region-aware homepage composition

For a selected region, homepage sections should blend:

- primarily relevant questions;
- globally relevant questions;
- the user's own unfinished questions regardless of region; and
- a small, rotating `Beyond this region` selection where space permits.

Category counts and previews can reflect the selected region, provided their
labels make that scope clear. `All questions` and textual search remain routes
to the entire corpus.

## Ranking and editorial safeguards

The existing `FeaturedQuestionRanker` already combines editorial priority,
freshness, participation, informed participation, controversy and category
diversity. It is a useful starting point, but a larger catalogue needs explicit
collection-specific ranking rather than one ordering used everywhere.

Define a discovery result as a named collection with a documented purpose:

```text
featured_in_category
recently_published
popular_now
under_explored
continue_for_user
globally_relevant
beyond_selected_region
```

Each collection should have separate eligibility and ordering rules. Important
safeguards include:

- use recent, time-bounded activity rather than lifetime totals for `popular
  now`;
- retain minimum participation thresholds before describing a question as
  popular or controversial;
- give newly published questions a controlled opportunity for exposure;
- limit repeated questions across homepage sections;
- diversify adjacent results by category and, where useful, region;
- retain moderator feature and demotion controls with recorded reasons;
- prevent popularity from being represented as evidential importance; and
- periodically rotate eligible under-explored questions rather than rewarding
  only high engagement.

The public methodology should explain the principles without publishing a
formula that invites gaming. Moderators should be able to inspect why a question
was selected for a collection at a particular time.

## Data and privacy boundaries

Regional content selection does not initially require a participant-location
dataset. `Popular in the UK` should not be claimed unless the underlying data
actually describe a reviewed UK population. The first implementation should
instead use wording such as `Popular UK questions`, meaning questions classified
as relevant to the UK.

If a later proposal would analyse activity by a self-declared region, it needs a
separate privacy and statistical review covering:

- the purpose and lawful basis for collection;
- whether the field means residence or merely content preference;
- consent and ability to remove or change it;
- minimum group and disclosure thresholds;
- sensitive cross-tabulations and prohibited uses;
- representativeness and selection bias; and
- retention and account-deletion behaviour.

No such analysis should be inferred from the preference introduced by this
plan. The preference exists to select content, not to characterise participants.

## URLs, canonicalisation and caching

Category and regional views should have stable server-rendered URLs. The exact
shape can be selected during implementation, for example:

```text
/questions
/categories/politics-and-government
/questions?region=GB
/categories/politics-and-government?region=GB
```

The default crawlable and canonical catalogue should normally be `All regions`.
Before indexing regional combinations, review duplicate-content and maintenance
costs. Search/filter combinations should not produce an unlimited indexable URL
space.

Cache keys for discovery fragments must include at least the site presentation,
selected region, collection, category where applicable, and a content/ranking
version. User-specific `Continue` content must never enter a shared public
cache.

## Performance and implementation implications

The current homepage loads every live opinion question into Ruby before
filtering, ordering and pagination. That is acceptable for the present corpus
but should be replaced before hundreds of questions are routinely published.

Required changes include:

1. Move text, category, tag and region filtering into database queries.
2. Apply ordering and pagination before loading records.
3. Add indexes for live state, publication date, category joins, region joins
   and the selected search implementation.
4. Replace per-question aggregate calculation on catalogue pages with a batched,
   cached or precomputed summary interface.
5. Batch signed-in progress for all displayed questions rather than constructing
   separate queries per card.
6. Return only the bounded questions required by each homepage collection.
7. Add PostgreSQL-backed query tests because production uses PostgreSQL even
   though the ordinary test suite uses SQLite.
8. Measure query counts and response time against representative generated
   corpora rather than relying only on functional tests.

PostgreSQL full-text search is a likely eventual choice. It should be introduced
after fields, ranking expectations and accent/case behaviour are specified;
400 questions do not by themselves justify an external search service.

Recent popularity may require a small, privacy-safe activity aggregate because
the current latest-opinion records are not a complete historical event stream.
Do not add page-view surveillance merely to produce a popularity feature.
Prefer meaningful participation events already required by the product, with
daily or weekly aggregates where necessary.

## Moderation and editorial tooling

Moderators will need to:

- assign and revise primary, secondary and global relevance;
- see unclassified live or draft questions;
- preview homepage/category placement for each region and presentation;
- feature or demote a question within a defined collection and scope;
- inspect the factors behind automated selection;
- find categories or regions with too little content or excessive duplication;
  and
- audit changes to regional classification and editorial prominence.

Regional relationships must pass through the moderator API, proposal
publication workflow, seeds and audit events. A proposed question's free-text
scope must not automatically become a published structured classification
without review.

## Delivery stages

### Stage 0: prototype and content audit

Build no persistent preference yet. Inventory existing questions and assign
provisional region relationships offline. Test homepage, category and catalogue
wireframes with synthetic catalogues of approximately 40, 100 and 400
questions. Determine whether the existing broad categories remain useful and
which compact result information readers actually need.

Success requires a comprehensible hierarchy without relying on search alone and
without hiding global or cross-regional questions.

### Stage 1: scalable catalogue queries

Replace load-all filtering and ordering with database-backed scopes or query
objects. Preserve current URLs and behaviour while moving pagination before
record loading. Introduce batched aggregate and participant-progress summaries.
Add representative-corpus performance and query-count tests.

This stage reduces risk independently of any homepage redesign.

### Stage 2: structured regional metadata

Add regions and opinion-question region joins, validations, audit/API support
and moderator controls. Classify every current question and block future
publication when classification is missing. Do not yet change public ordering;
first review the complete classification for consistency.

### Stage 3: dedicated catalogue and category pages

Move comprehensive browsing away from the homepage. Deliver compact paginated
results, category landing pages, tag filters and stable filter URLs. Retain an
obvious `All regions` route throughout.

### Stage 4: bounded homepage collections

Introduce category tiles, signed-in continuation, recent questions and
documented discovery collections. Limit the number of rendered questions and
deduplicate them across sections. Allow IO and WYV to compose or label the same
collections differently.

### Stage 5: explicit regional preference

Add the visible selector and local persistence. Apply it to category previews
and default catalogue ordering, not search eligibility. Include global and
outside-region discovery. Validate canonical URLs, caches and both site
presentations before considering account persistence.

### Stage 6: recent activity and measured refinement

Only if needed, add privacy-safe time-bounded participation aggregates for
`Popular now`. Review discovery outcomes for concentration, new-question
exposure, regional imbalance and performance. Adjust documented ranking rules
through reviewed changes rather than informal constants.

## Tests and acceptance criteria

Before broad release, automated and editorial checks should establish that:

- homepage query and rendering work remain bounded as the total corpus grows;
- database pagination returns stable results without omissions or duplicates;
- category, tag, region and text filters compose correctly;
- every published question has a reviewed regional classification;
- multi-region and global questions appear in the intended views;
- changing region changes prominence but not search availability;
- `All regions` always exposes the complete published catalogue;
- an anonymous preference is not represented or analysed as residence;
- signed-in continuation ignores the regional filter where necessary;
- question previews do not repeat excessively across homepage collections;
- new and under-explored questions receive measurable exposure opportunities;
- popularity uses its documented time window and minimum threshold;
- aggregate and user-progress summaries match the existing authoritative score
  calculations;
- cache entries cannot leak user-specific content or cross site/region
  presentations;
- canonical metadata avoids uncontrolled duplicate indexing;
- moderator classification and feature changes are authorised and audited; and
- keyboard, screen-reader and narrow-screen browsing remain usable with the
  selector, category tiles and compact catalogue.

## Decisions to make before implementation

1. Which existing categories remain suitable at 400 questions?
2. How many category tiles and previews should each presentation show?
3. Should category pages or the complete catalogue become the principal indexed
   discovery surface?
4. Which region codes and groupings have enough initial content to expose?
5. How should global relevance interact with a primary country relationship?
6. Which explicit events constitute recent popularity without creating a new
   tracking system?
7. How much editorial control is necessary at collection, category and region
   level?
8. Should a region preference remain browser-local or later follow an account?
9. What representative corpus and query budgets will be used for acceptance?

Implementation should begin with Stage 0 and Stage 1. The visible regional
selector should follow consistent classification and scalable catalogue
queries, not precede them.
