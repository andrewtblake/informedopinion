class CreateFactQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :fact_questions do |t|
      t.references :opinion_question, null: false, foreign_key: true
      t.text :prompt, null: false
      t.json :options, null: false
      t.integer :correct_option, null: false
      t.text :explanation, null: false
      t.string :source_name, null: false
      t.string :source_url, null: false
      t.integer :evidence_direction, null: false, default: 0
      t.integer :display_order, null: false, default: 0
      t.timestamps
    end

    add_index :fact_questions,
      %i[opinion_question_id display_order],
      unique: true,
      name: "index_fact_questions_on_opinion_and_order"
  end
end
