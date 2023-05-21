class AddOrganizationToStories < ActiveRecord::Migration[7.0]
  def change
    add_reference :stories, :organization, null: false, foreign_key: true
  end
end
