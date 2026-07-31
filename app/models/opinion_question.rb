class OpinionQuestion < ApplicationRecord
  belongs_to :category, optional: true
  has_many :fact_questions, -> { order(:display_order) }, dependent: :destroy
  has_many :user_opinions, dependent: :destroy
  has_many :opinion_question_reactions, dependent: :destroy
  has_many :opinion_question_tags, dependent: :destroy
  has_many :fact_question_proposals, dependent: :destroy
  has_many :tags, through: :opinion_question_tags

  validates :slug, :title, :statement, :accent, presence: true
  validates :slug, uniqueness: true
  validates :display_order, uniqueness: true
  validates :response_options, length: { is: 5 }

  scope :in_display_order, -> { order(:display_order) }

  def response_label(position)
    response_options.fetch(position)
  end

  def to_param
    slug
  end
end
