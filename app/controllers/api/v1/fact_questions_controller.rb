class Api::V1::FactQuestionsController < Api::V1::BaseController
  MAXIMUM_BULK_SIZE = 30

  def index
    render json: { fact_questions: parent.fact_questions.map { self.class.serialize(_1) } }
  end

  def show
    render json: self.class.serialize(fact_question)
  end

  def create
    record = create_for!(parent, fact_attributes)
    audit!(action: "fact_question.create", resource: record, changes: record.attributes.except("created_at", "updated_at"))
    render json: self.class.serialize(record), status: :created
  end

  def bulk_create
    payload = params.require(:fact_questions)
    unless payload.is_a?(Array) && payload.length.between?(1, MAXIMUM_BULK_SIZE)
      return render json: { error: "invalid_batch", message: "Provide between 1 and #{MAXIMUM_BULK_SIZE} fact questions." }, status: :unprocessable_entity
    end

    records = FactQuestion.transaction do
      created = payload.map { |attributes| create_for!(parent, permitted(attributes)) }
      created.each { audit!(action: "fact_question.create", resource: _1, changes: _1.attributes.except("created_at", "updated_at")) }
      created
    end
    render json: { fact_questions: records.map { self.class.serialize(_1) }, opinion_question_live: parent.reload.live? }, status: :created
  end

  def update
    before = fact_question.attributes
    FactQuestion.transaction do
      fact_question.update!(fact_attributes)
      fact_question.opinion_question.tap do |opinion|
        opinion.unpublish_if_fact_bank_not_ready!
      end
      changes = fact_question.attributes.filter_map do |key, value|
        [ key, { "from" => before[key], "to" => value } ] if before[key] != value
      end.to_h
      audit!(action: "fact_question.update", resource: fact_question, changes: changes)
    end
    render json: self.class.serialize(fact_question.reload)
  end

  def destroy
    if fact_question.fact_responses.exists?
      return render json: { error: "has_responses", message: "Answered fact questions cannot be deleted; set withdrawn_at instead." }, status: :unprocessable_entity
    end
    opinion = fact_question.opinion_question
    snapshot = self.class.serialize(fact_question)
    FactQuestion.transaction do
      audit!(action: "fact_question.destroy", resource: fact_question, changes: snapshot)
      fact_question.destroy!
      opinion.unpublish_if_fact_bank_not_ready!
    end
    head :no_content
  end

  def self.serialize(record)
    record.as_json(only: %i[id opinion_question_id prompt options correct_option explanation source_name source_url
      importance_weight importance_rationale evidence_direction display_order withdrawn_at])
  end

  private

  def parent
    identifier = params[:opinion_question_id] || params[:id]
    @parent ||= identifier.to_s.match?(/\A\d+\z/) ? OpinionQuestion.find(identifier) : OpinionQuestion.find_by!(slug: identifier)
  end

  def fact_question
    @fact_question ||= FactQuestion.find(params[:id])
  end

  def fact_attributes
    permitted(params.require(:fact_question))
  end

  def permitted(attributes)
    attributes = attributes.to_unsafe_h if attributes.respond_to?(:to_unsafe_h)
    ActionController::Parameters.new(attributes).permit(:prompt, :correct_option, :explanation, :source_name, :source_url,
      :importance_weight, :importance_rationale, :evidence_direction, :withdrawn_at, options: [])
  end

  def create_for!(opinion, attributes)
    opinion.fact_questions.create!(attributes.merge(display_order: opinion.fact_questions.maximum(:display_order).to_i + 1))
  end
end
