class SocialCard < ApplicationRecord
  SITE_KEYS = %w[informed_opinion whats_your_view].freeze

  belongs_to :opinion_question

  validates :site_key, inclusion: { in: SITE_KEYS }
  validates :content_fingerprint, :content_type, :image_data, :generated_at, presence: true
  validates :template_version, :byte_size, numericality: { only_integer: true, greater_than: 0 }
  validates :site_key, uniqueness: { scope: :opinion_question_id }

  def self.fetch_or_generate!(opinion_question, site_key)
    site_key = site_key.to_s
    expected = SocialCardRenderer.fingerprint(opinion_question.title, site_key)
    card = find_by(opinion_question: opinion_question, site_key: site_key)
    return card if card&.content_fingerprint == expected

    SocialCardGenerator.generate!(opinion_question, site_key)
  end
end
