class UserOpinion < ApplicationRecord
  belongs_to :user
  belongs_to :opinion_question
  has_many :opinion_histories, dependent: :destroy

  validates :position, inclusion: { in: 0..4 }
  validates :opinion_question_id, uniqueness: { scope: :user_id }

  after_create :record_initial_history
  after_update :record_revision_history, if: :saved_change_to_position?

  def label
    opinion_question.response_label(position)
  end

  def stance
    2 - position
  end

  private

  def record_initial_history
    OpinionHistory.capture!(self, event_type: :initial_response)
  end

  def record_revision_history
    OpinionHistory.capture!(
      self,
      event_type: :revision,
      from_position: saved_change_to_position.first
    )
  end
end
