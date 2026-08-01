class Api::V1::OpinionQuestionsController < Api::V1::BaseController
  def index
    questions = OpinionQuestion.includes(:category, :tags).in_display_order
    questions = questions.where(live: ActiveModel::Type::Boolean.new.cast(params[:live])) if params.key?(:live)
    questions = questions.where("title LIKE :q OR statement LIKE :q", q: "%#{OpinionQuestion.sanitize_sql_like(params[:q])}%") if params[:q].present?
    render json: { opinion_questions: questions.map { serialize(_1) } }
  end

  def show
    render json: serialize(question, include_facts: true)
  end

  def create
    record = OpinionQuestion.new(question_attributes)
    record.display_order ||= OpinionQuestion.maximum(:display_order).to_i + 1
    record.accent ||= "slate"
    record.live = false
    record.response_options = PublishOpinionQuestionProposal::RESPONSE_OPTIONS if record.response_options.blank?
    record.slug = available_slug(record.title) if record.slug.blank?
    OpinionQuestion.transaction do
      record.save!
      set_tags(record)
      audit!(action: "opinion_question.create", resource: record, changes: record.previous_changes.except("created_at", "updated_at"))
    end
    render json: serialize(record.reload), status: :created
  end

  def update
    if params.dig(:opinion_question, :live).present? && ActiveModel::Type::Boolean.new.cast(params.dig(:opinion_question, :live)) &&
        question.published_fact_questions.count < Rails.configuration.x.fact_question_proposals.minimum_existing_questions
      return render json: { error: "fact_bank_too_small", message: "This question cannot go live until its fact bank reaches the configured minimum." }, status: :unprocessable_entity
    end
    before = question.attributes
    OpinionQuestion.transaction do
      question.update!(question_attributes)
      set_tags(question) if params.require(:opinion_question).key?(:tag_names)
      audit!(action: "opinion_question.update", resource: question, changes: changed_values(before, question.attributes))
    end
    render json: serialize(question.reload)
  end

  def destroy
    participation = FactResponse.joins(:fact_question).where(fact_questions: { opinion_question_id: question.id })
    if question.user_opinions.exists? || participation.exists?
      return render json: { error: "has_participation", message: "Questions with participation cannot be deleted; set live to false instead." }, status: :unprocessable_entity
    end
    snapshot = serialize(question)
    OpinionQuestion.transaction do
      audit!(action: "opinion_question.destroy", resource: question, changes: snapshot)
      question.destroy!
    end
    head :no_content
  end

  private

  def question
    @question ||= find_question(params[:id])
  end

  def question_attributes
    params.require(:opinion_question).permit(:title, :statement, :slug, :category_id, :featured_priority, :live,
      response_options: []).except(:tag_names)
  end

  def set_tags(record)
    names = Array(params.require(:opinion_question)[:tag_names]).filter_map { _1.to_s.strip.presence }.uniq
    record.tags = names.map { |name| Tag.find_or_create_by!(slug: name.parameterize) { _1.name = name } }
  end

  def serialize(record, include_facts: false)
    result = record.as_json(only: %i[id slug title statement category_id live published_at featured_priority display_order response_options])
    result["category"] = record.category&.name
    result["tags"] = record.tags.map(&:name)
    result["fact_question_count"] = record.published_fact_questions.count
    result["fact_questions"] = record.fact_questions.map { Api::V1::FactQuestionsController.serialize(_1) } if include_facts
    result
  end

  def changed_values(before, after)
    after.filter_map { |key, value| [ key, { "from" => before[key], "to" => value } ] if before[key] != value }.to_h
  end

  def available_slug(title)
    base = title.to_s.parameterize.presence || "opinion-question"
    candidate = base
    suffix = 2
    while OpinionQuestion.exists?(slug: candidate)
      candidate = "#{base}-#{suffix}"
      suffix += 1
    end
    candidate
  end

  def find_question(identifier)
    identifier.to_s.match?(/\A\d+\z/) ? OpinionQuestion.find(identifier) : OpinionQuestion.find_by!(slug: identifier)
  end
end
