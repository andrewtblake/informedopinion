class Rack::Attack
  cache.store = Rails.env.test? ? ActiveSupport::Cache::MemoryStore.new : Rails.cache

  safelist("Render health check") { |request| request.path == "/up" }

  throttle("authentication/sign-in", limit: 20, period: 5.minutes) do |request|
    request.ip if request.post? && request.path == "/users/sign_in"
  end

  throttle("authentication/sign-up", limit: 10, period: 1.hour) do |request|
    request.ip if request.post? && request.path == "/users"
  end

  throttle("authentication/password-reset", limit: 10, period: 1.hour) do |request|
    request.ip if request.post? && request.path == "/users/password"
  end

  throttle("contributions/fact-reports", limit: 30, period: 1.hour) do |request|
    request.ip if request.post? && request.path == "/fact-reports"
  end

  throttle("contributions/reactions", limit: 120, period: 1.hour) do |request|
    next unless request.path.match?(%r{\A/topics/[^/]+/reaction\z})

    request.ip if request.post? || request.delete?
  end

  throttle("contributions/opinion-proposals", limit: 10, period: 1.day) do |request|
    request.ip if request.post? && request.path == "/proposals"
  end

  throttle("contributions/fact-proposals", limit: 30, period: 1.day) do |request|
    next unless request.post?

    request.ip if request.path.match?(%r{\A/topics/[^/]+/fact-proposals\z})
  end

  self.throttled_responder = lambda do |request|
    match_data = request.env.fetch("rack.attack.match_data", {})
    retry_after = match_data[:period].to_i

    [
      429,
      {
        "Content-Type" => "text/plain; charset=utf-8",
        "Retry-After" => retry_after.to_s
      },
      [ "Too many requests. Please try again later.\n" ]
    ]
  end
end
