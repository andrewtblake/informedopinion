module PlausibleDistractorCalibration
  REVIEWED_OPTIONS = {
    voting_reform: [
      [ "The constituency candidate with the most votes", "The candidate receiving more than half of all registered electors", "The party receiving the largest UK-wide vote share", "The candidate leading after lower preferences are transferred" ],
      [ "Preserving one MP for each single-member constituency", "Proportional vote-to-seat results", "Making a Commons majority more likely for the largest party", "Reducing the number of parties represented in Parliament" ],
      [ "Yes—about 44%", "Yes—just over 50%", "No—about 34%", "No—about 24%" ],
      [ "A seat where the previous result was decided by fewer than 1,000 votes", "A seat whose boundaries cannot be altered", "A constituency contested by only one major party", "A predictably retained seat" ],
      [ "Backing a viable alternative", "Casting a protest vote for a party unlikely to win", "Ranking several candidates in order of preference", "Voting for different parties in simultaneous elections" ],
      [ "Yes—closed-list PR", "No—there are several designs", "Yes—the Additional Member System", "No—because PR describes only a target seat share, not an electoral system" ],
      [ "First past the post", "Single transferable vote", "The Additional Member System", "Closed-list proportional representation" ],
      [ "The Additional Member System", "Alternative Vote", "Closed-list proportional representation", "STV" ],
      [ "It generally decreases", "It generally increases because more candidates are elected", "It is unaffected because district size changes only geography", "It falls only when every district elects the same number" ],
      [ "A minimum turnout for the election to be valid", "A representation threshold", "A maximum share of seats one party may receive", "A minimum constituency vote for an individual candidate" ],
      [ "It prevents them winning constituency seats", "It leaves their prospects unchanged unless support is regional", "It makes representation more likely", "It helps only parties that lead the national vote" ],
      [ "No; only UK-wide vote share matters under FPTP", "No; concentrated support wastes more votes", "Only if the party contests fewer than half the seats", "Yes, if support is concentrated" ],
      [ "An excess district seat", "A compensatory list seat allocated to another party", "A seat left empty because no party crossed the threshold", "A constituency seat created when turnout exceeds projections" ],
      [ "One vote that is transferred between candidates", "Two votes", "One constituency vote plus rankings for list candidates", "Two party votes, one national and one regional" ],
      [ "Yes; proportionality requires one national constituency", "Yes; constituency representation is unique to FPTP", "No; some proportional systems retain them", "No; but only indirectly elected regional representatives can be retained" ],
      [ "It requires a coalition whenever no party wins 50% of votes", "It makes coalitions less common by reducing party numbers", "It has no systematic relationship with government formation", "It makes coalition bargaining more common" ],
      [ "No overall Commons majority", "A government whose ministers sit in both Houses", "A Commons in which two parties have exactly equal seats", "A Parliament elected without a majority of registered voters participating" ],
      [ "No; the system guarantees a majority to the largest party", "Yes", "Only when two parties tie in the popular vote", "Only when turnout falls below 50%" ],
      [ "The change in turnout between two elections", "The effective number of political parties", "Disproportionality between votes and seats", "The geographical concentration of each party's vote" ],
      [ "It must increase because PR creates new parties", "It normally remains identical to FPTP", "It must fall because thresholds remove small parties", "It often increases, depending on thresholds and district size" ],
      [ "A party, while the party-determined order allocates its elected candidates", "A party and one preferred candidate whose vote overrides the list order", "Individual candidates but not a political party", "A constituency candidate and a separate regional party list" ],
      [ "A second vote for a different political party", "Some voter influence over which party candidates take seats", "The ability to rank candidates from every party in one transferable ballot", "A constituency representative alongside the party list" ],
      [ "By casting one vote for a party list", "By approving as many candidates as desired without ranking", "By ranking candidates", "By choosing a constituency candidate and a regional party" ],
      [ "Only which candidate has the largest plurality in each seat", "The formal threshold for entering Parliament", "How many representatives each constituency elects", "How efficiently parties' votes translate into seats" ],
      [ "One clearly identifiable local MP", "A legislature whose party balance mirrors national votes", "The ability to rank candidates from within one party", "A lower probability of single-party majority government" ],
      [ "Coalitions cannot replace an unpopular governing party", "Voters may find responsibility for compromises less clear", "Coalition agreements are not subject to parliamentary votes", "Small coalition parties always control the legislative programme" ],
      [ "Yes; proportional results mean each ballot elects its first choice", "Yes, unless an electoral threshold applies", "No; it improves aggregate proportionality but cannot satisfy every preference", "No; because PR counts only party preferences, never candidate preferences" ],
      [ "No; electoral systems affect seats but not campaign strategy", "Only parties below the representation threshold change strategy", "Only constituency candidates change where they campaign", "Yes; incentives follow the votes and places that can affect seats" ],
      [ "Which proportional design, districts and thresholds to use", "Whether MPs should continue to represent geographical areas", "Whether coalition agreements should require a referendum", "Which parties should be guaranteed initial representation" ],
      [ "FPTP produces stronger local representation without any cost in proportionality", "PR improves vote-seat proportionality but trades against features such as simplicity, local linkage or single-party government depending on design", "Closed-list PR dominates every other proportional design on representation and accountability", "Electoral-system effects are limited to seat totals and do not change party or voter behaviour" ]
    ],
    nuclear_power: [
      [ "It retires", "It continues after automatic twenty-year life extensions", "It is converted to small modular reactors", "It remains available but operates only during winter peaks" ],
      [ "More than a modern gas station because of steam production", "Very little directly", "About half as much as an equivalent gas station", "An amount that varies with the uranium's country of origin" ],
      [ "Slightly higher than efficient gas generation", "Similar to gas generation once construction is included", "Much lower", "Lower than coal but substantially higher than wind and solar" ],
      [ "Electricity whose wholesale price is contractually fixed", "Generation that runs continuously without planned outages", "Capacity reserved only for periods of peak demand", "Capacity available on demand" ],
      [ "High output over much of the year", "Output concentrated in winter when electricity demand is highest", "Low output because reactors routinely balance wind generation", "Output fixed by the regulator rather than station availability" ],
      [ "Yes; their operating cost is unaffected by changes in output", "No, not as flexibly", "No; large reactors are physically incapable of reducing output", "Yes; but only while their fuel is newly loaded" ],
      [ "Managing carbon dioxide captured from reactor exhaust", "Preventing methane leakage during uranium enrichment", "Isolating spent fuel", "Recycling all activated structural material within the station" ],
      [ "Yes; one has operated at Sellafield since the 1990s", "Yes; each licensed station maintains its own permanent repository", "No; the UK instead exports all such waste for final disposal", "No—not yet" ],
      [ "The ONR", "Ofgem", "The Environment Agency alone", "The International Atomic Energy Agency" ],
      [ "Yes; approval certifies that no severe sequence remains possible", "No", "Only if the reactor uses a design already operating abroad", "No; but approval transfers all accident liability to the regulator" ],
      [ "Three Mile Island and Windscale", "Bhopal and Fukushima Daiichi", "Chernobyl and Fukushima Daiichi", "Chernobyl and Deepwater Horizon" ],
      [ "A loss-of-coolant accident during normal refuelling", "Failure of the reactor control software", "Loss of the external electrical grid alone", "Station blackout" ],
      [ "Delays and cost overruns", "Delivery close to budget but with substantially lower output", "Short construction followed by unexpectedly early closure", "Standardised costs falling at the same rate in every project" ],
      [ "Direct annual grants for each unit of electricity generated", "A guaranteed strike price", "Government ownership of all construction debt", "A capacity-market payment available only during shortages" ],
      [ "The uranium price is fixed before the plant can generate", "Construction materials deteriorate before commissioning", "Pre-revenue financing costs", "The strike price falls automatically for every delayed year" ],
      [ "Replacing fuel assemblies during a planned operating outage", "Extending a station's licence beyond its original design life", "Placing spent fuel into interim storage while generation continues", "Defuelling, dismantling and cleaning a closed nuclear site" ],
      [ "The public sector", "The current operators without any government support", "A levy paid only by future nuclear generators", "A pooled international fund administered by the IAEA" ],
      [ "A reactor small enough to provide heat to one household", "A lower-output reactor intended for factory-based modular manufacture", "A conventional large reactor divided among several generating companies", "A research reactor adapted to charge grid-scale batteries" ],
      [ "Yes; breeder reactors replenish uranium on the timescale it is consumed", "Yes; known resources expand whenever market prices rise", "No; it is a finite mined fuel", "No; but spent fuel cannot be reused in any reactor design" ],
      [ "More, because the thermal efficiency is lower", "A similar mass once enrichment material is included", "Slightly less, principally because reactors run for more hours", "Far less because nuclear fuel is highly energy-dense" ],
      [ "Yes, stations can hold long fuel inventories", "No; uranium must arrive through a continuous pipeline", "Only if the fuel is enriched within the United Kingdom", "No; international safeguards prohibit storing unused fuel onsite" ],
      [ "Yes; constant nuclear output removes short-term and seasonal variation", "No; a reliable system still needs networks and balancing", "Only transmission remains necessary; storage and flexible resources do not", "Only storage remains necessary; reserve and network constraints disappear" ],
      [ "Reserve requirements fall because the remaining units run harder", "No reserve can respond quickly enough to a nuclear-unit loss", "Enough reserve must respond to cover the lost unit", "The unit's contracted output is removed from measured demand" ],
      [ "Yes; variable and firm generation cannot operate on the same network", "Yes; adding either technology necessarily curtails all output from the other", "Only small modular reactors can operate alongside wind generation", "No; they can contribute different output characteristics" ],
      [ "44%", "34%", "54%", "64%" ],
      [ "Support was 35% and opposition 24%", "Support was 24% and opposition 35%", "Support and opposition were both 30%", "Support was 14% and opposition 45%" ],
      [ "Construction cost and effects on local property values", "Dependence on imported uranium and water consumption", "Safety/security and radioactive-waste disposal", "Visual impact and competition with offshore wind" ],
      [ "Yes; wholesale prices cause consumers to use correspondingly less", "Yes; decommissioning a station removes its former network demand", "Only if the closure occurs after its original design life", "No; their output must be replaced or demand separately reduced" ],
      [ "Its whole-system cost and risk against feasible low-carbon alternatives", "Its construction cost per unit of nameplate capacity alone", "Its fuel and operating cost after construction expenditure is excluded", "Its annual output compared only with intermittent renewable generation" ],
      [ "Nuclear is the lowest-cost firm generation in every plausible future system", "Nuclear supplies firm low-carbon power, but projects carry material cost, delivery, accident and waste obligations", "Nuclear lifecycle emissions are low but its output cannot complement renewable generation", "Retiring nuclear can always be replaced more cheaply by one alternative technology" ]
    ]
  }.freeze

  TARGETED_OPTIONS = {
    climate: {
      16 => [ "No; it redistributes heat and affects short periods but does not supply the persistent added energy", "Yes; multi-decadal ocean oscillations can supply a continuing net energy gain", "Yes; repeated El Niño events explain both the trend and the measured energy imbalance", "No; internal variability affects regional trends but not global annual temperature" ],
      18 => [ "They reproduce the warming but place it several decades too early", "They reproduce the surface trend but not ocean heat uptake", "They do not reproduce the sustained recent warming unless human influences are included", "They reproduce the trend only when volcanic forcing is excluded" ],
      21 => [ "It shows that the global trend paused for the duration of the cold event", "Nothing by itself; weather still varies within a changing climate", "It contradicts the global trend if the event sets a local record", "It is evidence against warming only if it covers an entire continent" ],
      23 => [ "Similar overall, because water vapour would maintain the present temperature", "Several degrees colder, mainly because clouds would disappear", "Warmer, because more outgoing heat would escape the atmosphere", "Much colder" ],
      27 => [ "That low-confidence findings are omitted from the assessment", "That model spread is substituted for observational uncertainty", "That all outcomes within a stated range have equal probability", "That confidence and probability ranges are stated explicitly" ]
    },
    gun_control: {
      6 => [ "Ask the dealer to submit a second check using a different identifier", "Seek review from the state agency that supplied the record", "Request the reason and submit a challenge", "Appeal directly to a federal district court before obtaining the record" ],
      8 => [ "Concurrent policies and differences between states", "Differences in firearm ownership rates are not measured consistently between states", "Federal and state background checks use incompatible definitions of homicide", "Universal-check laws have not been in force long enough for changes in rare outcomes to be measured reliably" ],
      9 => [ "The federal dealer network may not have capacity to process private transfers", "Limited compliance, enforcement and market coverage", "Prohibited buyers may lawfully bypass a check after a waiting period", "Checked transfers may displace purchases from handguns to long guns" ],
      11 => [ "Whether the buyer has previously passed a federal check", "Whether the transfer occurs within the buyer's state of residence", "Whether the firearm was previously sold by a licensed dealer", "Coverage and available records" ],
      27 => [ "A mandatory ten-business-day waiting period", "Direct interviews with the buyer's parents or guardian", "Fingerprint comparison with juvenile court files", "A search for potentially disqualifying juvenile records" ]
    },
    brexit: {
      14 => [ "Trade values were converted from euros at changing exchange rates", "The TCA phased its principal border provisions in over four years", "The pandemic, war in Ukraine and supply-chain disruption overlapped", "Services trade replaced goods trade in the official series after 2020" ],
      16 => [ "The right to live, work and study in other EU countries under free-movement rules", "An unconditional right to vote in every election held within the EU", "Automatic recognition of every professional qualification without national rules", "Access to another member state's benefits on the same terms from the first day of residence" ],
      26 => [ "Either side may suspend the entire agreement without consultation", "The dispute must be referred to the Court of Justice of the European Union", "Treaty dispute, remedy or rebalancing mechanisms may apply", "The affected industry receives compensation from a joint UK–EU fund" ],
      28 => [ "The UK participates as an associated country", "The UK participates through the Trade and Cooperation Agreement without association", "UK institutions may join projects but cannot receive programme funding", "Only researchers holding citizenship of an EU country may participate from the UK" ],
      29 => [ "They preserve Northern Ireland's participation in every EU policy programme", "The arrangements protect both the open Irish land border and the EU single market", "They maintain unrestricted movement of all goods from Great Britain into the EU", "They keep Northern Ireland inside the EU customs union for all legal purposes" ]
    },
    wealth_tax: {
      15 => [ "Roughly 1–3%", "Roughly 25–35%", "Roughly 45–55%", "Roughly 7–17%" ],
      16 => [ "It consumes half rather than one-tenth of the pre-tax return", "Assets with low returns are assessed at a higher statutory rate", "Low-return assets must use a less favourable valuation date", "High-return assets receive a deduction for reinvested income" ],
      20 => [ "The base narrows and avoidance opportunities can increase", "The tax rate must rise automatically to maintain the original yield", "Administrative valuation becomes simpler because fewer asset types remain", "Exempt assets fall in value relative to otherwise similar taxable assets" ],
      23 => [ "They prevent quoted and unquoted companies being taxed at different rates", "They ensure active businesses receive the same treatment as passive investments", "They reduce valuation disputes by excluding ownership interests from net wealth", "Broad exemptions can invite reclassification of personal wealth as business wealth" ],
      28 => [ "Some response exists, but estimates vary and most affected people do not move", "Migration responses occur only after a tax has been in place for a decade", "Reported migration reflects tax residence changes but no physical relocation", "Most affected taxpayers move, but usually remain liable under departure taxes" ],
      29 => [ "Those reforms necessarily raise less revenue from the same population", "Alternative reforms may address some of the same revenue and fairness goals with different distortions and administration", "Existing capital taxes cannot apply to property or private-business wealth", "A recurrent wealth tax and the existing capital taxes use the same base and timing" ]
    },
    flat_earth: {
      16 => [ "The Sun circling through all azimuths without setting on suitable dates", "The Sun setting briefly in the south before rising in the same position", "The Sun remaining above the horizon but confined to the northern half of the sky", "The Sun completing less than half a circuit before reversing direction" ],
      22 => [ "Earth curvature and a constant standard-refraction correction", "Instrument collimation and magnetic declination", "Tidal height and the geometric dip of the horizon", "Earth curvature and variable atmospheric refraction" ],
      27 => [ "Because a flat plane predicts a constant horizon distance while weather changes only its apparent height", "Because curvature gives a stable height-and-distance pattern, while refraction and lens distortion vary and can be identified", "Because refraction affects vertical measurements whereas curvature affects only horizontal measurements", "Because observations made above two different heights remove the need to model atmospheric refraction" ],
      28 => [ "A flat disk fits all four if separate Sun heights are chosen for northern and southern observations", "The models fit the same observations but assign different speeds to the Sun and stars", "A rotating globe fits them coherently", "Neither model fits all four unless atmospheric refraction is held constant" ],
      20 => [ "The trails turn clockwise around both poles when each observer faces the pole", "It reverses, with opposite signs north and south", "They turn in the same sense but at different angular rates", "The apparent sense reverses with the season rather than the hemisphere" ],
      29 => [ "Specifying dimensions and mechanisms that predict numerical results before measurements are taken", "Publishing a diagram that can be adjusted after each new observation", "Reproducing individual photographs without predicting where or when they were taken", "Explaining anomalies by adding unmeasured optical effects to the model" ]
    },
    minimum_wage: {
      11 => [ "Higher employment in every covered industry", "No employment change because labour demand is fixed", "A precisely estimated employment reduction", "Possible job losses, with uncertain size" ],
      12 => [ "Higher income for some workers", "A lower measured threshold with unchanged household income", "A tax credit paid to every minimum-wage worker", "Higher earnings only for households already above the poverty line" ],
      13 => [ "Minimum-wage workers are distributed across households at different income levels", "Hourly pay is not family income", "Poverty measures exclude earnings from workers under age 25", "Some low-income households contain no hourly workers covered by federal law" ],
      14 => [ "A reduction in the employer's payroll-tax rate", "A federal wage subsidy paid directly to the employer", "Higher prices", "A lower statutory minimum for firms with narrow profit margins" ],
      18 => [ "Differences in state income-tax rates", "Regional variation in consumer-price inflation since 2009", "Local wages and living costs", "Different federal coverage rules in urban and rural counties" ],
      23 => [ "No; studies agree on direction but not magnitude", "No; national studies agree while local studies do not", "No; estimates vary only because nominal wage rates differ", "No; estimates vary with data, setting, method and policy size" ],
      29 => [ "It raises earnings without affecting prices or employment in the studied range", "It would raise many wages, while employment, prices and regional effects remain important and uncertain", "Its employment effect is known, but its distributional effect is not", "State evidence establishes the effect of a national $15 floor with little remaining uncertainty" ]
    },
    death_penalty: {
      8 => [ "They could not establish a causal effect", "They found deterrence only in states using lethal injection", "They found a small causal effect that was not statistically significant", "They concluded that deterrence varied predictably with execution frequency" ],
      10 => [ "Yes, if enough years and states are included", "Yes, after controlling only for population size", "No—confounding factors remain", "No, because state murder-rate data cannot be compared over time" ],
      14 => [ "Confession evidence obtained after conviction", "Reanalysis of eyewitness confidence scores", "DNA testing", "Statistical evidence about the local false-conviction rate" ],
      20 => [ "They require specialised, longer guilt and penalty proceedings plus extensive review", "They require a separate jury but generally fewer appellate proceedings", "Their principal extra cost is maintaining execution facilities and equipment", "Their trials cost about the same, but death-row imprisonment is substantially more expensive" ],
      28 => [ "No; most countries have abolished it in law or practice", "No; abolition is concentrated in Europe while most other countries retain it", "No; a majority retain it in law even though few carry out executions", "Yes; abolition in law is universal although executions continue unlawfully" ],
      29 => [ "Capital punishment deters some categories of murder, but its overall effect cannot be measured", "Capital punishment expresses severe retribution, but deterrence is unproven and irreversibility, error, disparity and cost are material concerns", "Capital punishment costs more than imprisonment but produces more consistent sentencing", "Capital punishment's legal safeguards remove innocence risk but not concerns about disparity" ]
    },
    gaza: {
      6 => [ "Yes; self-defence changes how expected civilian harm is weighed", "Yes; warnings make subsequent civilian harm voluntary", "No; distinction, proportionality and feasible precautions still apply", "No; attacks on military objectives are prohibited whenever civilians are nearby" ],
      10 => [ "That the evidence already established a likely genocide", "That the Court had jurisdiction but no plausible protected rights were at risk", "That plausible rights under the Genocide Convention faced a risk of irreparable prejudice requiring interim measures", "That provisional measures were unnecessary pending a final merits hearing" ],
      11 => [ "Yes; provisional measures decide responsibility but not remedy", "Yes; the order was final unless appealed to the Security Council", "No; the Court decided only jurisdiction and not risk to protected rights", "No; the merits had not been finally decided" ],
      12 => [ "Reasonable grounds to believe", "A balance of probabilities after an evidential hearing", "Substantial grounds for concluding that crimes had occurred", "Proof beyond reasonable doubt, subject to confirmation at trial" ],
      14 => [ "Yes; it divided the total into civilians, militants and unknown cases", "Yes; demographic categories supplied a complete legal status classification", "Only fatalities independently verified by the UN were classified", "No; the total did not itself provide that complete classification" ],
      29 => [ "That civilian harm outweighed every military gain under one legal formula", "That the campaign's stated objectives could not be evaluated using factual evidence", "The relevant gains, harms, uncertainties and legal constraints—not a uniquely compelled moral weighting of them", "That legal compliance determines whether the overall campaign was morally justified" ]
    },
    assisted_dying: {
      3 => [ "Yes, where the condition caused enduring and intolerable suffering", "Yes, where two doctors considered the condition irreversible", "Only where disability was accompanied by impaired decision-making capacity", "No" ],
      4 => [ "Capacity to make the decision to end their life", "Capacity to make every medical and financial decision without assistance", "A psychiatric finding that the person had never experienced depression", "A valid advance decision made before the terminal diagnosis" ],
      5 => [ "That the request had remained unchanged for at least six months", "That it was clear, settled, informed and voluntary", "That all available treatment had been attempted and failed", "That the applicant's family and primary clinician supported the request" ],
      8 => [ "A multidisciplinary Assisted Dying Review Panel", "A High Court judge sitting without medical evidence", "A regional panel consisting only of doctors", "The coordinating doctor together with the applicant's family" ],
      12 => [ "No", "Yes, when specialist palliative care begins before the final month", "Yes, for physical pain but not breathlessness or loss of control", "No, but only because access to specialist care is uneven" ],
      14 => [ "Exact for cancer diagnoses but uncertain for other conditions", "Reliable to within one month when two specialists agree", "Uncertain, especially for non-cancer illnesses", "Too uncertain to distinguish six months from several years in any case" ],
      18 => [ "Motor neurone disease", "Advanced heart failure", "Cancer", "Dementia" ],
      20 => [ "Uptake and overseas comparability are uncertain", "The number eligible can be estimated, but completion rates are not recorded overseas", "Prognostic uncertainty prevents any estimate of the eligible population", "Implementation costs determine how many applications the law would permit" ],
      23 => [ "Yes; a panel decision removes the possibility of later coercion", "Yes; two independent medical assessments eliminate diagnostic and prognostic error", "Only long reflection periods can reduce all three risks to zero", "No" ],
      24 => [ "No", "Yes; assisted dying would replace specialist end-of-life services for eligible patients", "No; but palliative care would no longer be relevant after approval", "Yes; because choosing assisted dying shows that symptom control has failed" ],
      25 => [ "The statutory definition of terminal illness varies between assessing doctors", "Disease trajectories vary between individuals", "Doctors are permitted to use different legal prognosis periods", "Palliative treatment prevents survival from being estimated at all" ],
      26 => [ "The approved substance's effects and the statutory reflection periods", "The panel's membership and the applicant's right to legal representation", "Diagnosis, prognosis, treatment and palliative options", "The cost to the NHS of treatment compared with assisted dying" ],
      29 => [ "Whether the six-month prognosis is accurate enough to administer consistently", "How autonomy should be weighed against safeguarding risks", "Whether assisted dying should be provided inside or outside the NHS", "How many applicants would be sufficient to justify a national service" ]
    },
    grey_belt: {
      1 => [ "Protecting land with the highest measured ecological value", "Checking unrestricted urban sprawl", "Directing all housing growth to previously developed land", "Maintaining a permanent agricultural reserve around major cities" ],
      2 => [ "Preventing development visible from designated landscapes", "Protecting public access to countryside around towns", "Preventing neighbouring towns from merging", "Preserving land in agricultural production near urban markets" ],
      5 => [ "Previously developed Green Belt land regardless of its contribution to openness", "Previously developed or other Green Belt land making a limited contribution to specified purposes", "Any Green Belt site whose authority cannot meet its housing target", "Land within a Green Belt that lacks a national environmental designation" ],
      9 => [ "Affordable housing and transport improvements only", "Affordable housing, infrastructure and accessible green space", "A fixed developer contribution replacing local planning obligations", "Social-rented housing and biodiversity net gain, with no infrastructure test" ],
      13 => [ "Collecting the Community Infrastructure Levy for strategic projects", "Securing site-specific planning obligations", "Setting the proportion of land allocated for housing in a local plan", "Requiring a developer to obtain building-control approval" ],
      14 => [ "It determines whether the authority's assessed housing need is valid", "It measures whether the design satisfies Green Belt openness tests", "Costs and obligations can affect whether a scheme is deliverable and land retains an incentive to come forward", "It establishes the maximum market price permitted for completed homes" ],
      21 => [ "It determines whether the site legally counts as grey belt", "It affects residents' access to work and services and likely travel patterns", "It fixes how much affordable housing the development can support", "It decides whether the authority may count the homes toward assessed need" ],
      24 => [ "Either, depending on location, developable area and density", "Always many, because Green Belt land has few physical constraints", "Always few, because grey-belt policy limits development density", "A predictable number derived from the national percentage alone" ],
      26 => [ "Offering unmet need to the first neighbouring authority with available Green Belt", "Reducing the assessed need to match land inside the boundary", "Cooperation with other authorities", "Combining its planning committee with those of adjoining authorities" ],
      28 => [ "Demand may be displaced farther out, increasing commuting distances", "Development may concentrate at higher density immediately inside the boundary", "Urban land values may fall while values beyond the boundary remain unchanged", "Neighbouring authorities may meet the displaced demand within the same urban area" ],
      29 => [ "Whether every authority should use the same affordable-housing percentage", "Whether housing need and affordable provision justify mandatory release of suitable low-contribution land despite delivery and openness costs", "Whether Green Belt designation should be replaced by environmental designations", "Whether local authorities or central government should build the homes directly" ]
    }
  }.freeze

  module_function

  def apply(facts, bank)
    reviewed = REVIEWED_OPTIONS.fetch(bank)
    raise "#{bank} distractor review does not match fact bank" unless reviewed.length == facts.length

    reviewed.each_with_index do |options, index|
      raise "#{bank} question #{index + 1} must retain four distinct choices" unless options.length == 4 && options.uniq.length == 4

      fact = facts.fetch(index)
      correct_answer = fact[:options].fetch(fact[:correct_option])
      raise "#{bank} question #{index + 1} changed its correct answer" unless options.fetch(fact[:correct_option]) == correct_answer

      fact[:options] = options
    end
  end

  def apply_targeted(facts, bank)
    TARGETED_OPTIONS.fetch(bank).each do |index, options|
      raise "#{bank} question #{index + 1} must have four distinct choices" unless options.length == 4 && options.uniq.length == 4

      fact = facts.fetch(index)
      correct_answer = fact[:options].fetch(fact[:correct_option])
      raise "#{bank} question #{index + 1} changed its correct answer" unless options.fetch(fact[:correct_option]) == correct_answer

      fact[:options] = options
    end
  end
