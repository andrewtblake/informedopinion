class FeatureFlags
  TRUE_VALUES = %w[1 true yes on].freeze

  class << self
    def public_statistics?(user = nil)
      user&.admin? || TRUE_VALUES.include?(ENV.fetch("PUBLIC_STATISTICS_ENABLED", "false").downcase)
    end
  end
end
