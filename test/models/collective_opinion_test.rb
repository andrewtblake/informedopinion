require "test_helper"

class CollectiveOpinionTest < ActiveSupport::TestCase
  setup do
    @topic = OpinionQuestion.create!(
      slug: "collective-test",
      title: "Collective test",
      statement: "A proposition.",
      response_options: [ "Strongly agree", "Agree", "Neutral", "Disagree", "Strongly disagree" ],
      display_order: 1
    )
    @facts = 2.times.map do |index|
      @topic.fact_questions.create!(
        prompt: "Fact #{index}?",
        options: [ "Correct", "Incorrect", "Unsupported", "Unknown" ],
        correct_option: 0,
        explanation: "Evidence.",
        source_name: "Source",
        source_url: "https://example.com",
        display_order: index + 1
      )
    end
  end

  test "each opinion contributes in proportion to its topic knowledge" do
    fully_informed = create_user("full")
    partly_informed = create_user("part")
    uninformed = create_user("none")

    fully_informed.user_opinions.create!(opinion_question: @topic, position: 0)
    partly_informed.user_opinions.create!(opinion_question: @topic, position: 3)
    uninformed.user_opinions.create!(opinion_question: @topic, position: 4)

    answer(fully_informed, @facts.first, 0)
    answer(fully_informed, @facts.second, 0)
    answer(partly_informed, @facts.first, 0)
    answer(uninformed, @facts.first, 1)

    result = CollectiveOpinion.new(@topic)

    assert_equal 3, result.respondents
    assert_equal 2, result.informed_respondents
    assert_in_delta 1.5, result.weighted_total
    assert_equal "Strongly agree", result.leading_response[:label]
    assert_equal 66.7, result.distribution[0][:share]
    assert_equal 33.3, result.distribution[3][:share]
    assert_equal 0.0, result.distribution[4][:share]
    assert_equal 0.5, result.weighted_score
    assert_equal 75.0, result.indicator_position
    assert_equal 50.0, result.score_percentage
    assert_equal "Toward yes", result.result_label
    assert_equal 405.0, result.dial_angle
  end

  test "reports no collective result when every opinion has zero weight" do
    create_user("zero").user_opinions.create!(opinion_question: @topic, position: 2)

    result = CollectiveOpinion.new(@topic)

    assert_equal 1, result.respondents
    assert_nil result.leading_response
    assert_nil result.weighted_score
    assert_equal 50.0, result.indicator_position
    assert_nil result.score_percentage
    assert_equal "No weighted result", result.result_label
    assert_equal 360, result.dial_angle
    assert result.distribution.all? { |bucket| bucket[:share].zero? }
  end

  test "uses the full semicircle for the opinion endpoints" do
    user = create_user("endpoint")
    user.user_opinions.create!(opinion_question: @topic, position: 4)
    @facts.each { |fact| answer(user, fact, 0) }

    result = CollectiveOpinion.new(@topic)

    assert_equal(-1.0, result.weighted_score)
    assert_equal 270.0, result.dial_angle

    user.user_opinions.find_by!(opinion_question: @topic).update!(position: 0)
    result = CollectiveOpinion.new(@topic)

    assert_equal 1.0, result.weighted_score
    assert_equal 450.0, result.dial_angle
  end

  test "collective contributions use fact importance" do
    user = create_user("weighted")
    user.user_opinions.create!(opinion_question: @topic, position: 0)
    @facts.second.update!(
      importance_weight: 3,
      importance_rationale: "Foundational evidence."
    )
    answer(user, @facts.first, 0)
    answer(user, @facts.second, 1)

    result = CollectiveOpinion.new(@topic)

    assert_in_delta 0.25, result.weighted_total
    assert_equal 1, result.informed_respondents
  end

  test "an informed neutral opinion pulls the normalized result toward neutral" do
    yes_user = create_user("yes")
    neutral_user = create_user("neutral")
    yes_user.user_opinions.create!(opinion_question: @topic, position: 0)
    neutral_user.user_opinions.create!(opinion_question: @topic, position: 2)
    @facts.each do |fact|
      answer(yes_user, fact, 0)
      answer(neutral_user, fact, 0)
    end

    result = CollectiveOpinion.new(@topic)

    assert_equal 0.5, result.weighted_score
    assert_equal 75.0, result.indicator_position
  end

  test "withdrawn facts no longer contribute to the collective result" do
    user = create_user("withdrawn")
    user.user_opinions.create!(opinion_question: @topic, position: 0)
    answer(user, @facts.first, 0)
    @facts.first.update!(withdrawn_at: Time.current)

    result = CollectiveOpinion.new(@topic)

    assert_equal 0, result.informed_respondents
    assert_nil result.weighted_score
    assert_equal "No weighted result", result.result_label
  end

  private

  def create_user(prefix)
    User.create!(
      first_name: prefix.capitalize,
      last_name: "Person",
      email: "#{prefix}@example.com",
      password: "password123"
    )
  end

  def answer(user, fact, option)
    user.fact_responses.create!(
      fact_question: fact,
      selected_option: option,
      weight_before: 0,
      weight_after: 0,
      answered_at: Time.current
    )
  end
end
