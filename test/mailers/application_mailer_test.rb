require "test_helper"

class ApplicationMailerTest < ActionMailer::TestCase
  test "uses the public sender and reply address" do
    mail = SystemMailer.with(to: "reader@example.com").delivery_test

    assert_equal [ "accounts@informedopinion.info" ], mail.from
    assert_equal [ "hello@informedopinion.info" ], mail.reply_to
  end

  test "delivery test identifies the configured public host" do
    mail = SystemMailer.with(to: "reader@example.com").delivery_test

    assert_equal [ "reader@example.com" ], mail.to
    assert_equal "Informed Opinion email delivery test", mail.subject
    assert_includes mail.body.encoded, "example.com"
  end

  test "password recovery replies reach the public contact address" do
    user = create_user!(
      first_name: "Mailer",
      last_name: "Test",
      email: "mailer-test@example.com",
      password: "password123"
    )

    mail = DeviseMailer.reset_password_instructions(user, "reset-token")

    assert_equal [ "accounts@informedopinion.info" ], mail.from
    assert_equal [ "hello@informedopinion.info" ], mail.reply_to
  end

  test "confirmation email uses the requested identity and host" do
    user = User.new(first_name: "New", last_name: "Participant", email: "new@example.test")
    mail = DeviseMailer.confirmation_instructions(
      user,
      "confirmation-token",
      site_key: :whats_your_view,
      site_url_options: { host: "whatsyourview.info", protocol: "https" }
    )

    assert_equal "What's Your View? confirm your email", mail.subject
    assert_equal [ "What's Your View?" ], mail[:from].display_names
    assert_includes mail.text_part.body.decoded,
      "https://whatsyourview.info/users/confirmation?confirmation_token=confirmation-token"
  end

  test "alternative password recovery uses its own identity and reply address" do
    user = create_user!(
      first_name: "Alternative",
      last_name: "Mailer",
      email: "alternative-mailer@example.com",
      password: "password123"
    )

    mail = DeviseMailer.reset_password_instructions(
      user,
      "alternative-reset-token",
      site_key: :whats_your_view,
      site_url_options: { host: "whatsyourview.info", protocol: "https" }
    )

    assert_equal [ "accounts@informedopinion.info" ], mail.from
    assert_equal [ "What's Your View?" ], mail[:from].display_names
    assert_equal [ "hello@whatsyourview.info" ], mail.reply_to
    assert_equal "What's Your View? password reset", mail.subject
    assert_includes mail.text_part.body.decoded, "https://whatsyourview.info/users/password/edit"
  end
end
