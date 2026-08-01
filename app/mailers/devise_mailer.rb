class DeviseMailer < Devise::Mailer
  default reply_to: ENV.fetch("MAILER_REPLY_TO", "hello@informedopinion.info")
end
