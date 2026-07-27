class AddImportanceToFactQuestions < ActiveRecord::Migration[8.1]
  DEFAULT_RATIONALE = "This question currently has the standard importance weight; unequal weights will only be assigned after review."

  def change
    add_column :fact_questions, :importance_weight, :integer, null: false, default: 1
    add_column :fact_questions, :importance_rationale, :text, null: false, default: DEFAULT_RATIONALE

    add_check_constraint :fact_questions,
      "importance_weight BETWEEN 1 AND 3",
      name: "fact_questions_importance_weight_range"
  end
end
