require "test_helper"

class ModerationHeartbeatTest < ActionDispatch::IntegrationTest
  setup do
    @moderator = create_user!(email: "heartbeat-moderator@example.test", password: "password123",
      first_name: "Heartbeat", last_name: "Moderator", role: :moderator)
    @other_moderator = create_user!(email: "other-heartbeat@example.test", password: "password123",
      first_name: "Other", last_name: "Moderator", role: :moderator)
    @participant = create_user!(email: "heartbeat-participant@example.test", password: "password123",
      first_name: "Heartbeat", last_name: "Participant")
    @category = Category.create!(name: "Heartbeat policy", slug: "heartbeat-policy")
    @draft = OpinionQuestion.create!(category: @category, title: "Draft heartbeat", statement: "The policy should apply.",
      slug: "draft-heartbeat", live: false, display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate", response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    @proposal = @participant.opinion_question_proposals.create!(category: @category, title: "Heartbeat proposal",
      statement: "The UK should adopt this measure.", tags_text: "United Kingdom", rationale: "It is contested.")
  end

  test "heartbeat is moderator-only and unseen state is durable per moderator" do
    sign_in @participant, scope: :user
    get moderator_heartbeat_path
    assert_response :forbidden

    sign_out @participant
    sign_in @moderator, scope: :user
    get moderator_heartbeat_path
    assert_response :success
    sections = response.parsed_body.fetch("sections")
    proposal_item = sections.fetch("opinion-question-proposals").fetch("items").sole
    assert_equal "opinion-proposal:#{@proposal.id}", proposal_item.fetch("key")

    post moderator_moderation_views_path, params: { items: [ proposal_item ] }
    assert_response :no_content
    get moderator_heartbeat_path
    assert_equal 0, response.parsed_body.dig("sections", "opinion-question-proposals", "count")

    sign_out @moderator
    sign_in @other_moderator, scope: :user
    get moderator_heartbeat_path
    assert_equal 1, response.parsed_body.dig("sections", "opinion-question-proposals", "count")
  end

  test "an item becomes unseen again when its displayed version changes" do
    sign_in @moderator, scope: :user
    get moderator_heartbeat_path
    draft_item = response.parsed_body.dig("sections", "question-preparation", "items").sole
    post moderator_moderation_views_path, params: { items: [ draft_item ] }

    travel 1.second do
      @draft.fact_questions.create!(prompt: "What is the current measured value?",
        options: %w[One Two Three Four], correct_option: 0, explanation: "The source reports one.",
        source_name: "Official source", source_url: "https://example.test/source", display_order: 1)
    end

    get moderator_heartbeat_path
    assert_equal 1, response.parsed_body.dig("sections", "question-preparation", "count")
  end
end
