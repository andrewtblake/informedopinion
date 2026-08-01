class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch("MAILER_FROM", "Informed Opinion <accounts@informedopinion.info>"),
          reply_to: ENV.fetch("MAILER_REPLY_TO", "hello@informedopinion.info")
  layout "mailer"
end
