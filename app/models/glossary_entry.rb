class GlossaryEntry < ApplicationRecord
  normalizes :term, :definition, with: ->(value) { value.strip }

  validates :term, presence: true, uniqueness: true, length: { minimum: 2, maximum: 32 },
    format: { with: /\A[A-Z][A-Za-z0-9]*(?:[-\/][A-Za-z0-9]+)*\z/ }
  validates :definition, presence: true, length: { maximum: 500 }
end
