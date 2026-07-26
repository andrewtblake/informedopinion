module StatsHelper
  DIAL_CENTER = [ 200, 170 ].freeze
  DIAL_RADIUS = 140

  def opinion_arrow_endpoint(opinion, weight)
    radians = opinion.stance * 45 * Math::PI / 180
    radius = DIAL_RADIUS * weight.fdiv(100)

    [
      (DIAL_CENTER.first + (radius * Math.sin(radians))).round(1),
      (DIAL_CENTER.last - (radius * Math.cos(radians))).round(1)
    ]
  end
end
