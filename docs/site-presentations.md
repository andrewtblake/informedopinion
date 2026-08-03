# Site presentations

The application has two public presentations backed by the same controllers,
models, accounts, questions, answers, moderation records, and database.

| Presentation | Production host | Local host |
| --- | --- | --- |
| Informed Opinion (default) | `informedopinion.info` | `informedopinion.localhost:3000` |
| What's Your View? | `whatsyourview.info` | `whatsyourview.localhost:3000` |

Start the application normally with `bin/rails server`, then open either local
hostname. Browsers resolve names below `.localhost` to the loopback interface,
so no `/etc/hosts` change is normally needed. `wyv.localhost:3000` is also an
accepted shorthand. Unknown hosts deliberately receive the default Informed
Opinion presentation rather than selecting the alternative.

`SiteIdentity` resolves the request host. The alternative identity sets Rails'
`what_do_you_think` view variant, loads the alternative central stylesheet, and
selects the alternative metadata, interface language, and favicon. Templates
without an alternative variant fall back to the shared template. Moderator
pages always retain the Informed Opinion editorial presentation.

## Production activation

The Render blueprint defines:

- `ALTERNATE_APP_HOST=whatsyourview.info`
- `ALTERNATE_SITE_ENABLED=false`

The disabled state is intentional: even if DNS is pointed at Render early, the
unfinished host falls back to Informed Opinion. To launch it:

1. Add `whatsyourview.info` and `www.whatsyourview.info` as custom domains on
   the existing Render web service.
2. Point the domain's DNS records at the values Render supplies and wait for its
   TLS certificates to become active.
3. Change `ALTERNATE_SITE_ENABLED` to `true` and deploy.
4. Check the homepage, opinion selection, quiz, registration, password reset,
   personal opinions, Help, Privacy, and Terms through the HTTPS hostname.

Both domains use the same user table, but their browser sessions are separate:
a person signed into one domain must sign into the other independently. A
password-reset request is branded for the site on which it was made and returns
to that host. This relies on Devise's current synchronous delivery; if Devise
mail is moved to `deliver_later`, the site URL options must be serialized into
the job rather than read from request-local state.

The alternative homepage is self-canonical. Shared topic and supporting pages
identify the Informed Opinion URL as canonical so the second presentation does
not compete with the editorial source in search indexes. Any future rendered
fragment cache must include `current_site.key` in its cache key.
