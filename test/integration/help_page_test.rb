require "test_helper"

class HelpPageTest < ActionDispatch::IntegrationTest
  test "visitor can read a detailed explanation of the service" do
    get help_path

    assert_response :success
    assert_select "title", text: "Help — Informed Opinion"
    assert_select ".help-page.ui-page .ui-masthead", count: 1
    assert_select ".help-contents.ui-panel", count: 1
    assert_select ".help-article section", count: 9
    assert_select "#purpose", text: /What is Informed Opinion\?.*not simply a count of votes.*does not require a particular opinion/im
    assert_select "#question", text: /proposition, not only the title.*present view/im
    assert_select "#facts", text: /guided tour of the evidence.*new response replaces your earlier response to that fact.*other facts continue to count/im
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

  test "methodology explains scoring and corrections without internal publication workflow" do
    get methodology_path

    assert_response :success
    assert_select "#individual", text: /newest response to that fact replaces the earlier one.*every other fact continue/im
    assert_select "#publication", text: /Quality and correction.*strongest material evidence on every side.*retired question/im
    assert_not_includes response.body, "configured minimum number"
    assert_not_includes response.body, "marks the opinion question as live"
  end
end
