class ReconcileApprovedOpinionQuestionDrafts < ActiveRecord::Migration[8.1]
  RESPONSE_OPTIONS = [
    "Strongly agree",
    "Somewhat agree",
    "Neither agree nor disagree",
    "Somewhat disagree",
    "Strongly disagree"
  ].freeze

  class Proposal < ActiveRecord::Base
    self.table_name = "opinion_question_proposals"
  end

  class Question < ActiveRecord::Base
    self.table_name = "opinion_questions"
  end

  class Fact < ActiveRecord::Base
    self.table_name = "fact_questions"
  end

  class TagRecord < ActiveRecord::Base
    self.table_name = "tags"
  end

  class Tagging < ActiveRecord::Base
    self.table_name = "opinion_question_tags"
  end

  def up
    minimum_questions = ENV.fetch("FACT_PROPOSAL_MINIMUM_QUESTIONS", 10).to_i

    Question.find_each do |question|
      fact_count = Fact.where(opinion_question_id: question.id).count
      question.update_columns(live: false) if fact_count < minimum_questions
    end

    Proposal.where(status: 1, published_opinion_question_id: nil).find_each do |proposal|
      title = proposal.final_title.presence || proposal.title
      statement = proposal.final_statement.presence || proposal.statement
      question = Question.create!(
        title: title,
        statement: statement,
        slug: available_slug(title),
        category_id: proposal.category_id,
        response_options: RESPONSE_OPTIONS,
        display_order: Question.maximum(:display_order).to_i + 1,
        accent: "slate",
        live: false,
        created_at: Time.current,
        updated_at: Time.current
      )
      attach_tags(question, proposal.tags_text)
      proposal.update_columns(
        final_title: title,
        final_statement: statement,
        published_opinion_question_id: question.id,
        updated_at: Time.current
      )
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration,
      "Legacy approved proposals were materialised as editorial drafts"
  end

  private

  def available_slug(title)
    base = title.parameterize.presence || "opinion-question"
    candidate = base
    suffix = 2
    while Question.exists?(slug: candidate)
      candidate = "#{base}-#{suffix}"
      suffix += 1
    end
    candidate
  end

  def attach_tags(question, tags_text)
    tags_text.to_s.split(",").map(&:strip).reject(&:blank?).uniq.each do |name|
      tag = TagRecord.find_or_create_by!(slug: name.parameterize) do |record|
        record.name = name
      end
      Tagging.create!(
        opinion_question_id: question.id,
        tag_id: tag.id,
        created_at: Time.current,
        updated_at: Time.current
      )
    end
  end
end
