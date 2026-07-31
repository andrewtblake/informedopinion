require "test_helper"

class ModerationWorkflowTest < ActionDispatch::IntegrationTest
  setup do
    @category = Category.create!(name: "Public policy", slug: "public-policy")
    @topic = OpinionQuestion.create!(
      slug: "moderation-topic",
      title: "Moderation topic",
      statement: "A proposition suitable for moderation tests.",
      category: @category,
      response_options: [ "Strongly agree", "Agree", "Neutral", "Disagree", "Strongly disagree" ],
      display_order: 1
    )
    @fact = @topic.fact_questions.create!(
      prompt: "Is this fact question clear?",
      options: [ "Yes", "No", "Sometimes", "Unknown" ],
      correct_option: 0,
      explanation: "An explanation.",
      source_name: "Source",
      source_url: "https://example.com/source",
      display_order: 1
    )
    @participant = create_user("participant@example.com")
    @moderator = create_user("moderator@example.com", role: :moderator)
  end

  test "a signed-in user can report a fact and propose an opinion question" do
    sign_in @participant, scope: :user

    assert_difference "FactQuestionFlag.count", 1 do
      post fact_question_flags_path, params: {
        fact_question_id: @fact.id,
        fact_question_flag: { category: "unclear", details: "The time period is not specified." }
      }
    end
    assert_redirected_to opinion_question_quiz_path(@topic)

    assert_difference "OpinionQuestionProposal.count", 1 do
      post opinion_question_proposals_path, params: {
        opinion_question_proposal: {
          title: "A proposed question",
          statement: "The United Kingdom should adopt this specific policy.",
          category_id: @category.id,
          tags_text: "United Kingdom, Public policy",
          geographic_scope: "United Kingdom",
          rationale: "The issue is consequential, contested, and factually assessable."
        }
      }
    end
    assert_redirected_to opinion_question_proposals_path

    follow_redirect!
    assert_response :success
    assert_select "h1", "Proposals"
    assert_select ".proposal-record", text: /A proposed question/
    assert_select ".proposal-status", text: /Pending/
  end

  test "a user sees only their own proposal history and its statuses" do
    approved = @participant.opinion_question_proposals.create!(
      title: "An approved proposal",
      statement: "The United Kingdom should adopt a defined public policy.",
      category: @category,
      tags_text: "United Kingdom, Public policy",
      rationale: "It is consequential and factually assessable.",
      status: :approved,
      reviewer: @moderator,
      review_notes: "Internal editorial notes."
    )
    other_user = create_user("other@example.com")
    other_user.opinion_question_proposals.create!(
      title: "Another user's proposal",
      statement: "A proposition belonging to another user.",
      category: @category,
      tags_text: "Public policy",
      rationale: "A rationale."
    )

    sign_in @participant, scope: :user
    get opinion_question_proposals_path

    assert_response :success
    assert_select "h1", "Proposals"
    assert_select ".proposal-record", count: 1
    assert_select ".proposal-record h3", approved.title
    assert_select ".proposal-status", text: /Approved/
    assert_not_includes response.body, "Another user's proposal"
    assert_not_includes response.body, "Internal editorial notes"
    assert_not_includes response.body, @moderator.email
  end

  test "the former new-proposal address leads to the proposals space" do
    sign_in @participant, scope: :user

    get new_opinion_question_proposal_path

    assert_redirected_to opinion_question_proposals_path
  end

  test "a dislike requires a reason while a like does not" do
    sign_in @participant, scope: :user

    assert_no_difference "OpinionQuestionReaction.count" do
      post opinion_question_reaction_path(@topic), params: {
        opinion_question_reaction: { kind: "dislike", reason: "" }
      }
    end
    assert_redirected_to opinion_question_path(@topic)

    assert_difference "OpinionQuestionReaction.count", 1 do
      post opinion_question_reaction_path(@topic), params: {
        opinion_question_reaction: { kind: "like" }
      }
    end
    assert @participant.opinion_question_reactions.reload.last.like?

    assert_no_difference "OpinionQuestionReaction.count" do
      post opinion_question_reaction_path(@topic), params: {
        opinion_question_reaction: { kind: "dislike", reason: "The proposition combines two policies." }
      }
    end
    assert_equal "The proposition combines two policies.", @participant.opinion_question_reactions.reload.last.reason
  end

  test "moderator reviews anonymous editorial inputs" do
    flag = @participant.fact_question_flags.create!(
      fact_question: @fact,
      category: :inaccurate,
      details: "The cited figure conflicts with the source."
    )
    proposal = @participant.opinion_question_proposals.create!(
      title: "A proposed question",
      statement: "The United Kingdom should adopt this specific policy.",
      category: @category,
      tags_text: "United Kingdom, Public policy",
      rationale: "This is consequential and contested."
    )

    sign_in @participant, scope: :user
    get moderator_root_path
    assert_response :forbidden

    sign_out @participant
    sign_in @moderator, scope: :user
    get moderator_root_path

    assert_response :success
    assert_select "h1", text: "Moderation"
    assert_select ".moderation-item", text: /Is this fact question clear/
    assert_select ".moderation-item", text: /A proposed question/
    assert_select ".moderation-item", text: /participant@example.com/, count: 0
    assert_select ".moderation-item", text: /Participant User/, count: 0

    patch moderator_fact_question_flag_path(flag), params: {
      fact_question_flag: { status: "resolved", resolution_notes: "Source checked." }
    }
    assert flag.reload.resolved?
    assert_equal @moderator, flag.reviewer

    patch moderator_opinion_question_proposal_path(proposal), params: {
      opinion_question_proposal: { status: "approved", review_notes: "Suitable for research." }
    }
    assert proposal.reload.approved?
    assert_equal @moderator, proposal.reviewer
  end

  private

  def create_user(email, role: :participant)
    User.create!(
      first_name: role.to_s.humanize,
      last_name: "User",
      email: email,
      password: "password123",
      role: role
    )
  end
end
