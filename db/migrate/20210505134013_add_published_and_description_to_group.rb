class AddPublishedAndDescriptionToGroup < ActiveRecord::Migration[6.1]
  def up
    add_column :groups, :published, :boolean, default: false, null: false
    add_column :groups, :description, :string
  end

  def down
    remove_column :groups, :published
    remove_column :groups, :description
  end
end
