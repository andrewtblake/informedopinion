class CreateModeratorApiInfrastructure < ActiveRecord::Migration[8.1]
  def change
    create_table :moderator_api_tokens do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :token_digest, null: false
      t.string :token_prefix, null: false
      t.datetime :last_used_at
      t.datetime :revoked_at
      t.timestamps
    end
    add_index :moderator_api_tokens, :token_digest, unique: true

    create_table :api_audit_events do |t|
      t.references :actor, null: true, foreign_key: { to_table: :users, on_delete: :nullify }
      t.references :moderator_api_token, null: true, foreign_key: { on_delete: :nullify }
      t.string :action, null: false
      t.string :resource_type, null: false
      t.bigint :resource_id
      t.string :request_id
      t.json :change_data, null: false, default: {}
      t.timestamps
    end
    add_index :api_audit_events, %i[resource_type resource_id]
    add_index :api_audit_events, :created_at
  end
end
