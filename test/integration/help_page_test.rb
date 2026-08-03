require "test_helper"

class HelpPageTest < ActionDispatch::IntegrationTest
  test "visitor can read a detailed explanation of the service" do
    get help_path

    assert_response :success
    assert_select "title", text: "Help — Informed Opinion"
    assert_select ".help-page.ui-page .ui-masthead", count: 1
    assert_select ".help-contents.ui-panel", count: 1
    assert_select ".help-article section", count: 9
    assert_select "#weight", text: /Supporting.*Significant.*Foundational.*most recent answer/m
    assert_select "#collective", text: /position.*knowledge weight.*total knowledge weight/m
    assert_select "#collective", text: /adds weight without pushing the result towards either Yes or No/
    assert_select "#ordering", text: /Unseen fact questions.*review round/m
    assert_select "#limits", text: /not a representative opinion poll.*people who took part/m
  end

  test "help is linked from the site chrome" do
    get root_path

    assert_select ".site-nav a[href='#{help_path}']", text: "Help"
    assert_select ".site-footer a[href='#{help_path}']", text: "How it works"
  end
end
