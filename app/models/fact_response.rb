class FactResponse < ApplicationRecord
  belongs_to :user
  belongs_to :fact_question

  validates :fact_question_id, uniqueness: { scope: :user_id }
  validates :selected_option, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validate :selected_option_is_available

  before_validation :set_correctness

  private

  def set_correctness
    return if selected_option.blank? || fact_question.blank?

    self.correct = selected_option == fact_question.correct_option
  end

  def selected_option_is_available
    return if selected_option.blank? || fact_question.blank?
    return if selected_option < fact_question.options.length

    errors.add(:selected_option, "must identify one of the available options")
  end
end
