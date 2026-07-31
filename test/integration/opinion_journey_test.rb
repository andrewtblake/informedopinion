require "test_helper"

class OpinionJourneyTest < ActionDispatch::IntegrationTest
  setup do
    @topic = OpinionQuestion.create!(
      slug: "evidence-test",
      title: "Evidence test",
      statement: "Evidence matters.",
      response_options: [ "Strongly agree", "Agree", "Neutral", "Disagree", "Strongly disagree" ],
      display_order: 1
    )
    @fact = @topic.fact_questions.create!(
      prompt: "Which answer is supported?",
      options: [ "The supported answer", "A distractor", "Another distractor", "A final distractor" ],
      correct_option: 0,
      explanation: "The primary source supports the first answer.",
      source_name: "Primary source",
      source_url: "https://example.com/evidence",
      evidence_direction: 1,
      display_order: 1
    )
    @user = User.create!(
      first_name: "Grace",
      last_name: "Hopper",
      email: "grace@example.com",
      password: "password123"
    )
  end

  test "user registers an opinion, answers a fact, and revises the opinion" do
    sign_in @user, scope: :user

    post opinion_question_user_opinion_path(@topic),
      params: { user_opinion: { position: 1 } }
    assert_redirected_to opinion_question_quiz_path(@topic)

    get root_path
    assert_select ".editorial-topic-footer", text: /Your position:.*Agree.*0.0% weight/m
    assert_select ".editorial-topic-footer a[href='#{opinion_question_quiz_path(@topic)}']",
      text: "Continue knowledge check"

    get opinion_question_quiz_path(@topic)
    assert_response :success
    assert_select "h1", text: @fact.prompt
    assert_select ".quiz-weight", text: /0%/
    assert_select ".quiz-progress", text: /unweighted score 0%/
    assert_select ".fact-importance", text: /Importance: Supporting \(1 of 3\).*standard importance weight/m
    assert_select "input[name='selected_option']", count: 4
    assert_equal %w[0 1 2 3],
      css_select("input[name='selected_option']").map { |input| input["value"] }.sort

    post opinion_question_fact_responses_path(@topic),
      params: { fact_question_id: @fact.id, selected_option: 0 }
    fact_response = @user.fact_responses.find_by!(fact_question: @fact)
    assert_equal 1, fact_response.attempt_count
    assert_redirected_to opinion_question_quiz_path(@topic, feedback: fact_response.id)

    follow_redirect!
    assert_select ".feedback-correct"
    assert_select ".feedback-status h1", text: "Correct"
    assert_select ".feedback-status", text: /You knew this one/, count: 0
    assert_select ".answer-comparison-correct", text: /Your correct answer.*The supported answer/m
    assert_select ".explanation-panel", text: /primary source supports/
    assert_select ".weight-change", count: 0
    assert_select ".quiz-weight", text: /100%/
    assert_select ".quiz-progress", text: /unweighted score 100%/
    assert_select ".fact-importance", text: /Importance: Supporting \(1 of 3\)/
    assert_select "a[href='https://example.com/evidence']"

    patch opinion_question_user_opinion_path(@topic),
      params: { user_opinion: { position: 3 } }
    assert_redirected_to opinion_question_path(@topic)
    assert_equal 3, @user.user_opinions.find_by!(opinion_question: @topic).position
    assert_equal 100.0, OpinionProgress.new(@user, @topic).weight
  end

  test "answering a fact again increments its attempt count" do
    sign_in @user, scope: :user
    @user.user_opinions.create!(opinion_question: @topic, position: 1)

    2.times do
      post opinion_question_fact_responses_path(@topic),
        params: { fact_question_id: @fact.id, selected_option: 0 }
    end

    assert_equal 2, @user.fact_responses.find_by!(fact_question: @fact).attempt_count
  end

  test "incorrect feedback uses the same compact hierarchy" do
    sign_in @user, scope: :user
    @user.user_opinions.create!(opinion_question: @topic, position: 1)

    post opinion_question_fact_responses_path(@topic),
      params: { fact_question_id: @fact.id, selected_option: 2 }
    follow_redirect!

    assert_select ".feedback-incorrect"
    assert_select ".feedback-status h1", text: "Incorrect"
    assert_select ".feedback-status", text: /evidence says otherwise/, count: 0
    assert_select ".answer-comparison", text: /Your answer.*Correct answer/m
    assert_select ".explanation-panel", text: /primary source supports/
    assert_select ".weight-change", count: 0
  end

  test "visitor can browse a topic but must sign in to register a response" do
    get root_path
    assert_response :success
    assert_select ".editorial-masthead", text: /Current informed opinion/
    assert_select ".editorial-topic", text: /Evidence test.*Evidence matters/m
    assert_select ".editorial-result", text: /Informed aggregate.*No weighted result.*No.*Neutral.*Yes/m
    assert_select ".editorial-opinion-scale", count: 1
    assert_select ".editorial-result-bar", count: 0
    assert_select ".public-result-summary", count: 0
    assert_select ".topic-number", count: 0

    get opinion_question_path(@topic)
    assert_response :success
    assert_select "a", text: "Create account"

    post opinion_question_user_opinion_path(@topic),
      params: { user_opinion: { position: 0 } }
    assert_redirected_to new_user_session_path
  end
end
