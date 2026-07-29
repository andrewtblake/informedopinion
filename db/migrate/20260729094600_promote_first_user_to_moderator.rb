class PromoteFirstUserToModerator < ActiveRecord::Migration[8.1]
  def up
    execute "UPDATE users SET role = 1 WHERE id = 1"
  end

  def down
    execute "UPDATE users SET role = 0 WHERE id = 1"
  end
end
