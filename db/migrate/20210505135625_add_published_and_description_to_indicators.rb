class AddPublishedAndDescriptionToIndicators < ActiveRecord::Migration[6.1]
  def up
    add_column :indicators, :published, :boolean, default: false, null: false
    add_column :indicators, :description, :string
  end

  def down
    remove_column :indicators, :published
    remove_column :indicators, :description
  end
end
