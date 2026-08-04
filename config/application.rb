require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module InformedOpinion
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.x.fact_question_proposals.minimum_existing_questions =
      ENV.fetch("FACT_PROPOSAL_MINIMUM_QUESTIONS", 10).to_i
    config.x.fact_question_proposals.minimum_correct_percentage =
      ENV.fetch("FACT_PROPOSAL_MINIMUM_SCORE", 90).to_f

    config.x.privacy.notice_version = "2026-08-01"
    config.x.privacy.contact_email = ENV.fetch("PRIVACY_CONTACT_EMAIL", "hello@informedopinion.info")
    config.x.privacy.operator_name = ENV.fetch("SITE_OPERATOR_NAME", "Informed Opinion")

    config.x.statistics.minimum_group_size =
      ENV.fetch("PUBLIC_STATISTICS_MINIMUM_GROUP_SIZE", 5).to_i.clamp(2, 100)
  end
end
