# Production security controls

The initial Render deployment applies the following controls in the application:

- Rails trusts Render's TLS-terminating proxy, forces HTTPS and issues secure
  session cookies. The `/up` health check is exempt from application redirects.
- Host authorization permits `informedopinion.info`, its `www` form and Render's
  generated `onrender.com` service hostname. Other Host headers are rejected.
- Session cookies are HTTP-only and use `SameSite=Lax`.
- Authentication responses do not disclose whether a submitted email address
  belongs to an account.
- Rack::Attack limits repeated signup, sign-in, password-reset, reporting,
  reaction and proposal requests. The initial single Render process shares
  counters through Solid Cache in PostgreSQL.
- CI runs the Rails tests, RuboCop, Brakeman, Bundler Audit and Importmap Audit.

## Rate limits

Limits are deliberately generous enough for ordinary use and initially keyed
by client IP address:

| Endpoint | Limit |
| --- | ---: |
| Sign in | 20 per 5 minutes |
| Sign up | 10 per hour |
| Password reset | 10 per hour |
| Fact-question reports | 30 per hour |
| Likes and dislikes | 120 per hour |
| Opinion-question proposals | 10 per day |
| Fact-question proposals | 30 per day |

Throttled requests receive HTTP 429 and a `Retry-After` header. The health check
is always permitted. Revisit the limits using production measurements, taking
care not to disadvantage legitimate participants sharing a public IP address.

## Operational secrets

`RAILS_MASTER_KEY`, `RESEND_API_KEY` and `DATABASE_URL` must remain Render
environment secrets and must never be committed. Rotate a credential promptly
if it appears in a log, shell history, issue, chat or repository.
