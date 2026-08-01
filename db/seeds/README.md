# Curated seed policy

The seed catalogue bootstraps a new environment with categories, tags, opinion
questions and complete fact banks. It never creates users, opinions, fact
responses, reactions, reports, proposals or any other participation.

Rerunning `db:seed` is deliberately non-destructive:

- missing catalogue topics and their complete fact banks are created in one
  transaction;
- an existing topic is never rewritten, even when the catalogue has changed;
- moderator edits, community fact questions and participant records are never
  removed or reset;
- no account is granted a role as a side effect of seeding.

Use a reviewed data migration or the moderation workflow to change existing
published editorial content. Use `users:promote_moderator` from an authorised
provider console to grant the moderator role to an existing account.
