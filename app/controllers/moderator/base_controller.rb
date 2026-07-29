module Moderator
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :require_moderator!

    private

    def require_moderator!
      head :forbidden unless current_user.moderator?
    end
  end
end
