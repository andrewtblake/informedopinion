class OpinionQuestion < ApplicationRecord
  belongs_to :category, optional: true
  has_many :fact_questions, -> { order(:display_order) }, dependent: :destroy
  has_many :published_fact_questions,
    -> { published.order(:display_order) },
    class_name: "FactQuestion"
  has_many :user_opinions, dependent: :destroy
  has_many :opinion_question_reactions, dependent: :destroy
  has_many :opinion_question_tags, dependent: :destroy
  has_many :fact_question_proposals, dependent: :destroy
  has_many :social_cards, dependent: :destroy
  has_many :tags, through: :opinion_question_tags

  validates :slug, :title, :statement, :accent, presence: true
  validates :slug, uniqueness: true
  validates :display_order, uniqueness: true
  validates :featured_priority, inclusion: { in: -10..10 }
  validates :response_options, length: { is: 5 }

  scope :in_display_order, -> { order(:display_order) }
  scope :live, -> { where(live: true) }

  before_create :record_initial_publication
  after_commit :regenerate_social_cards, on: %i[create update], if: :title_previously_changed?

  def eligible_for_publication?
    published_fact_questions.count >= minimum_fact_questions
  end

  def publish!
    unless eligible_for_publication?
      errors.add(:base, "requires at least #{minimum_fact_questions} published fact questions before publication")
      raise ActiveRecord::RecordInvalid, self
    end

    update!(live: true, published_at: published_at || Time.current)
  end

  def unpublish_if_fact_bank_not_ready!
    update!(live: false) if live? && !eligible_for_publication?
  end

  def response_label(position)
    response_options.fetch(position)
  end

  def to_param
    slug
  end

  private

  def minimum_fact_questions
    Rails.configuration.x.fact_question_proposals.minimum_existing_questions
  end

  def record_initial_publication
    self.published_at ||= Time.current if live?
  end

  def title_previously_changed?
    previous_changes.key?("title")
  end

  def regenerate_social_cards
    GenerateSocialCardsJob.perform_later(id)
  end
end
