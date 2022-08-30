class AddSlugToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :slug, :string
    reversible do |dir|
      dir.up do
        Indicator.all.each { |i|
          i.set_slug
          i.save
        }
      end
    end
  end
end
