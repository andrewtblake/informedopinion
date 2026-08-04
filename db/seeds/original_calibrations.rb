module OriginalCalibration
  RATIONALES = {
    1 => "Supporting context or corroboration; useful, but not central enough to carry the opinion by itself.",
    2 => "Significant evidence about an important mechanism, consequence, or implementation trade-off.",
    3 => "Foundational evidence that directly bears on the proposition's central causal or policy judgement."
  }.freeze

  WEIGHTS = {
    climate: [ 3, 2, 1, 2, 2, 2, 1, 2, 3, 1, 3, 3, 3, 3, 2, 1, 2, 2, 3, 2, 1, 1, 1, 2, 2, 1, 2, 1, 3, 3 ],
    gun_control: [ 3, 3, 1, 2, 1, 1, 1, 1, 3, 3, 2, 3, 3, 3, 2, 2, 3, 3, 2, 2, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2 ],
    brexit: [ 1, 1, 1, 1, 3, 3, 3, 3, 2, 2, 2, 3, 3, 2, 2, 3, 3, 2, 1, 2, 2, 1, 1, 2, 2, 3, 2, 1, 2, 2 ],
    wealth_tax: [ 3, 1, 2, 3, 3, 1, 2, 1, 1, 2, 3, 3, 2, 2, 3, 3, 2, 1, 1, 1, 2, 2, 3, 2, 2, 2, 3, 2, 2, 2 ]
  }.freeze

  REPLACEMENTS = {
    climate: {
      16 => {
        prompt: "Can internal climate variability such as El Niño explain the sustained multi-decade warming trend by itself?",
        options: [ "No; it redistributes heat and affects short periods but does not supply the persistent added energy", "Yes; every El Niño permanently raises global temperature", "Yes; ocean cycles create atmospheric carbon dioxide from nothing", "No, because natural variability does not affect temperature" ],
        correct_option: 0,
        explanation: "Internal variability changes where heat is stored and can warm or cool particular years, but it does not create a persistent planetary energy imbalance. Attribution studies account for these cycles rather than assuming every year follows a smooth trend.",
        source_name: "IPCC AR6 Working Group I",
        source_url: "https://www.ipcc.ch/report/ar6/wg1/chapter/chapter-3/",
        evidence_direction: 1
      },
      17 => {
        prompt: "How does increased atmospheric water vapour principally affect carbon-dioxide-driven warming?",
        options: [ "It permanently cancels carbon dioxide", "It acts mainly as a feedback that amplifies an initial warming", "It is the external cause of rising fossil-fuel emissions", "It has no infrared interaction" ],
        correct_option: 1,
        explanation: "Warmer air can hold more water vapour, itself a greenhouse gas. Because atmospheric water vapour responds rapidly to temperature, it principally amplifies warming initiated by longer-lived forcing such as added carbon dioxide.",
        source_name: "NASA Global Climate Change",
        source_url: "https://science.nasa.gov/climate-change/faq/which-is-a-more-potent-greenhouse-gas-methane-or-carbon-dioxide/",
        evidence_direction: 1
      },
      18 => {
        prompt: "What happens when climate-attribution models include only measured natural drivers such as solar and volcanic changes?",
        options: [ "They reproduce all observed warming exactly", "They predict greater warming than observed", "They do not reproduce the sustained recent warming unless human influences are included", "They cannot calculate temperature at all" ],
        correct_option: 2,
        explanation: "Natural-only simulations reproduce some short-term variation but not the observed long-term warming. Simulations combining natural and human influences reproduce the broad observed evolution much more closely.",
        source_name: "IPCC AR6 Working Group I",
        source_url: "https://www.ipcc.ch/report/ar6/wg1/chapter/chapter-3/",
        evidence_direction: 1
      }
    },
    gun_control: {
      8 => {
        prompt: "What does RAND identify as a major obstacle to estimating the effect of universal background-check laws?",
        options: [ "States often adopt multiple firearm policies and differ in other ways at the same time", "Background checks leave no records", "Homicide is never measured", "Every state implemented the same law simultaneously" ],
        correct_option: 0,
        explanation: "Concurrent laws, pre-existing state differences, enforcement and limited outcome data make it difficult to isolate one policy's causal effect.",
        source_name: "RAND: The Science of Gun Policy",
        source_url: "https://www.rand.org/pubs/research_reports/RRA243-9.html",
        evidence_direction: 0
      },
      9 => {
        prompt: "Why can enactment of a universal background-check law fail to produce its intended effect?",
        options: [ "Federal dealers stop keeping records", "Compliance and enforcement may be low and alternative informal markets remain available", "The law automatically legalises prohibited possession", "NICS checks become unconstitutional" ],
        correct_option: 1,
        explanation: "A legal requirement changes outcomes only when transfers pass through the check process and violations are detected or deterred. Cross-border and informal acquisition can reduce its reach.",
        source_name: "RAND: The Science of Gun Policy",
        source_url: "https://www.rand.org/pubs/research_reports/RRA243-9.html",
        evidence_direction: -1
      },
      10 => {
        prompt: "How does RAND characterise evidence that universal background checks reduce mass shootings?",
        options: [ "Conclusive evidence of a large reduction", "Conclusive evidence of an increase", "Inconclusive", "No study has ever considered the question" ],
        correct_option: 2,
        explanation: "RAND found too few qualifying studies, with important methodological limitations, to determine the effect on mass shootings.",
        source_name: "RAND: The Science of Gun Policy",
        source_url: "https://www.rand.org/pubs/research_reports/RRA243-9.html",
        evidence_direction: -1
      },
      11 => {
        prompt: "What determines whether checking all private transfers prevents a prohibited buyer from obtaining a firearm?",
        options: [ "The buyer's political affiliation", "Whether the firearm is new", "The seller's distance from Washington", "Whether the transfer enters the system and the relevant prohibiting record is available" ],
        correct_option: 3,
        explanation: "Coverage alone is insufficient: compliance brings the transfer to a checker, and complete, accurate records allow the system to identify the prohibition.",
        source_name: "RAND: Using NICS Data for Policy Research",
        source_url: "https://www.rand.org/pubs/tools/TLA243-4.html",
        evidence_direction: 0
      }
    },
    wealth_tax: {
      13 => {
        prompt: "Approximately how many taxpayers did IFS-linked modelling estimate at a £10 million individual threshold?",
        options: [ "About 22 million", "About 22,000", "About 2.2 million", "About 220" ],
        correct_option: 1,
        explanation: "Published modelling estimated roughly 22,000 taxpayers at this high threshold, subject to data and valuation uncertainty.",
        source_name: "IFS Deaton Review: Measuring and taxing top wealth",
        source_url: "https://ifs.org.uk/inequality/wp-content/uploads/2022/04/Measuring-and-taxing-top-incomes-and-wealth-IFS-Deaton-Review-Inequality.pdf",
        evidence_direction: 1
      },
      14 => {
        prompt: "In the Institute for Fiscal Studies Deaton Review modelling of a UK wealth tax, what gross annual revenue was associated with a rate near 1% above £10 million before administration costs?",
        options: [ "About £100 million", "About £1 billion", "About £10 billion", "About £100 billion" ],
        correct_option: 2,
        explanation: "The modelling targeted approximately £10 billion of gross annual revenue with a rate close to the proposed rate, after an assumed low avoidance response but before administration costs.",
        source_name: "IFS Deaton Review: Measuring and taxing top wealth",
        source_url: "https://ifs.org.uk/inequality/wp-content/uploads/2022/04/Measuring-and-taxing-top-incomes-and-wealth-IFS-Deaton-Review-Inequality.pdf",
        evidence_direction: 1
      },
      15 => {
        prompt: "How much might a well-designed 1% annual wealth tax reduce its own taxable base through behavioural responses, in one IFS-reviewed synthesis?",
        options: [ "Exactly 0%", "More than 90% in every country", "Exactly 50%", "Roughly 7–17%" ],
        correct_option: 3,
        explanation: "The review reconciled widely varying studies and estimated a 7–17% reduction for a well-designed 1% tax; design, enforcement and context remain decisive.",
        source_name: "Institute for Fiscal Studies",
        source_url: "https://ifs.org.uk/journals/behavioural-responses-wealth-tax",
        evidence_direction: -1
      },
      16 => {
        prompt: "Why is a 1% annual tax more burdensome when an asset earns a 2% return than when it earns a 10% return?",
        options: [ "It consumes half rather than one-tenth of the pre-tax return", "The statutory wealth-tax rate changes", "Low returns make assets impossible to value", "High returns are exempt" ],
        correct_option: 0,
        explanation: "Relative to investment income, the effective burden is 1/2 of a 2% return but 1/10 of a 10% return before other taxes. This can favour riskier or higher-return assets.",
        source_name: "Institute for Fiscal Studies: The economics of a wealth tax",
        source_url: "https://ifs.org.uk/publications/economics-wealth-tax",
        evidence_direction: -1
      },
      28 => {
        prompt: "What does evidence on migration responses to taxes on highly affluent people generally show?",
        options: [ "Some response exists, but estimates vary and most affected people do not move", "Every taxpayer immediately emigrates", "Mobility is legally impossible", "Migration always increases revenue" ],
        correct_option: 0,
        explanation: "High-income and high-wealth groups can be more mobile than average, but estimated responses vary by tax, population and jurisdiction and are far below universal migration.",
        source_name: "Institute for Fiscal Studies",
        source_url: "https://ifs.org.uk/publications/taxing-high-income-earners-tax-avoidance-and-mobility",
        evidence_direction: -1
      },
      29 => {
        prompt: "Why must an annual wealth tax be compared with reforms to capital-gains, inheritance and property taxes?",
        options: [ "Those taxes are constitutionally identical", "Alternative reforms may address some of the same revenue and fairness goals with different distortions and administration", "A wealth tax automatically repeals them", "The UK has none of those taxes" ],
        correct_option: 1,
        explanation: "The relevant policy choice is not tax versus no tax. Existing taxes can sometimes be broadened or reformed, so comparative yield, avoidance, fairness and administrative cost matter.",
        source_name: "Institute for Fiscal Studies: The economics of a wealth tax",
        source_url: "https://ifs.org.uk/publications/economics-wealth-tax",
        evidence_direction: 0
      }
    }
  }.freeze

  module_function

  def apply(facts, key)
    REPLACEMENTS.fetch(key, {}).each { |index, replacement| facts.fetch(index).merge!(replacement) }
    weights = WEIGHTS.fetch(key)
    raise "#{key} calibration does not match fact bank" unless weights.length == facts.length

    facts.each_with_index do |fact, index|
      weight = weights.fetch(index)
      fact[:importance_weight] = weight
      fact[:importance_rationale] = RATIONALES.fetch(weight)
    end
  end
end

OriginalCalibration.apply(CLIMATE_FACTS, :climate)
OriginalCalibration.apply(GUN_CONTROL_FACTS, :gun_control)
OriginalCalibration.apply(BREXIT_FACTS, :brexit)
OriginalCalibration.apply(WEALTH_TAX_FACTS, :wealth_tax)
