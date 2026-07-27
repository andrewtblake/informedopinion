require "test_helper"

class OpinionProgressTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(
      first_name: "Ada",
      last_name: "Lovelace",
      email: "ada@example.com",
      password: "password123"
    )
    @opinion = OpinionQuestion.create!(
      slug: "test-topic",
      title: "Test topic",
      statement: "A test proposition.",
      response_options: [ "A", "B", "C", "D", "E" ],
      display_order: 1
    )
    2.times do |index|
      @opinion.fact_questions.create!(
        prompt: "Fact #{index}?",
        options: [ "Yes", "No", "Sometimes", "Unknown" ],
        correct_option: 0,
        explanation: "Because.",
        source_name: "Source",
        source_url: "https://example.com",
        display_order: index + 1
      )
    end
  end

  test "weight is correct latest responses divided by all fact questions" do
    first, second = @opinion.fact_questions
    create_response(first, 0)

    progress = OpinionProgress.new(@user, @opinion)
    assert_equal 1, progress.answered
    assert_equal 1, progress.correct
    assert_equal 50.0, progress.weight

    response = create_response(second, 1)
    assert_equal 50.0, OpinionProgress.new(@user, @opinion).weight

    response.update!(selected_option: 0)
    assert_equal 100.0, OpinionProgress.new(@user, @opinion).weight
  end

  test "uses importance for opinion weight and retains the unweighted score" do
    supporting, foundational = @opinion.fact_questions
    foundational.update!(
      importance_weight: 3,
      importance_rationale: "This is foundational to the proposition."
    )
    create_response(supporting, 0)
    create_response(foundational, 1)

    progress = OpinionProgress.new(@user, @opinion)

    assert_equal 25.0, progress.weight
    assert_equal 50.0, progress.raw_weight
    assert_equal 1, progress.earned_importance
    assert_equal 4, progress.total_importance
  end

  private

  def create_response(question, selected_option)
    @user.fact_responses.create!(
      fact_question: question,
      selected_option: selected_option,
      weight_before: 0,
      weight_after: 0,
      answered_at: Time.current
    )
  end
end
