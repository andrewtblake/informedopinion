class Tag < ApplicationRecord
  has_many :opinion_question_tags, dependent: :destroy
  has_many :opinion_questions, through: :opinion_question_tags

  validates :name, :slug, presence: true, uniqueness: true

  def to_param
    slug
  end
end
