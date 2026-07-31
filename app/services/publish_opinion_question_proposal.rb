class PublishOpinionQuestionProposal
  RESPONSE_OPTIONS = [
    "Strongly agree",
    "Somewhat agree",
    "Neither agree nor disagree",
    "Somewhat disagree",
    "Strongly disagree"
  ].freeze

  def initialize(proposal:, reviewer:, final_title:, final_statement:, review_notes: nil)
    @proposal = proposal
    @reviewer = reviewer
    @final_title = final_title.presence || proposal.title
    @final_statement = final_statement.presence || proposal.statement
    @review_notes = review_notes
  end

  def call
    OpinionQuestionProposal.transaction do
      question = OpinionQuestion.create!(
        title: @final_title,
        statement: @final_statement,
        slug: available_slug(@final_title),
        category: @proposal.category,
        response_options: RESPONSE_OPTIONS,
        display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
        accent: "slate",
        live: false
      )
      question.tags = @proposal.tag_names.map do |name|
        Tag.find_or_create_by!(slug: name.parameterize) { _1.name = name }
      end
      @proposal.update!(
        status: :approved,
        final_title: @final_title,
        final_statement: @final_statement,
        published_opinion_question: question,
        reviewer: @reviewer,
        review_notes: @review_notes,
        reviewed_at: Time.current
      )
      question
    end
  end

  private

  def available_slug(title)
    base = title.parameterize.presence || "opinion-question"
    candidate = base
    suffix = 2
    while OpinionQuestion.exists?(slug: candidate)
      candidate = "#{base}-#{suffix}"
      suffix += 1
    end
    candidate
  end
end
