class AddDownloadPrivilegeToIndicators < ActiveRecord::Migration[6.1]
  def change
    add_column :indicators, :download_privilege, :boolean
  end
end
