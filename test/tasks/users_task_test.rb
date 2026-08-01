require "test_helper"
require "rake"

class UsersTaskTest < ActiveSupport::TestCase
  setup do
    Rails.application.load_tasks unless Rake::Task.task_defined?("users:promote_moderator")
  end

  test "promote_moderator promotes the registered account designated by email" do
    user = create_user!(
      first_name: "Initial",
      last_name: "Moderator",
      email: "blakethomasandrew@gmail.com",
      password: "long-enough-password"
    )

    with_email(" BLAKETHOMASANDREW@GMAIL.COM ") do
      assert_output(/Promoted blakethomasandrew@gmail.com to moderator\./) do
        invoke_task
      end
    end

    assert user.reload.moderator?
  end

  private

  def invoke_task
    Rake::Task["users:promote_moderator"].tap(&:reenable).invoke
  end

  def with_email(value)
    previous = ENV["EMAIL"]
    ENV["EMAIL"] = value
    yield
  ensure
    ENV["EMAIL"] = previous
  end
end
