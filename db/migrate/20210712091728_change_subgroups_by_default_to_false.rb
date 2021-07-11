class ChangeSubgroupsByDefaultToFalse < ActiveRecord::Migration[6.1]
  def change
    change_column_default :subgroups, :by_default, false
  end
end
