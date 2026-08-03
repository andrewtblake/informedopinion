class FactQuestion < ApplicationRecord
  VALENCES = {
    -1 => "Counters the proposition",
    0 => "Contextual or mixed",
    1 => "Supports the proposition"
  }.freeze
  DIRECTIONS = VALENCES.keys.freeze
  IMPORTANCE_LEVELS = {
    1 => "Supporting",
    2 => "Significant",
    3 => "Foundational"
  }.freeze
  SPECIALIST_KNOWLEDGE_LEVELS = {
    1 => "General knowledge",
    2 => "News-informed",
    3 => "Issue-focused",
    4 => "Sustained study",
    5 => "Professional or postgraduate",
    6 => "Subfield expert"
  }.freeze
  ANSWERABILITY_LEVELS = {
    0 => "Unfit",
    1 => "Very demanding",
    2 => "Demanding",
    3 => "Moderate",
    4 => "Accessible",
    5 => "Straightforward"
  }.freeze

  belongs_to :opinion_question, touch: true
  has_many :fact_responses, dependent: :destroy
  has_many :fact_question_flags, dependent: :destroy
  has_many :calibration_assessments,
    class_name: "FactQuestionCalibrationAssessment",
    dependent: :destroy

  validates :prompt, :explanation, :source_name, :source_url, :importance_rationale, presence: true
  validates :source_url, format: { with: %r{\Ahttps?://[^\s]+\z}i }
  validates :importance_weight, inclusion: { in: IMPORTANCE_LEVELS.keys }
  validates :specialist_knowledge, inclusion: { in: SPECIALIST_KNOWLEDGE_LEVELS.keys }, allow_nil: true
  validates :answerability, inclusion: { in: ANSWERABILITY_LEVELS.keys }, allow_nil: true
  validates :options, length: { is: 4 }
  validates :correct_option, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :evidence_direction, inclusion: { in: DIRECTIONS }
  validate :correct_option_is_available
  validate :options_are_present_and_distinct

  scope :published, -> { where(withdrawn_at: nil) }

  def withdrawn?
    withdrawn_at.present?
  end

  def correct_answer
    options.fetch(correct_option)
  end

  def importance_label
    IMPORTANCE_LEVELS.fetch(importance_weight)
  end

  def valence_label
    VALENCES.fetch(evidence_direction)
  end

  def specialist_knowledge_label
    SPECIALIST_KNOWLEDGE_LEVELS.fetch(specialist_knowledge) if specialist_knowledge
  end

  def answerability_label
    ANSWERABILITY_LEVELS.fetch(answerability) unless answerability.nil?
  end

  private

  def correct_option_is_available
    return if correct_option.blank? || correct_option < options.length

    errors.add(:correct_option, "must identify one of the available options")
  end

  def options_are_present_and_distinct
    normalized = Array(options).map { _1.to_s.strip }
    errors.add(:options, "must all be present") if normalized.any?(&:blank?)
    errors.add(:options, "must be distinct") if normalized.uniq.length != 4
  end
end
