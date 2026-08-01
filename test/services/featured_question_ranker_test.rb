require "test_helper"

class FeaturedQuestionRankerTest < ActiveSupport::TestCase
  setup do
    @science = Category.create!(name: "Science", slug: "science")
    @law = Category.create!(name: "Law", slug: "law")
    @first = create_question("First science", @science, 1, created_at: 1.year.ago)
    @second = create_question("Second science", @science, 2, created_at: 1.year.ago)
    @law_question = create_question("Law question", @law, 3, created_at: 1.year.ago)
  end

  test "credible informed participation raises the featured order" do
    user = create_user(1)
    opinion = user.user_opinions.create!(opinion_question: @law_question, position: 0)
    fact = create_fact(@law_question)
    user.fact_responses.create!(
      fact_question: fact,
      selected_option: 0,
      correct: true,
      weight_before: 0,
      weight_after: 100,
      answered_at: Time.current
    )

    assert opinion.persisted?
    assert_equal @law_question, ranker.rank.first
    assert_equal 1, ranker.metric(@law_question).informed_respondents
  end

  test "category diversity avoids consecutive similar questions when scores are close" do
    assert_equal [ @first, @law_question, @second ], ranker.rank
  end

  test "an editorial adjustment can override the automatic baseline" do
    @second.update!(featured_priority: 1)

    assert_equal @second, ranker.rank.first
  end

  test "newly published questions receive temporary visibility" do
    @law_question.update!(published_at: Time.current)

    assert_equal @law_question, ranker.rank.first
    assert_equal 1.0, ranker.metric(@law_question).freshness
  end

  private

  def ranker
    FeaturedQuestionRanker.new([ @first, @second, @law_question ], now: Time.current)
  end

  def create_question(title, category, order, created_at:)
    OpinionQuestion.create!(
      slug: title.parameterize,
      title: title,
      statement: "A clearly stated proposition.",
      category: category,
      response_options: [ "Strongly agree", "Agree", "Neutral", "Disagree", "Strongly disagree" ],
      display_order: order,
      created_at: created_at,
      published_at: created_at
    )
  end

  def create_fact(question)
    question.fact_questions.create!(
      prompt: "Which answer is correct?",
      options: %w[A B C D],
      correct_option: 0,
      explanation: "A is correct.",
      source_name: "Source",
      source_url: "https://example.com",
      display_order: 1
    )
  end

  def create_user(index)
    create_user!(
      first_name: "Reader",
      last_name: index.to_s,
      email: "featured#{index}@example.com",
      password: "password123"
    )
  end
end
