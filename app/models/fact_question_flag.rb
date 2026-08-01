class FactQuestionFlag < ApplicationRecord
  enum :category, {
    inaccurate: 0,
    irrelevant: 1,
    unclear: 2,
    biased: 3,
    outdated: 4,
    other: 5
  }
  enum :status, { pending: 0, resolved: 1, dismissed: 2 }
  enum :resolution_action, { corrected: 0, withdrawn: 1, no_change: 2 }, prefix: :resolution

  belongs_to :user
  belongs_to :fact_question
  belongs_to :reviewer,
    class_name: "User",
    optional: true,
    inverse_of: :reviewed_fact_question_flags

  validates :category, presence: true
  validates :category, uniqueness: { scope: [ :user_id, :fact_question_id ] }
  validates :details, presence: true, if: :other?
  validates :resolution_action, :resolution_notes, presence: true, unless: :pending?

  def category_label
    category.humanize
  end
end
