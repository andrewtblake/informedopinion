require "test_helper"
require Rails.root.join("db/migrate/20261017140000_create_glossary_entries")

class GlossaryMigrationDatabase < ActiveRecord::Base
  self.abstract_class = true
end

class CreateGlossaryEntriesTest < ActiveSupport::TestCase
  setup do
    GlossaryMigrationDatabase.establish_connection(adapter: "sqlite3", database: ":memory:")
    @connection = GlossaryMigrationDatabase.connection
    @migration = CreateGlossaryEntries.new
    connection = @connection
    @migration.define_singleton_method(:connection) { connection }
  end

  teardown do
    GlossaryMigrationDatabase.remove_connection
  end

  test "imports every definition and enforces unique spellings" do
    @migration.suppress_messages { @migration.up }
    expected = JSON.parse(Rails.root.join("db/glossary/20261017_initial_entries.json").read)
    actual = @connection.select_all("SELECT term, definition FROM glossary_entries").to_h do |row|
      [ row.fetch("term"), row.fetch("definition") ]
    end
    assert_equal expected, actual
    assert_equal 81, actual.size
    assert_raises(ActiveRecord::RecordNotUnique) do
      @connection.execute("INSERT INTO glossary_entries (term, definition, created_at, updated_at) SELECT term, definition, created_at, updated_at FROM glossary_entries WHERE term = 'UNRWA'")
    end
    @migration.suppress_messages { @migration.down }
    assert_not @connection.table_exists?(:glossary_entries)
  end
end
