class Category < ApplicationRecord
  has_many :opinion_questions, dependent: :restrict_with_error
  has_many :live_opinion_questions, -> { live }, class_name: "OpinionQuestion"

  validates :name, :slug, presence: true, uniqueness: true

  def to_param
    slug
  end
end
