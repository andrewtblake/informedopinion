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
  validates :featured_priority, inclusion: { in: -10..10 }
  validates :response_options, length: { is: 5 }

  scope :in_display_order, -> { order(:display_order) }
  scope :live, -> { where(live: true) }

  before_create :record_initial_publication

  def publish_if_fact_bank_ready!
    minimum = Rails.configuration.x.fact_question_proposals.minimum_existing_questions
    if !live? && fact_questions.count >= minimum
      update!(live: true, published_at: Time.current)
    end
  end

  def response_label(position)
    response_options.fetch(position)
  end

  def to_param
    slug
  end

  private

  def record_initial_publication
    self.published_at ||= Time.current if live?
  end
end
