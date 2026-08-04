class CreateOpinionHistories < ActiveRecord::Migration[8.1]
  def up
    create_table :opinion_histories do |t|
      t.references :user_opinion, null: false, foreign_key: true
      t.integer :event_type, null: false
      t.integer :from_position
      t.integer :to_position, null: false
      t.decimal :knowledge_weight, precision: 5, scale: 2
      t.decimal :raw_knowledge_weight, precision: 5, scale: 2
      t.integer :facts_answered
      t.integer :facts_correct
      t.integer :facts_available
      t.timestamps
    end

    add_index :opinion_histories, %i[user_opinion_id created_at]
    add_index :opinion_histories, :event_type
    add_check_constraint :opinion_histories,
      "from_position IS NULL OR from_position BETWEEN 0 AND 4",
      name: "opinion_histories_from_position_range"
    add_check_constraint :opinion_histories,
      "to_position BETWEEN 0 AND 4",
      name: "opinion_histories_to_position_range"

    # Existing opinions establish the point from which change can be measured.
    # Their earlier positions and knowledge state cannot be reconstructed.
    execute <<~SQL.squish
      INSERT INTO opinion_histories
        (user_opinion_id, event_type, from_position, to_position, created_at, updated_at)
      SELECT id, 0, NULL, position, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
      FROM user_opinions
    SQL
  end

  def down
    drop_table :opinion_histories
  end
end
