module FactBank
  module_function

  def build(rows, sources)
    rows.map do |prompt, options, correct_option, explanation, source, evidence_direction, importance_weight,
      importance_rationale, specialist_knowledge, answerability|
      source_name, source_url = sources.fetch(source)
      {
        prompt: prompt,
        options: options,
        correct_option: correct_option,
        explanation: explanation,
        source_name: source_name,
        source_url: source_url,
        evidence_direction: evidence_direction,
        importance_weight: importance_weight,
        importance_rationale: importance_rationale,
        specialist_knowledge: specialist_knowledge,
        answerability: answerability
      }
    end.freeze
  end
end
