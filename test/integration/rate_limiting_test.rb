require "test_helper"

class RateLimitingTest < ActionDispatch::IntegrationTest
  setup do
    Rack::Attack.cache.store.clear
  end

  teardown do
    Rack::Attack.cache.store.clear
  end

  test "repeated sign-in attempts are throttled by IP address" do
    20.times do
      post user_session_path, params: {
        user: { email: "absent@example.com", password: "incorrect-password" }
      }
      assert_response :unprocessable_content
    end

    post user_session_path, params: {
      user: { email: "absent@example.com", password: "incorrect-password" }
    }

    assert_response :too_many_requests
    assert_equal "300", response.headers["Retry-After"]
  end

  test "password reset requests are throttled independently" do
    10.times do
      post user_password_path, params: { user: { email: "absent@example.com" } }
      assert_response :see_other
    end

    post user_password_path, params: { user: { email: "absent@example.com" } }

    assert_response :too_many_requests
    assert_equal "3600", response.headers["Retry-After"]
  end

  test "health checks are always permitted" do
    25.times do
      get rails_health_check_path
      assert_response :success
    end
  end
end
