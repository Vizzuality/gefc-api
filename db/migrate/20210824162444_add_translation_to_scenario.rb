class AddTranslationToScenario < ActiveRecord::Migration[6.1]
  def change
    rename_column :scenarios, :name, :name_en
    add_column :scenarios, :name_cn, :string
  end
end
