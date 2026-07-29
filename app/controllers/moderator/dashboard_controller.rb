module Moderator
  class DashboardController < BaseController
    def index
      @flags = FactQuestionFlag.pending
        .includes(fact_question: :opinion_question)
        .order(:created_at)
      @proposals = OpinionQuestionProposal.pending
        .includes(:category)
        .order(:created_at)
    end
  end
end
