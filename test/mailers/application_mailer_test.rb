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
    user = User.create!(
      first_name: "Mailer",
      last_name: "Test",
      email: "mailer-test@example.com",
      password: "password123"
    )

    mail = DeviseMailer.reset_password_instructions(user, "reset-token")

    assert_equal [ "accounts@informedopinion.info" ], mail.from
    assert_equal [ "hello@informedopinion.info" ], mail.reply_to
  end
end
