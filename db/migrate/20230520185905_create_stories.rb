class CreateStories < ActiveRecord::Migration[7.0]
  def change
    create_table :stories do |t|
      t.string :headline
      t.text :body

      t.timestamps
    end
  end
end
