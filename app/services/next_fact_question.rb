class NextFactQuestion
  GATEWAY_OPENING_LENGTH = 8

  # The opening questions affirm the user's present position. Contextual facts
  # are introduced almost immediately, and counter-attitudinal evidence begins
  # in the first third before becoming progressively more frequent.
  VALENCE_PATTERN = %i[
    supportive supportive neutral supportive neutral
    supportive neutral challenging supportive neutral
    challenging supportive neutral challenging neutral
    supportive challenging neutral challenging supportive
    challenging neutral challenging supportive challenging
    neutral challenging challenging neutral challenging
  ].freeze

  def initialize(user:, opinion_question:, user_opinion:)
    @user = user
    @opinion_question = opinion_question
    @user_opinion = user_opinion
  end

  def call
    unanswered.first || answered.first
  end

  private

  attr_reader :user, :opinion_question, :user_opinion

  def unanswered
    ordered_questions.where.not(id: response_question_ids)
  end

  def answered
    ordered_questions.where(id: least_reviewed_question_ids)
  end

  def ordered_questions
    priorities = direction_priorities

    ordering = "CASE WHEN evidence_direction = ? THEN 0 " \
      "WHEN evidence_direction = ? THEN 1 ELSE 2 END, "
    ordering += "CASE WHEN gateway THEN 0 ELSE 1 END, " if opening_phase?
    ordering += "RANDOM()"

    opinion_question.published_fact_questions
      .reorder(
        Arel.sql(
          ActiveRecord::Base.sanitize_sql_array(
            [ ordering, *priorities.first(2) ]
          )
        )
      )
  end

  def opening_phase?
    sequence_position < GATEWAY_OPENING_LENGTH
  end

  def sequence_position
    @sequence_position ||= response_question_ids.count
  end

  def direction_priorities
    stance = user_opinion.stance <=> 0
    position = [ sequence_position, VALENCE_PATTERN.length - 1 ].min

    if stance.zero?
      neutral_priorities(position)
    else
      attitude_priorities(stance, VALENCE_PATTERN.fetch(position))
    end
  end

  def attitude_priorities(stance, preferred)
    case preferred
    when :supportive
      [ stance, 0, -stance ]
    when :neutral
      [ 0, stance, -stance ]
    else
      [ -stance, 0, stance ]
    end
  end

  def neutral_priorities(position)
    return [ 0, 1, -1 ] if position < 2

    position.even? ? [ 1, 0, -1 ] : [ -1, 0, 1 ]
  end

  def response_question_ids
    topic_responses.select(:fact_question_id)
  end

  def least_reviewed_question_ids
    minimum_attempts = topic_responses.minimum(:attempt_count)

    topic_responses
      .where(attempt_count: minimum_attempts)
      .select(:fact_question_id)
  end

  def topic_responses
    user.fact_responses
      .joins(:fact_question)
      .where(fact_questions: { opinion_question_id: opinion_question.id, withdrawn_at: nil })
  end
end
