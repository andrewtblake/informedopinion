class SystemMailer < ApplicationMailer
  def delivery_test
    host = Rails.application.config.action_mailer.default_url_options[:host]

    mail(
      to: params.fetch(:to),
      subject: "Informed Opinion email delivery test",
      body: <<~TEXT
        Transactional email delivery is working for Informed Opinion.

        Public application host: #{host}
      TEXT
    )
  end
end
