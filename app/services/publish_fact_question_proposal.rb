class PublishFactQuestionProposal
  def initialize(proposal:, reviewer:, attributes:, review_notes: nil)
    @proposal = proposal
    @reviewer = reviewer
    @attributes = attributes
    @review_notes = review_notes
  end

  def call
    FactQuestionProposal.transaction do
      @proposal.update!(@attributes)
      fact_question = @proposal.opinion_question.fact_questions.create!(
        prompt: @proposal.prompt,
        options: @proposal.options,
        correct_option: @proposal.correct_option,
        explanation: @proposal.explanation,
        source_name: @proposal.source_name,
        source_url: @proposal.source_url,
        importance_weight: @proposal.importance_weight,
        importance_rationale: @proposal.importance_rationale,
        evidence_direction: @proposal.evidence_direction,
        display_order: @proposal.opinion_question.fact_questions.maximum(:display_order).to_i + 1
      )
      @proposal.update!(
        status: :approved,
        published_fact_question: fact_question,
        reviewer: @reviewer,
        review_notes: @review_notes,
        reviewed_at: Time.current
      )
      @proposal.opinion_question.publish_if_fact_bank_ready!
      fact_question
    end
  end
end
