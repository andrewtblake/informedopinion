class RecalculateFactResponseCorrectness < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      UPDATE fact_responses
      SET correct = CASE
        WHEN selected_option = (
          SELECT correct_option
          FROM fact_questions
          WHERE fact_questions.id = fact_responses.fact_question_id
        ) THEN TRUE
        ELSE FALSE
      END
    SQL
  end

  def down
    # Correctness cannot safely be restored to its value under an obsolete answer key.
  end
end
