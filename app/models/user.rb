class User < ApplicationRecord
  attribute :accept_terms, :boolean
  attribute :consent_sensitive_data, :boolean
  attr_accessor :require_participation_consent

  enum :role, { participant: 0, moderator: 1 }

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :user_opinions, dependent: :destroy
  has_many :opinion_questions, through: :user_opinions
  has_many :fact_responses, dependent: :destroy
  has_many :fact_question_flags, dependent: :destroy
  has_many :opinion_question_reactions, dependent: :destroy
  has_many :reviewed_opinion_question_reactions,
    class_name: "OpinionQuestionReaction",
    foreign_key: :reviewer_id,
    dependent: :nullify,
    inverse_of: :reviewer
  has_many :opinion_question_proposals, foreign_key: :proposer_id, dependent: :destroy, inverse_of: :proposer
  has_many :fact_question_proposals, foreign_key: :proposer_id, dependent: :destroy, inverse_of: :proposer
  has_many :moderator_api_tokens, dependent: :destroy
  has_many :moderation_item_views, foreign_key: :moderator_id, dependent: :destroy, inverse_of: :moderator
  has_many :api_audit_events, foreign_key: :actor_id, dependent: :nullify, inverse_of: :actor
  has_many :reviewed_fact_question_flags,
    class_name: "FactQuestionFlag",
    foreign_key: :reviewer_id,
    dependent: :nullify,
    inverse_of: :reviewer
  has_many :reviewed_opinion_question_proposals,
    class_name: "OpinionQuestionProposal",
    foreign_key: :reviewer_id,
    dependent: :nullify,
    inverse_of: :reviewer
  has_many :reviewed_fact_question_proposals,
    class_name: "FactQuestionProposal",
    foreign_key: :reviewer_id,
    dependent: :nullify,
    inverse_of: :reviewer

  validates :first_name, :last_name, presence: true, length: { maximum: 50 }
  validates :accept_terms,
    inclusion: { in: [ true ], message: "must be accepted" },
    if: :require_participation_consent
  validates :consent_sensitive_data,
    inclusion: { in: [ true ], message: "must be accepted" },
    if: :require_participation_consent

  before_create :record_initial_privacy_consent, if: :require_participation_consent

  def name
    [ first_name, last_name ].join(" ")
  end

  def privacy_consent_current?
    terms_accepted_at.present? && special_category_consent_at.present? &&
      privacy_notice_version == Rails.configuration.x.privacy.notice_version
  end

  def record_privacy_consent!
    update!(
      terms_accepted_at: Time.current,
      special_category_consent_at: Time.current,
      privacy_notice_version: Rails.configuration.x.privacy.notice_version
    )
  end

  protected

  def send_reset_password_instructions_notification(token)
    site = SiteIdentity.fetch(Current.site_key)
    send_devise_notification(
      :reset_password_instructions,
      token,
      site_name: site.name,
      site_url_options: Current.site_url_options
    )
  end

  private

  def record_initial_privacy_consent
    self.terms_accepted_at = Time.current
    self.special_category_consent_at = Time.current
    self.privacy_notice_version = Rails.configuration.x.privacy.notice_version
  end
end
