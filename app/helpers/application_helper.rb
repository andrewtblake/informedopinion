module ApplicationHelper
  def site_page_title(title = nil)
    decoded_title = CGI.unescapeHTML(title.to_s).presence
    decoded_title&.sub("Informed Opinion", current_site.name) || current_site.name
  end

  def site_asset_path(name)
    "/#{current_site.favicon_prefix}#{name}"
  end

  def site_copy(key)
    current_site.copy.fetch(key)
  end

  def public_statistics_enabled?
    FeatureFlags.public_statistics?(current_user)
  end

  def signed_percentage(value)
    number = number_with_precision(value, precision: 1, strip_insignificant_zeros: true)
    "#{'+' if value.positive?}#{number}"
  end

  def whole_percentage(value)
    number_with_precision(value, precision: 0)
  end

  def privacy_safe_count(count, minimum: Rails.configuration.x.statistics.minimum_group_size)
    return "0" if count.zero?
    return "Fewer than #{minimum}" if count < minimum

    number_with_delimiter(count)
  end

  def site_canonical_url
    canonical_host = if current_site.alternative? && controller_path == "home"
      request.host
    elsif Rails.env.local?
      "informedopinion.localhost"
    else
      ENV.fetch("APP_HOST", "informedopinion.info")
    end
    port = request.optional_port
    authority = port ? "#{canonical_host}:#{port}" : canonical_host
    protocol = Rails.env.production? ? "https" : request.protocol.delete_suffix("://")
    "#{protocol}://#{authority}#{request.path}"
  end

  def social_card_site_key
    current_site.alternative? ? "whats_your_view" : "informed_opinion"
  end

  def opinion_social_card_url(opinion_question)
    site_key = social_card_site_key
    social_card_url(
      slug: opinion_question.slug,
      site_key: site_key,
      fingerprint: SocialCardRenderer.fingerprint(opinion_question.title, site_key),
      host: request.host,
      protocol: request.protocol,
      port: request.optional_port
    )
  end

  def branded_page_social_card_url(page_key)
    page_social_card_url(
      page_key: page_key,
      site_key: social_card_site_key,
      host: request.host,
      protocol: request.protocol,
      port: request.optional_port
    )
  end

  def glossary_text(text)
    definitions, pattern = glossary_index
    return safe_join([ text.to_s ]) unless pattern

    safe_join(text.to_s.split(pattern).map do |segment|
      definition = definitions[segment]
      next segment unless definition

      content_tag(
        :abbr,
        segment,
        class: "glossary-term",
        title: definition,
        tabindex: 0,
        aria: { label: "#{segment}: #{definition}" },
        data: {
          controller: "glossary",
          action: "click->glossary#show keydown.esc->glossary#hide",
          definition: definition
        }
      )
    end)
  end

  private

  def glossary_index
    @glossary_index ||= begin
      definitions = GlossaryEntry.order(:term).pluck(:term, :definition).to_h
      pattern = if definitions.any?
        Regexp.new("(?<![[:alnum:]_])(#{Regexp.union(definitions.keys.sort_by { -_1.length })})(?![[:alnum:]_])")
      end
      [ definitions, pattern ]
    end
  end
end