end

PlausibleDistractorCalibration.apply(VOTING_REFORM_FACTS, :voting_reform)
PlausibleDistractorCalibration.apply(NUCLEAR_POWER_FACTS, :nuclear_power)
PlausibleDistractorCalibration.apply_targeted(CLIMATE_FACTS, :climate)
PlausibleDistractorCalibration.apply_targeted(GUN_CONTROL_FACTS, :gun_control)
PlausibleDistractorCalibration.apply_targeted(BREXIT_FACTS, :brexit)
PlausibleDistractorCalibration.apply_targeted(WEALTH_TAX_FACTS, :wealth_tax)
PlausibleDistractorCalibration.apply_targeted(FLAT_EARTH_FACTS, :flat_earth)
PlausibleDistractorCalibration.apply_targeted(MINIMUM_WAGE_FACTS, :minimum_wage)
PlausibleDistractorCalibration.apply_targeted(DEATH_PENALTY_FACTS, :death_penalty)
PlausibleDistractorCalibration.apply_targeted(GAZA_FACTS, :gaza)
PlausibleDistractorCalibration.apply_targeted(ASSISTED_DYING_FACTS, :assisted_dying)
PlausibleDistractorCalibration.apply_targeted(GREY_BELT_HOUSING_FACTS, :grey_belt)
