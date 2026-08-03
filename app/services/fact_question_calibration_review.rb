require "digest"

class FactQuestionCalibrationReview
  attr_reader :opinion_question

  def initialize(opinion_question)
    @opinion_question = opinion_question
  end

  def latest_assessments
    @latest_assessments ||= opinion_question.fact_questions
      .includes(:calibration_assessments)
      .filter_map { _1.calibration_assessments.max_by { |assessment| [ assessment.created_at, assessment.id ] } }
  end

  def summary
    {
      total_questions: opinion_question.fact_questions.length,
      assessed: latest_assessments.length,
      pending: latest_assessments.count(&:ai_proposed?),
      accepted: latest_assessments.count(&:accepted?),
      overridden: latest_assessments.count(&:overridden?),
      reassessment_requested: latest_assessments.count(&:reassessment_requested?),
      unfit: latest_assessments.count { effective_answerability(_1).zero? },
      stale: latest_assessments.count { stale?(_1) }
    }
  end

  def specialist_distribution
    distribution(latest_assessments.map { effective_specialist_knowledge(_1) }, 1..6)
  end

  def answerability_distribution
    distribution(latest_assessments.map { effective_answerability(_1) }, 0..5)
  end

  def cross_tabulation
    latest_assessments.each_with_object(Hash.new(0)) do |assessment, result|
      result[[ effective_specialist_knowledge(assessment), effective_answerability(assessment) ]] += 1
    end
  end

  def supervisory_sample
    candidates = latest_assessments.select(&:ai_proposed?)
    selected = candidates.select { review_reasons(_1).any? }
    candidates.group_by { [ _1.specialist_knowledge, _1.answerability ] }.each_value do |group|
      selected << group.min_by(&:id)
    end
    remaining = candidates - selected
    selected << remaining.min_by { Digest::SHA256.hexdigest("calibration-sample:#{_1.id}") } if remaining.any?
    selected.compact.uniq.sort_by { [ _1.fact_question.display_order, _1.id ] }
  end

  def review_reasons(assessment)
    reasons = []
    reasons << "Unfit question" if assessment.answerability.zero?
    reasons << "Extreme specialist-knowledge rating" if [ 1, 5, 6 ].include?(assessment.specialist_knowledge)
    reasons << "Extreme answerability rating" if [ 1, 5 ].include?(assessment.answerability)
    if assessment.specialist_knowledge_confidence <= 2 || assessment.answerability_confidence <= 2
      reasons << "Low AI confidence"
    end
    reasons << "Question changed after assessment" if stale?(assessment)
    reasons
  end

  def stale?(assessment)
    assessment.content_fingerprint != FactQuestionCalibrationAudit.fingerprint(assessment.fact_question)
  end

  private

  def effective_specialist_knowledge(assessment)
    assessment.reviewed_specialist_knowledge || assessment.specialist_knowledge
  end

  def effective_answerability(assessment)
    assessment.reviewed_answerability.nil? ? assessment.answerability : assessment.reviewed_answerability
  end

  def distribution(values, range)
    range.to_h { |rating| [ rating, values.count(rating) ] }
  end
end
