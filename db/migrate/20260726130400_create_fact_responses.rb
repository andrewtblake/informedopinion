class CreateFactResponses < ActiveRecord::Migration[8.1]
  def change
    create_table :fact_responses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :fact_question, null: false, foreign_key: true
      t.integer :selected_option, null: false
      t.boolean :correct, null: false
      t.decimal :weight_before, precision: 5, scale: 2, null: false
      t.decimal :weight_after, precision: 5, scale: 2, null: false
      t.datetime :answered_at, null: false
      t.timestamps
    end

    add_index :fact_responses,
      %i[user_id fact_question_id],
      unique: true
  end
end
