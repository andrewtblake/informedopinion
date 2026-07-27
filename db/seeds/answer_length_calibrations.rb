module AnswerLengthCalibration
  REPLACEMENTS = {
    death_penalty: {
      0 => "Federal and some state governments",
      1 => "Invalidated existing schemes",
      2 => "They can be constitutional",
      5 => "No, under Atkins",
      6 => "A statutory aggravator",
      7 => "Evidence favouring a lesser sentence",
      8 => "They could not establish a causal effect",
      10 => "No—confounding factors remain",
      15 => "No; validation strength varies",
      16 => "Higher rates in white-victim cases",
      17 => "No—not every individual motive",
      21 => "No; imprisonment remains"
    },
    flat_earth: {
      0 => "In opposite senses around the two celestial poles",
      1 => "About one degree per degree travelled north",
      3 => "The same southern celestial pole",
      4 => "About 15° per hour",
      6 => "It remains about half a degree across",
      7 => "It crosses the horizon without shrinking away",
      8 => "It does not restore the Sun",
      9 => "The hull disappears first; added height restores it"
    },
    gun_control: {
      1 => "No federal check is generally required",
      3 => "Whether records show the buyer is prohibited",
      5 => "Allow a transfer at the dealer's discretion",
      7 => "Name and date of birth",
      8 => "Concurrent policies and differences between states",
      9 => "Limited compliance, enforcement and market coverage",
      11 => "Coverage and available records",
      16 => "Underground markets, family and friends"
    },
    minimum_wage: {
      2 => "The higher rate",
      5 => "Non-hourly workers",
      7 => "No; Congress must change it",
      11 => "Possible job losses, with uncertain size",
      12 => "Higher income for some workers",
      13 => "Hourly pay is not family income",
      18 => "Local wages and living costs"
    },
    nuclear_power: {
      3 => "Capacity available on demand",
      5 => "No, not as flexibly",
      6 => "Isolating spent fuel",
      7 => "No—not yet",
      8 => "The ONR",
      9 => "No",
      11 => "Station blackout",
      12 => "Delays and cost overruns",
      13 => "A guaranteed strike price",
      14 => "Pre-revenue financing costs"
    },
    voting_reform: {
      0 => "The constituency candidate with the most votes",
      1 => "Proportional vote-to-seat results",
      2 => "No—about 34%",
      3 => "A predictably retained seat",
      4 => "Backing a viable alternative",
      5 => "No—there are several designs",
      7 => "STV",
      9 => "A representation threshold",
      10 => "It makes representation more likely",
      11 => "Yes, if support is concentrated",
      12 => "An excess district seat",
      13 => "Two votes",
      14 => "No; some proportional systems retain them",
      15 => "It makes coalition bargaining more common",
      16 => "No overall Commons majority"
    },
    wealth_tax: {
      0 => "Assets minus eligible debts",
      1 => "No comprehensive annual tax",
      2 => "One recurs; the other is assessed once",
      4 => "Debts change net positions",
      5 => "Each person has a separate threshold"
    }
  }.freeze

  module_function

  def apply(facts, bank)
    REPLACEMENTS.fetch(bank).each do |index, replacement|
      fact = facts.fetch(index)
      fact[:options][fact.fetch(:correct_option)] = replacement
    end
  end
end

AnswerLengthCalibration.apply(DEATH_PENALTY_FACTS, :death_penalty)
AnswerLengthCalibration.apply(FLAT_EARTH_FACTS, :flat_earth)
AnswerLengthCalibration.apply(GUN_CONTROL_FACTS, :gun_control)
AnswerLengthCalibration.apply(MINIMUM_WAGE_FACTS, :minimum_wage)
AnswerLengthCalibration.apply(NUCLEAR_POWER_FACTS, :nuclear_power)
AnswerLengthCalibration.apply(VOTING_REFORM_FACTS, :voting_reform)
AnswerLengthCalibration.apply(WEALTH_TAX_FACTS, :wealth_tax)
