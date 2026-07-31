class AddEditorialOutcomesAndFactQuestionProposals < ActiveRecord::Migration[8.1]
  def change
    change_table :opinion_question_proposals, bulk: true do |t|
      t.string :final_title
      t.text :final_statement
      t.references :published_opinion_question, foreign_key: { to_table: :opinion_questions }
    end

    create_table :fact_question_proposals do |t|
      t.references :proposer, null: false, foreign_key: { to_table: :users }
      t.references :opinion_question, null: false, foreign_key: true
      t.text :prompt, null: false
      t.json :options, null: false
      t.integer :correct_option, null: false
      t.text :explanation, null: false
      t.string :source_name, null: false
      t.string :source_url, null: false
      t.integer :importance_weight, null: false
      t.text :importance_rationale, null: false
      t.integer :evidence_direction, null: false
      t.integer :status, default: 0, null: false
      t.references :reviewer, foreign_key: { to_table: :users }
      t.text :review_notes
      t.datetime :reviewed_at
      t.references :published_fact_question, foreign_key: { to_table: :fact_questions }
      t.timestamps
    end

    add_index :fact_question_proposals, :status
    add_check_constraint :fact_question_proposals,
      "importance_weight BETWEEN 1 AND 3",
      name: "fact_question_proposals_importance_weight_range"
    add_check_constraint :fact_question_proposals,
      "correct_option BETWEEN 0 AND 3",
      name: "fact_question_proposals_correct_option_range"
    add_check_constraint :fact_question_proposals,
      "evidence_direction BETWEEN -1 AND 1",
      name: "fact_question_proposals_evidence_direction_range"
  end
end
