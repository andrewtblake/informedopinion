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
    end
  end

  test "the explicit local alternative host selects what do you think" do
    host! "whatdoyouthink.localhost"
    get root_path

    assert_response :success
    assert_select "body[data-site='what-do-you-think']"
    assert_select ".brand > span:last-child", text: "What Do You Think?"
    assert_select "title", text: "What Do You Think? — knowledge-weighted public opinion"
    assert_select "meta[name='application-name'][content='What Do You Think?']", count: 1
    assert_select "link[rel='icon'][href='/what-do-you-think-icon.svg']", count: 1
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
end
