# Privacy operations checklist

The public privacy notice describes the intended operating practice. Before a
broad public launch, the operator must keep the following external details with
the deployment records and review them whenever a provider or purpose changes:

- the controller's complete legal identity and correspondence address;
- the current privacy contact and a process for responding to rights requests;
- Render, Resend and Gandi data-processing terms and international-transfer
  safeguards where applicable;
- actual log, email-event and backup retention settings against the limits and
  criteria stated in the notice;
- a record of notice versions and the reason for each material change;
- a periodic review of accounts with no sign-in for two years;
- an incident process that records disclosures without putting credentials or
  unnecessary personal information into issue trackers.

Changing `config.x.privacy.notice_version` makes existing participants review
and accept the new version before continuing. Use this only for material terms
or privacy changes, not typographical corrections.

The self-service deletion route removes the user and dependent participation
records from the live database. Moderator-review foreign keys are nullified so
deleting a moderator does not erase other people's reports or proposals.
Published question-bank records are not dependent on the proposing user.
