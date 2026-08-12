class DeviseMailer < Devise::Mailer
  default reply_to: ENV.fetch("MAILER_REPLY_TO", "hello@informedopinion.info")

  def confirmation_instructions(record, token, opts = {})
    options = site_options(opts, subject_suffix: "confirm your email")
    super(record, token, options)
  end

  def reset_password_instructions(record, token, opts = {})
    options = site_options(opts, subject_suffix: "password reset")
    super(record, token, options)
  end

  def default_url_options
    @site_url_options.presence || super
  end

  private

  def site_options(opts, subject_suffix:)
    options = opts.dup
    site = SiteIdentity.fetch(options.delete(:site_key))
    @site_name = options.delete(:site_name) || site.name
    @site_url_options = options.delete(:site_url_options)
    options.merge!(subject: "#{@site_name} #{subject_suffix}")
    options.merge!(alternative_mail_headers) if site.alternative?
    options
  end

  def alternative_mail_headers
    {
      from: ENV.fetch(
        "ALTERNATE_MAILER_FROM",
        "What's Your View? <accounts@informedopinion.info>"
      ),
      reply_to: ENV.fetch("ALTERNATE_MAILER_REPLY_TO", "hello@whatsyourview.info")
    }
  end
end
