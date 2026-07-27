class FactQuestion < ApplicationRecord
  DIRECTIONS = [ -1, 0, 1 ].freeze
  IMPORTANCE_LEVELS = {
    1 => "Supporting",
    2 => "Significant",
    3 => "Foundational"
  }.freeze

  belongs_to :opinion_question
  has_many :fact_responses, dependent: :destroy

  validates :prompt, :explanation, :source_name, :source_url, :importance_rationale, presence: true
  validates :importance_weight, inclusion: { in: IMPORTANCE_LEVELS.keys }
  validates :options, length: { is: 4 }
  validates :correct_option, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :evidence_direction, inclusion: { in: DIRECTIONS }
  validate :correct_option_is_available

  def correct_answer
    options.fetch(correct_option)
  end

  def importance_label
    IMPORTANCE_LEVELS.fetch(importance_weight)
  end

  private

  def correct_option_is_available
    return if correct_option.blank? || correct_option < options.length

    errors.add(:correct_option, "must identify one of the available options")
  end
end
