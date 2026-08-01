require "test_helper"

class NextFactQuestionTest < ActiveSupport::TestCase
  setup do
    @user = create_user!(
      first_name: "Ada",
      last_name: "Lovelace",
      email: "ada-next@example.com",
      password: "password123"
    )
    @topic = OpinionQuestion.create!(
      slug: "sequencing-test",
      title: "Sequencing test",
      statement: "A test proposition.",
      response_options: [ "Strongly agree", "Agree", "Neutral", "Disagree", "Strongly disagree" ],
      display_order: 1
    )
    @opinion = @user.user_opinions.create!(opinion_question: @topic, position: 0)
    10.times do |index|
      [ 1, 0, -1 ].each do |direction|
        @topic.fact_questions.create!(
          prompt: "Fact #{index} direction #{direction}?",
          options: [ "A", "B", "C", "D" ],
          correct_option: 0,
          explanation: "Evidence.",
          source_name: "Source",
          source_url: "https://example.com",
          evidence_direction: direction,
          display_order: (index * 3) + direction + 2
        )
      end
    end
  end

  test "starts supportively and introduces challenge gradually" do
    observed = 12.times.map do
      question = service.call
      create_response(question)
      question.evidence_direction
    end

    assert_equal [ 1, 1, 0, 1, 0, 1, 0, -1, 1, 0, -1, 1 ], observed
  end

  test "reverses supportive and challenging valence for disagreement" do
    @opinion.update!(position: 4)

    observed = 8.times.map do
      question = service.call
      create_response(question)
      question.evidence_direction
    end

    assert_equal [ -1, -1, 0, -1, 0, -1, 0, 1 ], observed
  end

  test "reviews every question once before repeating one" do
    @topic.fact_questions.each { |question| create_response(question) }

    reviewed_ids = @topic.fact_questions.count.times.map do
      question = service.call
      response = @user.fact_responses.find_by!(fact_question: question)
      response.update!(attempt_count: response.attempt_count + 1, answered_at: Time.current)
      question.id
    end

    assert_equal @topic.fact_questions.count, reviewed_ids.uniq.count
    assert_equal [ 2 ], @user.fact_responses.distinct.pluck(:attempt_count)
  end

  test "prefers facts with fewer attempts in a review round" do
    @topic.fact_questions.each { |question| create_response(question) }
    already_reviewed = @topic.fact_questions.first
    @user.fact_responses.find_by!(fact_question: already_reviewed).update!(attempt_count: 2)

    refute_equal already_reviewed, service.call
  end

  private

  def service
    NextFactQuestion.new(user: @user, opinion_question: @topic, user_opinion: @opinion)
  end

  def create_response(question)
    @user.fact_responses.create!(
      fact_question: question,
      selected_option: 0,
      attempt_count: 1,
      weight_before: 0,
      weight_after: 0,
      answered_at: Time.current
    )
  end
end
