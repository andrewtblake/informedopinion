class PublicStatisticsController < ApplicationController
  def show
    return head :not_found unless FeatureFlags.public_statistics?

    @statistics = PublicStatisticsSummary.new
    @response_labels = PublishOpinionQuestionProposal::RESPONSE_OPTIONS
  end
end
