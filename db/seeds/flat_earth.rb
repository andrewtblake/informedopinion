FLAT_EARTH_FACTS = [
  {
    prompt: "Which description best matches Earth's measured overall shape?",
    options: [ "An irregular ellipsoid, slightly flattened at the poles", "A flat circular disk", "A perfect sphere with no surface variation", "A cylinder capped by polar ice" ],
    correct_option: 0,
    explanation: "Geodesy measures Earth as an irregular ellipsoid: nearly spherical, slightly flattened at the poles, and locally varied by topography and gravity.",
    source_name: "NOAA National Ocean Service",
    source_url: "https://oceanservice.noaa.gov/facts/earth-round.html",
    evidence_direction: -1
  },
  {
    prompt: "What is Earth's measured equatorial diameter?",
    options: [ "About 6,378 km", "About 12,756 km", "About 40,075 km", "About 149.6 million km" ],
    correct_option: 1,
    explanation: "NASA gives an equatorial diameter of 12,756 kilometres; 6,378 kilometres is approximately the equatorial radius.",
    source_name: "NASA Earth facts",
    source_url: "https://science.nasa.gov/earth/facts/",
    evidence_direction: -1
  },
  {
    prompt: "Why is Earth's equatorial diameter slightly larger than its polar diameter?",
    options: [ "Ocean tides permanently pile water at the equator", "The equator is closer to the Sun", "Rotation produces an equatorial bulge", "Mountain ranges occur only near the equator" ],
    correct_option: 2,
    explanation: "Earth's rotation contributes to a slight equatorial bulge and polar flattening.",
    source_name: "NOAA National Ocean Service",
    source_url: "https://oceanservice.noaa.gov/facts/earth-round.html",
    evidence_direction: -1
  },
  {
    prompt: "What is the geoid used by geodesists?",
    options: [ "A flat plane through the equator", "The solid surface beneath the oceans", "A perfect mathematical sphere", "An equipotential gravity surface that best fits global mean sea level" ],
    correct_option: 3,
    explanation: "NOAA defines the geoid as an equipotential surface of Earth's gravity field that best fits global mean sea level.",
    source_name: "NOAA National Geodetic Survey",
    source_url: "https://geodesy.noaa.gov/GEOID/geoid_def.html",
    evidence_direction: -1
  },
  {
    prompt: "What does the EPIC instrument aboard DSCOVR image?",
    options: [ "The entire sunlit face of Earth", "Only a narrow strip directly below the spacecraft", "Only Earth's polar regions", "A computer model without camera observations" ],
    correct_option: 0,
    explanation: "EPIC repeatedly records the entire sunlit face of Earth from the Sun–Earth L1 region.",
    source_name: "NASA EPIC",
    source_url: "https://epic.gsfc.nasa.gov/about/epic",
    evidence_direction: -1
  },
  {
    prompt: "Approximately how far from Earth is the DSCOVR spacecraft while taking full-Earth images?",
    options: [ "250 miles", "One million miles", "93 million miles", "12,756 kilometres" ],
    correct_option: 1,
    explanation: "DSCOVR operates near the Sun–Earth L1 point, approximately one million miles from Earth.",
    source_name: "NASA Science: DSCOVR",
    source_url: "https://science.nasa.gov/mission/dscovr/",
    evidence_direction: -1
  },
  {
    prompt: "How long does the International Space Station take to orbit Earth once?",
    options: [ "About 24 hours", "About 12 hours", "About 90 minutes", "About 365 days" ],
    correct_option: 2,
    explanation: "The station travels at roughly 17,500 mph and completes an orbit in about 90 minutes.",
    source_name: "NASA Space Station facts",
    source_url: "https://www.nasa.gov/international-space-station/space-station-facts-and-figures/",
    evidence_direction: -1
  },
  {
    prompt: "How many sunrises and sunsets does an ISS crew typically experience in 24 hours?",
    options: [ "One of each", "Two of each", "Eight of each", "Sixteen of each" ],
    correct_option: 3,
    explanation: "About 16 ninety-minute orbits per day produce approximately 16 sunrises and sunsets.",
    source_name: "NASA Space Station facts",
    source_url: "https://www.nasa.gov/international-space-station/space-station-facts-and-figures/",
    evidence_direction: -1
  },
  {
    prompt: "What alignment produces a lunar eclipse?",
    options: [ "The Moon passes through Earth's shadow with Earth between Sun and Moon", "Earth passes through the Moon's shadow at new moon", "The Sun passes between Earth and Moon", "The Moon passes behind the Sun" ],
    correct_option: 0,
    explanation: "A lunar eclipse occurs when the Sun, Earth, and Moon align so the Moon enters Earth's shadow.",
    source_name: "NASA Science",
    source_url: "https://science.nasa.gov/solar-system/moon/an-almost-total-lunar-eclipse/",
    evidence_direction: -1
  },
  {
    prompt: "What shape is Earth's umbral shadow observed to have during partial lunar eclipses?",
    options: [ "Rectangular", "Round regardless of the Moon's position in the sky", "Triangular", "Different at every eclipse with no repeatable geometry" ],
    correct_option: 1,
    explanation: "NASA's eclipse account notes that Earth's shadow is round whether the eclipsed Moon is high or near the horizon.",
    source_name: "NASA Eclipse Web Site",
    source_url: "https://eclipse.gsfc.nasa.gov/LEcat5/appearance.html",
    evidence_direction: -1
  },
  {
    prompt: "What do NASA's lunar-eclipse catalogues calculate?",
    options: [ "Only eclipses already photographed", "Approximate dates without visibility regions", "The Moon's path through Earth's penumbral and umbral shadows and geographic visibility", "Weather conditions during each eclipse" ],
    correct_option: 2,
    explanation: "The catalogues calculate eclipse geometry, contact times, shadow paths, durations, and geographic visibility.",
    source_name: "NASA Eclipse Web Site",
    source_url: "https://eclipse.gsfc.nasa.gov/LEcat5/figure.html",
    evidence_direction: -1
  },
  {
    prompt: "What did Léon Foucault's pendulum demonstrate using laboratory apparatus in 1851?",
    options: [ "Earth's annual orbit around the Sun", "The distance between Earth and Moon", "The speed of light", "Earth's rotation" ],
    correct_option: 3,
    explanation: "The pendulum's swing plane remains comparatively fixed while Earth rotates beneath it.",
    source_name: "Smithsonian Institution",
    source_url: "https://www.si.edu/spotlight/foucault-pendulum",
    evidence_direction: -1
  },
  {
    prompt: "How long does Earth take to complete one rotation relative to the Sun?",
    options: [ "About 23.9 hours", "About 90 minutes", "About 29.5 days", "About 365.25 days" ],
    correct_option: 0,
    explanation: "NASA gives Earth's length of day as approximately 23.9 hours.",
    source_name: "NASA Earth facts",
    source_url: "https://science.nasa.gov/earth/facts/",
    evidence_direction: -1
  },
  {
    prompt: "How long does Earth take to complete one orbit around the Sun?",
    options: [ "23.9 hours", "About 365.25 days", "About 27.3 days", "Exactly 400 days" ],
    correct_option: 1,
    explanation: "Earth completes its solar orbit in approximately 365.25 days.",
    source_name: "NASA Earth facts",
    source_url: "https://science.nasa.gov/earth/facts/",
    evidence_direction: -1
  },
  {
    prompt: "What principally causes Earth's yearly cycle of seasons?",
    options: [ "Earth's daily rotation", "Changes in the Sun's energy output every six months", "Earth's 23.4-degree axial tilt during its solar orbit", "The Moon alternately warming each hemisphere" ],
    correct_option: 2,
    explanation: "Earth's tilted axis changes solar angle and day length in each hemisphere over the course of its orbit.",
    source_name: "NASA Earth facts",
    source_url: "https://science.nasa.gov/earth/facts/",
    evidence_direction: -1
  },
  {
    prompt: "When the Northern Hemisphere is tilted toward the Sun, what season ordinarily occurs in the Southern Hemisphere?",
    options: [ "Summer as well", "Spring only", "No season", "Winter" ],
    correct_option: 3,
    explanation: "The hemispheres receive contrasting solar angles and day lengths, producing opposite seasons.",
    source_name: "NASA Earth facts",
    source_url: "https://science.nasa.gov/earth/facts/",
    evidence_direction: -1
  },
  {
    prompt: "What daylight pattern occurs at the geographic South Pole during its summer?",
    options: [ "Continuous daylight for several months", "A normal twelve-hour day throughout the year", "One hour of daylight each day", "Daily sunrise and sunset every six hours" ],
    correct_option: 0,
    explanation: "At the pole, the Sun remains above the horizon continuously for several summer months.",
    source_name: "Australian Antarctic Program",
    source_url: "https://www.antarctica.gov.au/about-antarctica/weather-and-climate/weather/sunlight-hours/",
    evidence_direction: -1
  },
  {
    prompt: "At approximately what latitude is the Antarctic Circle?",
    options: [ "23°26′ south", "66°34′ south", "45° south", "90° south" ],
    correct_option: 1,
    explanation: "The Antarctic Circle lies near 66°34′ south, beyond which the Sun can remain above or below the horizon for a full day seasonally.",
    source_name: "Australian Antarctic Program",
    source_url: "https://www.antarctica.gov.au/about-antarctica/weather-and-climate/weather/sunlight-hours/",
    evidence_direction: -1
  },
  {
    prompt: "How does Earth's rotation deflect long-distance motion in the two hemispheres?",
    options: [ "Left in both hemispheres", "Right in both hemispheres", "Right in the Northern Hemisphere and left in the Southern", "It produces no measurable deflection" ],
    correct_option: 2,
    explanation: "The Coriolis effect produces opposite apparent deflections north and south of the equator.",
    source_name: "NOAA NESDIS",
    source_url: "https://www.nesdis.noaa.gov/about/k-12-education/atmosphere/what-the-coriolis-effect",
    evidence_direction: -1
  },
  {
    prompt: "What large-scale storm rotation does NOAA describe?",
    options: [ "All tropical cyclones rotate clockwise", "Storm direction depends only on longitude", "All tropical cyclones rotate counterclockwise", "Northern cyclones generally rotate counterclockwise and Southern cyclones clockwise" ],
    correct_option: 3,
    explanation: "Opposite Coriolis deflections lead large low-pressure systems to rotate in opposite directions across the hemispheres.",
    source_name: "NOAA NESDIS",
    source_url: "https://www.nesdis.noaa.gov/about/k-12-education/atmosphere/what-the-coriolis-effect",
    evidence_direction: -1
  },
  {
    prompt: "Relative to what surface does high-precision GPS determine ellipsoidal position and height?",
    options: [ "A mathematically defined Earth ellipsoid", "A universal flat sea-level plane", "The nearest local road surface", "A cylinder aligned with the equator" ],
    correct_option: 0,
    explanation: "GPS positioning is calculated relative to a defined Earth ellipsoid.",
    source_name: "NOAA National Geodetic Survey",
    source_url: "https://geodesy.noaa.gov/GEOID/GSVS/global-positioning.shtml",
    evidence_direction: -1
  },
  {
    prompt: "What does the scientific discipline of geodesy measure and monitor?",
    options: [ "Only ocean depth", "Earth's size, shape, gravity field, and surface positions", "Only the distance to other planets", "Weather forecasts without geographic coordinates" ],
    correct_option: 1,
    explanation: "Geodesy determines Earth's size and shape, its gravity field, and precise locations on its surface.",
    source_name: "NOAA National Ocean Service",
    source_url: "https://oceanservice.noaa.gov/facts/earth-round.html",
    evidence_direction: -1
  },
  {
    prompt: "Why is a geoid model needed when converting GPS height to height above mean sea level?",
    options: [ "GPS cannot measure any height", "Mean sea level is a flat plane everywhere", "GPS ellipsoidal height and gravity-based orthometric height use different reference surfaces", "Satellites transmit only horizontal coordinates" ],
    correct_option: 2,
    explanation: "GPS provides ellipsoidal height, while conventional elevation follows a gravity-based geoid; conversion requires their separation.",
    source_name: "NOAA National Geodetic Survey",
    source_url: "https://www.ngs.noaa.gov/PUBS_LIB/gislis96.html",
    evidence_direction: -1
  },
  {
    prompt: "What is a map projection?",
    options: [ "A photograph that preserves every distance and area", "Proof that the represented surface is flat", "A list of place names without coordinates", "A two-dimensional representation of a three-dimensional sphere, ellipsoid, or irregular body" ],
    correct_option: 3,
    explanation: "Projection is the mathematical process of representing a three-dimensional body on a two-dimensional map.",
    source_name: "U.S. Geological Survey",
    source_url: "https://astrogeology.usgs.gov/docs/concepts/camera-geometry-and-projections/learning-about-map-projections/",
    evidence_direction: -1
  },
  {
    prompt: "In the Northern Hemisphere, what simple astronomical observation can estimate latitude?",
    options: [ "The elevation angle of Polaris above the horizon", "The apparent colour of Mars", "The Moon's phase alone", "The width of the Milky Way" ],
    correct_option: 0,
    explanation: "The elevation of Polaris provides a simple approximation of an observer's northern latitude.",
    source_name: "NOAA: Geodesy for the Layman",
    source_url: "https://geodesy.noaa.gov/PUBS_LIB/Geodesy4Layman/TR80003A.HTM",
    evidence_direction: -1
  },
  {
    prompt: "In geodetic surveying, how is a properly levelled instrument's vertical axis oriented?",
    options: [ "Parallel to every local water surface", "Along the local direction of gravity and perpendicular to the geoid", "Toward the geographic North Pole", "Parallel to Earth's rotational axis everywhere" ],
    correct_option: 1,
    explanation: "A plumb or level follows local gravity, which is perpendicular to the geopotential surface.",
    source_name: "NOAA: Geodesy for the Layman",
    source_url: "https://geodesy.noaa.gov/PUBS_LIB/Geodesy4Layman/TR80003A.HTM",
    evidence_direction: -1
  },
  {
    prompt: "How would freely connected oceans settle if tides, currents, and winds were removed?",
    options: [ "On one infinite Euclidean plane", "At unrelated heights determined only by continents", "Along an equipotential surface of Earth's gravity field", "Into a cylinder around the equator" ],
    correct_option: 2,
    explanation: "Water follows gravity; the geoid represents the equipotential surface that best corresponds to global mean sea level.",
    source_name: "NOAA National Geodetic Survey",
    source_url: "https://geodesy.noaa.gov/research/geopotential-datums/geopotential-surface.shtml",
    evidence_direction: -1
  },
  {
    prompt: "How does NASA rank Earth by size among the planets in the solar system?",
    options: [ "Smallest", "Second largest", "Largest", "Fifth largest" ],
    correct_option: 3,
    explanation: "Earth is the fifth-largest planet and the largest of the four terrestrial planets.",
    source_name: "NASA Earth facts",
    source_url: "https://science.nasa.gov/earth/facts/",
    evidence_direction: -1
  },
  {
    prompt: "Approximately what angular width does the entire Earth present to EPIC near the L1 point?",
    options: [ "About 0.5 degrees", "About 5 degrees", "About 45 degrees", "About 180 degrees" ],
    correct_option: 0,
    explanation: "Earth's apparent diameter varies roughly from 0.45 to 0.53 degrees from EPIC's operating region.",
    source_name: "NASA EPIC",
    source_url: "https://epic.gsfc.nasa.gov/about/epic",
    evidence_direction: -1
  },
  {
    prompt: "Why can the International Space Station be seen from the ground around dawn or dusk?",
    options: [ "It produces a continuous visible flame", "It reflects sunlight", "It projects an artificial image onto the sky", "It is visible only through radio signals" ],
    correct_option: 1,
    explanation: "Like the Moon, the station is visible because it reflects sunlight; favourable passes occur when it is illuminated against a darker sky.",
    source_name: "NASA Spot the Station",
    source_url: "https://www.nasa.gov/missions/station/spot-the-station-frequently-asked-questions/",
    evidence_direction: -1
  }
].freeze
