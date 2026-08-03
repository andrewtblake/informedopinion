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
      if @proposal.answerability.zero?
        @proposal.errors.add(:answerability, "must be a passing rating from 1 to 5 before publication")
        raise ActiveRecord::RecordInvalid, @proposal
      end
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
        specialist_knowledge: @proposal.specialist_knowledge,
        answerability: @proposal.answerability,
        display_order: @proposal.opinion_question.fact_questions.maximum(:display_order).to_i + 1
      )
      @proposal.update!(
        status: :approved,
        published_fact_question: fact_question,
        reviewer: @reviewer,
        review_notes: @review_notes,
        reviewed_at: Time.current
      )
      fact_question
    end
  end
end
