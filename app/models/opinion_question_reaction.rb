class OpinionQuestionReaction < ApplicationRecord
  enum :kind, { like: 0, dislike: 1 }
  enum :moderation_status, { pending: 0, reviewed: 1, dismissed: 2 }, prefix: :moderation

  belongs_to :user
  belongs_to :opinion_question
  belongs_to :reviewer, class_name: "User", optional: true

  validates :kind, presence: true
  validates :opinion_question_id, uniqueness: { scope: :user_id }
  validates :reason, presence: true, if: :dislike?
  validates :moderation_status, presence: true, if: :dislike?

  before_validation :prepare_moderation_state

  private

  def prepare_moderation_state
    if like?
      self.reason = nil
      self.moderation_status = nil
      self.moderation_notes = nil
      self.reviewer = nil
      self.reviewed_at = nil
    elsif new_record? || will_save_change_to_reason? || will_save_change_to_kind?
      self.moderation_status = :pending
      self.moderation_notes = nil
      self.reviewer = nil
      self.reviewed_at = nil
    end
  end
end
