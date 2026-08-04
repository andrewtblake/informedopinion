class OpinionHistory < ApplicationRecord
  belongs_to :user_opinion

  enum :event_type, { imported_baseline: 0, initial_response: 1, revision: 2 }

  validates :event_type, presence: true
  validates :from_position, inclusion: { in: 0..4 }, allow_nil: true
  validates :to_position, inclusion: { in: 0..4 }
  validates :from_position, presence: true, if: :revision?
  validates :knowledge_weight, :raw_knowledge_weight,
    numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 },
    allow_nil: true
  validates :facts_answered, :facts_correct, :facts_available,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 },
    allow_nil: true

  before_update { raise ActiveRecord::ReadOnlyRecord, "opinion history is immutable" }

  def self.capture!(user_opinion, event_type:, from_position: nil)
    progress = OpinionProgress.new(user_opinion.user, user_opinion.opinion_question)

    create!(
      user_opinion: user_opinion,
      event_type: event_type,
      from_position: from_position,
      to_position: user_opinion.position,
      knowledge_weight: progress.weight,
      raw_knowledge_weight: progress.raw_weight,
      facts_answered: progress.answered,
      facts_correct: progress.correct,
      facts_available: progress.total
    )
  end
end
