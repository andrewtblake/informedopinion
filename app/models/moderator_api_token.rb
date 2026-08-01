require "digest"
require "securerandom"

class ModeratorApiToken < ApplicationRecord
  PREFIX = "io_mod_"

  belongs_to :user
  has_many :api_audit_events, dependent: :nullify

  validates :name, :token_digest, :token_prefix, presence: true
  validates :token_digest, uniqueness: true
  validate :user_is_moderator

  scope :active, -> { where(revoked_at: nil) }

  def self.issue!(user:, name:)
    plaintext = "#{PREFIX}#{SecureRandom.urlsafe_base64(32)}"
    token = create!(
      user: user,
      name: name,
      token_digest: digest(plaintext),
      token_prefix: plaintext.first(15)
    )
    [ token, plaintext ]
  end

  def self.authenticate(plaintext)
    return if plaintext.blank? || !plaintext.start_with?(PREFIX)

    active.includes(:user).find_by(token_digest: digest(plaintext))
  end

  def self.digest(plaintext)
    Digest::SHA256.hexdigest(plaintext)
  end

  def revoke!
    update!(revoked_at: Time.current)
  end

  private

  def user_is_moderator
    errors.add(:user, "must be a moderator") unless user&.moderator?
  end
end
