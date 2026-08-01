class ModerationItemView < ApplicationRecord
  belongs_to :moderator, class_name: "User"

  validates :item_key, :seen_version_at, :displayed_at, presence: true
  validates :item_key, uniqueness: { scope: :moderator_id }
  validate :moderator_role

  private

  def moderator_role
    errors.add(:moderator, "must have the moderator role") unless moderator&.moderator?
  end
end
