class TopicDiscovery
  POSITION_SCORES = [ 1.0, 0.5, 0.0, -0.5, -1.0 ].freeze

  def initialize(questions)
    @questions = questions.to_a
  end

  def popular(limit: 5)
    questions.sort_by { |question| [ -respondent_counts.fetch(question.id, 0), question.display_order ] }.first(limit)
  end

  def controversial(limit: 5)
    questions
      .select { |question| respondent_counts.fetch(question.id, 0) > 1 }
      .sort_by { |question| [ -controversy_score(question.id), question.display_order ] }
      .first(limit)
  end

  def respondents(question)
    respondent_counts.fetch(question.id, 0)
  end

  private

  attr_reader :questions

  def respondent_counts
    @respondent_counts ||= UserOpinion.where(opinion_question_id: question_ids)
      .group(:opinion_question_id)
      .count
  end

  def position_counts
    @position_counts ||= UserOpinion.where(opinion_question_id: question_ids)
      .group(:opinion_question_id, :position)
      .count
  end

  def controversy_score(question_id)
    counts = POSITION_SCORES.each_index.map do |position|
      position_counts.fetch([ question_id, position ], 0)
    end
    total = counts.sum
    return 0 if total < 2

    mean = counts.each_with_index.sum { |count, position| count * POSITION_SCORES.fetch(position) }.fdiv(total)
    variance = counts.each_with_index.sum do |count, position|
      count * ((POSITION_SCORES.fetch(position) - mean)**2)
    end.fdiv(total)

    variance * Math.log1p(total)
  end

  def question_ids
    @question_ids ||= questions.map(&:id)
  end
end
