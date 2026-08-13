class DiscardResponsesToRevisedVotingReformQuestions < ActiveRecord::Migration[8.0]
  REVISED_FACT_QUESTION_IDS = %w[
    181 182 183 184 185 186 188 189 190 191 192 193
    194 195 196 197 198 199 203 206 207 209 210
  ].freeze

  def up
    execute <<~SQL
      DELETE FROM fact_responses
      WHERE fact_question_id IN (#{REVISED_FACT_QUESTION_IDS.join(", ")})
    SQL
  end

  def down
    # Responses to obsolete question wording cannot be restored safely.
  end
end
