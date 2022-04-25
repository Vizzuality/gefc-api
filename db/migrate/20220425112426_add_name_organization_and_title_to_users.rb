class AddNameOrganizationAndTitleToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :name, :string
    add_column :users, :organization, :string
    add_column :users, :title, :string
  end
end
