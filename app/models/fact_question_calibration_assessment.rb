class FactQuestionCalibrationAssessment < ApplicationRecord
  FAILURE_CATEGORIES = %w[
    implausible_distractors
    answer_cue
    multiple_defensible_answers
    unsupported_distinction
    immaterial_trivia
    unnecessary_technical_language
    misleading_numerical_options
    other
  ].freeze

  enum :status, {
    ai_proposed: 0,
    accepted: 1,
    overridden: 2,
    reassessment_requested: 3
  }

  belongs_to :fact_question
  belongs_to :submitted_by, class_name: "User"
  belongs_to :reviewer, class_name: "User", optional: true

  validates :content_fingerprint, :specialist_knowledge_rationale, :answerability_rationale,
    :assessor_name, :run_identifier, presence: true
  validates :specialist_knowledge, inclusion: { in: FactQuestion::SPECIALIST_KNOWLEDGE_LEVELS.keys }
  validates :answerability, inclusion: { in: FactQuestion::ANSWERABILITY_LEVELS.keys }
  validates :specialist_knowledge_confidence, :answerability_confidence, inclusion: { in: 1..5 }
  validates :failure_category, inclusion: { in: FAILURE_CATEGORIES },
    allow_nil: true
  validate :unfit_assessment_has_diagnosis

  private

  def unfit_assessment_has_diagnosis
    return unless answerability == 0

    errors.add(:failure_category, "must identify why the question is unfit") if failure_category.blank?
    errors.add(:remediation, "must propose how to correct or replace the question") if remediation.blank?
  end
end
