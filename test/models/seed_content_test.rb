require "test_helper"
require Rails.root.join("db/seeds/climate")
require Rails.root.join("db/seeds/gun_control")
require Rails.root.join("db/seeds/brexit")
require Rails.root.join("db/seeds/wealth_tax")
require Rails.root.join("db/seeds/original_calibrations")
require Rails.root.join("db/seeds/flat_earth")
require Rails.root.join("db/seeds/flat_earth_calibrations")
require Rails.root.join("db/seeds/minimum_wage")
require Rails.root.join("db/seeds/voting_reform")
require Rails.root.join("db/seeds/nuclear_power")
require Rails.root.join("db/seeds/death_penalty")
require Rails.root.join("db/seeds/answer_length_calibrations")
require Rails.root.join("db/seeds/gaza")
require Rails.root.join("db/seeds/assisted_dying")
require Rails.root.join("db/seeds/echr_withdrawal")
require Rails.root.join("db/seeds/grey_belt_housing")

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
    death_penalty: DEATH_PENALTY_FACTS,
    gaza: GAZA_FACTS,
    assisted_dying: ASSISTED_DYING_FACTS,
    echr_withdrawal: ECHR_WITHDRAWAL_FACTS,
    grey_belt_housing: GREY_BELT_HOUSING_FACTS
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

  test "answer length is not a successful guessing strategy" do
    TOPICS.each do |topic, facts|
      uniquely_longest_correct = facts.count do |fact|
        lengths = fact[:options].map { _1.strip.length }
        correct_length = lengths.fetch(fact[:correct_option])

        correct_length == lengths.max && lengths.count(correct_length) == 1
      end
      weighted_total = facts.sum { _1[:importance_weight] || 1 }
      weighted_longest_correct = facts.sum do |fact|
        lengths = fact[:options].map { _1.strip.length }
        correct_length = lengths.fetch(fact[:correct_option])

        if correct_length == lengths.max && lengths.count(correct_length) == 1
          fact[:importance_weight] || 1
        else
          0
        end
      end

      assert_operator uniquely_longest_correct.fdiv(facts.length), :<=, 0.4,
        "#{topic} should not reward choosing the uniquely longest answer"
      assert_operator weighted_longest_correct.fdiv(weighted_total), :<=, 0.4,
        "#{topic} should not reward choosing the weighted uniquely longest answer"
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

  test "flat Earth bank publishes calibrated importance and a coherent synthesis answer" do
    assert_equal [ 1, 2, 3 ], FLAT_EARTH_FACTS.map { _1[:importance_weight] }.uniq.sort
    assert_equal 9, FLAT_EARTH_FACTS.count { _1[:importance_weight] == 3 }
    assert_operator FLAT_EARTH_FACTS.count { _1[:importance_weight] == 1 }, :>=, 7
    assert_equal(
      "A rotating globe fits them coherently",
      FLAT_EARTH_FACTS.fetch(28).fetch(:options).fetch(FLAT_EARTH_FACTS.fetch(28).fetch(:correct_option))
    )
  end

  test "new policy banks publish reviewed importance assessments" do
    banks = [
      MINIMUM_WAGE_FACTS, VOTING_REFORM_FACTS, NUCLEAR_POWER_FACTS,
      DEATH_PENALTY_FACTS, GAZA_FACTS, ASSISTED_DYING_FACTS,
      ECHR_WITHDRAWAL_FACTS, GREY_BELT_HOUSING_FACTS
    ]
    facts = banks.flatten

    assert facts.all? { |fact| FactQuestion::IMPORTANCE_LEVELS.key?(fact[:importance_weight]) }
    assert facts.all? { |fact| fact[:importance_rationale].present? }
    assert facts.any? { |fact| fact[:importance_weight] == 3 }
    assert_includes 6..9, GAZA_FACTS.count { _1[:importance_weight] == 3 }
    assert_operator GAZA_FACTS.count { _1[:importance_weight] == 1 }, :>=, 7
    [ ASSISTED_DYING_FACTS, ECHR_WITHDRAWAL_FACTS, GREY_BELT_HOUSING_FACTS ].each do |bank|
      assert_includes 6..9, bank.count { _1[:importance_weight] == 3 }
      assert_operator bank.count { _1[:importance_weight] == 1 }, :>=, 7
    end
  end

  test "Gaza bank distinguishes evidence directions and procedural claims" do
    assert_equal [ -1, 0, 1 ], GAZA_FACTS.map { _1[:evidence_direction] }.uniq.sort
    assert GAZA_FACTS.any? { _1[:prompt].include?("provisional-measures") }
    assert GAZA_FACTS.any? { _1[:prompt].include?("fatality total") }
    assert GAZA_FACTS.any? { _1[:prompt].include?("principal Gaza war objectives") }
  end

  test "original policy banks publish reviewed importance assessments" do
    banks = [ CLIMATE_FACTS, GUN_CONTROL_FACTS, BREXIT_FACTS, WEALTH_TAX_FACTS ]
    facts = banks.flatten

    assert facts.all? { |fact| FactQuestion::IMPORTANCE_LEVELS.key?(fact[:importance_weight]) }
    assert facts.all? { |fact| fact[:importance_rationale].present? }
    assert facts.map { _1[:importance_weight] }.uniq.sort == [ 1, 2, 3 ]
    banks.each do |bank|
      assert_includes 6..9, bank.count { _1[:importance_weight] == 3 }
      assert_operator bank.count { _1[:importance_weight] == 1 }, :>=, 7
    end
  end
end
