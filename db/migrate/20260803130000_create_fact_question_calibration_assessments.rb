class CreateFactQuestionCalibrationAssessments < ActiveRecord::Migration[8.1]
  def change
    create_table :fact_question_calibration_assessments do |t|
      t.references :fact_question, null: false, foreign_key: true
      t.string :content_fingerprint, null: false
      t.integer :specialist_knowledge, null: false
      t.text :specialist_knowledge_rationale, null: false
      t.integer :specialist_knowledge_confidence, null: false
      t.integer :answerability, null: false
      t.text :answerability_rationale, null: false
      t.integer :answerability_confidence, null: false
      t.string :failure_category
      t.text :remediation
      t.string :assessor_name, null: false
      t.string :run_identifier, null: false
      t.integer :status, null: false, default: 0
      t.references :submitted_by, null: false, foreign_key: { to_table: :users }
      t.references :reviewer, foreign_key: { to_table: :users }
      t.text :review_notes
      t.datetime :reviewed_at
      t.timestamps
    end

    add_index :fact_question_calibration_assessments, :content_fingerprint
    add_index :fact_question_calibration_assessments, :run_identifier
    add_index :fact_question_calibration_assessments,
      %i[fact_question_id created_at],
      name: "index_fact_calibrations_on_question_and_created"
    add_check_constraint :fact_question_calibration_assessments,
      "specialist_knowledge BETWEEN 1 AND 6",
      name: "fact_calibrations_specialist_knowledge_range"
    add_check_constraint :fact_question_calibration_assessments,
      "answerability BETWEEN 0 AND 5",
      name: "fact_calibrations_answerability_range"
    add_check_constraint :fact_question_calibration_assessments,
      "specialist_knowledge_confidence BETWEEN 1 AND 5",
      name: "fact_calibrations_specialist_confidence_range"
    add_check_constraint :fact_question_calibration_assessments,
      "answerability_confidence BETWEEN 1 AND 5",
      name: "fact_calibrations_answerability_confidence_range"
  end
end
