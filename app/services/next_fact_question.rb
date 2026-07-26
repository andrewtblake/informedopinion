class NextFactQuestion
  def initialize(user:, opinion_question:, user_opinion:)
    @user = user
    @opinion_question = opinion_question
    @user_opinion = user_opinion
  end

  def call
    unanswered.sample || answered.sample
  end

  private

  attr_reader :user, :opinion_question, :user_opinion

  def unanswered
    ordered_questions.where.not(id: response_question_ids).to_a
  end

  def answered
    ordered_questions.where(id: response_question_ids).to_a
  end

  def ordered_questions
    direction = user_opinion.stance <=> 0

    opinion_question.fact_questions
      .reorder(
        Arel.sql(
          ActiveRecord::Base.sanitize_sql_array(
            ["CASE WHEN evidence_direction = ? THEN 0 " \
             "WHEN evidence_direction = 0 THEN 1 ELSE 2 END, RANDOM()", direction]
          )
        )
      )
  end

  def response_question_ids
    user.fact_responses
      .joins(:fact_question)
      .where(fact_questions: { opinion_question_id: opinion_question.id })
      .select(:fact_question_id)
  end
end
