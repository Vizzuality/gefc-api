class ReplaceDownloadPrivilegeWithOnlyAdminsCanDownload < ActiveRecord::Migration[6.1]
  def change
    rename_column :indicators, :download_privilege, :only_admins_can_download
  end
end
