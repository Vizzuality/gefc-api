class EnablePostgis < ActiveRecord::Migration[6.1]
  def change
    reversible do |dir|
      dir.up do
        if Rails.env.development? || Rails.env.test? || version_13plus?
          # only CREATEDB privilege required in 13+ rather than SUPERUSER
          execute 'CREATE EXTENSION IF NOT EXISTS "postgis";'
        end
      end
      dir.down do
        if Rails.env.development? || Rails.env.test? || version_13plus?
          execute 'DROP EXTENSION IF EXISTS "postgis";'
        end
      end
    end
  end

  def version_13plus?
    # e.g. 11.5
    version = ActiveRecord::Base.connection.select_value("show server_version")
    major = version.split(".").first
    major.to_i >= 13
  end
end
