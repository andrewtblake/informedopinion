class OpinionQuestionProposal < ApplicationRecord
  enum :status, { pending: 0, approved: 1, declined: 2 }

  belongs_to :proposer, class_name: "User"
  belongs_to :category
  belongs_to :reviewer, class_name: "User", optional: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :statement, presence: true, length: { maximum: 1_000 }
  validates :tags_text, presence: true
  validates :rationale, presence: true, length: { maximum: 2_000 }

  def tag_names
    tags_text.split(",").map(&:strip).reject(&:blank?).uniq
  end
end
