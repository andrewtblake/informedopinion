class AddFeaturedPriorityToOpinionQuestions < ActiveRecord::Migration[8.1]
  def change
    add_column :opinion_questions, :featured_priority, :integer, default: 0, null: false
    add_check_constraint :opinion_questions,
      "featured_priority BETWEEN -10 AND 10",
      name: "opinion_questions_featured_priority_range"
  end
end
