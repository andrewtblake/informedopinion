class AddFactReportOutcomes < ActiveRecord::Migration[8.1]
  LEGACY_NOTE = "Reviewed under the previous moderation workflow; no corrective action was recorded."

  def up
    add_column :fact_questions, :withdrawn_at, :datetime
    add_index :fact_questions, :withdrawn_at
    add_column :fact_question_flags, :resolution_action, :integer

    execute <<~SQL.squish
      UPDATE fact_question_flags
      SET resolution_action = 2,
          resolution_notes = CASE
            WHEN resolution_notes IS NULL OR resolution_notes = '' THEN '#{LEGACY_NOTE}'
            ELSE resolution_notes
          END
      WHERE status != 0
    SQL
  end

  def down
    remove_column :fact_question_flags, :resolution_action
    remove_index :fact_questions, :withdrawn_at
    remove_column :fact_questions, :withdrawn_at
  end
end
