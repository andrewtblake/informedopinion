class FactQuestionProposal < ApplicationRecord
  enum :status, { pending: 0, approved: 1, declined: 2 }

  belongs_to :proposer, class_name: "User", inverse_of: :fact_question_proposals
  belongs_to :opinion_question
  belongs_to :reviewer, class_name: "User", optional: true
  belongs_to :published_fact_question, class_name: "FactQuestion", optional: true

  validates :prompt, :explanation, :source_name, :source_url, :importance_rationale, presence: true
  validates :source_url, format: { with: %r{\Ahttps?://}i }
  validates :options, length: { is: 4 }
  validates :correct_option, inclusion: { in: 0..3 }
  validates :importance_weight, inclusion: { in: FactQuestion::IMPORTANCE_LEVELS.keys }
  validates :evidence_direction, inclusion: { in: FactQuestion::DIRECTIONS }
  validate :options_are_present_and_distinct

  def correct_answer
    options.fetch(correct_option)
  end

  private

  def options_are_present_and_distinct
    normalized = Array(options).map { _1.to_s.strip }
    errors.add(:options, "must all be present") if normalized.any?(&:blank?)
    errors.add(:options, "must be distinct") if normalized.uniq.length != 4
  end
end
