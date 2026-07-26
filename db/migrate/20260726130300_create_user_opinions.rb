class CreateUserOpinions < ActiveRecord::Migration[8.1]
  def change
    create_table :user_opinions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :opinion_question, null: false, foreign_key: true
      t.integer :position, null: false
      t.timestamps
    end

    add_index :user_opinions,
      %i[user_id opinion_question_id],
      unique: true
  end
end
