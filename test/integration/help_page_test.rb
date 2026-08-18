require "test_helper"

class HelpPageTest < ActionDispatch::IntegrationTest
  test "visitor can read a detailed explanation of the service" do
    get help_path

    assert_response :success
    assert_select "title", text: "Help — Informed Opinion"
    assert_select ".help-page.ui-page .ui-masthead", count: 1
    assert_select ".help-contents.ui-panel", count: 1
    assert_select ".help-article section", count: 8
    assert_select "#question", text: /proposition, not only the title.*present view/im
    assert_select "#facts", text: /guided tour of the evidence.*wrong answer is not a penalty/im
    assert_select "#progress", text: /view, answers and weight can change.*not displayed publicly/im
    assert_select "#results", text: /direction, strength and participation.*methodology page/im
    assert_select "#contributing a[href='#{opinion_question_proposals_path}']"
    assert_select "#limits", text: /does not settle the issue.*changed—or failed to change—my view/im
  end

  test "help is linked from the site chrome" do
    get root_path

    assert_select ".site-nav a[href='#{help_path}']", text: "Help"
    assert_select ".site-footer a[href='#{help_path}']", text: "How it works"
  end
end
