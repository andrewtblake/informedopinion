require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "organisation initialisms receive accessible definitions" do
    rendered = glossary_text("The ICC considered evidence cited by the OECD.")
    fragment = Nokogiri::HTML.fragment(rendered)

    assert_equal "ICC", fragment.at_css("abbr[title='International Criminal Court'][tabindex='0']").text
    assert_equal "OECD", fragment.at_css("abbr[title='Organisation for Economic Co-operation and Development']").text
    assert_equal "glossary", fragment.at_css("abbr")["data-controller"]
  end

  test "economic and ownership initialisms receive accessible definitions" do
    rendered = glossary_text("An ESOP is governed by ERISA. SOE evidence from the IMF, NBER and TVA includes GDP and COVID-19 data.")
    fragment = Nokogiri::HTML.fragment(rendered)

    expected_definitions = {
      "ESOP" => "Employee Stock Ownership Plan",
      "ERISA" => "Employee Retirement Income Security Act",
      "SOE" => "State-Owned Enterprise",
      "IMF" => "International Monetary Fund",
      "NBER" => "National Bureau of Economic Research",
      "TVA" => "Tennessee Valley Authority",
      "GDP" => "Gross Domestic Product",
      "COVID-19" => "Coronavirus Disease 2019"
    }

    assert_equal expected_definitions, fragment.css("abbr").to_h { [ _1.text, _1["title"] ] }
  end

  test "glossary rendering continues to escape arbitrary HTML" do
    rendered = glossary_text("<script>alert('x')</script> ICC")
    fragment = Nokogiri::HTML.fragment(rendered)

    assert_not_includes rendered, "<script>"
    assert_includes rendered, "&lt;script&gt;"
    assert_equal [ "ICC" ], fragment.css("abbr.glossary-term").map(&:text)
  end

  test "initialisms embedded within another word are not annotated" do
    rendered = glossary_text("PICCC does not mean ICC")
    fragment = Nokogiri::HTML.fragment(rendered)

    assert_equal [ "ICC" ], fragment.css("abbr.glossary-term").map(&:text)
  end
end
