class OpinionQuestionReaction < ApplicationRecord
  enum :kind, { like: 0, dislike: 1 }

  belongs_to :user
  belongs_to :opinion_question

  validates :kind, presence: true
  validates :opinion_question_id, uniqueness: { scope: :user_id }
  validates :reason, presence: true, if: :dislike?
end
