require "test_helper"
require Rails.root.join("db/seeds/climate")
require Rails.root.join("db/seeds/gun_control")
require Rails.root.join("db/seeds/brexit")
require Rails.root.join("db/seeds/wealth_tax")
require Rails.root.join("db/seeds/flat_earth")
require Rails.root.join("db/seeds/minimum_wage")
require Rails.root.join("db/seeds/voting_reform")
require Rails.root.join("db/seeds/nuclear_power")
require Rails.root.join("db/seeds/death_penalty")

class SeedContentTest < ActiveSupport::TestCase
  TOPICS = {
    climate: CLIMATE_FACTS,
    gun_control: GUN_CONTROL_FACTS,
    brexit: BREXIT_FACTS,
    wealth_tax: WEALTH_TAX_FACTS,
    flat_earth: FLAT_EARTH_FACTS,
    minimum_wage: MINIMUM_WAGE_FACTS,
    voting_reform: VOTING_REFORM_FACTS,
    nuclear_power: NUCLEAR_POWER_FACTS,
    death_penalty: DEATH_PENALTY_FACTS
  }.freeze

  test "every topic contains thirty four-choice fact questions" do
    TOPICS.each do |topic, facts|
      assert_equal 30, facts.length, "#{topic} should contain 30 questions"
      assert facts.all? { |fact| fact[:options].length == 4 },
        "#{topic} should use exactly four choices per question"
    end
  end

  test "correct answers are evenly distributed across A through D" do
    TOPICS.each do |topic, facts|
      counts = facts.group_by { |fact| fact[:correct_option] }.transform_values(&:count)

      assert_equal [ 0, 1, 2, 3 ], counts.keys.sort
      assert_operator counts.values.max - counts.values.min, :<=, 1,
        "#{topic} answer positions should be balanced"
    end
  end

  test "every choice within a question is unique" do
    TOPICS.each do |topic, facts|
      assert facts.all? { |fact| fact[:options].uniq.length == 4 },
        "#{topic} questions should not repeat a choice"
    end
  end

  test "every fact provides a named HTTPS evidence link" do
    TOPICS.each do |topic, facts|
      assert facts.all? { |fact| fact[:source_name].present? && fact[:source_url].start_with?("https://") },
        "#{topic} questions should link to named source material"
    end
  end

  test "flat Earth explanations examine a competing prediction" do
    comparison_terms = /predict|flat|plane|disk|claim|model|perspective/i

    assert FLAT_EARTH_FACTS.all? { |fact| fact[:explanation].match?(comparison_terms) }
    assert FLAT_EARTH_FACTS.all? { |fact| fact[:explanation].length >= 300 }
  end

  test "new policy banks publish reviewed importance assessments" do
    facts = MINIMUM_WAGE_FACTS + VOTING_REFORM_FACTS + NUCLEAR_POWER_FACTS + DEATH_PENALTY_FACTS

    assert facts.all? { |fact| FactQuestion::IMPORTANCE_LEVELS.key?(fact[:importance_weight]) }
    assert facts.all? { |fact| fact[:importance_rationale].present? }
    assert facts.any? { |fact| fact[:importance_weight] == 3 }
  end
end
