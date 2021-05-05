class AddPublishedAndDescriptionToSubgroups < ActiveRecord::Migration[6.1]
  def up
    add_column :subgroups, :published, :boolean, default: false, null: false
    add_column :subgroups, :description, :string
  end

  def down
    remove_column :subgroups, :published
    remove_column :subgroups, :description
  end
end
