class AddTranslationColumns < ActiveRecord::Migration[6.1]
  def change
    rename_column :groups, :name, :name_en
    add_column :groups, :name_cn, :string
    rename_column :groups, :description, :description_en
    add_column :groups, :description_cn, :string
    rename_column :groups, :subtitle, :subtitle_en
    add_column :groups, :subtitle_cn, :string

    rename_column :subgroups, :name, :name_en
    add_column :subgroups, :name_cn, :string
    rename_column :subgroups, :description, :description_en
    add_column :subgroups, :description_cn, :string

    rename_column :regions, :name, :name_en
    add_column :regions, :name_cn, :string

    rename_column :units, :name, :name_en
    add_column :units, :name_cn, :string

    rename_column :indicators, :name, :name_en
    add_column :indicators, :name_cn, :string
    rename_column :indicators, :description, :description_en
    add_column :indicators, :description_cn, :text

    rename_column :records, :category_1, :category_1_en
    add_column :records, :category_1_cn, :string
    rename_column :records, :category_2, :category_2_en
    add_column :records, :category_2_cn, :string
    add_column :records, :category_3_en, :string
    add_column :records, :category_3_cn, :string

    reversible do |dir|
      dir.up do
        change_column :groups, :description_en, :text
        change_column :subgroups, :description_en, :text
        change_column :indicators, :description_en, :text
      end

      dir.down do
        change_column :groups, :description_en, :text
        change_column :subgroups, :description_en, :text
        change_column :indicators, :description_en, :string
      end
    end
  end
end
