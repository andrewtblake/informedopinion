# Transactional email

Production account email is delivered through Resend over SMTP. This covers
Devise password-reset messages and leaves Rails free to add confirmation or
other transactional messages later.

## Application configuration

The Render Blueprint declares all non-secret settings. It requests
`RESEND_API_KEY` as a secret during initial setup and uses:

- public host: `informedopinion.info` over HTTPS;
- sender: `Informed Opinion <accounts@informedopinion.info>`;
- replies: `hello@informedopinion.info`;
- SMTP: `smtp.resend.com`, port 587, STARTTLS, username `resend`.

The SMTP endpoint, port and username can be overridden with `SMTP_ADDRESS`,
`SMTP_PORT` and `SMTP_USERNAME` if the provider changes. Never commit the
Resend API key or put it in `render.yaml`.

## One-time setup

1. Create a Resend account and add `informedopinion.info` as a sending domain.
2. Copy the SPF, DKIM and MX records shown by Resend into Gandi's DNS editor.
   Use the exact names and values Resend supplies; they are account-specific.
3. Wait until Resend marks the domain verified.
4. Create a sending-only Resend API key.
5. Enter that key as `RESEND_API_KEY` in the Render service's environment.
6. Create `hello@informedopinion.info` as a real mailbox or forwarding address
   so replies and delivery enquiries reach a person.

## Verification

After the service and custom domain are live, open the Render Shell and run:

```sh
bin/rails email:send_test EMAIL=blakethomasandrew@gmail.com
```

Then request a password reset through the public site and follow the received
link. A successful smoke test alone does not prove that generated links use the
right public host.

If delivery fails, inspect the Render application log and the email entry in
Resend. Do not print or paste the API key into logs or support messages.
