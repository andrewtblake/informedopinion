require_relative "fact_bank"

GREY_BELT_SOURCES = {
  nppf: [ "UK Government: National Planning Policy Framework — Green Belt", "https://www.gov.uk/guidance/national-planning-policy-framework/13-protecting-green-belt-land" ],
  green_belt: [ "House of Commons Library: Green Belt", "https://commonslibrary.parliament.uk/research-briefings/sn00934/" ],
  statistics: [ "UK Government: Green Belt statistics 2024–25", "https://www.gov.uk/government/statistics/local-planning-authority-green-belt-statistics-for-england-2024-to-2025" ],
  supply: [ "UK Government: housing supply, England, 2024–25", "https://www.gov.uk/government/statistics/housing-supply-net-additional-dwellings-england-2024-to-2025/housing-supply-net-additional-dwellings-england-2024-to-2025" ],
  affordability: [ "Office for National Statistics: housing purchase affordability, 2024", "https://www.ons.gov.uk/peoplepopulationandcommunity/housing/bulletins/housingpurchaseaffordabilitygreatbritain/2024" ],
  viability: [ "UK Government: planning practice guidance — viability", "https://www.gov.uk/guidance/viability" ],
  section_106: [ "UK Government: roadmap for section 106 delivery", "https://www.gov.uk/government/publications/policy-statement-a-roadmap-for-section-106-delivery-in-england/policy-statement-a-roadmap-for-section-106-delivery-in-england" ]
}.freeze

