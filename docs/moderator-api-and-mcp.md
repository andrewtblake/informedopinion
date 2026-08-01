# Moderator API and MCP

The versioned moderator API is the authoritative interface for agent-assisted editorial work. The included MCP server is a local adapter: it gives an AI agent concise tools and the editorial standard, while every read and write still passes through Rails authentication and validation.

## Safety model

- Only a moderator account can own an API token.
- Tokens are random, revocable, and stored in the database only as SHA-256 digests. The plaintext is shown once.
- Every API write creates an append-only `ApiAuditEvent` with actor, token, request ID, action, target, and changed values.
- User identities are deliberately omitted from moderation-issue responses.
- Saving an amended candidate does not approve it. Approval and decline are separate, explicit operations.
- Creating a batch of fact questions is transactional. A batch contains at most 30 questions and either all pass validation or none are retained.
- A question with participation cannot be deleted. Withdraw or unpublish it instead; answered fact questions likewise cannot be deleted.

## Issue IDs and workflow

Moderation issue IDs are composite and stable, for example `opinion_proposal:12`, `fact_proposal:7`, and `fact_report:31`.
Anonymous dislike reasons appear as `opinion_reaction:9`. They can be resolved as `reviewed` when they identify useful editorial work or `dismissed` when no action is warranted; likes are aggregate-only and are not moderation issues.

For an opinion proposal:

1. List pending issues and read the proposal.
2. Read `informed-opinion://editorial-standard`.
3. Draft wording in conversation. No write is needed for a draft that the moderator has not accepted.
4. After instruction, save the agreed candidate with `save_opinion_proposal_edit`.
5. Only after a separate instruction, call `decide_moderation_issue` with `action: approve`.
6. Read the approved, initially non-live opinion question and create its fact bank with `create_fact_questions`.
7. Review the complete bank against the editorial standard. Only after the moderator is satisfied, publish it with `publish_opinion_question`.

An approved opinion remains non-live after the configured minimum is reached. The threshold establishes eligibility; explicit moderator publication makes it public.

## HTTP API

All endpoints are below `/api/v1` and require `Authorization: Bearer TOKEN`.

- `GET/POST /opinion_questions`
- `GET/PATCH/DELETE /opinion_questions/:id`
- `POST/DELETE /opinion_questions/:opinion_question_id/publication`
- `GET/POST /opinion_questions/:opinion_question_id/fact_questions`
- `POST /opinion_questions/:id/fact_questions/bulk`
- `GET/PATCH/DELETE /fact_questions/:id`
- `GET /moderation_issues?status=pending&type=opinion_proposal`
- `GET/PATCH /moderation_issues/:composite_id`
- `POST /moderation_issues/:composite_id/approve`
- `POST /moderation_issues/:composite_id/decline`
- `POST /moderation_issues/:composite_id/resolve`
- `GET /editorial_standard`

Fact-question payloads use zero-based `correct_option`, exactly four `options`, `importance_weight` 1–3, and `evidence_direction` -1, 0, or 1. See [editorial-standard.md](editorial-standard.md) for their editorial meaning.

## Issue a token

Run this in a trusted local or Render shell:

```sh
EMAIL=moderator@example.org NAME="Codex on laptop" bin/rails moderator_api_tokens:issue
```

Copy the displayed secret into a password manager. To revoke it:

```sh
ID=3 bin/rails moderator_api_tokens:revoke
```

## Connect Codex

Export the secret in the environment from which Codex starts:

```sh
export INFORMED_OPINION_API_URL="https://informedopinion.info/api/v1"
export INFORMED_OPINION_API_TOKEN="io_mod_..."
```

Then add the local server to Codex:

```sh
codex mcp add informed-opinion -- /absolute/path/to/bin/informed-opinion-mcp
```

Do not place the token in this repository or pass it as a command-line argument. Restart the Codex session after adding the server so its tools and resources are discovered.
