class ApiAuditEvent < ApplicationRecord
  belongs_to :actor, class_name: "User", optional: true
  belongs_to :moderator_api_token, optional: true

  validates :action, :resource_type, presence: true

  def readonly?
    persisted?
  end
end
