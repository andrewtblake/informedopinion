class CreateModerationItemViews < ActiveRecord::Migration[8.1]
  def change
    create_table :moderation_item_views do |t|
      t.references :moderator, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.string :item_key, null: false
      t.datetime :seen_version_at, null: false
      t.datetime :displayed_at, null: false
      t.timestamps
    end

    add_index :moderation_item_views, %i[moderator_id item_key], unique: true
  end
end
