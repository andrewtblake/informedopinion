class AddAttemptCountToFactResponses < ActiveRecord::Migration[8.1]
  def up
    add_column :fact_responses, :attempt_count, :integer, null: false, default: 0
    add_check_constraint :fact_responses,
      "attempt_count >= 0",
      name: "fact_responses_attempt_count_nonnegative"

    execute "UPDATE fact_responses SET attempt_count = 1"
  end

  def down
    remove_check_constraint :fact_responses,
      name: "fact_responses_attempt_count_nonnegative"
    remove_column :fact_responses, :attempt_count
  end
end
