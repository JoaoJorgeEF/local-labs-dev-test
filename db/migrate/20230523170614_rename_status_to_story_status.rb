class RenameStatusToStoryStatus < ActiveRecord::Migration[7.0]
  def change
    rename_column :stories, :status, :story_status
  end
end
