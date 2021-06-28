class AddSlugToSubgroup < ActiveRecord::Migration[6.1]
  def change
    add_column :subgroups, :slug, :string
  end
end
