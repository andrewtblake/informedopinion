class AddModerationFeatures < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :role, :integer, default: 0, null: false
    add_index :users, :role

    create_table :fact_question_flags do |t|
      t.references :user, null: false, foreign_key: true
      t.references :fact_question, null: false, foreign_key: true
      t.integer :category, null: false
      t.text :details
      t.integer :status, default: 0, null: false
      t.references :reviewer, foreign_key: { to_table: :users }
      t.text :resolution_notes
      t.datetime :reviewed_at
      t.timestamps
    end
    add_index :fact_question_flags,
      [ :user_id, :fact_question_id, :category ],
      unique: true,
      name: "index_fact_flags_on_user_question_category"
    add_index :fact_question_flags, :status

    create_table :opinion_question_reactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :opinion_question, null: false, foreign_key: true
      t.integer :kind, null: false
      t.text :reason
      t.timestamps
    end
    add_index :opinion_question_reactions,
      [ :user_id, :opinion_question_id ],
      unique: true,
      name: "index_opinion_reactions_on_user_and_question"

    create_table :opinion_question_proposals do |t|
      t.references :proposer, null: false, foreign_key: { to_table: :users }
      t.references :category, null: false, foreign_key: true
      t.string :title, null: false
      t.text :statement, null: false
      t.text :tags_text, null: false
      t.string :geographic_scope
      t.text :rationale, null: false
      t.integer :status, default: 0, null: false
      t.references :reviewer, foreign_key: { to_table: :users }
      t.text :review_notes
      t.datetime :reviewed_at
      t.timestamps
    end
    add_index :opinion_question_proposals, :status
  end
end
