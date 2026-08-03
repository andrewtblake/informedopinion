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

  test "the explicit local alternative host selects what's your view" do
    category = Category.create!(name: "Alternative homepage", slug: "alternative-homepage")
    OpinionQuestion.create!(category: category, title: "Alternative homepage question",
      slug: "alternative-homepage-question", statement: "This proposition should be considered.",
      live: true, display_order: 1, response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    host! "whatsyourview.localhost"
    get root_path

    assert_response :success
    assert_select "body[data-site='what-do-you-think']"
    assert_select ".brand > span:last-child", text: "What's Your View?"
    assert_select "title", text: /Your View\? — opinion, backed by the facts/
    assert_includes response.body, "<title>What&#39;s Your View? — opinion, backed by the facts</title>"
    assert_not_includes response.body, "What&amp;#39;s Your View?"
    assert_select "meta[name='application-name'][content=\"What's Your View?\"]", count: 1
    assert_select "link[rel='icon'][href='/what-do-you-think-icon.svg']", count: 1
    assert_select "link[rel='icon'][href='/what-do-you-think-favicon.ico']", count: 1
    assert_select "link[rel='apple-touch-icon'][href='/what-do-you-think-icon.png']", count: 1
    assert_select "link[rel='canonical'][href='http://whatsyourview.localhost/']", count: 1
    assert_select "link[rel='stylesheet']", count: 2
    assert_includes response.body, "/assets/what_do_you_think-"
    assert_select ".wdyt-hero h1", text: "What do people think?"
    assert_select ".wdyt-kicker", text: "Opinion, backed by the facts"
    assert_select ".wdyt-result header", text: "Those in the know say"
    assert_select ".wdyt-result header strong", count: 0
    assert_select ".wdyt-result-scale > div:last-child span", text: /Neutral/, count: 0
  end

  test "moderation follows the alternative presentation and retains featured controls" do
    category = Category.create!(name: "Featured controls", slug: "featured-controls")
    OpinionQuestion.create!(category: category, title: "Featured control question", slug: "featured-control-question",
      statement: "This question should be featured.", live: true, display_order: 1,
      response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    moderator = create_user!(email: "site-moderator@example.test", password: "password123",
      first_name: "Site", last_name: "Moderator", role: :moderator)
    sign_in moderator, scope: :user
    host! "whatsyourview.localhost"

    get moderator_root_path

    assert_response :success
    assert_select "body[data-site='what-do-you-think']"
    assert_select ".brand > span:last-child", text: "What's Your View?"
    assert_includes response.body, "/assets/what_do_you_think-"
    assert_select ".moderation-page"
    assert_select "#featured-order" do
      assert_select "button", text: "Promote", minimum: 1
      assert_select "button", text: "Demote", minimum: 1
    end
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
    host! "whatsyourview.localhost"

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
    host! "whatsyourview.localhost"

    get new_user_session_path

    assert_response :success
    assert_select ".account-masthead", text: /Return to your opinions/
    assert_select ".account-switch", text: /New to What's Your View\?/
    assert_select ".account-note h2", text: "What's retained"
  end

  test "alternative account uses plain but precise consent language" do
    participant = User.create!(first_name: "Account", last_name: "Holder",
      email: "alternative-account@example.test", password: "password123")
    sign_in participant, scope: :user
    host! "whatsyourview.localhost"

    get account_path

    assert_response :success
    assert_select ".account-masthead", text: /confirm your consent to take part/
    assert_select ".account-consent-review", text: /Review the current terms and your consent/
    assert_select ".account-consent-review", text: /Some answers may reveal political opinions/
    assert_select ".account-danger-zone", text: /This cannot be undone/
  end

  test "shared topic pages name informed opinion as canonical" do
    category = Category.create!(name: "Canonical", slug: "canonical")
    question = OpinionQuestion.create!(category: category, title: "Canonical question", slug: "canonical-question",
      statement: "This is the canonical proposition.", live: true, display_order: 1,
      response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    host! "whatsyourview.localhost"

    get opinion_question_path(question)

    assert_response :success
    assert_select "link[rel='canonical'][href='http://informedopinion.localhost/topics/canonical-question']", count: 1
  end

  test "alternative help is detailed and uses direct language" do
    host! "whatsyourview.localhost"

    get help_path

    assert_response :success
    assert_select "h1", text: "How it works"
    assert_select ".help-article", text: /See what people think—and what they know/
    assert_select "#idea", text: /does not tell you what the right opinion is/
    assert_select "#results strong", text: "Neutral", count: 0
    assert_select "#taking-part", text: /Read its exact wording/
    assert_select "#weight", text: /importance rating of Supporting \(1\), Significant \(2\), or Foundational \(3\)/
    assert_select "#weight", text: /deliberately narrow/, count: 0
    assert_select "#limits", text: /transparent account/, count: 0
    assert_select ".help-article section", minimum: 7
  end

  test "password recovery returns the participant to the requesting site" do
    create_user!(email: "alternative-reset@example.test", password: "password123",
      first_name: "Reset", last_name: "Participant")
    host! "whatsyourview.localhost"

    assert_difference "ActionMailer::Base.deliveries.size", 1 do
      post user_password_path, params: { user: { email: "alternative-reset@example.test" } }
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal "What's Your View? password reset", mail.subject
    assert_includes mail.body.encoded, "whatsyourview.localhost/users/password/edit"
  end
end
