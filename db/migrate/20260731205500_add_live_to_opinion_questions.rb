class AddLiveToOpinionQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :opinion_questions, :live, :boolean, default: true, null: false
    add_index :opinion_questions, :live
  end
end
