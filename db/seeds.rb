require_relative "seeds/climate"
require_relative "seeds/gun_control"
require_relative "seeds/brexit"
require_relative "seeds/wealth_tax"
require_relative "seeds/original_calibrations"
require_relative "seeds/flat_earth"
require_relative "seeds/flat_earth_calibrations"
require_relative "seeds/minimum_wage"
require_relative "seeds/voting_reform"
require_relative "seeds/nuclear_power"
require_relative "seeds/death_penalty"
require_relative "seeds/answer_length_calibrations"
require_relative "seeds/gaza"
require_relative "seeds/assisted_dying"
require_relative "seeds/echr_withdrawal"
require_relative "seeds/grey_belt_housing"

category_names = [
  "Economics",
  "Politics & government",
  "Science & environment",
  "Society & law"
]
categories = category_names.index_with do |name|
  Category.find_or_create_by!(slug: name.parameterize) { |category| category.name = name }
end

topics = [
  {
    slug: "climate-change",
    title: "Global warming",
    statement: "Human activities—especially burning fossil fuels and deforestation—have been the main cause of the rise in global average temperature since 1950.",
    response_options: [
      "Definitely true",
      "Probably true",
      "Unsure",
      "Probably false",
      "Definitely false"
    ],
    display_order: 1,
    accent: "teal",
    category: "Science & environment",
    tags: [ "Climate change", "Earth science", "Scientific evidence", "Global" ],
    facts: CLIMATE_FACTS
  },
  {
    slug: "us-gun-background-checks",
    title: "Gun control",
    statement: "The United States should require a background check before every firearm sale, including sales by private individuals.",
    response_options: [
      "Strongly agree",
      "Somewhat agree",
      "Neither agree nor disagree",
      "Somewhat disagree",
      "Strongly disagree"
    ],
    display_order: 2,
    accent: "amber",
    category: "Society & law",
    tags: [ "Firearms", "Public safety", "United States", "Criminal justice" ],
    facts: GUN_CONTROL_FACTS
  },
  {
    slug: "uk-eu-membership",
    title: "Brexit",
    statement: "The United Kingdom should be a member of the European Union.",
    response_options: [
      "Strongly agree",
      "Somewhat agree",
      "Neither agree nor disagree",
      "Somewhat disagree",
      "Strongly disagree"
    ],
    display_order: 3,
    accent: "violet",
    category: "Politics & government",
    tags: [ "European Union", "United Kingdom", "Trade", "Immigration" ],
    facts: BREXIT_FACTS
  },
  {
    slug: "uk-wealth-tax",
    title: "Wealth tax",
    statement: "The UK should impose an annual tax of 1% on each UK-resident individual's worldwide net wealth above £10 million, including property, pensions, financial assets and private-business interests, after deducting debts.",
    response_options: [
      "Strongly agree",
      "Somewhat agree",
      "Neither agree nor disagree",
      "Somewhat disagree",
      "Strongly disagree"
    ],
    display_order: 4,
    accent: "rose",
    category: "Economics",
    tags: [ "Taxation", "Wealth inequality", "United Kingdom", "Public finance" ],
    facts: WEALTH_TAX_FACTS
  },
  {
    slug: "flat-earth",
    title: "The Earth is flat",
    statement: "The Earth is flat.",
    response_options: [
      "Definitely true",
      "Probably true",
      "Unsure",
      "Probably false",
      "Definitely false"
    ],
    display_order: 5,
    accent: "slate",
    category: "Science & environment",
    tags: [ "Earth science", "Astronomy", "Scientific evidence", "Geodesy", "Global" ],
    facts: FLAT_EARTH_FACTS
  },
  {
    slug: "us-federal-minimum-wage",
    title: "Minimum wage",
    statement: "The standard US federal minimum wage for non-tipped adult workers should be increased to $15 per hour.",
    response_options: [ "Strongly agree", "Somewhat agree", "Neither agree nor disagree", "Somewhat disagree", "Strongly disagree" ],
    display_order: 6,
    accent: "amber",
    category: "Economics",
    tags: [ "Minimum wage", "Employment", "Income inequality", "United States" ],
    facts: MINIMUM_WAGE_FACTS
  },
  {
    slug: "uk-proportional-representation",
    title: "Voting reform",
    statement: "Elections to the UK House of Commons should use proportional representation instead of first past the post.",
    response_options: [ "Strongly agree", "Somewhat agree", "Neither agree nor disagree", "Somewhat disagree", "Strongly disagree" ],
    display_order: 7,
    accent: "violet",
    category: "Politics & government",
    tags: [ "Electoral reform", "Democracy", "Representation", "United Kingdom" ],
    facts: VOTING_REFORM_FACTS
  },
  {
    slug: "uk-new-nuclear-power",
    title: "Nuclear power",
    statement: "The UK should build new nuclear power stations to replace nuclear generating capacity as existing stations retire.",
    response_options: [ "Strongly agree", "Somewhat agree", "Neither agree nor disagree", "Somewhat disagree", "Strongly disagree" ],
    display_order: 8,
    accent: "teal",
    category: "Science & environment",
    tags: [ "Nuclear energy", "Energy security", "Climate change", "United Kingdom" ],
    facts: NUCLEAR_POWER_FACTS
  },
  {
    slug: "us-death-penalty",
    title: "Death penalty",
    statement: "The death penalty should be abolished for all federal and state crimes in the United States.",
    response_options: [ "Strongly agree", "Somewhat agree", "Neither agree nor disagree", "Somewhat disagree", "Strongly disagree" ],
    display_order: 9,
    accent: "rose",
    category: "Society & law",
    tags: [ "Capital punishment", "Criminal justice", "Civil rights", "United States" ],
    facts: DEATH_PENALTY_FACTS
  },
  {
    slug: "gaza-war",
    title: "Gaza war",
    statement: "The military and security gains achieved by Israel's campaign in Gaza from 7 October 2023 to the ceasefire beginning 10 October 2025 justified the resulting harm to Palestinian civilians.",
    response_options: [ "Strongly agree", "Somewhat agree", "Neither agree nor disagree", "Somewhat disagree", "Strongly disagree" ],
    display_order: 10,
    accent: "slate",
    category: "Politics & government",
    tags: [ "Gaza", "Israel and Palestine", "Middle East", "Armed conflict", "International humanitarian law" ],
    facts: GAZA_FACTS
  },
  {
    slug: "assisted-dying",
    title: "Assisted dying",
    statement: "Adults in England and Wales who have mental capacity and are reasonably expected to die within six months should be legally permitted to obtain medical assistance to end their lives, subject to approval by two independent doctors and an independent review panel.",
    response_options: [ "Strongly agree", "Somewhat agree", "Neither agree nor disagree", "Somewhat disagree", "Strongly disagree" ],
    display_order: 11,
    accent: "rose",
    category: "Society & law",
    tags: [ "Assisted dying", "End-of-life care", "Medical ethics", "Healthcare", "England and Wales" ],
    facts: ASSISTED_DYING_FACTS
  },
  {
    slug: "echr-withdrawal",
    title: "European human-rights convention",
    statement: "The United Kingdom should withdraw from the European Convention on Human Rights.",
    response_options: [ "Strongly agree", "Somewhat agree", "Neither agree nor disagree", "Somewhat disagree", "Strongly disagree" ],
    display_order: 12,
    accent: "violet",
    category: "Politics & government",
    tags: [ "ECHR", "Human rights", "Immigration", "Constitutional law", "United Kingdom", "Europe" ],
    facts: ECHR_WITHDRAWAL_FACTS
  },
  {
    slug: "grey-belt-housing",
    title: "Grey Belt housing",
    statement: "When an English local authority cannot otherwise meet its assessed housing need, national planning policy should require it to permit housing development on suitable 'grey belt' land, with at least 50% of the homes designated as affordable housing.",
    response_options: [ "Strongly agree", "Somewhat agree", "Neither agree nor disagree", "Somewhat disagree", "Strongly disagree" ],
    display_order: 13,
    accent: "amber",
    category: "Economics",
    tags: [ "Housing", "Planning", "Green Belt", "Affordable housing", "Land use", "England" ],
    facts: GREY_BELT_HOUSING_FACTS
  }
]

topics.each do |attributes|
  facts = attributes.delete(:facts)
  tag_names = attributes.delete(:tags)
  attributes[:category] = categories.fetch(attributes[:category])
  topic = OpinionQuestion.find_or_initialize_by(slug: attributes[:slug])
  topic.update!(attributes)
  topic.tags = tag_names.map do |name|
    Tag.find_or_create_by!(slug: name.parameterize) { |tag| tag.name = name }
  end

  facts.each_with_index do |fact, index|
    question = topic.fact_questions.find_or_initialize_by(display_order: index + 1)
    previous_assessment = [ question.prompt, question.options, question.correct_option ]
    new_assessment = [ fact[:prompt], fact[:options], fact[:correct_option] ]
    question.fact_responses.delete_all if question.persisted? && previous_assessment != new_assessment
    question.update!({
      importance_weight: 1,
      importance_rationale: "This question currently has the standard importance weight; unequal weights will only be assigned after review."
    }.merge(fact))
  end

  topic.fact_questions.where.not(display_order: 1..facts.length).destroy_all
end

puts "Seeded #{OpinionQuestion.count} opinion questions and #{FactQuestion.count} fact questions."
