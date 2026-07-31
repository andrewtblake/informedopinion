class User < ApplicationRecord
  enum :role, { participant: 0, moderator: 1 }

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :validatable

  has_many :user_opinions, dependent: :destroy
  has_many :opinion_questions, through: :user_opinions
  has_many :fact_responses, dependent: :destroy
  has_many :fact_question_flags, dependent: :destroy
  has_many :opinion_question_reactions, dependent: :destroy
  has_many :opinion_question_proposals, foreign_key: :proposer_id, dependent: :destroy, inverse_of: :proposer
  has_many :fact_question_proposals, foreign_key: :proposer_id, dependent: :destroy, inverse_of: :proposer

  validates :first_name, :last_name, presence: true, length: { maximum: 50 }

  def name
    [ first_name, last_name ].join(" ")
  end
end
