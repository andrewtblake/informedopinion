class CreateGlossaryEntries < ActiveRecord::Migration[8.1]
  def up
    create_table :glossary_entries do |t|
      t.string :term, null: false
      t.text :definition, null: false
      t.timestamps
    end
    add_index :glossary_entries, :term, unique: true

    # This dated import is immutable. Later edits belong in the database.
    definitions = JSON.parse(File.read(File.expand_path("../glossary/20261017_initial_entries.json", __dir__)))
    now = connection.quote(Time.current)
    definitions.each do |term, definition|
      execute <<~SQL
        INSERT INTO glossary_entries (term, definition, created_at, updated_at)
        VALUES (#{connection.quote(term)}, #{connection.quote(definition)}, #{now}, #{now})
      SQL
    end
  end

  def down
    drop_table :glossary_entries
  end
end
