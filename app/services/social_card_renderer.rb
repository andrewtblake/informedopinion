require "digest"

class SocialCardRenderer
  WIDTH = 1200
  HEIGHT = 630
  TEMPLATE_VERSION = 2

  THEMES = {
    "informed_opinion" => {
      background: "#fbfaf3", ink: "#103536", accent: "#b7e52f", border: "#d7f4d0",
      pattern: "#e9e5d9", mark: "io", name: "Informed Opinion", title_font: "DejaVu Serif"
    },
    "whats_your_view" => {
      background: "#fffaf2", ink: "#172b4d", accent: "#e76549", border: "#eee5d8",
      pattern: "#e9e1d6", mark: "w?", name: "What's Your View?", title_font: "DejaVu Sans"
    }
  }.freeze

  def self.fingerprint(title, site_key)
    Digest::SHA256.hexdigest([ TEMPLATE_VERSION, site_key, title ].join("\0"))
  end

  def initialize(title:, site_key:, subtitle: nil, decorative: true, brand_rule: true)
    @title = title.to_s.strip
    @subtitle = subtitle.to_s.strip.presence
    @decorative = decorative
    @brand_rule = brand_rule
    @site_key = site_key.to_s
    @theme = THEMES.fetch(@site_key)
  end

  def render
    require "vips"
    image = Vips::Image.svgload_buffer(svg)
    image.pngsave_buffer(compression: 9, strip: true)
  end

  private

  def svg
    lines, font_size = fitted_title
    line_height = (font_size * 1.06).round
    title_height = line_height * lines.length
    title_y = [ 128, 305 - (title_height / 2) ].max
    brand_y = 525
    subtitle_y = title_y + title_height + 42

    <<~SVG
      <svg xmlns="http://www.w3.org/2000/svg" width="#{WIDTH}" height="#{HEIGHT}" viewBox="0 0 #{WIDTH} #{HEIGHT}">
        <rect width="#{WIDTH}" height="#{HEIGHT}" fill="#{@theme[:border]}"/>
        <rect x="18" y="18" width="1164" height="594" rx="34" fill="#{@theme[:background]}"/>
        #{@decorative ? pattern_svg : ""}
        <g fill="#{@theme[:ink]}" font-family="#{@theme[:title_font]}">
          <text x="92" y="#{title_y}" font-size="#{font_size}" font-weight="700">
            #{lines.each_with_index.map { |line, index| %(<tspan x="92" dy="#{index.zero? ? 0 : line_height}">#{escape(line)}</tspan>) }.join}
          </text>
        </g>
        #{@subtitle ? subtitle_svg(subtitle_y) : ""}
        #{@brand_rule ? brand_rule_svg(brand_y) : ""}
        <text x="92" y="#{brand_y}" fill="#{@theme[:accent]}" font-family="DejaVu Sans" font-size="52" font-weight="700">#{escape(@theme[:mark])}</text>
        <circle cx="#{@site_key == "informed_opinion" ? 174 : 185}" cy="#{brand_y - 17}" r="4" fill="#{@theme[:ink]}"/>
        <text x="#{@site_key == "informed_opinion" ? 194 : 205}" y="#{brand_y}" fill="#{@theme[:ink]}" font-family="DejaVu Sans" font-size="34">#{escape(@theme[:name])}</text>
      </svg>
    SVG
  end

  def fitted_title
    [ 108, 96, 86, 76, 68, 60 ].each do |font_size|
      lines = wrap_title(font_size)
      return [ lines, font_size ] if lines.length <= 3 && lines.all? { text_width(_1, font_size) <= 1016 }
    end
    raise ArgumentError, "Title does not fit the social-card template"
  end

  def wrap_title(font_size)
    words = @title.split
    lines = []
    current = words.shift.to_s
    words.each do |word|
      candidate = "#{current} #{word}"
      if text_width(candidate, font_size) <= 1016
        current = candidate
      else
        lines << current
        current = word
      end
    end
    lines << current
  end

  def text_width(text, font_size)
    Vips::Image.text(text, font: "#{@theme[:title_font]} #{font_size}", dpi: 72).width
  end

  def pattern_svg
    <<~PATTERN
      <g fill="none" stroke="#{@theme[:pattern]}" stroke-width="3" opacity="0.52">
        <circle cx="1040" cy="112" r="35"/><circle cx="1090" cy="430" r="54"/>
        <circle cx="315" cy="78" r="22"/><path d="M980 175l35 35m-35 0l35-35"/>
        <path d="M45 155h35m-18-18v36M1060 560h44m-22-22v44"/>
        <path d="M830 72c28 0 28 42 0 42s-28-42 0-42zm-46 78c14-30 78-30 92 0"/>
        <rect x="920" y="290" width="74" height="50" rx="9"/><path d="M938 315h38"/>
        <path d="M55 430c38-45 75-6 49 28-20 27-49 43-49 43s-29-16-49-43c-26-34 11-73 49-28z"/>
      </g>
    PATTERN
  end

  def subtitle_svg(y)
    %(<text x="92" y="#{y}" fill="#{@theme[:ink]}" opacity="0.78" font-family="DejaVu Sans" font-size="34">#{escape(@subtitle)}</text>)
  end

  def brand_rule_svg(brand_y)
    %(<rect x="92" y="#{brand_y - 62}" width="178" height="5" rx="2.5" fill="#{@theme[:accent]}"/>)
  end

  def escape(value)
    ERB::Util.html_escape(value)
  end
end
