require "test_helper"

class StatsDashboardTest < ActionDispatch::IntegrationTest
  setup do
    @topic = OpinionQuestion.create!(
      slug: "stats-test",
      title: "Stats test",
      statement: "A testable opinion.",
      response_options: [ "Strongly agree", "Agree", "Neutral", "Disagree", "Strongly disagree" ],
      display_order: 1
    )
    @facts = 2.times.map do |index|
      @topic.fact_questions.create!(
        prompt: "Fact #{index}?",
        options: [ "Correct", "Wrong one", "Wrong two", "Wrong three" ],
        correct_option: 0,
        explanation: "Evidence.",
        source_name: "Source",
        source_url: "https://example.com",
        display_order: index + 1
      )
    end
    @user = User.create!(
      first_name: "Ada",
      last_name: "Lovelace",
      email: "ada@example.com",
      password: "password123"
    )
  end

  test "authentication is required" do
    get stats_path

    assert_redirected_to new_user_session_path
  end

  test "user sees a compact opinion card and can resume a topic" do
    @user.user_opinions.create!(opinion_question: @topic, position: 1)
    @user.fact_responses.create!(
      fact_question: @facts.first,
      selected_option: 0,
      weight_before: 0,
      weight_after: 50,
      answered_at: Time.current
    )
    sign_in @user, scope: :user

    get stats_path

    assert_response :success
    assert_select "title", text: /My opinions/
    assert_select "h1", text: "My opinions"
    assert_select ".opinions-tools input[type='search'][placeholder='Search your opinions']"
    assert_select ".opinions-tools select[name='sort'] option", count: 4
    assert_select ".opinion-card", count: 1, text: /Stats test.*Agree.*50% weight.*1\/1 correct.*1 unseen/m
    assert_select ".compact-choice-dial", count: 1
    assert_select ".personal-dial-arc", count: 1
    assert_select ".personal-weight-guide", count: 3
    %w[25% 50% 75%].each do |label|
      assert_select ".personal-weight-guide-label", text: label
    end
    assert_select ".personal-choice-dial line[x2='249.5'][y2='120.5']"
    assert_select ".personal-card-actions a[href='#{opinion_question_quiz_path(@topic)}']", text: "Resume quiz"
    assert_select ".personal-card-actions a[href='#{opinion_question_path(@topic)}']", text: "Revise opinion"
    assert_select ".compact-choice-dial .personal-dial-choice", count: 0
    assert_select ".personal-card-actions", text: /→/, count: 0
    assert_select "a[href='#{stats_path}']", text: "My opinions"
  end

  test "user can search and order their registered opinions" do
    other_topic = OpinionQuestion.create!(
      slug: "another-opinion",
      title: "Another opinion",
      statement: "A second position about housing.",
      response_options: @topic.response_options,
      display_order: 2
    )
    @user.user_opinions.create!(opinion_question: @topic, position: 1)
    @user.user_opinions.create!(opinion_question: other_topic, position: 3)
    sign_in @user, scope: :user

    get stats_path(sort: "title")

    assert_response :success
    assert_select ".opinion-card h2" do |headings|
      assert_equal [ "Another opinion", "Stats test" ], headings.map { _1.text.strip }
    end

    get stats_path(q: "housing", sort: "title")

    assert_response :success
    assert_select ".opinions-index-heading", text: /1 opinion/
    assert_select ".opinion-card", count: 1, text: /Another opinion/
    assert_select ".opinion-card", text: /Stats test/, count: 0
  end
end
