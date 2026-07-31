module Moderator
  class DashboardController < BaseController
    def index
      @flags = FactQuestionFlag.pending
        .includes(fact_question: :opinion_question)
        .order(:created_at)
      @proposals = OpinionQuestionProposal.pending
        .includes(:category)
        .order(:created_at)
      @fact_proposals = FactQuestionProposal.pending
        .includes(:opinion_question)
        .order(:created_at)
      @draft_questions = OpinionQuestion.where(live: false)
        .includes(:fact_questions)
        .in_display_order
      @featured_ranker = FeaturedQuestionRanker.new(
        OpinionQuestion.live.includes(:category).to_a
      )
      @featured_questions = @featured_ranker.rank
    end
  end
end
