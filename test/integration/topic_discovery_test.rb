require "test_helper"

class TopicDiscoveryTest < ActionDispatch::IntegrationTest
  setup do
    science = Category.create!(name: "Science", slug: "science")
    economics = Category.create!(name: "Economics", slug: "economics")
    evidence = Tag.create!(name: "Evidence", slug: "evidence")

    @earth = create_question("Earth shape", "The Earth has a measured shape.", science, 1)
    @earth.tags << evidence
    @tax = create_question("Tax policy", "A question about public revenue.", economics, 2)
  end

  test "visitor searches and browses the question catalogue" do
    get root_path

    assert_response :success
    assert_select "link[rel='icon'][href='/icon.svg']", count: 1
    assert_select "link[rel='icon'][href='/favicon.ico']", count: 1
    assert_select "link[rel='icon'][href='/icon-32.png'][sizes='32x32']", count: 1
    assert_select ".topic-search input[type='search'][placeholder='Search questions, categories, or tags']"
    assert_select ".topic-search button[type='submit'][aria-label='Search']", count: 1
    assert_select ".topic-search input[type='submit']", count: 0
    assert_select ".catalogue-order-field label", text: "Order by"
    assert_select ".catalogue-order-field select[data-action='change->autosubmit#submit']", count: 1
    assert_select ".topic-search select[name='category']", count: 0
    assert_select ".editorial-topic", count: 2
    assert_select ".category-list", text: /Economics.*Science/m
    assert_select ".editorial-tag-cloud a", text: "Evidence"

    get root_path, params: { q: "measured" }
    assert_select ".editorial-topic", count: 1
    assert_select ".editorial-topic h2", text: "Earth shape"

    get root_path, params: { category: "economics" }
    assert_select ".editorial-topic", count: 1
    assert_select ".editorial-topic h2", text: "Tax policy"

    get root_path, params: { tag: "evidence" }
    assert_select ".editorial-topic", count: 1
    assert_select ".editorial-topic h2", text: "Earth shape"
    assert_select ".selected-tag-filter", text: /Selected: Evidence/
    assert_select ".selected-tag-filter a[href='#{root_path(sort: "featured")}']", text: "Clear tag"
    assert_select ".editorial-tag-cloud a.is-selected", text: "Evidence"

    create_question("A new question", "A third catalogue entry.", @earth.category, 3)
    get root_path, params: { sort: "title" }
    assert_select ".editorial-topic h2" do |headings|
      assert_equal [ "A new question", "Earth shape", "Tax policy" ], headings.map { _1.text.strip }
    end
  end

  test "discovery ranks participation and genuine disagreement" do
    users = 3.times.map { |index| create_user(index) }
    users[0].user_opinions.create!(opinion_question: @earth, position: 0)
    users[1].user_opinions.create!(opinion_question: @earth, position: 4)
    users[2].user_opinions.create!(opinion_question: @tax, position: 2)

    discovery = TopicDiscovery.new([ @tax, @earth ])

    assert_equal [ @earth, @tax ], discovery.popular
    assert_equal [ @earth ], discovery.controversial
    assert_equal 2, discovery.respondents(@earth)
  end

  private

  def create_question(title, statement, category, order)
    OpinionQuestion.create!(
      slug: title.parameterize,
      title: title,
      statement: statement,
      category: category,
      response_options: [ "Definitely true", "Probably true", "Unsure", "Probably false", "Definitely false" ],
      display_order: order
    )
  end

  def create_user(index)
    create_user!(
      first_name: "Reader",
      last_name: index.to_s,
      email: "reader#{index}@example.com",
      password: "password123"
    )
  end
end
