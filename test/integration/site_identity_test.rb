require "test_helper"

class SiteIdentityTest < ActionDispatch::IntegrationTest
  test "the default and unknown hosts retain the informed opinion presentation" do
    [ "informedopinion.localhost", "unexpected.localhost" ].each do |hostname|
      host! hostname
      get root_path

      assert_response :success
      assert_select "body[data-site='informed-opinion']"
      assert_select ".brand > span:last-child", text: "Informed Opinion"
      assert_select "meta[name='application-name'][content='Informed Opinion']", count: 1
      assert_select "link[rel='icon'][href='/icon.svg']", count: 1
      assert_not_includes response.body, "/assets/what_do_you_think-"
    end
  end

  test "the explicit local alternative host selects what do you think" do
    host! "whatdoyouthink.localhost"
    get root_path

    assert_response :success
    assert_select "body[data-site='what-do-you-think']"
    assert_select ".brand > span:last-child", text: "What Do You Think?"
    assert_select "title", text: "What Do You Think? — opinion, informed by the facts"
    assert_select "meta[name='application-name'][content='What Do You Think?']", count: 1
    assert_select "link[rel='icon'][href='/what-do-you-think-icon.svg']", count: 1
    assert_select "link[rel='stylesheet']", count: 2
    assert_includes response.body, "/assets/what_do_you_think-"
    assert_select ".wdyt-hero h1", text: "What do people think?"
  end

  test "moderation retains the editorial presentation on the alternative host" do
    moderator = create_user!(email: "site-moderator@example.test", password: "password123",
      first_name: "Site", last_name: "Moderator", role: :moderator)
    sign_in moderator, scope: :user
    host! "whatdoyouthink.localhost"

    get moderator_root_path

    assert_response :success
    assert_select "body[data-site='informed-opinion']"
    assert_select ".brand > span:last-child", text: "Informed Opinion"
  end

  test "the alternative language follows a participant through the public journey" do
    category = Category.create!(name: "Site journey", slug: "site-journey")
    question = OpinionQuestion.create!(category: category, title: "A site journey", slug: "a-site-journey",
      statement: "This proposition should be accepted.", live: true, display_order: 1,
      response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    question.fact_questions.create!(prompt: "Which answer is supported?", options: %w[First Second Third Fourth],
      correct_option: 0, explanation: "The first answer is supported.", source_name: "Source",
      source_url: "https://example.test/source", display_order: 1)
    participant = create_user!(email: "site-participant@example.test", password: "password123",
      first_name: "Site", last_name: "Participant")
    participant.user_opinions.create!(opinion_question: question, position: 0)
    sign_in participant, scope: :user
    host! "whatdoyouthink.localhost"

    get opinion_question_path(question)
    assert_response :success
    assert_select ".topic-hero-card h1", text: "Where do you stand?"
    assert_select ".text-link", text: "Continue with the facts"

    get opinion_question_quiz_path(question)
    assert_response :success
    assert_select ".quiz-header .eyebrow", text: /the facts/
    assert_select ".back-link", text: "← Leave for now"

    get stats_path
    assert_response :success
    assert_select ".opinions-masthead h1", text: "Your opinions"
    assert_select ".opinion-card h2", text: "A site journey"
  end

  test "alternative authentication uses the alternative name and language" do
    host! "whatdoyouthink.localhost"

    get new_user_session_path

    assert_response :success
    assert_select ".account-masthead", text: /Return to your opinions/
    assert_select ".account-switch", text: /New to What Do You Think\?/
  end
end
