FLAT_EARTH_FACTS = [
  {
    prompt: "If observers face the celestial pole visible from their hemisphere, how do long-exposure star trails turn?",
    options: [
      "In opposite senses: anticlockwise around the north celestial pole and clockwise around the south celestial pole",
      "Clockwise around both poles",
      "In the same sense everywhere because the stars circle above one flat surface",
      "Randomly, with no stable centre of rotation"
    ],
    correct_option: 0,
    explanation: "This can be checked with fixed cameras in the two hemispheres. Each records concentric trails, but the apparent direction reverses when the observer faces the relevant pole. A single set of lights circling above a disk predicts one common rotational sense when viewed from below; it does not produce two opposed celestial poles with reversed apparent rotation. A rotating globe does: observers face opposite ends of the same axis.",
    source_name: "University of Nebraska–Lincoln: Paths of the Stars",
    source_url: "https://astro.unl.edu/naap/motion2/starpaths.html",
    evidence_direction: -1
  },
  {
    prompt: "In the Northern Hemisphere, what happens to Polaris's angle above a level northern horizon as an observer travels north?",
    options: [
      "It stays at the same angle because the sky is a dome over a flat plane",
      "It rises by approximately one degree for every degree of latitude travelled north",
      "It falls until it reaches the horizon at the North Pole",
      "It changes only with longitude, not latitude"
    ],
    correct_option: 1,
    explanation: "An observer can measure the angle with a simple inclinometer. Polaris is near 0° elevation at the equator, about 50° high at 50° north, and almost overhead at the North Pole. Perspective above a plane can make an object appear lower with distance, but it does not make the measured elevation equal geographic latitude across thousands of locations while also fitting the southern sky. The globe geometry does so directly.",
    source_name: "University of Oklahoma: Movement and Patterns of the Sky",
    source_url: "https://www.nhn.ou.edu/~simpson/files/teacher/Part_1_Movement_and_Patterns_of_the_Sky.pdf",
    evidence_direction: -1
  },
  {
    prompt: "What happens to Polaris when an observer travels south across the equator?",
    options: [
      "It remains visible above the northern horizon everywhere on a flat Earth",
      "It moves toward the south celestial pole",
      "It drops below the northern horizon and cannot be seen",
      "It remains fixed at an elevation of about 45°"
    ],
    correct_option: 2,
    explanation: "Travellers can check this without specialised equipment: Polaris descends toward the northern horizon and is no longer visible from sufficiently far south. On a transparent, level plane, increasing distance can make a raised object approach the horizon, but cannot place it geometrically below that horizon. A curved surface naturally blocks the northern sky as the observer passes into the Southern Hemisphere.",
    source_name: "University of Oklahoma: Movement and Patterns of the Sky",
    source_url: "https://www.nhn.ou.edu/~simpson/files/teacher/Part_1_Movement_and_Patterns_of_the_Sky.pdf",
    evidence_direction: -1
  },
  {
    prompt: "What do observers in southern Australia, southern Africa and South America see southern stars circling around?",
    options: [
      "Polaris, seen through the Earth",
      "A different centre for each continent",
      "No centre; southern star trails are straight",
      "The same south celestial pole, in a direction due south from each location"
    ],
    correct_option: 3,
    explanation: "Fixed-camera trails from widely separated southern longitudes form circles about one common southern celestial pole. On the usual north-centred flat-disk map, 'south' points outward in different directions at those locations, so their sight lines do not meet at one celestial point. On a globe, all three observers face the same end of Earth's rotation axis.",
    source_name: "University of Nebraska–Lincoln: Paths of the Stars",
    source_url: "https://astro.unl.edu/naap/motion2/starpaths.html",
    evidence_direction: -1
  },
  {
    prompt: "When measured from a time-lapse photograph, at what angular rate do ordinary star trails turn around a celestial pole?",
    options: [
      "About 15° per hour, completing a circle in roughly one sidereal day",
      "Faster for stars near the horizon than for stars near the pole",
      "At rates that depend on each star's distance from the observer",
      "One complete circle per year"
    ],
    correct_option: 0,
    explanation: "Marking star positions against a fixed foreground shows that the whole sky turns through about 15° each hour. Stars trace different-sized circles but share the same angular rate. A collection of lights independently circling above a plane would need carefully varying linear speeds to maintain this rigid rotation; one rotating observer naturally gives every star the same angular rate.",
    source_name: "University of Nebraska–Lincoln: Paths of the Stars",
    source_url: "https://astro.unl.edu/naap/motion2/starpaths.html",
    evidence_direction: -1
  },
  {
    prompt: "If two observers at similar longitudes view the Moon simultaneously from well north and well south of the equator, how are its visible markings oriented?",
    options: [
      "Identically upright, as expected when everyone looks up at the same flat image",
      "Rotated by nearly 180° relative to one another",
      "Mirror-reversed left to right but not rotated",
      "Different markings are visible in each hemisphere"
    ],
    correct_option: 1,
    explanation: "The same craters are visible, but photographs taken at the same phase show the lunar disk substantially rotated. The observers are not seeing different Moons or a mirrored image: they face the same object from oppositely oriented local horizons on a globe. A single overhead image above a common flat plane supplies no corresponding reversal of 'up' between north and south.",
    source_name: "Planetary Science Institute: The Moon",
    source_url: "https://www.psi.edu/epo/ask-an-expert/moon/",
    evidence_direction: -1
  },
  {
    prompt: "What happens to the Sun's angular diameter when it is measured through a safely filtered camera from noon to near sunset?",
    options: [
      "It shrinks to less than half its noon diameter as it recedes",
      "It grows rapidly because the atmosphere magnifies it",
      "It remains close to half a degree, apart from small annual variation and optical distortion",
      "It becomes immeasurably small before reaching the horizon"
    ],
    correct_option: 2,
    explanation: "Pixel measurements made with the same lens and safe solar filter show essentially the same solar diameter throughout the day. A nearby Sun travelling away above a flat plane must become markedly smaller with distance; perspective cannot make it approach the horizon while preserving its angular size. A distant Sun seen from a rotating globe predicts the measured constancy. Never look directly at the Sun without certified protection.",
    source_name: "University of Wyoming: Planetarium laboratory",
    source_url: "https://physics.uwyo.edu/~mbrother/a1050f12/Labs1_6/Planetarium.pdf",
    evidence_direction: -1
  },
  {
    prompt: "During an unobstructed sea sunset, what does a magnified, safely filtered recording show the Sun doing?",
    options: [
      "Fading into a distant point while remaining wholly above the horizon",
      "Moving upward after its lower edge touches the horizon",
      "Shrinking to zero because perspective reaches its vanishing point",
      "Passing below the horizon edge while retaining approximately the same angular diameter"
    ],
    correct_option: 3,
    explanation: "A telephoto sequence shows the lower limb crossing the horizon first and the disk retaining nearly its usual diameter. The common flat-disk account says a nearby Sun merely recedes until perspective makes it vanish; that predicts substantial shrinkage and does not explain a sharp horizon progressively covering the disk from below. Refraction can deform the image, but it does not turn recession into this consistent occultation.",
    source_name: "Millersville University: A Holiday Measurement of Earth's Circumference",
    source_url: "https://www.millersville.edu/physics/experiments/058/",
    evidence_direction: -1
  },
  {
    prompt: "After the Sun's upper edge has passed below a clear sea horizon, what does increasing optical zoom do?",
    options: [
      "It enlarges the horizon but does not restore the Sun to view",
      "It brings the entire Sun back above the horizon",
      "It reveals the Sun circling horizontally at constant height",
      "It reverses sunset into sunrise"
    ],
    correct_option: 0,
    explanation: "Zoom enlarges angular detail already entering the camera; it cannot reveal light blocked by the horizon. Claims that perspective alone makes the Sun vanish predict that sufficient magnification should recover the receding disk. In controlled recordings it does not. Gaining physical height can briefly restore the Sun because the curved horizon moves farther away, which is a different operation from zooming.",
    source_name: "NASA Goddard: Distance to the Horizon",
    source_url: "https://pwg.gsfc.nasa.gov/stargaze/Shorizon.htm",
    evidence_direction: -1
  },
  {
    prompt: "As a distant ship travels away across calm water, which repeatable sequence is normally observed through a telescope?",
    options: [
      "The whole ship shrinks uniformly but remains visible down to its waterline",
      "The hull is hidden before the upper structure, and gaining observer height reveals more of the lower parts",
      "The mast disappears first because it is tallest",
      "Zoom always restores every hidden part from the same height"
    ],
    correct_option: 1,
    explanation: "The waterline and hull are lost before the mast; raising the observer lowers the intervening horizon and reveals more of the ship. Ordinary perspective makes the entire object smaller but does not selectively conceal it from the bottom behind a level boundary. Waves and refraction can affect a single sighting, so the useful test is repeated observations at known distances, heights and atmospheric conditions.",
    source_name: "NASA Goddard: Distance to the Horizon",
    source_url: "https://pwg.gsfc.nasa.gov/stargaze/Shorizon.htm",
    evidence_direction: -1
  },
  {
    prompt: "Ignoring atmospheric refraction, how does measured distance to a sea horizon change as eye height increases?",
    options: [
      "It is independent of height on a flat plane",
      "It increases directly in proportion to height",
      "It increases approximately with the square root of height",
      "It decreases because a higher observer looks down more steeply"
    ],
    correct_option: 2,
    explanation: "Observers can compare shoreline, mast or drone heights: the distance follows d ≈ √(2Rh), where h is eye height and R is about 6,371 km. A level infinite plane has no geometric horizon at a finite distance, so it predicts no square-root relation. Atmospheric refraction shifts individual results, especially close to the water, but repeated measurements cluster around the curved-surface rule.",
    source_name: "NASA Goddard: Distance to the Horizon",
    source_url: "https://pwg.gsfc.nasa.gov/stargaze/Shorizon.htm",
    evidence_direction: -1
  },
  {
    prompt: "What happens to the geometric horizon's angle relative to a truly level horizontal as an observer climbs?",
    options: [
      "It stays exactly at eye level at every altitude",
      "It rises above eye level",
      "It alternates above and below level with longitude",
      "It dips increasingly below level"
    ],
    correct_option: 3,
    explanation: "A level or calibrated theodolite at increasing altitude shows the distant horizon below the horizontal plane, with a larger dip at greater height. The flat-plane prediction is a horizon at eye level regardless of altitude. Camera lens distortion can imitate curvature or tilt, so a levelled instrument and a horizon placed on the optical axis are required for a careful test.",
    source_name: "Applied Optics: Visually discerning the curvature of the Earth",
    source_url: "https://pubmed.ncbi.nlm.nih.gov/19037349/",
    evidence_direction: -1
  },
  {
    prompt: "When two observers far apart north–south measure a vertical stick's shadow at their respective local noon, what can their angle difference and separation be used to calculate?",
    options: [
      "A repeatable Earth circumference, approximately 40,000 km",
      "Only the height of a nearby Sun above a flat plane",
      "The distance to Polaris",
      "Nothing, because parallel sunlight must cast identical shadows everywhere"
    ],
    correct_option: 0,
    explanation: "The experiment needs only sticks, clocks, measured separation and shadow angles. Many pairs can repeat it: angle difference divided by surface distance gives a consistent circumference. A flat model can fit one pair by choosing a nearby Sun height, but different pairs and more than two locations do not preserve one common height, whereas they converge on one globe radius.",
    source_name: "Bucknell University: Eratosthenes and the Size of Earth",
    source_url: "https://www.eg.bucknell.edu/physics/astronomy/astr101/specials/eratosthenes.html",
    evidence_direction: -1
  },
  {
    prompt: "If simultaneous stick-shadow angles from three or more widely separated cities are interpreted using a flat plane and nearby Sun, what happens to the inferred height of that Sun?",
    options: [
      "Every pair gives exactly the same height",
      "Different city pairs generally require incompatible heights",
      "The height is always zero",
      "The result is independent of the cities' separation"
    ],
    correct_option: 1,
    explanation: "On a plane, each observed elevation angle and ground distance triangulates a supposedly nearby Sun. Applying that construction to several cities produces no single height that fits them all. The curved-Earth construction instead treats the sunlight as nearly parallel and the local verticals as differently oriented; the same measurements then yield a consistent radius. This is why using a network of observers is stronger than the classic two-stick demonstration.",
    source_name: "University of Texas: Repeat Eratosthenes' experiment",
    source_url: "https://outreach.as.utexas.edu/marykay/assignments/eratos1.html",
    evidence_direction: -1
  },
  {
    prompt: "Around an equinox, where can observers at widely separated latitudes directly see the Sun rise and set, allowing for local terrain and refraction?",
    options: [
      "Rise north and set south everywhere",
      "Rise and set at the same northern point",
      "Rise approximately due east and set approximately due west",
      "Circle clockwise without crossing the horizon"
    ],
    correct_option: 2,
    explanation: "A compass-corrected observation on an equinox finds sunrise near east and sunset near west over a broad range of latitudes. One tilted plane illuminated by a nearby Sun circling above it does not naturally give every observer these opposed horizon crossings on the same date. A globe with the day–night boundary passing through both poles does.",
    source_name: "Griffith Observatory: Sun and Stars' Paths",
    source_url: "https://griffithobservatory.lacity.gov/exhibits/ahmanson-hall-of-the-sky/sun-stars-paths/",
    evidence_direction: -1
  },
  {
    prompt: "When equal northern and southern latitudes are compared through a year, what broad daylight pattern is measured?",
    options: [
      "Both hemispheres always lengthen and shorten their days together",
      "Only northern day length changes",
      "Every latitude has exactly 12 hours of daylight every day",
      "Their seasonal changes are opposed: long northern days coincide with short southern days"
    ],
    correct_option: 3,
    explanation: "Anyone can compare dated sunrise and sunset observations with a counterpart in the other hemisphere. The patterns reverse around the equinoxes. A small Sun circling above a flat disk can vary illumination with radius, but it does not reproduce the measured, symmetric opposition of day lengths across both hemispheres without additional ad hoc light restrictions. An axially tilted globe does.",
    source_name: "US National Weather Service: Astronomical seasons",
    source_url: "https://www.weather.gov/dvn/Climate_Astronomical_Seasons",
    evidence_direction: -1
  },
  {
    prompt: "During southern summer, what can an observer south of the Antarctic Circle record over a continuous 24-hour period?",
    options: [
      "The Sun circling through all azimuths without setting on suitable dates",
      "The Sun setting every evening, as a north-centred flat-disk model requires",
      "The Sun remaining fixed due north",
      "Two separate Suns alternating at twelve-hour intervals"
    ],
    correct_option: 0,
    explanation: "This is a direct observation, not one that logically depends on a space agency: residents, visitors and independently operated cameras can follow the Sun continuously. On the common flat-disk map, a Sun circling above the disk may remain visible in the north, but it cannot circle an Antarctic observer through every compass direction. The southern polar day is the counterpart of the observable Arctic midnight Sun on a tilted globe.",
    source_name: "European Space Agency: 24 hours in Antarctica",
    source_url: "https://www.esa.int/esatv/Videos/2021/10/24_hrs_in_Antarctica",
    evidence_direction: -1
  },
  {
    prompt: "During a partial lunar eclipse, what shape can an observer directly see Earth's shadow make across the Moon?",
    options: [
      "A straight edge, as a flat disk seen face-on would cast",
      "A circular arc",
      "A triangular notch",
      "A different polygon at each eclipse"
    ],
    correct_option: 1,
    explanation: "The boundary entering and leaving the lunar disk is consistently curved. A circular disk can cast a round shadow only when it faces the Moon directly; at other orientations it casts an ellipse or narrow line. A sphere casts a circular outline from every direction, matching eclipses observed with the Moon in different parts of the sky.",
    source_name: "NASA Eclipse Web Site: Appearance of lunar eclipses",
    source_url: "https://eclipse.gsfc.nasa.gov/LEcat5/appearance.html",
    evidence_direction: -1
  },
  {
    prompt: "Using only repeated observations of Sun, Moon and shadows, what can eclipse geometry predict in advance?",
    options: [
      "Only whether an eclipse occurs, never where it is visible",
      "A lunar eclipse for every full Moon",
      "Different times for each observer with no geographic pattern",
      "Contact times, duration and the geographic regions from which each eclipse is visible"
    ],
    correct_option: 3,
    explanation: "Predictions can be checked by observers inside and outside the stated visibility region. One coherent spherical geometry produces the contact times and geographic boundaries together. A claim that an unseen object or unexplained mechanism causes eclipses can accommodate an event after the fact, but without specified dimensions and motion it does not independently calculate when, how long and where the event will occur.",
    source_name: "NASA Eclipse Web Site: Lunar eclipse figures",
    source_url: "https://eclipse.gsfc.nasa.gov/LEcat5/figure.html",
    evidence_direction: -1
  },
  {
    prompt: "How does the daily precession rate of a well-built Foucault pendulum vary with latitude?",
    options: [
      "It is proportional to the sine of latitude: zero at the equator and greatest at the poles",
      "It is identical everywhere on a stationary flat plane",
      "It depends only on the pendulum's mass",
      "It is greatest at the equator and zero at the poles"
    ],
    correct_option: 0,
    explanation: "A sufficiently long, carefully released pendulum can be built and measured locally. Its swing plane turns at a predictable latitude-dependent rate, rather than one universal rate. Small pendulums are easily disturbed, but installations at many latitudes follow the same sine rule. That rule is the projection of one globe's rotation onto each observer's local vertical.",
    source_name: "American Meteorological Society: Foucault pendulum",
    source_url: "https://glossary.ametsoc.org/wiki/foucault-pendulum/",
    evidence_direction: -1
  },
  {
    prompt: "What happens to the apparent direction of Foucault-pendulum precession between the Northern and Southern Hemispheres?",
    options: [
      "It is clockwise everywhere",
      "It reverses, with opposite signs north and south",
      "It changes only when the pendulum crosses a time zone",
      "It has no repeatable direction"
    ],
    correct_option: 1,
    explanation: "Comparable pendulums precess in opposite senses on opposite sides of the equator and approach zero precession near it. A single stationary plane offers no reason for latitude to reverse the sign of this local mechanical effect. A rotating globe predicts both the reversal and its measured latitude dependence with the same rule.",
    source_name: "American Meteorological Society: Foucault pendulum",
    source_url: "https://glossary.ametsoc.org/wiki/foucault-pendulum/",
    evidence_direction: -1
  },
  {
    prompt: "If two accurately vertical plumb lines are established many kilometres apart, how are their downward directions related?",
    options: [
      "Exactly parallel, as required by one flat plane",
      "They diverge upward and downward equally",
      "They converge toward Earth's centre by an angle corresponding to their separation",
      "They point toward the geographic North Pole"
    ],
    correct_option: 2,
    explanation: "A plumb line supplies a local gravity direction. Surveying and the two-stick experiment measure a small angular difference between separated verticals. On a flat plane with uniform 'down', they should be parallel; invoking a different down direction at every location already introduces a centre and the radial geometry of a globe. The measured angular change is also consistent with the same roughly 6,371 km radius found from horizons and shadows.",
    source_name: "NOAA: Geodesy for the Layman",
    source_url: "https://geodesy.noaa.gov/PUBS_LIB/Geodesy4Layman/TR80003A.HTM",
    evidence_direction: -1
  },
  {
    prompt: "In long reciprocal surveys across water or level terrain, what treatment makes sight-line measurements from different distances agree?",
    options: [
      "Assuming all level lines remain parallel forever",
      "Applying an arbitrary correction that changes for every surveyor",
      "Ignoring refraction and observer height",
      "Accounting for predictable curvature and separately estimating atmospheric refraction"
    ],
    correct_option: 3,
    explanation: "Careful surveys observe targets in both directions and under varied conditions to separate curvature from refraction. A flat interpretation can attribute every discrepancy to refraction, but then requires light to bend by just the amount of geometric curvature across ordinary conditions. Survey networks instead use one stable curvature term while the smaller, variable refraction term changes with the atmosphere.",
    source_name: "NOAA: Geodesy for the Layman",
    source_url: "https://geodesy.noaa.gov/PUBS_LIB/Geodesy4Layman/TR80003A.HTM",
    evidence_direction: -1
  },
  {
    prompt: "By comparing when the Sun reaches its highest point at different longitudes, what progression can observers measure?",
    options: [
      "Local solar noon shifts by about one hour for each 15° of longitude",
      "Noon occurs simultaneously everywhere on a flat Earth",
      "The shift depends only on latitude",
      "Solar noon moves eastward and westward randomly each day"
    ],
    correct_option: 0,
    explanation: "Observers need only a vertical stick and a shared time reference: the shortest-shadow time progresses regularly around the world. A circling local Sun in a flat-disk model can imitate a sequence of noons, but the same geometry must also explain measured solar angles, constant angular size, sunrise directions and polar daylight. Rotation of a globe gives the 15°-per-hour relation and all those observations together.",
    source_name: "Griffith Observatory: Sun and Stars' Paths",
    source_url: "https://griffithobservatory.lacity.gov/exhibits/ahmanson-hall-of-the-sky/sun-stars-paths/",
    evidence_direction: -1
  },
  {
    prompt: "What do coordinated observers find about the boundary between daylight and darkness around an equinox?",
    options: [
      "Daylight occupies only a small circular spotlight beneath a nearby Sun",
      "Sunrise and sunset progress around the world along a boundary joining the polar regions",
      "Every location is illuminated simultaneously",
      "Only the Northern Hemisphere experiences sunset"
    ],
    correct_option: 1,
    explanation: "Calls, public cameras and personal observations can track sunrise and sunset without relying on a picture of Earth. Near an equinox the transition advances through longitude while both hemispheres have nearly equal day lengths. A local spotlight above a disk predicts a circular pool of light and incompatible illumination at the outer southern latitudes; a rotating globe predicts the coordinated boundary.",
    source_name: "NASA Science: Seeing equinoxes and solstices",
    source_url: "https://science.nasa.gov/resource/seeing-equinoxes-and-solstices-from-space/",
    evidence_direction: -1
  },
  {
    prompt: "As an observer travels steadily from the Northern into the Southern Hemisphere, what happens to the set of stars visible during the year?",
    options: [
      "Exactly the same stars remain visible everywhere above a flat plane",
      "All stars vanish at the equator",
      "Northern circumpolar stars disappear while new southern stars and a southern celestial pole become visible",
      "Only the stars' brightness changes; their paths do not"
    ],
    correct_option: 2,
    explanation: "This transition can be recorded gradually during travel: the northern sky is increasingly hidden and a previously invisible southern region appears. Distance and perspective over a plane can make objects smaller, but do not create a sharp horizon that replaces one entire part of the celestial sphere with another. Changing tangent horizons on a globe do.",
    source_name: "University of Nebraska–Lincoln: Paths of the Stars",
    source_url: "https://astro.unl.edu/naap/motion2/starpaths.html",
    evidence_direction: -1
  },
  {
    prompt: "At a given latitude, what determines the angle at which ordinary stars rise through a clear eastern horizon?",
    options: [
      "Each star chooses an unrelated angle",
      "The observer's longitude alone",
      "Distance from the supposed centre of a flat disk, with no southern counterpart",
      "The observer's latitude, with a mirrored tilt in the opposite hemisphere"
    ],
    correct_option: 3,
    explanation: "Time-lapse images show parallel rising tracks whose angle is 90° minus the observer's absolute latitude, mirrored north and south. A dome above a plane can be drawn to resemble the sky at one location, but one fixed dome does not reproduce the systematic mirrored change for observers across both hemispheres. A rotating celestial view around a globe does.",
    source_name: "University of Nebraska–Lincoln: Paths of the Stars",
    source_url: "https://astro.unl.edu/naap/motion2/starpaths.html",
    evidence_direction: -1
  },
  {
    prompt: "Why is repeating curvature tests at several heights and in different weather stronger than relying on one long-distance photograph?",
    options: [
      "Because every photograph proves whichever model the photographer prefers",
      "Because curvature gives a stable height-and-distance pattern, while refraction and lens distortion vary and can be identified",
      "Because atmospheric refraction is always exactly equal to Earth's expected curvature",
      "Because a flat surface cannot ever be photographed"
    ],
    correct_option: 1,
    explanation: "A single image near the horizon can be misleading: temperature gradients bend light, waves hide objects and lenses distort lines. The correct response is not to assume either shape from that image, but to vary height, distance and conditions and test quantitative predictions. A flat explanation that assigns every result to perspective or refraction without predicting its size is not falsifiable; the globe model supplies a stable baseline that variable effects can be tested against.",
    source_name: "Applied Optics: Visually discerning the curvature of the Earth",
    source_url: "https://pubmed.ncbi.nlm.nih.gov/19037349/",
    evidence_direction: -1
  },
  {
    prompt: "When one Earth model is required to fit star trails, shadow angles, horizon distances and polar daylight with the same dimensions and motions, what is found?",
    options: [
      "A flat disk fits all four quantitatively with one measured Sun height and speed",
      "A rotating, roughly spherical Earth fits them with one radius and axis, while common flat-disk accounts require incompatible or unspecified mechanisms",
      "Both models make identical numerical predictions",
      "Neither model permits any test an individual observer can perform"
    ],
    correct_option: 2,
    explanation: "No one observation should carry the whole conclusion. The force of the evidence is convergence: stick shadows and horizons yield the same approximate radius; celestial poles and pendulums identify the same axis and rotation; seasons and polar daylight follow from its tilt. A flat model can offer a separate story for an individual observation, but those stories do not form one geometry that calculates all the measurements in advance.",
    source_name: "Smithsonian Institution: Measurement of Earth",
    source_url: "https://www.si.edu/object/painting-measurement-earth-eratosthenes%3Anmah_694634",
    evidence_direction: -1
  },
  {
    prompt: "Which practice best distinguishes a testable alternative Earth model from a conspiracy claim?",
    options: [
      "Specifying dimensions and mechanisms that predict numerical results before measurements are taken",
      "Rejecting any observation made by someone outside one's own group",
      "Explaining every contrary result as fabrication after it occurs",
      "Accepting only photographs that look intuitively flat"
    ],
    correct_option: 0,
    explanation: "Suspicion of an authority is not itself evidence for a competing geometry. A testable model states, for example, the Sun's height and path, the map scale and how light travels, then predicts shadow angles, angular sizes and visibility before observing them. If any failed prediction can instead be attributed to an unconstrained dome, refraction or fabrication, the claim has been protected from testing rather than supported.",
    source_name: "University of California Museum of Paleontology: Understanding Science",
    source_url: "https://undsci.berkeley.edu/understanding-science-101/how-science-works/testing-scientific-ideas/",
    evidence_direction: -1
  }
].freeze
