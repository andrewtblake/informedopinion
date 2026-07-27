class AddTopicTaxonomy < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
    add_index :categories, :name, unique: true
    add_index :categories, :slug, unique: true

    create_table :tags do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.timestamps
    end
    add_index :tags, :name, unique: true
    add_index :tags, :slug, unique: true

    create_table :opinion_question_tags do |t|
      t.references :opinion_question, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
      t.timestamps
    end
    add_index :opinion_question_tags, %i[opinion_question_id tag_id],
      unique: true, name: "index_opinion_question_tags_uniquely"

    add_reference :opinion_questions, :category, foreign_key: true
  end
end
