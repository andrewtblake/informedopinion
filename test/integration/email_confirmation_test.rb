require "test_helper"

class EmailConfirmationTest < ActionDispatch::IntegrationTest
  test "new participant verifies their email and is signed in" do
    assert_difference [ "User.count", "ActionMailer::Base.deliveries.size" ], 1 do
      register(email: "verify@example.test")
    end

    user = User.find_by!(email: "verify@example.test")
    assert_not user.confirmed?
    assert_redirected_to pending_user_confirmation_path

    follow_redirect!
    assert_select "h1", text: "Check your email"
    assert_select "[data-controller='confirmation-status']", count: 1

    get user_confirmation_status_path, as: :json
    assert_equal false, response.parsed_body.fetch("confirmed")
    assert_equal false, response.parsed_body.fetch("signed_in")

    get confirmation_path_from(ActionMailer::Base.deliveries.last)
    assert_redirected_to root_path
    assert user.reload.confirmed?

    follow_redirect!
    assert_select ".site-nav", text: /Hello, Ada/
    assert_select ".flash-notice", text: /Email verified/
  end

  test "alternative signup email and confirmation retain the alternative identity" do
    host! "whatsyourview.localhost"

    assert_difference "ActionMailer::Base.deliveries.size", 1 do
      register(email: "wyv-verify@example.test")
    end

    mail = ActionMailer::Base.deliveries.last
    assert_equal "What's Your View? confirm your email", mail.subject
    assert_equal [ "What's Your View?" ], mail[:from].display_names
    assert_includes mail.body.encoded, "whatsyourview.localhost/users/confirmation"

    get confirmation_path_from(mail)
    follow_redirect!

    assert_select "body[data-site='whats-your-view']"
    assert_select ".flash-notice", text: /What's Your View\?/
  end

  test "confirmation returns a new participant to their proposal draft" do
    get register_to_propose_path
    assert_redirected_to new_user_registration_path

    assert_difference "ActionMailer::Base.deliveries.size", 1 do
      register(email: "proposal-verify@example.test")
    end

    get confirmation_path_from(ActionMailer::Base.deliveries.last)

    assert_redirected_to opinion_question_proposals_path
    follow_redirect!
    assert_select "form.proposal-form[data-proposal-draft-authenticated-value='true']"
    assert_select "input[type='submit'][value='Send proposal']"
  end

  test "confirmed participants can request another message without account disclosure" do
    create_user!(first_name: "Existing", last_name: "Participant",
      email: "existing-confirmed@example.test", password: "password123")

    assert_no_difference "ActionMailer::Base.deliveries.size" do
      post user_confirmation_path, params: { user: { email: "existing-confirmed@example.test" } }
    end

    assert_redirected_to pending_user_confirmation_path
  end

  private

  def register(email:)
    post user_registration_path, params: {
      user: {
        first_name: "Ada",
        last_name: "Lovelace",
        email: email,
        password: "password123",
        password_confirmation: "password123",
        accept_terms: "1",
        consent_sensitive_data: "1"
      }
    }
  end

  def confirmation_path_from(mail)
    html = Nokogiri::HTML(mail.html_part.body.decoded)
    URI.parse(html.at_css("a")["href"]).request_uri
  end
end
