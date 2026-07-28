module FlatEarthCalibration
  ASSESSMENTS = [
    [ 3, "Opposed rotation around two celestial poles is a direct, repeatable conflict with a single overhead rotation." ],
    [ 3, "Polaris altitude tracking latitude supplies a quantitative prediction over long north–south journeys." ],
    [ 2, "Polaris disappearing below the horizon is significant corroboration of changing tangent horizons." ],
    [ 3, "One southern celestial pole seen due south from separated continents is a foundational geometric constraint." ],
    [ 1, "The common angular rate supports rigid rotation but is less discriminating than the existence of two poles." ],
    [ 1, "Lunar orientation is useful corroboration of differently oriented local horizons, but viewing geometry needs care." ],
    [ 3, "The Sun's nearly constant angular diameter directly contradicts the usual nearby, receding-Sun account." ],
    [ 3, "The horizon progressively occulting an unshrinking Sun is a direct and repeatable geometric observation." ],
    [ 1, "Zoom not recovering an occulted Sun clarifies the difference between optical magnification and physical obstruction." ],
    [ 2, "Bottom-first disappearance and recovery with observer height provide a strong repeated horizon test." ],
    [ 2, "The square-root height relation is quantitative evidence for a curved surface of consistent radius." ],
    [ 2, "Measured horizon dip is significant but demands careful levelling and control of lens distortion." ],
    [ 3, "Shadow angle and surface distance yield a repeatable circumference using accessible measurements." ],
    [ 3, "A multi-city shadow network rejects the free parameter of one arbitrarily chosen nearby-Sun height." ],
    [ 2, "Equinox sunrise and sunset directions constrain any proposed geometry of the Sun and surface." ],
    [ 2, "Opposed seasonal day lengths are a major constraint, though less individually decisive than polar daylight." ],
    [ 3, "Twenty-four-hour Antarctic sunlight through all azimuths directly challenges the common north-centred disk model." ],
    [ 1, "Earth's curved eclipse shadow is classical corroboration, but a disk can imitate it in a restricted orientation." ],
    [ 2, "Successful advance eclipse predictions test one geometry across time and widely separated locations." ],
    [ 2, "The latitude-dependent Foucault rate is a local mechanical measurement of terrestrial rotation." ],
    [ 1, "The hemispheric reversal corroborates the Foucault sine rule but is not independent of the preceding assessment." ],
    [ 2, "Separated local verticals constrain surface geometry, although precise measurement requires surveying equipment." ],
    [ 2, "Long-line survey closure is practical quantitative evidence, but it is less accessible to an individual participant." ],
    [ 1, "The progression of solar noon is readily observed but can also be imitated by some circling-Sun models in isolation." ],
    [ 2, "The global day–night boundary combines simultaneous observations that a local spotlight must explain." ],
    [ 2, "The systematic replacement of northern by southern stars strongly constrains the shape of the observer's horizon." ],
    [ 1, "Star-rise angles corroborate latitude geometry but overlap substantially with the celestial-pole questions." ],
    [ 1, "Repeated conditions are principally a methodological safeguard against refraction and optical artefacts." ],
    [ 3, "Convergence of independent measurements on one radius, axis and motion is the bank's central model-comparison test." ],
    [ 1, "Advance numerical prediction distinguishes a scientific model from an unfalsifiable claim but is methodological evidence." ]
  ].freeze

  REPLACEMENTS = {
    5 => {
      prompt: "When level photographs of the same lunar phase are compared from mid-northern and mid-southern latitudes, how is the Moon's visible disk typically oriented?",
      options: [
        "It has one universal upright orientation relative to every local horizon",
        "It is substantially rotated between the two hemispheres",
        "Its near and far sides exchange places",
        "Different lunar surface features become visible"
      ],
      explanation: "The same lunar features remain visible, but their orientation relative to a level local horizon is substantially rotated between northern and southern observations; the exact angle depends on latitude, lunar position and time. The effect does not require trusting an authority and can be photographed independently. It follows because observers' local verticals are differently oriented on a globe. A common flat plane does not supply that systematic reversal of local 'up'.",
      source_name: "NASA Science: Top Moon Questions",
      source_url: "https://science.nasa.gov/moon/top-moon-questions/"
    },
    8 => {
      prompt: "After the Sun has completely passed below a clear sea horizon, what does increasing optical zoom do?",
      options: [
        "It magnifies the visible scene but does not bring the Sun back above the horizon",
        "It restores the complete solar disk above the same horizon",
        "It shows the Sun continuing horizontally at a fixed elevation",
        "It changes the completed sunset into a new sunrise"
      ],
      explanation: "Zoom increases the angular size of detail that reaches the camera; it cannot recover light blocked by an intervening horizon. If insufficient magnification alone made a still-unobstructed, receding Sun disappear, greater zoom could recover it. Controlled recordings do not do so after the upper limb has set. Physically raising the observer can briefly reveal the Sun again because the horizon moves farther away; that distinct effect fits a curved surface rather than the usual flat-plane perspective claim."
    },
    22 => {
      prompt: "When surveyors check vertical-angle measurements over long distances, which effects must their calculation distinguish?",
      options: [
        "Map colour and the surveyor's time zone",
        "Only instrument magnification",
        "Tides and magnetic compass variation alone",
        "Earth curvature and variable atmospheric refraction"
      ],
      explanation: "Geodetic survey procedures use reciprocal observations and corrections to control instrument error and the variable bending of light. Over long lines, the closure calculation must also account for the stable geometric effect of Earth curvature. Refraction changes with atmospheric conditions and is measured or estimated separately; it is not an unrestricted explanation for every result. The measurements therefore distinguish a persistent curvature term from the variable optical effects invoked by a flat model."
    },
    12 => {
      prompt: "When the two-stick experiment is repeated at many north–south location pairs, what spherical-Earth measurement do the shadow-angle differences and surface separations consistently produce?"
    },
    28 => {
      options: [
        "A flat disk fits all four with one measured Sun height and speed",
        "Both models make identical numerical predictions",
        "A rotating globe fits them coherently",
        "Neither model allows observations by individuals"
      ],
      correct_option: 2
    }
  }.freeze

  module_function

  def apply
    REPLACEMENTS.each do |index, attributes|
      FLAT_EARTH_FACTS.fetch(index).merge!(attributes)
    end

    ASSESSMENTS.each_with_index do |(weight, rationale), index|
      FLAT_EARTH_FACTS.fetch(index).merge!(
        importance_weight: weight,
        importance_rationale: rationale
      )
    end
  end
end

FlatEarthCalibration.apply
