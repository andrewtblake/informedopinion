class Api::V1::ModerationIssuesController < Api::V1::BaseController
  TYPES = {
    "fact_report" => { model: FactQuestionFlag, status: :status },
    "opinion_proposal" => { model: OpinionQuestionProposal, status: :status },
    "fact_proposal" => { model: FactQuestionProposal, status: :status },
    "opinion_reaction" => { model: OpinionQuestionReaction.dislike, status: :moderation_status }
  }.freeze

  def index
    status = params[:status].presence || "pending"
    issues = TYPES.flat_map do |type, configuration|
      next [] if params[:type].present? && params[:type] != type

      scope = configuration.fetch(:model)
      if status != "all"
        status_column = configuration.fetch(:status)
        model_class = scope.respond_to?(:klass) ? scope.klass : scope
        next [] unless model_class.defined_enums.fetch(status_column.to_s).key?(status)

        scope = scope.where(status_column => status)
      end
      scope.order(:created_at).map { serialize(type, _1) }
    end.sort_by { _1.fetch("created_at") }
    render json: { moderation_issues: issues, count: issues.length }
  end

  def show
    render json: serialize(issue_type, issue)
  end

  # Saves an editorial candidate without deciding the proposal.
  def update
    unless issue_type == "opinion_proposal" && issue.pending?
      return render json: { error: "unsupported_update", message: "Only a pending opinion proposal's candidate wording can be edited here." }, status: :unprocessable_entity
    end

    before = issue.attributes
    issue.update!(params.require(:opinion_question_proposal).permit(:final_title, :final_statement))
    audit!(action: "opinion_proposal.candidate_update", resource: issue, changes: diff(before, issue.attributes))
    render json: serialize(issue_type, issue)
  end

  def approve
    return already_decided unless issue_pending?

    published = case issue_type
    when "opinion_proposal"
      PublishOpinionQuestionProposal.new(
        proposal: issue,
        reviewer: current_moderator,
        final_title: params[:final_title].presence || issue.final_title.presence || issue.title,
        final_statement: params[:final_statement].presence || issue.final_statement.presence || issue.statement,
        review_notes: params[:review_notes]
      ).call
    when "fact_proposal"
      PublishFactQuestionProposal.new(
        proposal: issue,
        reviewer: current_moderator,
        attributes: fact_proposal_attributes,
        review_notes: params[:review_notes]
      ).call
    else
      return render json: { error: "wrong_action", message: "Fact reports are resolved, not approved." }, status: :unprocessable_entity
    end
    audit!(action: "#{issue_type}.approve", resource: issue.reload, changes: { "published_id" => published.id })
    render json: serialize(issue_type, issue.reload)
  end

  def decline
    return already_decided unless issue_pending?
    unless %w[opinion_proposal fact_proposal].include?(issue_type)
      return render json: { error: "wrong_action" }, status: :unprocessable_entity
    end

    issue.update!(status: :declined, reviewer: current_moderator, review_notes: params.require(:review_notes), reviewed_at: Time.current)
    audit!(action: "#{issue_type}.decline", resource: issue, changes: { "review_notes" => issue.review_notes })
    render json: serialize(issue_type, issue)
  end

  def resolve
    return already_decided unless issue_pending?

    if issue_type == "opinion_reaction"
      return resolve_opinion_reaction
    end
    return render(json: { error: "wrong_action" }, status: :unprocessable_entity) unless issue_type == "fact_report"

    outcome = params.require(:outcome)
    FactQuestionFlag.transaction do
      case outcome
      when "corrected"
        issue.fact_question.update!(fact_question_attributes.merge(withdrawn_at: nil))
        finish_report!(:resolved, :corrected)
      when "withdrawn"
        issue.fact_question.update!(withdrawn_at: Time.current)
        issue.fact_question.opinion_question.unpublish_if_fact_bank_not_ready!
        finish_report!(:resolved, :withdrawn)
      when "dismissed"
        finish_report!(:dismissed, :no_change)
      else
        return render json: { error: "invalid_outcome" }, status: :unprocessable_entity
      end
      audit!(action: "fact_report.#{outcome}", resource: issue, changes: { "resolution_notes" => issue.resolution_notes })
    end
    render json: serialize(issue_type, issue.reload)
  end

  private

  def issue_type
    @issue_type ||= params[:id].to_s.split(":", 2).first
  end

  def issue
    configuration = TYPES.fetch(issue_type) { raise ActiveRecord::RecordNotFound }
    @issue ||= configuration.fetch(:model).find(params[:id].to_s.split(":", 2).second)
  end

  def serialize(type, record)
    common = record.as_json.except("user_id", "proposer_id", "reviewer_id")
    context = case type
    when "fact_report"
      fact = record.fact_question
      { "fact_question" => Api::V1::FactQuestionsController.serialize(fact),
        "opinion_question" => fact.opinion_question.as_json(only: %i[id title statement slug]) }
    when "fact_proposal"
      { "opinion_question" => record.opinion_question.as_json(only: %i[id title statement slug]) }
    when "opinion_proposal"
      { "category" => record.category.name }
    when "opinion_reaction"
      { "opinion_question" => record.opinion_question.as_json(only: %i[id title statement slug]) }
    end
    common.merge("id" => "#{type}:#{record.id}", "type" => type, "created_at" => record.created_at.iso8601,
      "editorial_context" => context)
  end

  def fact_proposal_attributes
    params.fetch(:fact_question_proposal, {}).permit(:prompt, :correct_option, :explanation, :source_name, :source_url,
      :importance_weight, :importance_rationale, :evidence_direction, :specialist_knowledge, :answerability,
      options: []).to_h.presence || issue.attributes.slice(
        "prompt", "options", "correct_option", "explanation", "source_name", "source_url",
        "importance_weight", "importance_rationale", "evidence_direction", "specialist_knowledge", "answerability"
      )
  end

  def fact_question_attributes
    params.require(:fact_question).permit(:prompt, :correct_option, :explanation, :source_name, :source_url,
      :importance_weight, :importance_rationale, :evidence_direction, :specialist_knowledge, :answerability,
      options: [])
  end

  def finish_report!(status, resolution)
    issue.update!(status: status, resolution_action: resolution, resolution_notes: params.require(:resolution_notes),
      reviewer: current_moderator, reviewed_at: Time.current)
  end

  def resolve_opinion_reaction
    outcome = params.require(:outcome)
    unless %w[reviewed dismissed].include?(outcome)
      return render json: { error: "invalid_outcome" }, status: :unprocessable_entity
    end

    issue.update!(moderation_status: outcome, moderation_notes: params[:resolution_notes],
      reviewer: current_moderator, reviewed_at: Time.current)
    audit!(action: "opinion_reaction.#{outcome}", resource: issue,
      changes: { "moderation_notes" => issue.moderation_notes })
    render json: serialize(issue_type, issue.reload)
  end

  def already_decided
    render json: { error: "already_decided" }, status: :conflict
  end

  def issue_pending?
    issue_type == "opinion_reaction" ? issue.moderation_pending? : issue.pending?
  end

  def diff(before, after)
    after.filter_map { |key, value| [ key, { "from" => before[key], "to" => value } ] if before[key] != value }.to_h
  end
end
