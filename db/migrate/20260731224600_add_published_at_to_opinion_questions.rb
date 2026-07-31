class AddPublishedAtToOpinionQuestions < ActiveRecord::Migration[8.1]
  def up
    add_column :opinion_questions, :published_at, :datetime
    execute "UPDATE opinion_questions SET published_at = created_at WHERE live = TRUE"
  end

  def down
    remove_column :opinion_questions, :published_at
  end
end
