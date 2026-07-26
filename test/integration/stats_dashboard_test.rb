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

  test "user sees participation totals and can resume a topic" do
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
    assert_select "h1", text: "My stats"
    assert_select ".stats-page-title", text: "Your opinions"
    assert_select ".stats-overview", count: 0
    assert_select ".stats-topic-grid[style*='repeat(2']"
    assert_select ".personal-topic-card", text: /Stats test.*Agree.*50% weight.*1 correct.*1 answered.*1 unseen/m
    assert_select ".personal-choice-dial[style*='max-width: 330px']"
    assert_select ".personal-dial-arc[fill='none'][stroke='#cfd9d4']"
    assert_select ".personal-weight-guide", count: 3
    %w[25% 50% 75%].each do |label|
      assert_select ".personal-weight-guide-label", text: label
    end
    assert_select ".personal-choice-dial line[x2='249.5'][y2='120.5']"
    assert_select "form[action='#{opinion_question_quiz_path(@topic)}'] button.stats-card-button", text: "Resume quiz"
    assert_select "form[action='#{opinion_question_path(@topic)}'] button.stats-card-button", text: "Revise opinion"
    assert_select ".personal-card-actions", text: /→/, count: 0
    assert_select "a[href='#{stats_path}']", text: "My stats"
  end
end
