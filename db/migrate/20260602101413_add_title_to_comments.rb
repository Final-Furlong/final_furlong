class AddTitleToComments < ActiveRecord::Migration[8.1]
  def change
    add_column :horse_comments, :title, :string
  end
end

