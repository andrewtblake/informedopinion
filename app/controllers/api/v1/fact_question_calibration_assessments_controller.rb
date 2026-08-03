class Api::V1::FactQuestionCalibrationAssessmentsController < Api::V1::BaseController
  MAXIMUM_BANK_SIZE = 100

  def index
    assessments = parent.fact_questions.includes(:calibration_assessments).flat_map(&:calibration_assessments)
    render json: { calibration_assessments: assessments.sort_by(&:created_at).map { serialize(_1) } }
  end

  def bulk_create
    payload = params.require(:assessments)
    unless payload.is_a?(Array) && payload.length.between?(1, MAXIMUM_BANK_SIZE)
      return render json: { error: "invalid_batch", message: "Provide between 1 and #{MAXIMUM_BANK_SIZE} assessments." },
        status: :unprocessable_entity
    end

    questions = parent.fact_questions.index_by(&:id)
    supplied_ids = payload.map { _1.require(:fact_question_id).to_i }
    unless supplied_ids.uniq.length == supplied_ids.length && supplied_ids.sort == questions.keys.sort
      return render json: {
        error: "incomplete_bank",
        message: "Submit exactly one assessment for every fact question in the bank.",
        expected_ids: questions.keys.sort,
        supplied_ids: supplied_ids.sort
      }, status: :unprocessable_entity
    end

    records = payload.map do |attributes|
      question = questions.fetch(attributes[:fact_question_id].to_i)
      submitted_fingerprint = attributes.require(:content_fingerprint)
      if submitted_fingerprint != FactQuestionCalibrationAudit.fingerprint(question)
        question.errors.add(:base, "changed after this calibration assessment was prepared")
        raise ActiveRecord::RecordInvalid, question
      end
      question.calibration_assessments.new(
        assessment_attributes(attributes).merge(
          submitted_by: current_moderator,
          assessor_name: params.require(:assessor_name),
          run_identifier: params.require(:run_identifier),
          status: :ai_proposed
        )
      )
    end

    FactQuestionCalibrationAssessment.transaction do
      records.each do |assessment|
        assessment.save!
        assessment.fact_question.update!(
          specialist_knowledge: assessment.specialist_knowledge,
          answerability: assessment.answerability
        )
        audit!(action: "fact_question_calibration.ai_propose", resource: assessment,
          changes: serialize(assessment))
      end
    end

    render json: {
      calibration_assessments: records.map { serialize(_1) },
      opinion_question_id: parent.id,
      status: "awaiting_supervisory_review"
    }, status: :created
  end

  private

  def parent
    identifier = params[:opinion_question_id] || params[:id]
    @parent ||= identifier.to_s.match?(/\A\d+\z/) ? OpinionQuestion.find(identifier) : OpinionQuestion.find_by!(slug: identifier)
  end

  def assessment_attributes(attributes)
    attributes.permit(:content_fingerprint, :specialist_knowledge, :specialist_knowledge_rationale,
      :specialist_knowledge_confidence, :answerability, :answerability_rationale,
      :answerability_confidence, :failure_category, :remediation)
  end

  def serialize(record)
    record.as_json(only: %i[id fact_question_id content_fingerprint specialist_knowledge
      specialist_knowledge_rationale specialist_knowledge_confidence answerability answerability_rationale
      answerability_confidence failure_category remediation assessor_name run_identifier status submitted_by_id
      reviewer_id review_notes reviewed_at created_at])
  end
end
