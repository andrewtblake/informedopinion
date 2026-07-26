class CreateOpinionQuestions < ActiveRecord::Migration[8.1]
  def change
    create_table :opinion_questions do |t|
      t.string :slug, null: false
      t.string :title, null: false
      t.text :statement, null: false
      t.json :response_options, null: false
      t.integer :display_order, null: false, default: 0
      t.string :accent, null: false, default: "teal"
      t.timestamps
    end

    add_index :opinion_questions, :slug, unique: true
    add_index :opinion_questions, :display_order, unique: true
  end
end
