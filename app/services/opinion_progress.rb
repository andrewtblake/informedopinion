class OpinionProgress
  attr_reader :user, :opinion_question

  def initialize(user, opinion_question)
    @user = user
    @opinion_question = opinion_question
  end

  def total
    opinion_question.fact_questions.count
  end

  def answered
    responses.count
  end

  def correct
    responses.where(correct: true).count
  end

  def weight
    return 0.0 if total.zero?

    (correct.fdiv(total) * 100).round(1)
  end

  def remaining
    total - answered
  end

  def complete?
    total.positive? && remaining.zero?
  end

  private

  def responses
    FactResponse
      .where(user: user)
      .joins(:fact_question)
      .where(fact_questions: { opinion_question_id: opinion_question.id })
  end
end
