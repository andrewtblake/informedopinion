class CreateSocialCards < ActiveRecord::Migration[8.1]
  def change
    create_table :social_cards do |t|
      t.references :opinion_question, null: false, foreign_key: true
      t.string :site_key, null: false
      t.string :content_fingerprint, null: false
      t.integer :template_version, null: false
      t.string :content_type, null: false, default: "image/png"
      t.binary :image_data, null: false
      t.integer :byte_size, null: false
      t.datetime :generated_at, null: false
      t.timestamps

      t.index %i[opinion_question_id site_key], unique: true
      t.index :content_fingerprint
    end
  end
end
