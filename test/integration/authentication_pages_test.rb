require "test_helper"

class AuthenticationPagesTest < ActionDispatch::IntegrationTest
  test "sign-in page uses the editorial account layout" do
    get new_user_session_path

    assert_response :success
    assert_select "section.account-page"
    assert_select ".account-masthead h1", "Sign in"
    assert_select "form.account-form"
    assert_select "input[type=email][autocomplete=email]"
    assert_select "input[type=password][autocomplete=current-password]"
    assert_select ".account-note h2", "What is retained"
    assert_select ".auth-intro", count: 0
    assert_not_includes response.body, "270 sourced facts"
  end

  test "registration page uses the editorial account layout" do
    get new_user_registration_path

    assert_response :success
    assert_select "section.account-page"
    assert_select ".account-masthead h1", "Create an account"
    assert_select "form.account-form"
    assert_select "input[name='user[first_name]']"
    assert_select "input[name='user[last_name]']"
    assert_select "input[name='user[email]']"
    assert_select "input[name='user[password]']"
    assert_select "input[name='user[password_confirmation]']"
    assert_select "input[name='user[accept_terms]'][type=checkbox]"
    assert_select "input[name='user[consent_sensitive_data]'][type=checkbox]"
    assert_select ".account-note h2", "How the account is used"
  end

  test "password request page shares the account layout" do
    get new_user_password_path

    assert_response :success
    assert_select "section.account-page"
    assert_select ".account-masthead h1", "Reset your password"
    assert_select "form.account-form"
    assert_select "input[type=email]"
    assert_select ".simple-auth-card", count: 0
  end

  test "password change page shares the account layout" do
    get edit_user_password_path(reset_password_token: "example-token")

    assert_response :success
    assert_select "section.account-page"
    assert_select ".account-masthead h1", "Choose a new password"
    assert_select "form.account-form"
    assert_select "input[name='user[reset_password_token]'][type=hidden]"
    assert_select "input[name='user[password]']"
    assert_select "input[name='user[password_confirmation]']"
  end
end
