class OpinionQuestionTag < ApplicationRecord
  belongs_to :opinion_question
  belongs_to :tag

  validates :tag_id, uniqueness: { scope: :opinion_question_id }
end
