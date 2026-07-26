class OpinionQuestion < ApplicationRecord
  has_many :fact_questions, -> { order(:display_order) }, dependent: :destroy
  has_many :user_opinions, dependent: :destroy

  validates :slug, :title, :statement, :accent, presence: true
  validates :slug, uniqueness: true
  validates :display_order, uniqueness: true
  validates :response_options, length: { is: 5 }

  scope :in_display_order, -> { order(:display_order) }

  def response_label(position)
    response_options.fetch(position)
  end
end
