class FactQuestionProposalEligibility
  attr_reader :user, :opinion_question, :progress

  def initialize(user, opinion_question)
    @user = user
    @opinion_question = opinion_question
    @progress = OpinionProgress.new(user, opinion_question)
  end

  def eligible?
    enough_questions? && progress.complete? && progress.raw_weight >= minimum_score
  end

  def explanation
    return "This question needs at least #{minimum_questions} published fact questions before contributions open." unless enough_questions?
    return "Answer all #{progress.total} published fact questions before proposing another." unless progress.complete?
    return "A score of at least #{formatted_score}% is required; your current score is #{formatted_current_score}%." if progress.raw_weight < minimum_score

    "You are eligible to propose a fact question."
  end

  def minimum_questions
    Rails.configuration.x.fact_question_proposals.minimum_existing_questions
  end

  def minimum_score
    Rails.configuration.x.fact_question_proposals.minimum_correct_percentage
  end

  private

  def enough_questions?
    progress.total >= minimum_questions
  end

  def formatted_score
    format("%g", minimum_score)
  end

  def formatted_current_score
    format("%g", progress.raw_weight)
  end
end
