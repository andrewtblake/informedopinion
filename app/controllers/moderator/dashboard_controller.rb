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
        .includes(:published_fact_questions)
        .in_display_order
      @featured_ranker = FeaturedQuestionRanker.new(
        OpinionQuestion.live.includes(:category).to_a
      )
      @featured_questions = @featured_ranker.rank
      @reaction_questions = OpinionQuestion.includes(:opinion_question_reactions).filter_map do |question|
        reactions = question.opinion_question_reactions
        next if reactions.empty?

        [ question, reactions ]
      end.sort_by do |question, reactions|
        dislikes = reactions.count(&:dislike?)
        [ -dislikes, -(dislikes.fdiv(reactions.length)), question.title ]
      end
      @pending_reaction_count = OpinionQuestionReaction.dislike.moderation_pending.count
    end
  end
end
