class PublicStatisticsSummary
  TopicResult = Data.define(
    :question,
    :collective,
    :unweighted_score,
    :changed_opinions,
    :revisions
  )

  attr_reader :minimum_group_size

  def initialize(minimum_group_size: Rails.configuration.x.statistics.minimum_group_size)
    @minimum_group_size = minimum_group_size
  end

  def participants
    public_opinions.distinct.count(:user_id)
  end

  def registered_opinions
    public_opinions.count
  end

  def informed_opinions
    topic_results.sum { _1.collective.informed_respondents }
  end

  def people_who_changed
    revisions.joins(:user_opinion).distinct.count("user_opinions.user_id")
  end

  def opinions_changed
    revisions.distinct.count(:user_opinion_id)
  end

  def revision_count
    revisions.count
  end

  def side_crossings
    revisions.where(
      "(from_position < 2 AND to_position > 2) OR (from_position > 2 AND to_position < 2)"
    ).count
  end

  def transition_counts
    @transition_counts ||= revisions.group(:from_position, :to_position).count
  end

  def topic_results
    @topic_results ||= begin
      change_counts = revisions.group("user_opinions.opinion_question_id").distinct.count(:user_opinion_id)
      revision_counts = revisions.group("user_opinions.opinion_question_id").count

      public_questions.map do |question|
        positions = question.user_opinions.pluck(:position)
        TopicResult.new(
          question: question,
          collective: CollectiveOpinion.new(question),
          unweighted_score: unweighted_score(positions),
          changed_opinions: change_counts.fetch(question.id, 0),
          revisions: revision_counts.fetch(question.id, 0)
        )
      end
    end
  end

  private

  def public_questions
    @public_questions ||= OpinionQuestion.live.in_display_order.to_a
  end

  def public_opinions
    UserOpinion.joins(:opinion_question).merge(OpinionQuestion.live)
  end

  def revisions
    OpinionHistory.revision
      .joins(user_opinion: :opinion_question)
      .merge(OpinionQuestion.live)
  end

  def unweighted_score(positions)
    return if positions.empty?

    scores = positions.map { CollectiveOpinion::POSITION_SCORES.fetch(_1) }
    (scores.sum.fdiv(scores.length) * 100).round(1)
  end
end
