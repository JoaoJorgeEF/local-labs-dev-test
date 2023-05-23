class ChangeWriterColumnToNullable < ActiveRecord::Migration[7.0]
  def change
    change_column :stories, :writer_id, :bigint, null: true
    change_column :stories, :reviewer_id, :bigint, null: true
  end
end
