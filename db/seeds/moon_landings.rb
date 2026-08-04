require_relative "fact_bank"

MOON_LANDING_OPINION = {
  slug: "moon-landings",
  title: "Moon landings",
  statement: "Between 1969 and 1972, NASA's Apollo programme landed astronauts on the Moon.",
  response_options: [ "Definitely true", "Probably true", "Unsure", "Probably false", "Definitely false" ],
  display_order: 15,
  accent: "slate",
  category: "Science & environment",
  tags: [ "Moon", "Apollo programme", "Space exploration", "Scientific evidence", "Conspiracy theories", "United States" ]
}.freeze

MOON_LANDING_SOURCES = {
  overview: [ "NASA: Apollo 11 mission overview", "https://www.nasa.gov/history/apollo-11-mission-overview/" ],
  missions: [ "NASA: The Apollo missions", "https://www.nasa.gov/the-apollo-program/" ],
  samples: [ "NASA Science: Apollo samples yield new Moon information", "https://science.nasa.gov/science-research/planetary-science/astrobiology/nasas-apollo-samples-yield-new-information-about-the-moon/" ],
  lro: [ "NASA Science: Lunar Reconnaissance Orbiter", "https://science.nasa.gov/mission/lro/about/" ],
  reflectors: [ "International Laser Ranging Service: Apollo and Luna reflectors", "https://ilrs.gsfc.nasa.gov/missions/satellite_missions/current_missions/ap11_general.html" ],
  ranging: [ "NASA: The Apollo experiment that keeps on giving", "https://www.nasa.gov/missions/apollo/apollo-11/the-apollo-experiment-that-keeps-on-giving/" ],
  jodrell: [ "Jodrell Bank: The Moon landing and Jodrell Bank", "https://www.jodrellbank.net/explore/stories/the-moon-landing-and-jodrell-bank/" ],
  report: [ "NASA Technical Reports Server: Apollo programme summary report", "https://www.nasa.gov/wp-content/uploads/static/history/alsj/apsr-jsc-09423.pdf" ],
  radiation: [ "NASA: Biomedical results of Apollo — radiation protection", "https://history.nasa.gov/SP-368/s2ch3.htm" ],
  photography: [ "NASA History: Apollo 11 lunar-surface photography", "https://www.nasa.gov/history/alsj/a11/a11.photidx.html" ],
  surveyor: [ "NASA: Apollo 12 mission overview", "https://www.nasa.gov/history/apollo-12-mission-overview/" ],
  archive: [ "NASA: Apollo Flight Journal", "https://www.nasa.gov/history/afj/" ],
  luna: [ "NASA Science: Luna 16 robotic sample return", "https://science.nasa.gov/photojournal/luna-16/" ]
}.freeze

