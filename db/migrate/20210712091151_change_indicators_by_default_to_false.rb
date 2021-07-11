class ChangeIndicatorsByDefaultToFalse < ActiveRecord::Migration[6.1]
  def change
    change_column_default :indicators, :by_default, false
  end
end
