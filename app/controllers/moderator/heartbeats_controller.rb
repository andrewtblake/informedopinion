module Moderator
  class HeartbeatsController < BaseController
    def show
      sections = ModerationInbox.new(current_user).sections
      render json: {
        generated_at: Time.current.iso8601(6),
        total: sections.values.sum { _1.fetch(:count) },
        sections: sections
      }
    end
  end
end
