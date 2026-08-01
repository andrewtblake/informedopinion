ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def create_user!(attributes)
      accepted_at = Time.current
      User.create!({
        terms_accepted_at: accepted_at,
        special_category_consent_at: accepted_at,
        privacy_notice_version: Rails.configuration.x.privacy.notice_version
      }.merge(attributes))
    end

    # Add more helper methods to be used by all tests here...
  end
end

class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end
