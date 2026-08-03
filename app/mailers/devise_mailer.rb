class DeviseMailer < Devise::Mailer
  default reply_to: ENV.fetch("MAILER_REPLY_TO", "hello@informedopinion.info")

  def reset_password_instructions(record, token, opts = {})
    options = opts.dup
    @site_name = options.delete(:site_name) || SiteIdentity::PRIMARY.name
    @site_url_options = options.delete(:site_url_options)
    super(record, token, options.merge(subject: "#{@site_name} password reset"))
  end

  def default_url_options
    @site_url_options.presence || super
  end
end
