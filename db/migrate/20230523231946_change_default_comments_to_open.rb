class ChangeDefaultCommentsToOpen < ActiveRecord::Migration[7.0]
  def change
    change_column :stories, :comments_open, :boolean, :default => true
  end
end
