Devise.setup do |config|
  config.mailer_sender = ENV.fetch("MAILER_FROM", "Informed Opinion <accounts@informedopinion.info>")
  config.mailer = "DeviseMailer"
  require "devise/orm/active_record"
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [ :http_auth ]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.confirm_within = 3.days
  config.allow_unconfirmed_access_for = 0.days
  config.expire_all_remember_me_on_sign_out = true
  config.paranoid = true
  config.password_length = 8..128
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete
  config.responder.error_status = :unprocessable_content
  config.responder.redirect_status = :see_other
end
