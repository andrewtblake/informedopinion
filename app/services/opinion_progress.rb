class OpinionProgress
  attr_reader :user, :opinion_question

  def initialize(user, opinion_question, responses: nil)
    @user = user
    @opinion_question = opinion_question
    @loaded_responses = responses
  end

  def total
    @total ||= if opinion_question.published_fact_questions.loaded?
      opinion_question.published_fact_questions.size
    else
      opinion_question.published_fact_questions.count
    end
  end

  def answered
    @answered ||= loaded? ? current_responses.size : current_responses.count
  end

  def correct
    @correct ||= loaded? ? correct_responses.size : current_responses.where(correct: true).count
  end

  def retired_answered
    @retired_answered ||= loaded? ? retired_responses.size : retired_responses.count
  end

  def retired_correct
    @retired_correct ||= loaded? ? retired_responses.count(&:correct?) : retired_responses.where(correct: true).count
  end

  def retired_answers?
    retired_answered.positive?
  end

  def weight
    return 0.0 if total_importance.zero?

    (earned_importance.fdiv(total_importance) * 100).round(1)
  end

  def raw_weight
    return 0.0 if total.zero?

    (correct.fdiv(total) * 100).round(1)
  end

  def earned_importance
    @earned_importance ||= if loaded?
      correct_responses.sum { _1.fact_question.importance_weight }
    else
      current_responses.where(correct: true).sum("fact_questions.importance_weight")
    end
  end

  def total_importance
    @total_importance ||= if opinion_question.published_fact_questions.loaded?
      opinion_question.published_fact_questions.sum(&:importance_weight)
    else
      opinion_question.published_fact_questions.sum(:importance_weight)
    end
  end

  def remaining
    total - answered
  end

  def complete?
    total.positive? && remaining.zero?
  end

  private

  def loaded?
    !@loaded_responses.nil?
  end

  def correct_responses
    @correct_responses ||= current_responses.select(&:correct?)
  end

  def current_responses
    return @loaded_responses.reject { _1.fact_question.withdrawn? } if loaded?

    FactResponse
      .where(user: user)
      .joins(:fact_question)
      .where(fact_questions: { opinion_question_id: opinion_question.id, withdrawn_at: nil })
  end

  def retired_responses
    return @loaded_responses.select { _1.fact_question.withdrawn? } if loaded?

    FactResponse
      .where(user: user)
      .joins(:fact_question)
      .where.not(fact_questions: { withdrawn_at: nil })
      .where(fact_questions: { opinion_question_id: opinion_question.id })
  end
end
