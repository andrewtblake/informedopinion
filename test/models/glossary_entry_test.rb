require "test_helper"

class GlossaryEntryTest < ActiveSupport::TestCase
  test "normalizes editorial input without changing term case" do
    entry = GlossaryEntry.create!(term: "  TESTs  ", definition: "  A test definition  ")
    assert_equal "TESTs", entry.reload.term
    assert_equal "A test definition", entry.definition
    assert_not GlossaryEntry.new(term: "TESTs", definition: "Duplicate").valid?
  end

  test "rejects empty or ambiguous matching terms and missing definitions" do
    [ "", "A", "two words", "<abbr>", "TERM.*", "aLowercaseWord", "A" * 33 ].each do |term|
      assert_not GlossaryEntry.new(term: term, definition: "A definition").valid?, term
    end
    assert_not GlossaryEntry.new(term: "EXAMPLE", definition: " ").valid?
    assert_not GlossaryEntry.new(term: "EXAMPLE", definition: "x" * 501).valid?
    assert GlossaryEntry.new(term: "TEST-19", definition: "Hyphenated term").valid?
    assert GlossaryEntry.new(term: "ME/CFS", definition: "A slash-separated initialism").valid?
  end
end
