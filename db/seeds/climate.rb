CLIMATE_FACTS = [
  {
    prompt: "According to the IPCC, what has unequivocally caused the global warming observed since the 19th century?",
    options: [ "Human activities, principally greenhouse-gas emissions", "Changes in the Sun alone", "Natural volcanic cycles" ],
    correct_option: 0,
    explanation: "The IPCC concludes that human activities, principally through greenhouse-gas emissions, have unequivocally caused global warming.",
    source_name: "IPCC AR6 Synthesis Report",
    source_url: "https://www.ipcc.ch/report/ar6/syr/summary-for-policymakers/",
    evidence_direction: 1
  },
  {
    prompt: "How much warmer was global surface temperature in 2011–2020 than in 1850–1900?",
    options: [ "About 0.2°C", "About 1.1°C", "About 3.0°C" ],
    correct_option: 1,
    explanation: "The IPCC's best estimate is 1.1°C of warming for 2011–2020 relative to 1850–1900.",
    source_name: "IPCC AR6 Synthesis Report",
    source_url: "https://www.ipcc.ch/report/ar6/syr/resources/spm-headline-statements/",
    evidence_direction: 1
  },
  {
    prompt: "When did the IPCC find global surface temperature began rising faster than in any other 50-year period for at least 2,000 years?",
    options: [ "Since 1970", "Since 1800", "Only since 2015" ],
    correct_option: 0,
    explanation: "The IPCC assesses the rate of warming since 1970 as faster than any other 50-year period in at least two millennia.",
    source_name: "IPCC AR6 Synthesis Report",
    source_url: "https://www.ipcc.ch/report/ar6/syr/summary-for-policymakers/",
    evidence_direction: 1
  },
  {
    prompt: "Where is roughly 90% of the excess heat trapped in Earth's climate system stored?",
    options: [ "In the atmosphere", "In the ocean", "In glaciers" ],
    correct_option: 1,
    explanation: "The ocean absorbs and stores about 90% of the extra energy accumulated in the climate system.",
    source_name: "NASA Climate Evidence",
    source_url: "https://science.nasa.gov/climate-change/evidence/",
    evidence_direction: 1
  },
  {
    prompt: "What has happened to the mass of both the Greenland and Antarctic ice sheets in recent decades?",
    options: [ "Both have gained mass", "Neither has measurably changed", "Both have lost mass" ],
    correct_option: 2,
    explanation: "Satellite gravity measurements show sustained mass loss from both major ice sheets.",
    source_name: "NASA Climate Evidence",
    source_url: "https://science.nasa.gov/climate-change/evidence/",
    evidence_direction: 1
  },
  {
    prompt: "How did global mean sea level change between 1901 and 2018?",
    options: [ "It fell about 20 cm", "It rose about 20 cm", "It did not measurably change" ],
    correct_option: 1,
    explanation: "The IPCC estimates a rise of 0.20 metres, with the rate accelerating over the period.",
    source_name: "IPCC AR6 Synthesis Report",
    source_url: "https://www.ipcc.ch/report/ar6/syr/summary-for-policymakers/",
    evidence_direction: 1
  },
  {
    prompt: "Compared with 1901–1971, the rate of global sea-level rise during 2006–2018 was approximately what?",
    options: [ "Nearly three times as fast", "About the same", "Half as fast" ],
    correct_option: 0,
    explanation: "The assessed rate increased from about 1.3 mm/year to about 3.7 mm/year.",
    source_name: "IPCC AR6 Synthesis Report",
    source_url: "https://www.ipcc.ch/report/ar6/syr/summary-for-policymakers/",
    evidence_direction: 1
  },
  {
    prompt: "What has happened to Arctic sea-ice extent and thickness over recent decades?",
    options: [ "Both have declined rapidly", "Both have increased", "Extent rose while thickness fell" ],
    correct_option: 0,
    explanation: "Multiple satellite records show rapid declines in both Arctic sea-ice extent and thickness.",
    source_name: "NASA Climate Evidence",
    source_url: "https://science.nasa.gov/climate-change/evidence/",
    evidence_direction: 1
  },
  {
    prompt: "By approximately how much had global atmospheric carbon dioxide risen since 1800 by 2024?",
    options: [ "Less than 5%", "About 15%", "More than 50%" ],
    correct_option: 2,
    explanation: "NOAA reports a rise of more than 50%, reaching a global average of about 422 ppm in 2024.",
    source_name: "NOAA Climate.gov",
    source_url: "https://www.climate.gov/ghg/current-levels",
    evidence_direction: 1
  },
  {
    prompt: "Which human activity is the largest source of greenhouse-gas emissions in the United States?",
    options: [ "Burning fossil fuels for energy and transport", "Breathing by people and animals", "Volcanic eruptions" ],
    correct_option: 0,
    explanation: "EPA identifies fossil-fuel combustion for electricity, heat and transportation as the largest U.S. source.",
    source_name: "U.S. Environmental Protection Agency",
    source_url: "https://www.epa.gov/ghgemissions/sources-greenhouse-gas-emissions",
    evidence_direction: 1
  },
  {
    prompt: "What property makes carbon dioxide a greenhouse gas?",
    options: [ "It reflects all sunlight back to space", "It absorbs outgoing infrared heat radiation", "It removes oxygen from the atmosphere" ],
    correct_option: 1,
    explanation: "Carbon dioxide absorbs and re-emits infrared radiation, slowing the loss of heat to space.",
    source_name: "NASA Climate Evidence",
    source_url: "https://science.nasa.gov/climate-change/evidence/",
    evidence_direction: 1
  },
  {
    prompt: "Which observation helps identify fossil fuels as the source of much of the additional atmospheric carbon dioxide?",
    options: [ "Changes in carbon isotope ratios", "Changes in the Moon's orbit", "Increases in atmospheric oxygen" ],
    correct_option: 0,
    explanation: "The carbon added to the atmosphere carries the isotope signature of ancient plant matter, while atmospheric oxygen declines as combustion consumes it.",
    source_name: "NOAA Global Monitoring Laboratory",
    source_url: "https://gml.noaa.gov/ccgg/about/co2_measurements.html",
    evidence_direction: 1
  },
  {
    prompt: "Over the satellite era, has the amount of energy Earth receives from the Sun shown a net increase capable of explaining recent warming?",
    options: [ "Yes, a large sustained increase", "No, satellite measurements show no such net increase", "Solar energy has not been measured" ],
    correct_option: 1,
    explanation: "Satellite records show no upward trend in incoming solar energy large enough to account for the observed warming.",
    source_name: "NASA Climate Causes",
    source_url: "https://science.nasa.gov/climate-change/causes/",
    evidence_direction: 1
  },
  {
    prompt: "If increased solar output were driving recent warming, which atmospheric pattern would scientists expect?",
    options: [ "Warming throughout the atmosphere", "Surface warming with upper-atmosphere cooling", "Cooling at every altitude" ],
    correct_option: 0,
    explanation: "A brighter Sun would warm atmospheric layers broadly; observed stratospheric cooling alongside lower-atmosphere warming instead matches greenhouse forcing.",
    source_name: "NASA Climate Causes",
    source_url: "https://science.nasa.gov/climate-change/causes/",
    evidence_direction: 1
  },
  {
    prompt: "What is the usual short-term effect of a major volcanic eruption on global temperature?",
    options: [ "Temporary cooling", "Permanent rapid warming", "No physical effect" ],
    correct_option: 0,
    explanation: "Large eruptions can inject reflective aerosols into the stratosphere, producing temporary cooling rather than the sustained warming trend.",
    source_name: "USGS Volcano Hazards Program",
    source_url: "https://www.usgs.gov/programs/VHP/volcanoes-can-affect-climate",
    evidence_direction: 1
  },
  {
    prompt: "Approximately what share of human carbon dioxide emissions does the ocean absorb?",
    options: [ "None", "About 20–30%", "Nearly 100%" ],
    correct_option: 1,
    explanation: "The ocean has absorbed roughly one-quarter of recent human CO₂ emissions, limiting atmospheric warming but changing ocean chemistry.",
    source_name: "NOAA National Centers for Environmental Information",
    source_url: "https://www.ncei.noaa.gov/news/managing-ocean-carbon-data",
    evidence_direction: 1
  },
  {
    prompt: "How has average surface-ocean acidity changed over roughly the past 250 years?",
    options: [ "It has decreased by about 26%", "It has increased by about 26%", "It has remained exactly constant" ],
    correct_option: 1,
    explanation: "NOAA estimates the global surface ocean has become about 26% more acidic as it absorbs additional CO₂.",
    source_name: "NOAA Ocean Acidification Program",
    source_url: "https://oceanacidification.noaa.gov/what-is-ocean-acidification/",
    evidence_direction: 1
  },
  {
    prompt: "Why can a small numerical fall in ocean pH represent a substantial chemical change?",
    options: [ "The pH scale is logarithmic", "The pH scale measures temperature", "Seawater has no buffering capacity" ],
    correct_option: 0,
    explanation: "Because pH is logarithmic, a seemingly small change corresponds to a much larger change in hydrogen-ion concentration.",
    source_name: "NOAA Ocean Acidification Program",
    source_url: "https://oceanacidification.noaa.gov/oa-indicators-explained/",
    evidence_direction: 1
  },
  {
    prompt: "Which organisms can be directly affected when ocean acidification reduces carbonate ions?",
    options: [ "Shell-building corals, oysters and clams", "Only land mammals", "Only freshwater plants" ],
    correct_option: 0,
    explanation: "Reduced carbonate availability makes it harder for many marine organisms to build and maintain shells and skeletons.",
    source_name: "NOAA National Centers for Environmental Information",
    source_url: "https://www.ncei.noaa.gov/news/managing-ocean-carbon-data",
    evidence_direction: 1
  },
  {
    prompt: "Has human-caused climate change already affected weather and climate extremes?",
    options: [ "Yes, in every region of the globe", "Only in the Arctic", "No; effects are only projected after 2100" ],
    correct_option: 0,
    explanation: "The IPCC finds human-caused climate change is already affecting many extremes in every region.",
    source_name: "IPCC AR6 Synthesis Report",
    source_url: "https://www.ipcc.ch/report/ar6/syr/resources/spm-headline-statements/",
    evidence_direction: 1
  },
  {
    prompt: "What has happened to record high and record low temperature events in the United States since 1950?",
    options: [ "Record highs increased while record lows decreased", "Both decreased equally", "Record lows increased while highs decreased" ],
    correct_option: 0,
    explanation: "Observed U.S. records show more record highs and fewer record lows, as expected in a warming climate.",
    source_name: "NASA Climate Evidence",
    source_url: "https://science.nasa.gov/climate-change/evidence/",
    evidence_direction: 1
  },
  {
    prompt: "Does climate change mean cold weather can no longer occur?",
    options: [ "Yes", "No", "Only in the Southern Hemisphere" ],
    correct_option: 1,
    explanation: "Weather still varies daily and seasonally; a rising global average shifts probabilities but does not eliminate cold events.",
    source_name: "NOAA Climate.gov",
    source_url: "https://www.climate.gov/news-features/climate-qa/does-cold-weather-disprove-climate-change",
    evidence_direction: 1
  },
  {
    prompt: "Which is a climate trend rather than a single weather event?",
    options: [ "One afternoon thunderstorm", "A multi-decade rise in average temperature", "Tomorrow's local forecast" ],
    correct_option: 1,
    explanation: "Climate describes long-term statistical patterns, whereas weather describes short-term conditions.",
    source_name: "NOAA National Centers for Environmental Information",
    source_url: "https://www.ncei.noaa.gov/news/weather-vs-climate",
    evidence_direction: 1
  },
  {
    prompt: "Without natural greenhouse gases, would Earth's average surface be warmer or colder?",
    options: [ "Much colder", "Much warmer", "Exactly the same" ],
    correct_option: 0,
    explanation: "The natural greenhouse effect makes Earth habitable; human emissions strengthen that existing effect.",
    source_name: "NASA Climate Causes",
    source_url: "https://science.nasa.gov/climate-change/causes/",
    evidence_direction: 1
  },
  {
    prompt: "Which greenhouse gas contributes the largest share of warming influence from long-lived, human-emitted greenhouse gases?",
    options: [ "Carbon dioxide", "Oxygen", "Argon" ],
    correct_option: 0,
    explanation: "NOAA estimates CO₂ supplies about two-thirds of the warming influence from human-emitted long-lived greenhouse gases.",
    source_name: "NOAA Climate.gov",
    source_url: "https://www.climate.gov/ghg/current-levels",
    evidence_direction: 1
  },
  {
    prompt: "How do scientists reconstruct climates from before thermometers were widespread?",
    options: [ "Only by guessing", "Using proxies such as ice cores, tree rings, corals and sediments", "Using modern weather forecasts backward" ],
    correct_option: 1,
    explanation: "Independent paleoclimate archives preserve physical and chemical evidence of past temperature and atmospheric composition.",
    source_name: "NASA Climate Evidence",
    source_url: "https://science.nasa.gov/climate-change/evidence/",
    evidence_direction: 1
  },
  {
    prompt: "How does the current rate of warming compare with the average rate after an ice age?",
    options: [ "Roughly ten times faster", "Roughly ten times slower", "Exactly the same" ],
    correct_option: 0,
    explanation: "Paleoclimate evidence summarized by NASA indicates current warming is occurring roughly ten times faster.",
    source_name: "NASA Climate Evidence",
    source_url: "https://science.nasa.gov/climate-change/evidence/",
    evidence_direction: 1
  },
  {
    prompt: "Which statement best describes scientific uncertainty about climate change?",
    options: [ "Uncertainty means nothing is known", "Ranges are quantified, while core conclusions can still have high confidence", "All projections are exact" ],
    correct_option: 1,
    explanation: "Assessments state confidence and probability explicitly; uncertainty about precise magnitude does not erase well-established causal findings.",
    source_name: "IPCC AR6 Synthesis Report",
    source_url: "https://www.ipcc.ch/report/ar6/syr/summary-for-policymakers/",
    evidence_direction: 1
  },
  {
    prompt: "What do climate models project if cumulative carbon dioxide emissions continue to rise?",
    options: [ "Additional warming", "Immediate global cooling", "No further temperature response" ],
    correct_option: 0,
    explanation: "The IPCC finds a near-linear relationship between cumulative CO₂ emissions and global warming.",
    source_name: "IPCC AR6 Working Group I",
    source_url: "https://www.ipcc.ch/report/ar6/wg1/chapter/summary-for-policymakers/",
    evidence_direction: 1
  },
  {
    prompt: "What is required to halt the human-caused rise in global surface temperature driven by carbon dioxide?",
    options: [ "Net-zero carbon dioxide emissions", "Keeping annual emissions constant above zero", "Planting trees while fossil-fuel emissions grow indefinitely" ],
    correct_option: 0,
    explanation: "Reaching net-zero CO₂ is necessary to stop further CO₂-driven warming; limiting other greenhouse gases also affects peak warming.",
    source_name: "IPCC AR6 Synthesis Report",
    source_url: "https://www.ipcc.ch/report/ar6/syr/resources/spm-headline-statements/",
    evidence_direction: 1
  }
].freeze
