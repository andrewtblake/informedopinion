class Category < ApplicationRecord
  has_many :opinion_questions, dependent: :restrict_with_error

  validates :name, :slug, presence: true, uniqueness: true

  def to_param
    slug
  end
end
