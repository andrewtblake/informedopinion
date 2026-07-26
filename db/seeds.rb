require_relative "seeds/climate"
require_relative "seeds/gun_control"
require_relative "seeds/brexit"

topics = [
  {
    slug: "climate-change",
    title: "Climate change",
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
    facts: CLIMATE_FACTS
  },
  {
    slug: "us-gun-background-checks",
    title: "U.S. gun background checks",
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
    facts: GUN_CONTROL_FACTS
  },
  {
    slug: "uk-eu-membership",
    title: "The UK and the European Union",
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
    facts: BREXIT_FACTS
  }
]

topics.each do |attributes|
  facts = attributes.delete(:facts)
  topic = OpinionQuestion.find_or_initialize_by(slug: attributes[:slug])
  topic.update!(attributes)

  facts.each_with_index do |fact, index|
    question = topic.fact_questions.find_or_initialize_by(display_order: index + 1)
    previous_assessment = [ question.prompt, question.options, question.correct_option ]
    new_assessment = [ fact[:prompt], fact[:options], fact[:correct_option] ]
    question.fact_responses.delete_all if question.persisted? && previous_assessment != new_assessment
    question.update!(fact)
  end

  topic.fact_questions.where.not(display_order: 1..facts.length).destroy_all
end

puts "Seeded #{OpinionQuestion.count} opinion questions and #{FactQuestion.count} fact questions."
