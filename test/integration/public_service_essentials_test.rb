require "test_helper"

class PublicServiceEssentialsTest < ActionDispatch::IntegrationTest
  test "privacy terms and methodology are publicly available" do
    {
      privacy_path => [ "How your information is used", "Cookies", "Your data-protection rights" ],
      terms_path => [ "Terms of participation", "Good faith", "Ending participation" ],
      methodology_path => [ "Methodology", "Individual opinion weight", "Collective informed opinion" ]
    }.each do |path, copy|
      get path

      assert_response :success
      copy.each { |text| assert_includes response.body, text }
    end
  end

  test "registration requires and records separate participation consent" do
    assert_no_difference "User.count" do
      post user_registration_path, params: {
        user: {
          first_name: "Ada",
          last_name: "Lovelace",
          email: "ada@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      }
    end
    assert_response :unprocessable_content

    assert_difference "User.count", 1 do
      post user_registration_path, params: {
        user: {
          first_name: "Ada",
          last_name: "Lovelace",
          email: "ada@example.com",
          password: "password123",
          password_confirmation: "password123",
          accept_terms: "1",
          consent_sensitive_data: "1"
        }
      }
    end

    user = User.find_by!(email: "ada@example.com")
    assert user.terms_accepted_at.present?
    assert user.special_category_consent_at.present?
    assert_equal Rails.configuration.x.privacy.notice_version, user.privacy_notice_version
  end

  test "an existing account must review current terms before continuing" do
    user = User.create!(
      first_name: "Existing",
      last_name: "Participant",
      email: "existing@example.com",
      password: "password123"
    )
    sign_in user, scope: :user

    get root_path
    assert_redirected_to account_path

    patch consent_account_path, params: {
      accept_terms: "1",
      consent_sensitive_data: "1"
    }
    assert_redirected_to account_path
    assert user.reload.privacy_consent_current?

    get root_path
    assert_response :success
  end

  test "account deletion requires the current password and removes participation" do
    category = Category.create!(name: "Account test", slug: "account-test")
    topic = OpinionQuestion.create!(
      category: category,
      slug: "account-deletion-test",
      title: "Account deletion test",
      statement: "A test proposition.",
      response_options: [ "Strongly agree", "Agree", "Neutral", "Disagree", "Strongly disagree" ],
      display_order: 1
    )
    fact = topic.fact_questions.create!(
      prompt: "A test fact?",
      options: [ "Correct", "Wrong one", "Wrong two", "Wrong three" ],
      correct_option: 0,
      explanation: "An explanation.",
      source_name: "Source",
      source_url: "https://example.com",
      display_order: 1
    )
    user = create_user!(
      first_name: "Delete",
      last_name: "Me",
      email: "delete@example.com",
      password: "password123"
    )
    user.user_opinions.create!(opinion_question: topic, position: 0)
    user.fact_responses.create!(
      fact_question: fact,
      selected_option: 0,
      answered_at: Time.current,
      weight_before: 0,
      weight_after: 100
    )
    sign_in user, scope: :user

    assert_no_difference "User.count" do
      delete account_path, params: { current_password: "wrong-password", confirmation: "DELETE" }
    end
    assert_response :unprocessable_content

    assert_difference "User.count", -1 do
      delete account_path, params: { current_password: "password123", confirmation: "DELETE" }
    end

    assert_redirected_to root_path
    assert_empty UserOpinion.where(user_id: user.id)
    assert_empty FactResponse.where(user_id: user.id)
    assert OpinionQuestion.exists?(topic.id)
    assert FactQuestion.exists?(fact.id)
  end
end
