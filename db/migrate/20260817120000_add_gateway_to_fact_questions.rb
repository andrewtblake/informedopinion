class AddGatewayToFactQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :fact_questions, :gateway, :boolean, null: false, default: false
    add_column :fact_questions, :gateway_rationale, :text
    add_index :fact_questions, [ :opinion_question_id, :gateway ]
  end
end
