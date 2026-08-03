class SiteIdentity
  Site = Data.define(
    :key,
    :name,
    :short_mark,
    :variant,
    :theme_color,
    :description,
    :favicon_prefix,
    :copy
  ) do
    def alternative?
      key == :what_do_you_think
    end
  end

  PRIMARY = Site.new(
    key: :informed_opinion,
    name: "Informed Opinion",
    short_mark: "io",
    variant: nil,
    theme_color: "#102a2b",
    description: "Discover how well the evidence supports the opinions you hold.",
    favicon_prefix: "",
    copy: {
      nav_opinions: "My opinions",
      nav_proposals: "Proposals",
      nav_help: "Help",
      create_account: "Create account",
      footer_tagline: "Evidence gives an opinion weight."
    }
  )

  ALTERNATIVE = Site.new(
    key: :what_do_you_think,
    name: "What Do You Think?",
    short_mark: "w?",
    variant: :what_do_you_think,
    theme_color: "#1769d2",
    description: "See where people stand on disputed questions—and how much factual knowledge lies behind the result.",
    favicon_prefix: "what-do-you-think-",
    copy: {
      nav_opinions: "Your opinions",
      nav_proposals: "Suggest a question",
      nav_help: "How it works",
      create_account: "Join in",
      footer_tagline: "See what people think—and what they know."
    }
  )

  LOCAL_ALTERNATIVE_HOSTS = %w[whatdoyouthink.localhost wdyt.localhost].freeze

  class << self
    def for_host(host)
      return ALTERNATIVE if alternative_enabled? && alternative_hosts.include?(host.to_s.downcase)

      PRIMARY
    end

    def alternative_enabled?
      Rails.env.local? || ActiveModel::Type::Boolean.new.cast(ENV["ALTERNATE_SITE_ENABLED"])
    end

    def alternative_hosts
      configured = ENV["ALTERNATE_APP_HOST"].to_s.downcase.presence
      hosts = configured ? [ configured, "www.#{configured}" ] : []
      Rails.env.local? ? hosts | LOCAL_ALTERNATIVE_HOSTS : hosts
    end
  end
end
