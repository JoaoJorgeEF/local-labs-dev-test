class AddCommentsOpenToStories < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :comments_open, :boolean
  end
end
