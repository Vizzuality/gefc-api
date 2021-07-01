class FixActiveStorageRecordId < ActiveRecord::Migration[6.1]
  def up
    execute 'delete from active_storage_attachments'
    remove_column :active_storage_attachments, :record_id
    add_column :active_storage_attachments, :record_id, :uuid, null: false

    add_index :active_storage_attachments, [ :record_type, :record_id, :name, :blob_id ], name: 'active_storage_attachments_uniqueness_idx', unique: true
  end

  def down
    execute 'delete from active_storage_attachments'
    remove_column :active_storage_attachments, :record_id
    add_column :active_storage_attachments, :record_id, :int, null: false

    add_index :active_storage_attachments, [ :record_type, :record_id, :name, :blob_id ], name: 'active_storage_attachments_uniqueness_idx', unique: true
  end
end
