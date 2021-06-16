class AddSubtitleAndSlugToGroups < ActiveRecord::Migration[6.1]
  def up
    add_column :groups, :slug, :string
    add_column :groups, :subtitle, :string
  end

  def down
    remove_column :groups, :slug, :string
    remove_column :groups, :subtitle, :string
  end
end
