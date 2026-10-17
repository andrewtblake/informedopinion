# Database-backed glossary

## Behaviour

Initialisms and their plain-text definitions live in `glossary_entries`.
Moderators can search, create, edit and delete them through the authenticated
API or the project's MCP adapter. Each write records the actor, token, request
and changed data in the existing append-only API audit trail.

Matching is case-sensitive and literal. Terms have unique spellings; plural
forms can be separate entries. The current `NGO` and `NGOs` entries preserve
that existing behaviour. Terms contain letters, digits, hyphens or slashes,
begin with a capital letter and have 2–32 characters. Definitions contain at
most 500 characters. Blank terms and definitions are rejected.

The existing tooltip renderer retains hover, keyboard-focus and tap support. It
escapes both source text and definition content. Longer overlapping terms match
first, so `UNRWA` does not become a tooltip for `UN` followed by `RWA`. Unknown
terms and terms whose entry has been deleted remain ordinary text.

Each view reads the glossary once. There is no process-wide or expiring cache:
edits appear on the next page request, including requests handled by another
application worker. An already open page retains its original snapshot until
navigation or refresh.

## Initial deployment

Deploy the migration and matching code together. The migration only adds the
glossary table and imports definitions; it does not alter participant data. The
identity-security migration is on a separate branch and is not required.

The dated file `db/glossary/20261017_initial_entries.json` contains the 81
existing definitions, including the recent additions. Preserve this snapshot for
migration reproducibility. Future additions belong in the database.
Schema-loaded databases import the same defaults when seeded with an empty
glossary. Ordinary seeding leaves a nonempty glossary unchanged.

After deployment, restart the MCP adapter so the client discovers its new
glossary tools. Existing moderator tokens continue to work. Test a new entry,
check its tooltip on a fresh quiz or moderator-bank page, edit it, and verify
that the new definition appears after refresh. Remove the test entry and confirm
that its text remains visible without a tooltip.

The 23 shorter-wording updates prepared for the recent question banks remain in
`tmp/today_glossary_after_deployment_updates.json`. Re-read those banks and
check their current fingerprints before applying that local payload. Do not
apply it blindly if editorial content has changed since it was prepared.

## Recovery and validation

Include glossary records and their audit events in database backups. Rolling
back the table migration deletes definitions, including later editorial changes,
so export or back up the table before any rollback. The earlier code-based
glossary will not contain subsequent database additions.

Local development used an isolated SQLite database because the existing working
databases may reflect the identity-security branch's schema. The following
checks do not modify those databases:

```sh
DATABASE_URL=sqlite3:/tmp/io-glossary-test.sqlite3 RAILS_ENV=test bin/rails db:prepare
DATABASE_URL=sqlite3:/tmp/io-glossary-test.sqlite3 bin/rails test
```
