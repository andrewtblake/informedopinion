class UserOpinion < ApplicationRecord
  belongs_to :user
  belongs_to :opinion_question

  validates :position, inclusion: { in: 0..4 }
  validates :opinion_question_id, uniqueness: { scope: :user_id }

  def label
    opinion_question.response_label(position)
  end

  def stance
    2 - position
  end
end
