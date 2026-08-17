class GenerateSocialCardsJob < ApplicationJob
  queue_as :default

  def perform(opinion_question_id)
    question = OpinionQuestion.find(opinion_question_id)
    SocialCard::SITE_KEYS.each { SocialCardGenerator.generate!(question, _1) }
  end
end