GREY_BELT_HOUSING_FACTS = FactBank.build([
  [ "What is England's Green Belt?", [ "A planning-policy designation", "A register of nature reserves", "A public-ownership boundary", "A measure of soil fertility" ], 0,
    "Green Belt is a land-use planning designation. It does not by itself describe ownership, public access or ecological quality.", :green_belt, 0, 3, "The policy cannot be assessed without understanding what Green Belt status means." ],
  [ "What is the Green Belt's central planning purpose?", [ "Maximising agricultural exports", "Checking unrestricted urban sprawl", "Protecting every wildlife habitat", "Preventing all rural construction" ], 1,
    "The framework says the fundamental aim is to prevent urban sprawl by keeping land permanently open.", :nppf, 0, 3, "The proposal directly trades housing delivery against the designation's central purpose." ],
  [ "Which is one of the five stated Green Belt purposes?", [ "Guaranteeing public access", "Subsidising food production", "Preventing neighbouring towns from merging", "Preserving every existing view" ], 2,
    "Separating neighbouring towns is an express purpose; biodiversity, access and farming may matter but are not themselves among the five purposes.", :nppf, 0, 2, "The distinction is significant when judging whether a site contributes strongly to Green Belt purposes." ],
  [ "Must all Green Belt land be green, rural-looking or environmentally valuable?", [ "Yes, by statutory definition", "Only near London", "Only if publicly owned", "No" ], 3,
    "The designation can include developed or visually unremarkable land; its planning function is primarily spatial.", :green_belt, 1, 3, "This is foundational to the case for identifying a grey-belt subset." ],
  [ "Roughly what share of England was designated Green Belt in 2024–25?", [ "About 13%", "About 2%", "About 35%", "More than half" ], 0,
    "Official statistics put Green Belt at roughly one eighth of England's land area.", :statistics, 0, 1, "Scale is useful context but does not reveal how much land is suitable for homes." ],
  [ "What does current national policy mean by 'grey belt'?", [ "Only disused factories outside towns", "Previously developed or other Green Belt land making a limited contribution to specified purposes", "Every field beside a railway", "All land without protected species" ], 1,
    "Grey belt covers previously developed Green Belt land and other land that does not strongly contribute to specified Green Belt purposes, subject to exclusions.", :nppf, 1, 3, "The definition identifies the land to which the proposition would apply." ],
  [ "Does being labelled grey belt make a site automatically suitable for housing?", [ "Yes, without further assessment", "Yes, if a developer owns it", "No", "Only housing density remains relevant" ], 2,
    "Policy still tests sustainability, need, the effect on the remaining Green Belt, protected assets and other planning considerations.", :nppf, -1, 3, "Suitability safeguards are foundational to the proposition as worded." ],
  [ "Which land is excluded from the grey-belt definition?", [ "All land used for grazing", "Every site without buildings", "Land within ten miles of a city", "Specified protected areas and assets" ], 3,
    "The definition excludes land covered by listed protections such as habitats sites, Sites of Special Scientific Interest, National Parks and irreplaceable habitats.", :nppf, -1, 2, "Protected-land exclusions significantly limit environmental risk." ],
  [ "What must grey-belt development avoid doing to the Green Belt as a whole?", [ "Fundamentally undermining the purposes of the remaining Green Belt across the plan area", "Changing any field boundary", "Increasing a parish's population", "Using land previously in agriculture" ], 0,
    "The framework requires assessment of whether development would fundamentally undermine the purposes of the remaining Green Belt.", :nppf, -1, 3, "This is a foundational strategic safeguard against cumulative erosion." ],
  [ "Under current 'golden rules', what is required alongside major Green Belt housing?", [ "Freehold purchase for every tenant", "Affordable housing, infrastructure and accessible green space", "A ban on all private cars", "A referendum of the whole county" ], 1,
    "The golden rules cover affordable housing, necessary infrastructure and new or improved accessible green space.", :nppf, -1, 3, "The package of public benefits is central to whether release is advisable." ],
  [ "Does current national policy always require exactly 50% affordable housing on these sites?", [ "Yes, in every authority", "No affordable homes are required", "No", "Only rented homes count" ], 2,
    "Current policy generally seeks 15 percentage points above the existing local requirement, capped at 50%; the resulting percentage can therefore be below 50.", :nppf, 1, 3, "The proposed fixed minimum is materially stronger than current policy in many areas." ],
  [ "What does 'affordable housing' mean in planning policy?", [ "Any home cheaper than the local average", "Only council housing at social rent", "Any home below £500,000", "Defined tenures for eligible households whose needs are not met by the market" ], 3,
    "It is a technical umbrella covering defined rented and ownership products, not a promise that every household will regard the price as affordable.", :nppf, 0, 3, "The meaning of the proposition's central benefit is foundational." ],
  [ "Is an affordable home necessarily sold for half the open-market price?", [ "No", "Yes, by definition", "Only in the Green Belt", "Only after ten years" ], 0,
    "Different affordable tenures use different rent, discount and eligibility rules; '50% affordable homes' describes their share, not a universal 50% price discount.", :nppf, 0, 2, "This prevents a consequential misunderstanding of the proposed quota." ],
  [ "What is a section 106 agreement commonly used for?", [ "Setting Bank Rate", "Securing site-specific planning obligations", "Designating parliamentary seats", "Registering medical practices" ], 1,
    "A section 106 agreement can secure affordable housing, infrastructure contributions and other obligations connected with permission.", :section_106, 0, 2, "Delivery mechanisms matter because a headline quota must survive into completed homes." ],
  [ "Why does development viability matter to an affordable-housing requirement?", [ "It determines national interest rates", "It measures architectural beauty alone", "Costs and obligations can affect whether a scheme is deliverable and land retains an incentive to come forward", "It guarantees developer profit" ], 2,
    "Viability assessment compares development value with costs and an appropriate land benchmark; requirements can change delivery incentives.", :viability, 1, 3, "The central risk of a fixed 50% minimum is that some otherwise suitable schemes may not proceed." ],
  [ "Under the Green Belt golden rules, may a developer routinely use a later viability review to reduce the agreed affordable share?", [ "Yes, whenever sales slow", "Yes, after buying expensive land", "Only if neighbours agree", "No" ], 3,
    "National policy says viability assessment should not be used to justify reducing contributions, including affordable housing, required by the golden rules.", :nppf, -1, 2, "This materially strengthens delivery certainty but also shifts viability risk before permission." ],
  [ "How many net additional dwellings were recorded in England in 2024–25?", [ "About 209,000", "About 21,000", "About 900,000", "More than two million" ], 0,
    "Official statistics recorded 208,600 net additions in 2024–25.", :supply, 0, 1, "The annual flow supplies useful scale but does not identify the correct target." ],
  [ "Compared with 2023–24, England's 2024–25 net additions were:", [ "Twice as high", "About 6% lower", "Exactly unchanged", "Down by more than half" ], 1,
    "The recorded total fell by about 6% from the preceding year.", :supply, 1, 1, "The direction of recent supply is relevant context but a single year's change is not decisive." ],
  [ "What supplied most net additional dwellings in 2024–25?", [ "Office conversions alone", "Subdivision of existing homes", "New-build homes", "Caravans and houseboats" ], 2,
    "New-build homes accounted for about 91% of net additions.", :supply, 0, 1, "Composition is contextual rather than a direct argument for where new building should occur." ],
  [ "What was England's median house-price-to-workplace-earnings ratio in 2024?", [ "About 2.1", "About 4.0", "About 15.5", "About 7.9" ], 3,
    "The ONS estimated that a median-priced home cost about 7.9 times median annual earnings in England.", :affordability, 1, 3, "The scale of purchase unaffordability is foundational to the case for additional supply and affordable homes." ],
  [ "Does granting planning permission guarantee that homes will be completed?", [ "No", "Yes, within one year", "Only Green Belt permissions do", "Only councils can delay completion" ], 0,
    "Permission is necessary for most development but construction also depends on ownership, finance, market absorption, conditions and infrastructure.", :supply, 0, 2, "The distinction is significant when predicting the proposal's actual housing yield." ],
  [ "Why does a site's transport access matter?", [ "It changes the legal definition of a dwelling", "It affects residents' access to work and services and likely travel patterns", "It determines mortgage interest", "It removes every infrastructure cost" ], 1,
    "Planning policy seeks sustainable locations; poorly connected development can increase car dependence and infrastructure demands.", :nppf, -1, 2, "Location quality significantly affects the wider costs and benefits of release." ],
  [ "Can agricultural land also be Green Belt?", [ "No, the designations conflict", "Only if unused", "Yes", "Only where the state owns it" ], 2,
    "Most Green Belt is undeveloped and much is agricultural; planning designation and existing use answer different questions.", :green_belt, 0, 1, "This is helpful descriptive context but does not settle suitability." ],
  [ "Is most Green Belt land covered by buildings?", [ "Yes, nearly all of it", "Exactly half is residential", "Official data do not distinguish land cover", "No" ], 3,
    "Land-cover estimates show the great majority is undeveloped, while residential buildings occupy only a small fraction.", :green_belt, -1, 2, "This checks the misleading idea that grey-belt reform concerns mainly derelict built sites." ],
  [ "Could releasing a small percentage of Green Belt produce many or few homes?", [ "Either, depending on location, developable area and density", "Always none", "Exactly one million", "The percentage alone fixes the total" ], 0,
    "A land percentage cannot determine housing yield without site constraints and density assumptions.", :green_belt, 0, 2, "This is significant to interpreting claims framed only as shares of Green Belt." ],
  [ "What does an area's assessed housing need represent?", [ "A guaranteed construction forecast", "A policy calculation of housing need used in plan-making", "The number of vacant council homes", "Developers' combined land holdings" ], 1,
    "The standard method informs plan requirements; it is not a prediction that the market will complete that exact number.", :nppf, 1, 2, "The trigger in the proposition must be understood accurately." ],
  [ "If one authority cannot meet need within its boundary, what does plan-making policy also expect it to examine?", [ "Closing its waiting list", "Ignoring neighbouring labour markets", "Cooperation with other authorities", "Replacing homes with hotels" ], 2,
    "Strategic planning includes cooperation across boundaries, although neighbouring areas may themselves face constraints.", :nppf, -1, 2, "Alternatives to compulsory local release are significant to proportionality." ],
  [ "Can a 50% affordable requirement affect the price a developer can rationally pay for land?", [ "No, land values are fixed by law", "Only construction costs matter", "It necessarily raises land prices", "Yes" ], 3,
    "Expected obligations enter a residual land valuation, so a clear requirement can be reflected in land bids if it is known in advance.", :viability, -1, 3, "Land-value adjustment is foundational to whether high affordable provision is feasible rather than simply suppressing delivery." ],
  [ "What is one risk of tightly containing development around a city?", [ "Demand may be displaced farther out, increasing commuting distances", "All inner-city rents automatically fall", "Public transport becomes unnecessary", "Every rural settlement merges" ], 0,
    "Where demand persists, restrictive boundaries can redirect development beyond them; outcomes depend on transport, density and neighbouring plans.", :green_belt, 1, 2, "Potential leapfrog development is a significant unintended consequence." ],
  [ "What judgment does the proposition ultimately require?", [ "Whether every green field is ecologically identical", "Whether housing need and affordable provision justify mandatory release of suitable low-contribution land despite delivery and openness costs", "Whether England should prohibit private housing", "Whether planning decisions need evidence" ], 1,
    "The evidence informs a trade-off among housing need, affordable delivery, site viability, infrastructure and the lasting spatial purposes of Green Belt.", :nppf, 0, 1, "This synthesis frames the policy judgment without manufacturing a factual answer to it." ]
], GREY_BELT_SOURCES)

# Reserve the highest weight for the proposition's defining rules and trade-offs.
[ 3, 8, 11 ].each do |index|
  GREY_BELT_HOUSING_FACTS.fetch(index)[:importance_weight] = 2
end
GREY_BELT_HOUSING_FACTS.fetch(12)[:importance_weight] = 1

# Keep answer length from becoming a profitable guessing rule.
{
  2 => [ 0, "Guaranteeing unrestricted public access to every parcel regardless of ownership or land use" ],
  5 => [ 2, "Every undeveloped field that lies within walking distance of an existing railway station, regardless of its planning function or protected status" ],
  9 => [ 3, "A permanent prohibition on private vehicles throughout the development and surrounding settlements" ],
  14 => [ 0, "It fixes the Bank of England's interest-rate decision and each lender's mortgage criteria" ]
}.each do |question_index, (option_index, text)|
  GREY_BELT_HOUSING_FACTS.fetch(question_index)[:options][option_index] = text
end