MOON_LANDING_FACTS = FactBank.build([
  [ "How many Apollo missions landed astronauts on the Moon between 1969 and 1972?",
    [ "Six", "Four", "Seven", "Nine" ], 0,
    "Apollo 11, 12, 14, 15, 16 and 17 each made a crewed lunar landing; Apollo 13 aborted before landing.", :missions, 1, 3, "The number of separate successful missions is foundational to the scale of the claim." ],
  [ "How many people walked on the Moon during the Apollo programme?",
    [ "Nine", "Twelve", "Six", "Eighteen" ], 1,
    "Two astronauts descended on each of six landing missions, making twelve lunar walkers in total.", :missions, 0, 1, "Crew numbers define the historical claim but add limited independent evidential weight." ],
  [ "Which Apollo mission made the first crewed lunar landing?",
    [ "Apollo 8", "Apollo 10", "Apollo 11", "Apollo 12" ], 2,
    "Apollo 11 landed Eagle in the Sea of Tranquillity in July 1969; Apollo 8 orbited and Apollo 10 rehearsed without landing.", :overview, 0, 1, "Identifying the first mission is useful orientation rather than decisive evidence." ],
  [ "Approximately how much lunar material did the six landing missions return to Earth?",
    [ "22 kilograms", "84 kilograms", "1,200 kilograms", "382 kilograms" ], 3,
    "The Apollo missions returned 2,196 catalogued samples with a combined mass of about 382 kilograms.", :samples, 1, 3, "A large, varied and continuing physical sample collection is foundational evidence." ],
  [ "What continues to happen to sealed Apollo samples as analytical methods improve?",
    [ "Researchers obtain new geological results from them", "They become chemically identical to Earth soil", "Their recorded collection sites are discarded", "They can no longer be examined" ], 0,
    "Curated material is still allocated and analysed with techniques unavailable in the 1970s, producing peer-reviewed lunar science.", :samples, 1, 2, "Continuing reproducible research is significant corroboration beyond contemporary broadcasts." ],
  [ "What has the Lunar Reconnaissance Orbiter photographed at all six Apollo landing sites?",
    [ "Only natural craters", "Hardware and surface traces at the recorded locations", "Six intact ascent stages still flying", "Modern replacement landers" ], 1,
    "High-resolution orbital images show descent stages and, depending on the site, experiment packages and tracks at every Apollo location.", :lro, 1, 3, "Later orbital observations matching six recorded sites are foundational physical corroboration." ],
  [ "Can present-day Earth-based optical telescopes resolve an Apollo lunar module on the Moon?",
    [ "Yes, with an amateur telescope", "Yes, but only in daylight", "No; the hardware is below their resolving power", "No, because the near side is never visible" ], 2,
    "A lunar module is only a few metres wide at roughly 384,000 kilometres, below the angular resolution of Earth-based optical telescopes.", :lro, -1, 1, "This prevents overstating what ordinary observers can verify and is a supporting limitation." ],
  [ "Which Apollo crews placed laser-ranging retroreflector arrays on the Moon?",
    [ "Apollo 8, 10 and 13", "Apollo 12 and 16 only", "Every Apollo flight", "Apollo 11, 14 and 15" ], 3,
    "Apollo 11, 14 and 15 deployed arrays whose locations are still ranged from Earth.", :reflectors, 1, 3, "Operating equipment at recorded landing sites is foundational evidence of delivered hardware." ],
  [ "Why do lunar observatories time laser pulses reflected from the Moon?",
    [ "To measure the Earth–Moon distance precisely", "To illuminate the whole lunar surface", "To transmit television pictures", "To determine the astronauts' heart rates" ], 0,
    "The round-trip travel time gives a precise range and supports measurements of lunar motion, rotation and gravity.", :ranging, 1, 2, "Repeated measurements provide significant, independently reproducible evidence of reflector locations." ],
  [ "Do the Apollo retroreflectors alone prove that people, rather than robots, placed them?",
    [ "Yes, because robots cannot carry glass", "No; Soviet robotic rovers also placed reflectors", "Yes, because only humans can aim them", "No, because no reflector has returned light" ], 1,
    "Lunokhod 1 and 2 carried Soviet reflectors, so reflector returns establish hardware on the Moon but are not by themselves proof of a crewed delivery.", :reflectors, -1, 3, "Understanding the evidential limit of a famous argument is foundational to sound assessment." ],
  [ "What was Jodrell Bank in Britain monitoring during the Apollo 11 landing period?",
    [ "Only a prerecorded NASA television feed", "Weather balloons over Britain", "Apollo signals alongside the Soviet Luna 15 mission", "No spacecraft because its telescope was offline" ], 2,
    "Jodrell Bank recorded Apollo transmissions while tracking Luna 15, whose attempted robotic landing ended in a crash.", :jodrell, 1, 2, "Observation outside the US programme is significant evidence against a wholly closed fabrication." ],
  [ "What did Apollo 12 astronauts retrieve from the Surveyor 3 site?",
    [ "A Soviet sample capsule", "An Apollo 11 camera", "A meteorite from Mars", "Parts of a robotic probe that had landed in 1967" ], 3,
    "Apollo 12 landed near Surveyor 3 and returned selected parts of the earlier robotic lander for laboratory examination.", :surveyor, 1, 3, "Reaching a previously photographed robotic site and returning its hardware is foundational cross-mission evidence." ],
  [ "Why are stars generally absent from photographs exposed for the sunlit lunar surface?",
    [ "The short exposures make faint stars too dim to record", "Stars cannot be seen from the Moon", "The photographs were all taken inside a studio", "Lunar gravity switches off starlight" ], 0,
    "Exposure settings suitable for bright suits and ground do not record much fainter stars, just as daytime Earth photographs usually do not.", :photography, 1, 1, "This resolves a common photographic misconception but is not strong independent evidence." ],
  [ "What primarily determines the direction of an object's shadow on uneven lunar ground?",
    [ "Its nationality", "The light direction plus local slope and perspective", "Whether the camera is colour or monochrome", "The object's mass alone" ], 1,
    "Parallel sunlight can produce apparently non-parallel lines in a perspective image, while slopes alter where shadows meet the ground.", :photography, 1, 2, "Shadow geometry is significant because divergent shadows are frequently presented as evidence of studio lighting." ],
  [ "Why can a planted flag continue moving briefly after an astronaut stops handling it?",
    [ "A steady lunar wind", "Hidden fans around the lander", "Inertia and motion of its supporting pole", "Exhaust from an orbiting spacecraft" ], 2,
    "With no air to damp it, fabric disturbed through the pole can oscillate; video does not show continuous wind-driven motion.", :photography, 1, 1, "The behaviour addresses a familiar objection but carries only supporting weight." ],
  [ "What happened to the Apollo ascent stages after they lifted crews from the surface?",
    [ "They returned intact to Earth", "They remained beside the descent stages", "They became permanent lunar satellites", "They rendezvoused with the command module in lunar orbit" ], 3,
    "Each lunar module ascent stage carried its two astronauts back to a command module already orbiting the Moon.", :missions, 0, 2, "The rendezvous architecture is significant to understanding what hardware images should show." ],
  [ "How were Apollo spacecraft followed when they were far beyond low Earth orbit?",
    [ "Radio tracking, ranging and telemetry from geographically separated stations", "A single television aerial in Houston", "Visual observation by the crew's families", "Navigation without any communication" ], 0,
    "The worldwide tracking network measured radio signals, range and mission telemetry through translunar flight and lunar operations.", :report, 1, 2, "Multiple geographically separated measurements are significant evidence of the flown trajectories." ],
  [ "Did Apollo crews spend most of their journey inside the most intense parts of Earth's radiation belts?",
    [ "Yes, for several weeks", "No; their trajectories crossed them comparatively quickly", "Yes, until lunar orbit insertion", "No, because the belts did not yet exist" ], 1,
    "Apollo trajectories crossed the belts rather than remaining within them; personal dosimeters recorded total mission exposure.", :radiation, 1, 1, "Transit time is supporting context for evaluating radiation objections." ],
  [ "What did Apollo personal dosimeters show about crew radiation exposure?",
    [ "No radiation was measurable anywhere", "Every crew received an immediately fatal dose", "Doses varied but remained below acute radiation-sickness levels", "Radiation was measured only after landing" ], 2,
    "Recorded mission doses were real and variable, but far below levels expected to cause acute radiation sickness.", :radiation, 1, 2, "Measured exposure is significant to whether the missions were physically survivable." ],
  [ "Why does lunar dust fall in sharp arcs rather than forming lingering airborne clouds?",
    [ "It is attracted to cameras", "It contains no small grains", "Astronaut boots chemically neutralise it", "The Moon has essentially no atmosphere to suspend it" ], 3,
    "Dust follows ballistic paths and falls promptly because there is no substantial air to keep particles aloft.", :photography, 1, 2, "Recorded dust motion is significant physical behaviour consistent across missions." ],
  [ "Why can bright white areas appear to cover a camera crosshair in a scanned Apollo image?",
    [ "Overexposure can bleed across the thin dark mark", "Crosshairs were painted behind studio scenery", "The Moon emits X-rays that erase film", "Only digital cameras can record crosshairs" ], 0,
    "High-brightness areas can saturate film and later scans, obscuring a fine fiducial line without placing the photographed object in front of it.", :photography, 1, 1, "This is a supporting explanation of an image artefact, not independent proof." ],
  [ "Were all widely circulated Apollo photographs taken by one camera under one set of lighting conditions?",
    [ "Yes, during one afternoon", "No; six sites and many cameras, films and viewing geometries were involved", "Yes, because only Apollo 11 carried cameras", "No; none used photographic film" ], 1,
    "The photographic record spans six landing missions, surface and orbital cameras, changing Sun angles and extensive sequences.", :photography, 0, 1, "Breadth of the archive is useful context but quality matters more than quantity." ],
  [ "What pattern appears in later orbital images of Apollo rover routes?",
    [ "Tracks at random sites unrelated to mission maps", "No disturbance anywhere", "Routes and experiment locations matching surface records", "One identical route copied at all sites" ], 2,
    "LRO images show disturbed paths and hardware positions corresponding to traverses documented decades earlier.", :lro, 1, 3, "Agreement between old surface records and later orbital mapping is foundational corroboration." ],
  [ "Who operates the Lunar Reconnaissance Orbiter that produced the best-known modern Apollo-site images?",
    [ "The European Space Agency", "A private newspaper", "The Soviet Academy of Sciences", "NASA, with camera operations at Arizona State University" ], 3,
    "LRO is a NASA mission and its camera facility is associated with Arizona State University; it is later evidence, but not institutionally independent of NASA.", :lro, -1, 2, "Institutional provenance is significant when assessing how independent a line of evidence is." ],
  [ "How did Apollo surface television reach viewers on Earth?",
    [ "Radio signals received by ground stations were converted for broadcast", "Film reels were flown back before transmission", "A cable ran from the Moon to Houston", "Commercial satellites filmed the astronauts from lunar orbit" ], 0,
    "Stations received the spacecraft's radio television signal and standards-converted it for terrestrial networks.", :report, 1, 2, "A live radio link integrated with tracking is significant evidence, though recordings can be misunderstood." ],
  [ "What happened to the command modules and crews at the end of landing missions?",
    [ "They remained in lunar orbit", "They re-entered and were recovered from the ocean", "They landed on the Moon beside the lunar modules", "They transferred to Soviet spacecraft" ], 1,
    "The command modules returned through Earth's atmosphere and splashed down for recovery with crews and samples.", :missions, 0, 2, "Recovery completes the physical mission chain and is significant context." ],
  [ "Why were astronauts initially quarantined after early Apollo landings?",
    [ "They had exceeded an immigration limit", "Their identities were uncertain", "Officials had not yet excluded possible biological hazards from lunar material", "Radiation made them permanently contagious" ], 2,
    "Early crews and samples were isolated under a precautionary planetary-protection policy until lunar material was better understood.", :archive, 0, 1, "Quarantine is historical context and neither proves nor undermines a landing." ],
  [ "Did the Soviet Union return its own lunar samples robotically during the Apollo era?",
    [ "No country returned any lunar material", "Yes, but only before Apollo 11", "Yes, and in a larger mass than Apollo", "Yes; Luna missions returned much smaller samples" ], 3,
    "Soviet Luna missions returned small robotic samples, showing that sample return alone need not be crewed while providing material for comparison.", :luna, -1, 2, "The robotic alternative is significant when judging exactly what samples do and do not prove." ],
  [ "Which overall account best fits the Apollo samples, tracking, surface equipment, photographs and later landing-site images together?",
    [ "Six crewed landings produced the mutually consistent records", "Every record independently establishes a crewed landing on its own", "The evidence identifies only an uncrewed mission", "No physical prediction differs between landing and fabrication" ], 0,
    "No single item carries the whole conclusion. The crewed-landing account explains many different records, while limitations such as robotic reflectors should be kept explicit.", :report, 1, 3, "Coherence across independent evidence, with limits acknowledged, is foundational to the proposition." ],
  [ "What remains a legitimate limitation of the evidence currently available to most people about the crewed Apollo Moon landings?",
    [ "No Apollo mission generated telemetry", "No later crew from an independent programme has revisited an Apollo site", "No lunar sample has been studied since 1972", "No spacecraft has imaged any landing site" ], 1,
    "Later orbiters and laboratories provide corroboration, but no independent human expedition has yet revisited and inspected an Apollo site in person.", :lro, -1, 3, "The strongest genuine verification limit is foundational to avoiding an appeal to authority." ]
], MOON_LANDING_SOURCES)

