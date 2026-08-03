require "digest"

class FactQuestionCalibrationAudit
  VERSION = 1
  FAILURE_CATEGORIES = FactQuestionCalibrationAssessment::FAILURE_CATEGORIES

  class InvalidWorksheet < StandardError; end

  def initialize(questions: OpinionQuestion.includes(:category, :fact_questions).in_display_order)
    @questions = questions
  end

  def worksheet
    {
      "schema_version" => VERSION,
      "generated_at" => Time.current.iso8601,
      "environment" => Rails.env,
      "instructions" => {
        "specialist_knowledge" => "Rate the underlying fact from 1 to 6 before considering the choices.",
        "answerability" => "Rate the presented item from 1 to 5, or 0 when it is unfit.",
        "reasons" => "Give a concise reason for each rating. For answerability 0, also select a failure category and propose remediation."
      },
      "failure_categories" => FAILURE_CATEGORIES,
      "banks" => questions.map { bank_entry(_1) }
    }
  end

  def self.validate!(document, questions: OpinionQuestion.includes(:fact_questions).in_display_order)
    errors = []
    unless document["schema_version"] == VERSION
      errors << "schema_version must be #{VERSION}"
    end

    current = questions.flat_map(&:fact_questions).index_by { _1.id.to_s }
    entries = Array(document["banks"]).flat_map { Array(_1["questions"]) }
    errors << "worksheet contains duplicate fact-question IDs" if entries.map { _1["id"].to_s }.uniq.length != entries.length

    entries.each do |entry|
      prefix = "fact question #{entry["id"]}"
      record = current[entry["id"].to_s]
      if record.nil?
        errors << "#{prefix} is not present in the selected database"
        next
      end
      errors << "#{prefix} changed after export" unless entry["content_fingerprint"] == fingerprint(record)

      assessment = entry.fetch("assessment", {})
      specialist = assessment["specialist_knowledge"]
      answerability = assessment["answerability"]
      unless FactQuestion::SPECIALIST_KNOWLEDGE_LEVELS.key?(specialist)
        errors << "#{prefix} specialist_knowledge must be from 1 to 6"
      end
      unless FactQuestion::ANSWERABILITY_LEVELS.key?(answerability)
        errors << "#{prefix} answerability must be from 0 to 5"
      end
      errors << "#{prefix} needs a specialist-knowledge rationale" if assessment["specialist_knowledge_rationale"].blank?
      errors << "#{prefix} needs an answerability rationale" if assessment["answerability_rationale"].blank?
      unless (1..5).include?(assessment["specialist_knowledge_confidence"])
        errors << "#{prefix} specialist-knowledge confidence must be from 1 to 5"
      end
      unless (1..5).include?(assessment["answerability_confidence"])
        errors << "#{prefix} answerability confidence must be from 1 to 5"
      end

      next unless answerability == 0

      unless FAILURE_CATEGORIES.include?(assessment["failure_category"])
        errors << "#{prefix} needs a recognised failure category"
      end
      errors << "#{prefix} needs a remediation proposal" if assessment["remediation"].blank?
    end

    missing = current.keys - entries.map { _1["id"].to_s }
    errors << "worksheet is missing fact questions: #{missing.join(", ")}" if missing.any?
    raise InvalidWorksheet, errors.join("\n") if errors.any?

    true
  end

  def self.report(document)
    banks = Array(document["banks"]).map do |bank|
      entries = Array(bank["questions"])
      specialist = entries.map { _1.dig("assessment", "specialist_knowledge") }
      answerability = entries.map { _1.dig("assessment", "answerability") }
      {
        "opinion_question" => bank["opinion_question"],
        "question_count" => entries.length,
        "specialist_knowledge" => distribution(specialist, 1..6),
        "answerability" => distribution(answerability, 0..5),
        "cross_tabulation" => cross_tabulation(entries),
        "unrated_question_ids" => entries.filter_map do |entry|
          entry["id"] if entry.dig("assessment", "specialist_knowledge").nil? ||
            entry.dig("assessment", "answerability").nil?
        end,
        "unfit_question_ids" => entries.filter_map { _1["id"] if _1.dig("assessment", "answerability") == 0 },
        "unused_specialist_levels" => (1..6).to_a - specialist.compact.uniq,
        "unused_answerability_levels" => (1..5).to_a - answerability.compact.uniq
      }
    end
    {
      "schema_version" => VERSION,
      "bank_count" => banks.length,
      "question_count" => banks.sum { _1["question_count"] },
      "banks" => banks
    }
  end

  def self.fingerprint(record)
    Digest::SHA256.hexdigest(JSON.generate([
      record.opinion_question_id,
      record.prompt,
      record.options,
      record.correct_option,
      record.explanation,
      record.source_name,
      record.source_url
    ]))
  end

  class << self
    private

    def distribution(values, range)
      range.to_h { |rating| [ rating.to_s, values.count(rating) ] }
        .merge("unrated" => values.count(&:nil?))
    end

    def cross_tabulation(entries)
      entries.each_with_object({}) do |entry, result|
        specialist = entry.dig("assessment", "specialist_knowledge")
        answerability = entry.dig("assessment", "answerability")
        next if specialist.nil? || answerability.nil?

        key = "#{specialist}:#{answerability}"
        result[key] = result.fetch(key, 0) + 1
      end
    end
  end

  private

  attr_reader :questions

  def bank_entry(question)
    {
      "opinion_question" => {
        "id" => question.id,
        "slug" => question.slug,
        "title" => question.title,
        "statement" => question.statement,
        "category" => question.category&.name,
        "live" => question.live?
      },
      "questions" => question.fact_questions.sort_by(&:display_order).map { fact_entry(_1) }
    }
  end

  def fact_entry(fact)
    {
      "id" => fact.id,
      "display_order" => fact.display_order,
      "withdrawn" => fact.withdrawn?,
      "prompt" => fact.prompt,
      "options" => fact.options,
      "correct_option" => fact.correct_option,
      "correct_answer" => fact.correct_answer,
      "explanation" => fact.explanation,
      "importance_weight" => fact.importance_weight,
      "evidence_direction" => fact.evidence_direction,
      "source_name" => fact.source_name,
      "source_url" => fact.source_url,
      "content_fingerprint" => self.class.fingerprint(fact),
      "assessment" => {
        "specialist_knowledge" => fact.specialist_knowledge,
        "specialist_knowledge_rationale" => nil,
        "specialist_knowledge_confidence" => nil,
        "answerability" => fact.answerability,
        "answerability_rationale" => nil,
        "answerability_confidence" => nil,
        "failure_category" => nil,
        "remediation" => nil
      }
    }
  end
end
