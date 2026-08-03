class AddReviewOutcomeToFactCalibrations < ActiveRecord::Migration[8.1]
  def change
    add_column :fact_question_calibration_assessments, :reviewed_specialist_knowledge, :integer
    add_column :fact_question_calibration_assessments, :reviewed_answerability, :integer

    add_check_constraint :fact_question_calibration_assessments,
      "reviewed_specialist_knowledge IS NULL OR reviewed_specialist_knowledge BETWEEN 1 AND 6",
      name: "fact_calibrations_reviewed_specialist_range"
    add_check_constraint :fact_question_calibration_assessments,
      "reviewed_answerability IS NULL OR reviewed_answerability BETWEEN 0 AND 5",
      name: "fact_calibrations_reviewed_answerability_range"
  end
end
