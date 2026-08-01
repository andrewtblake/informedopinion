class FeaturedQuestionRanker
  NEW_QUESTION_WINDOW = 90.days
  EDITORIAL_POINT_VALUE = 5.0
  SAME_CATEGORY_PENALTY = 4.0
  RECENT_CATEGORY_PENALTY = 1.5

  Metric = Data.define(:score, :respondents, :informed_respondents, :controversy, :freshness)

  def initialize(questions, now: Time.current)
    @questions = questions.to_a
    @now = now
  end

  def rank
    remaining = questions.dup
    ordered = []

    until remaining.empty?
      question = remaining.max_by do |candidate|
        [ diversified_score(candidate, ordered), score(candidate), -candidate.display_order, -candidate.id ]
      end
      ordered << question
      remaining.delete(question)
    end

    ordered
  end

  def metric(question)
    Metric.new(
      score: score(question).round(2),
      respondents: respondent_counts.fetch(question.id, 0),
      informed_respondents: informed_counts.fetch(question.id, 0),
      controversy: controversy_score(question.id).round(2),
      freshness: freshness(question).round(2)
    )
  end

  private

  attr_reader :questions, :now

  def score(question)
    (question.featured_priority * EDITORIAL_POINT_VALUE) +
      (Math.log1p(informed_counts.fetch(question.id, 0)) * 4.0) +
      Math.log1p(respondent_counts.fetch(question.id, 0)) +
      (controversy_score(question.id) * 1.5) +
      (freshness(question) * 3.0)
  end

  def diversified_score(question, ordered)
    recent_categories = ordered.last(3).map(&:category_id)
    penalty = if question.category_id.present? && question.category_id == recent_categories.last
      SAME_CATEGORY_PENALTY
    elsif question.category_id.present? && recent_categories.include?(question.category_id)
      RECENT_CATEGORY_PENALTY
    else
      0.0
    end

    score(question) - penalty
  end

  def freshness(question)
    age = [ now - (question.published_at || question.created_at), 0 ].max
    [ 1.0 - (age / NEW_QUESTION_WINDOW), 0.0 ].max
  end

  def respondent_counts
    @respondent_counts ||= UserOpinion.where(opinion_question_id: question_ids)
      .group(:opinion_question_id)
      .count
  end

  def informed_counts
    @informed_counts ||= FactResponse.joins(:fact_question)
      .where(correct: true, fact_questions: { opinion_question_id: question_ids, withdrawn_at: nil })
      .group("fact_questions.opinion_question_id")
      .distinct
      .count(:user_id)
  end

  def position_counts
    @position_counts ||= UserOpinion.where(opinion_question_id: question_ids)
      .group(:opinion_question_id, :position)
      .count
  end

  def controversy_score(question_id)
    counts = TopicDiscovery::POSITION_SCORES.each_index.map do |position|
      position_counts.fetch([ question_id, position ], 0)
    end
    total = counts.sum
    return 0.0 if total < 2

    mean = counts.each_with_index.sum do |count, position|
      count * TopicDiscovery::POSITION_SCORES.fetch(position)
    end.fdiv(total)
    variance = counts.each_with_index.sum do |count, position|
      count * ((TopicDiscovery::POSITION_SCORES.fetch(position) - mean)**2)
    end.fdiv(total)

    variance * Math.log1p(total)
  end

  def question_ids
    @question_ids ||= questions.map(&:id)
  end
end
