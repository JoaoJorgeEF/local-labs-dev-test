class AddStatusToStory < ActiveRecord::Migration[7.0]
  def change
    add_column :stories, :status, :string
  end
end
