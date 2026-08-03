module ApplicationHelper
  ORGANISATION_GLOSSARY = {
    "ATF" => "Bureau of Alcohol, Tobacco, Firearms and Explosives",
    "BLS" => "Bureau of Labor Statistics",
    "CBO" => "Congressional Budget Office",
    "CDC" => "Centers for Disease Control and Prevention",
    "COVID-19" => "Coronavirus Disease 2019",
    "CPS" => "Crown Prosecution Service",
    "DESNZ" => "Department for Energy Security and Net Zero",
    "EPA" => "Environmental Protection Agency",
    "ECHR" => "European Convention on Human Rights",
    "ERISA" => "Employee Retirement Income Security Act",
    "ESOP" => "Employee Stock Ownership Plan",
    "FBI" => "Federal Bureau of Investigation",
    "GAO" => "Government Accountability Office",
    "GDP" => "Gross Domestic Product",
    "HMRC" => "His Majesty's Revenue and Customs",
    "ICC" => "International Criminal Court",
    "ICJ" => "International Court of Justice",
    "ICRC" => "International Committee of the Red Cross",
    "IDF" => "Israel Defense Forces",
    "IFS" => "Institute for Fiscal Studies",
    "IMF" => "International Monetary Fund",
    "IPC" => "Integrated Food Security Phase Classification",
    "IPCC" => "Intergovernmental Panel on Climate Change",
    "NASA" => "National Aeronautics and Space Administration",
    "NDA" => "Nuclear Decommissioning Authority",
    "NBER" => "National Bureau of Economic Research",
    "NICS" => "National Instant Criminal Background Check System",
    "NIJ" => "National Institute of Justice",
    "NIST" => "National Institute of Standards and Technology",
    "NHS" => "National Health Service",
    "NPPF" => "National Planning Policy Framework",
    "NOAA" => "National Oceanic and Atmospheric Administration",
    "OBR" => "Office for Budget Responsibility",
    "OCHA" => "United Nations Office for the Coordination of Humanitarian Affairs",
    "OECD" => "Organisation for Economic Co-operation and Development",
    "OHCHR" => "Office of the United Nations High Commissioner for Human Rights",
    "ONR" => "Office for Nuclear Regulation",
    "ONS" => "Office for National Statistics",
    "RAND" => "RAND Corporation",
    "SOE" => "State-Owned Enterprise",
    "TVA" => "Tennessee Valley Authority",
    "UN" => "United Nations",
    "USGS" => "United States Geological Survey"
  }.freeze

  GLOSSARY_PATTERN = Regexp.new(
    "(?<![[:alnum:]_])(#{Regexp.union(ORGANISATION_GLOSSARY.keys.sort_by { -_1.length })})(?![[:alnum:]_])"
  )

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

  def glossary_text(text)
    safe_join(text.to_s.split(GLOSSARY_PATTERN).map do |segment|
      definition = ORGANISATION_GLOSSARY[segment]
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
end
