class CollectiveOpinion
  POSITION_SCORES = [ 1.0, 0.5, 0.0, -0.5, -1.0 ].freeze

  attr_reader :opinion_question

  def initialize(opinion_question)
    @opinion_question = opinion_question
  end

  def distribution
    @distribution ||= opinion_question.response_options.each_with_index.map do |label, position|
      weighted_total = weighted_totals.fetch(position, 0.0)

      {
        label: label,
        respondents: respondent_counts.fetch(position, 0),
        weighted_total: weighted_total.round(2),
        share: share_of_weight(weighted_total)
      }
    end
  end

  def respondents
    opinions.length
  end

  def informed_respondents
    user_weights.count { |_user_id, weight| weight.positive? }
  end

  def weighted_total
    @weighted_total ||= weighted_totals.values.sum
  end

  def leading_response
    return if weighted_total.zero?

    distribution.max_by { |bucket| bucket[:weighted_total] }
  end

  def weighted_score
    return if weighted_total.zero?

    weighted_sum = distribution.each_with_index.sum do |bucket, position|
      bucket[:weighted_total] * POSITION_SCORES.fetch(position)
    end

    (weighted_sum / weighted_total).round(3)
  end

  def dial_angle
    360 + (90 * (weighted_score || 0))
  end

  private

  def opinions
    @opinions ||= opinion_question.user_opinions.pluck(:user_id, :position)
  end

  def respondent_counts
    @respondent_counts ||= opinions.each_with_object(Hash.new(0)) do |(_user_id, position), counts|
      counts[position] += 1
    end
  end

  def weighted_totals
    @weighted_totals ||= opinions.each_with_object(Hash.new(0.0)) do |(user_id, position), totals|
      totals[position] += user_weights.fetch(user_id, 0.0)
    end
  end

  def user_weights
    @user_weights ||= begin
      total_importance = opinion_question.fact_questions.sum(:importance_weight)
      earned_importance = FactResponse
        .joins(:fact_question)
        .where(correct: true, fact_questions: { opinion_question_id: opinion_question.id })
        .group(:user_id)
        .sum("fact_questions.importance_weight")

      opinions.to_h do |user_id, _position|
        weight = total_importance.zero? ? 0.0 : earned_importance.fetch(user_id, 0).fdiv(total_importance)
        [ user_id, weight ]
      end
    end
  end

  def share_of_weight(bucket_weight)
    return 0.0 if weighted_total.zero?

    (bucket_weight.fdiv(weighted_total) * 100).round(1)
  end
end