# Keep verbosity from identifying the answer; these remain plausible competing accounts.
MOON_LANDING_FACTS.fetch(4)[:options][1] = "Researchers increasingly report that storage contamination makes the collection unusable"
MOON_LANDING_FACTS.fetch(5)[:options][2] = "Only broad patches of disturbed ground without hardware at the recorded coordinates"
MOON_LANDING_FACTS.fetch(6)[:options][3] = "No, because atmospheric turbulence prevents resolving objects below several kilometres wide"
MOON_LANDING_FACTS.fetch(8)[:options][3] = "To compare surface brightness at different lunar phases with calibrated instruments"
MOON_LANDING_FACTS.fetch(9)[:options][3] = "No, because the reported returns cannot be distinguished from reflection by ordinary lunar rock"
MOON_LANDING_FACTS.fetch(10)[:options][3] = "Apollo carrier signals relayed from an Earth-orbiting communications satellite"
MOON_LANDING_FACTS.fetch(11)[:options][0] = "A component from an earlier American orbiter believed to have reached the same region"
MOON_LANDING_FACTS.fetch(12)[:options][2] = "The cameras used filters designed to remove point sources from the black background"
MOON_LANDING_FACTS.fetch(13)[:options][2] = "A nearby fill light placed roughly along the camera axis in addition to the main source"
MOON_LANDING_FACTS.fetch(14)[:options][3] = "Gas vented intermittently from the life-support backpack after the astronaut moved away"
MOON_LANDING_FACTS.fetch(15)[:options][2] = "They followed independent trajectories and were later recovered from different ocean areas"
MOON_LANDING_FACTS.fetch(16)[:options][2] = "Optical sightings alone, with later trajectory values reconstructed from the crew's reports"
MOON_LANDING_FACTS.fetch(17)[:options][3] = "No, because mission planners scheduled each crossing when solar activity temporarily removed the belts"
