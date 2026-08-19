require "test_helper"

class PublicStatisticsTest < ActionDispatch::IntegrationTest
  setup do
    @question = OpinionQuestion.create!(
      slug: "public-statistics-test",
      title: "Public statistics test",
      statement: "This proposition should be accepted.",
      response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS,
      display_order: 1,
      live: true
    )
    @first_user = create_user!(first_name: "First", last_name: "Participant",
      email: "statistics-first@example.test", password: "password123")
    @second_user = create_user!(first_name: "Second", last_name: "Participant",
      email: "statistics-second@example.test", password: "password123")
    @first_opinion = @first_user.user_opinions.create!(opinion_question: @question, position: 0)
    @second_opinion = @second_user.user_opinions.create!(opinion_question: @question, position: 0)
    @first_opinion.update!(position: 4)
    @second_opinion.update!(position: 4)
  end

  test "statistics are hidden and unlinked by default" do
    get root_path

    assert_response :success
    assert_select "a[href='#{public_statistics_path}']", count: 0

    get public_statistics_path
    assert_response :not_found
  end

  test "the enabled page presents participation, changes and topic results" do
    with_public_statistics_enabled do
      get public_statistics_path

      assert_response :success
      assert_select "h1", text: "Statistics"
      assert_select ".statistics-metric", text: /2.*participants with a published-topic opinion/m
      assert_select ".statistics-metric", text: /Fewer than 5.*people who have changed/m
      assert_select ".statistics-metric", text: /Fewer than 5.*revisions crossing/m
      assert_select ".transition-table", text: /Small groups/, count: 0
      assert_select ".table-scroll[tabindex='0'][role='region'] .transition-table caption",
        text: "Recorded changes from one response to another"
      assert_select ".topic-statistics-row", text: /Public statistics test.*Participants.*2.*Unweighted.*-100/m
      assert_select "a[href='#{public_statistics_path}']", minimum: 1
    end
  end

  test "transition cells are published only once the privacy threshold is met" do
    summary = PublicStatisticsSummary.new(minimum_group_size: 2)

    assert_equal 2, summary.transition_counts.fetch([ 0, 4 ])
    assert_equal 2, summary.people_who_changed
    assert_equal 2, summary.opinions_changed
    assert_equal 2, summary.revision_count
  end

  test "the enabled page follows the alternative site presentation" do
    host! "whatsyourview.localhost"

    with_public_statistics_enabled do
      get public_statistics_path

      assert_response :success
      assert_select "body[data-site='whats-your-view']"
      assert_select ".statistics-masthead", text: /See how many people have taken part/
      assert_includes response.body, "/assets/whats_your_view-"
    end
  end

  private

  def with_public_statistics_enabled
    previous = ENV["PUBLIC_STATISTICS_ENABLED"]
    ENV["PUBLIC_STATISTICS_ENABLED"] = "true"
    yield
  ensure
    ENV["PUBLIC_STATISTICS_ENABLED"] = previous
  end
end
