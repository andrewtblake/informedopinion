class AddKnowledgeAndAnswerabilityToFactQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :fact_questions, :specialist_knowledge, :integer
    add_column :fact_questions, :answerability, :integer
    add_column :fact_question_proposals, :specialist_knowledge, :integer
    add_column :fact_question_proposals, :answerability, :integer

    add_check_constraint :fact_questions,
      "specialist_knowledge IS NULL OR specialist_knowledge BETWEEN 1 AND 6",
      name: "fact_questions_specialist_knowledge_range"
    add_check_constraint :fact_questions,
      "answerability IS NULL OR answerability BETWEEN 0 AND 5",
      name: "fact_questions_answerability_range"
    add_check_constraint :fact_question_proposals,
      "specialist_knowledge IS NULL OR specialist_knowledge BETWEEN 1 AND 6",
      name: "fact_question_proposals_specialist_knowledge_range"
    add_check_constraint :fact_question_proposals,
      "answerability IS NULL OR answerability BETWEEN 0 AND 5",
      name: "fact_question_proposals_answerability_range"
  end
end
