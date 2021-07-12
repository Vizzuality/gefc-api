class ChangeIndicatorWidgetsByDefaultToFalse < ActiveRecord::Migration[6.1]
  def change
    change_column_default :indicator_widgets, :by_default, false
  end
end
