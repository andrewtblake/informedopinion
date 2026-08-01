require "test_helper"

class ProductionSeedingTest < ActiveSupport::TestCase
  test "rerunning seeds preserves existing editorial content and participation" do
    category = Category.create!(name: "Locally reviewed science", slug: "science-environment")
    topic = OpinionQuestion.create!(
      category: category,
      slug: "climate-change",
      title: "Moderator-edited title",
      statement: "Moderator-edited proposition.",
      response_options: [ "Definitely true", "Probably true", "Unsure", "Probably false", "Definitely false" ],
      display_order: 1,
      accent: "teal",
      live: true
    )
    fact = topic.fact_questions.create!(
      prompt: "Moderator-edited fact question?",
      options: [ "One", "Two", "Three", "Four" ],
      correct_option: 0,
      explanation: "A moderator's explanation that the catalogue must not overwrite.",
      source_name: "Moderated source",
      source_url: "https://example.com/moderated-source",
      display_order: 1,
      importance_weight: 3,
      importance_rationale: "The moderator assessed this as foundational.",
      evidence_direction: -1
    )
    community_fact = topic.fact_questions.create!(
      prompt: "A community-authored fact question?",
      options: [ "Alpha", "Beta", "Gamma", "Delta" ],
      correct_option: 1,
      explanation: "This contribution must remain outside the curated bank without being deleted.",
      source_name: "Community source",
      source_url: "https://example.com/community-source",
      display_order: 31,
      importance_weight: 2,
      importance_rationale: "The community and moderator assessed this as significant.",
      evidence_direction: 0
    )
    user = User.create!(
      first_name: "Genuine",
      last_name: "Participant",
      email: "genuine@example.com",
      password: "long-enough-password"
    )
    response = user.fact_responses.create!(
      fact_question: fact,
      selected_option: 0,
      correct: true,
      answered_at: Time.current,
      attempt_count: 1,
      weight_before: 0,
      weight_after: 1
    )

    assert_output(/Seeded 15 opinion questions and 422 fact questions\./) do
      load Rails.root.join("db/seeds.rb")
    end

    assert_equal "Moderator-edited title", topic.reload.title
    assert_equal "Moderator-edited fact question?", fact.reload.prompt
    assert_equal community_fact, FactQuestion.find(community_fact.id)
    assert_equal response, FactResponse.find(response.id)
    assert user.reload.participant?
    assert_equal 1, User.count
  end
end
