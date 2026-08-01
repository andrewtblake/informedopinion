module Moderator
  class ModerationViewsController < BaseController
    def create
      ModerationInbox.new(current_user).mark_displayed!(displayed_items)
      head :no_content
    end

    private

    def displayed_items
      params.permit(items: %i[key version]).fetch(:items, []).map(&:to_h)
    end
  end
end
