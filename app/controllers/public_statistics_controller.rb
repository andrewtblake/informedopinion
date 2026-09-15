class PublicStatisticsController < ApplicationController
  def show
    return head :not_found unless FeatureFlags.public_statistics?(current_user)

    @statistics = PublicStatisticsSummary.new
    @response_labels = PublishOpinionQuestionProposal::RESPONSE_OPTIONS
  end
end
