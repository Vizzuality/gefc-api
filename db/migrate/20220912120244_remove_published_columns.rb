class RemovePublishedColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :groups, :published, :boolean
    remove_column :subgroups, :published, :boolean
    remove_column :indicators, :published, :boolean
  end
end
