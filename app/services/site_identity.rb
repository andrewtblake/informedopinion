class SiteIdentity
  Site = Data.define(
    :key,
    :name,
    :short_mark,
    :variant,
    :theme_color,
    :description,
    :favicon_prefix
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
    favicon_prefix: ""
  )

  ALTERNATIVE = Site.new(
    key: :what_do_you_think,
    name: "What Do You Think?",
    short_mark: "w?",
    variant: :what_do_you_think,
    theme_color: "#1769d2",
    description: "See where people stand on disputed questions—and how much factual knowledge lies behind the result.",
    favicon_prefix: "what-do-you-think-"
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
