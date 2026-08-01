class OpinionQuestionProposal < ApplicationRecord
  enum :status, { pending: 0, approved: 1, declined: 2 }

  belongs_to :proposer, class_name: "User"
  belongs_to :category
  belongs_to :reviewer,
    class_name: "User",
    optional: true,
    inverse_of: :reviewed_opinion_question_proposals
  belongs_to :published_opinion_question, class_name: "OpinionQuestion", optional: true

  validates :title, presence: true, length: { maximum: 100 }
  validates :statement, presence: true, length: { maximum: 1_000 }
  validates :final_title, length: { maximum: 100 }, allow_nil: true
  validates :final_statement, length: { maximum: 1_000 }, allow_nil: true
  validates :tags_text, presence: true
  validates :rationale, presence: true, length: { maximum: 2_000 }

  def tag_names
    tags_text.split(",").map(&:strip).reject(&:blank?).uniq
  end

  def edited_on_approval?
    approved? && (final_title != title || final_statement != statement)
  end

  def decision_label
    label = edited_on_approval? ? "Approved with editorial changes" : status.humanize
    return "#{label} — being prepared" if approved? && !published_opinion_question&.live?

    label
  end
end
