module Moderator
  class OpinionQuestionPublicationsController < BaseController
    def create
      question.publish!
      redirect_to moderator_root_path(anchor: "question-preparation"), notice: "#{question.title} is now live."
    rescue ActiveRecord::RecordInvalid => error
      redirect_to moderator_root_path(anchor: "question-preparation"), alert: error.record.errors.full_messages.to_sentence
    end

    def destroy
      question.update!(live: false)
      redirect_to moderator_root_path(anchor: "question-preparation"), notice: "#{question.title} has been taken out of public view."
    end

    private

    def question
      @question ||= OpinionQuestion.find_by!(slug: params[:opinion_question_id])
    end
  end
end
