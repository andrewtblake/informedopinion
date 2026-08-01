class Api::V1::OpinionQuestionPublicationsController < Api::V1::BaseController
  def create
    question.publish!
    audit!(action: "opinion_question.publish", resource: question, changes: { "live" => { "from" => false, "to" => true } })
    render json: { id: question.id, live: true, published_at: question.published_at }
  end

  def destroy
    was_live = question.live?
    question.update!(live: false)
    audit!(action: "opinion_question.unpublish", resource: question, changes: { "live" => { "from" => was_live, "to" => false } })
    render json: { id: question.id, live: false }
  end

  private

  def question
    identifier = params[:opinion_question_id]
    @question ||= identifier.to_s.match?(/\A\d+\z/) ? OpinionQuestion.find(identifier) : OpinionQuestion.find_by!(slug: identifier)
  end
end
