class AddModerationToOpinionQuestionReactions < ActiveRecord::Migration[8.1]
  def change
    add_column :opinion_question_reactions, :moderation_status, :integer
    add_column :opinion_question_reactions, :moderation_notes, :text
    add_column :opinion_question_reactions, :reviewed_at, :datetime
    add_reference :opinion_question_reactions, :reviewer, foreign_key: { to_table: :users, on_delete: :nullify }
    add_index :opinion_question_reactions, :moderation_status

    reversible do |direction|
      direction.up do
        execute "UPDATE opinion_question_reactions SET moderation_status = 0 WHERE kind = 1"
      end
    end
  end
end
