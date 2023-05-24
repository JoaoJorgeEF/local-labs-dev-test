class AddOrganizationRefToUsers < ActiveRecord::Migration[7.0]
  def change
    # add_reference :users, :organization
    # add_column :users, :organization_slug, :string
    # add_reference :users, :organization, foreign_key: { to_table: :organization, column: :slug }
  end
  add_foreign_key :users, :organizations, column: :organization_slug, primary_key: :slug
end
