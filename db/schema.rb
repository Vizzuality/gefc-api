# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_09_12_131613) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.uuid "record_id", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "active_storage_attachments_uniqueness_idx", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "geometry_import_attempts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "total_rows_count"
    t.integer "imported_records_count"
    t.integer "jid"
    t.integer "status"
    t.string "file_path"
  end

  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name_en"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description_en"
    t.string "slug", null: false
    t.string "subtitle_en"
    t.string "name_cn"
    t.string "description_cn"
    t.string "subtitle_cn"
    t.index ["name_en", "name_cn"], name: "index_groups_on_name_en_and_name_cn", unique: true
  end

  create_table "groups_import_attempts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "file_path"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "indicator_widgets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "indicator_id"
    t.uuid "widget_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "by_default", default: false, null: false
  end

  create_table "indicators", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "subgroup_id"
    t.string "name_en"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "widget_id"
    t.text "description_en"
    t.boolean "by_default", default: false, null: false
    t.string "name_cn"
    t.text "description_cn"
    t.string "slug", null: false
    t.string "data_source_en"
    t.string "data_source_cn"
    t.boolean "only_admins_can_download"
    t.text "region_ids"
    t.text "visualization_types"
    t.text "default_visualization_name"
    t.text "categories"
    t.text "category_filters"
    t.integer "start_date"
    t.integer "end_date"
    t.json "meta"
    t.text "sankey"
    t.text "scenarios"
    t.index ["name_en", "name_cn", "subgroup_id"], name: "index_indicators_on_name_en_and_name_cn_and_subgroup_id", unique: true
    t.index ["slug"], name: "index_indicators_on_slug", unique: true
    t.index ["subgroup_id", "by_default"], name: "index_indicators_on_subgroup_id_and_by_default", unique: true, where: "by_default"
    t.index ["subgroup_id"], name: "index_indicators_on_subgroup_id"
    t.index ["widget_id"], name: "index_indicators_on_widget_id"
  end

  create_table "record_widgets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "record_id"
    t.uuid "widget_id"
    t.datetime "created_at", default: "2022-09-09 15:26:45", null: false
    t.datetime "updated_at", default: "2022-09-09 15:26:45", null: false
  end

  create_table "records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "indicator_id"
    t.float "value"
    t.integer "year"
    t.string "category_1_en"
    t.string "category_2_en"
    t.datetime "created_at", default: "2022-09-09 15:26:45", null: false
    t.datetime "updated_at", default: "2022-09-09 15:26:45", null: false
    t.uuid "unit_id"
    t.uuid "region_id"
    t.json "original_categories"
    t.string "category_1_cn"
    t.string "category_2_cn"
    t.string "category_3_en"
    t.string "category_3_cn"
    t.uuid "scenario_id"
    t.text "visualization_types"
    t.text "scenario_info"
    t.text "unit_info"
    t.index ["indicator_id"], name: "index_records_on_indicator_id"
    t.index ["region_id"], name: "index_records_on_region_id"
    t.index ["scenario_id"], name: "index_records_on_scenario_id"
    t.index ["unit_id"], name: "index_records_on_unit_id"
  end

  create_table "regions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name_en"
    t.integer "region_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name_cn"
    t.json "geometry_encoded"
    t.geometry "geometry", limit: {:srid=>0, :type=>"geometry"}
    t.json "tooltip_properties"
    t.index ["name_en", "name_cn", "region_type"], name: "index_regions_on_name_en_and_name_cn_and_region_type", unique: true
  end

  create_table "scenarios", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name_en"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name_cn"
  end

  create_table "subgroups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "group_id"
    t.string "name_en"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description_en"
    t.boolean "by_default", default: false, null: false
    t.string "name_cn"
    t.string "description_cn"
    t.string "slug", null: false
    t.index ["group_id", "by_default"], name: "index_subgroups_on_group_id_and_by_default", unique: true, where: "by_default"
    t.index ["group_id", "name_en", "name_cn"], name: "index_subgroups_on_group_id_and_name_en_and_name_cn", unique: true
    t.index ["group_id"], name: "index_subgroups_on_group_id"
  end

  create_table "units", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name_en", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name_cn"
    t.index ["name_en", "name_cn"], name: "index_units_on_name_en_and_name_cn", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "role", default: 0
    t.string "name"
    t.string "organization"
    t.string "title"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "widgets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_widgets_on_name", unique: true
  end

  create_table "widgets_import_attempts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "total_rows_count"
    t.integer "imported_records_count"
    t.integer "jid"
    t.integer "status"
    t.string "file_path"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "indicator_widgets", "indicators"
  add_foreign_key "indicator_widgets", "widgets"
  add_foreign_key "indicators", "subgroups"
  add_foreign_key "record_widgets", "records"
  add_foreign_key "record_widgets", "widgets"
  add_foreign_key "records", "indicators"
  add_foreign_key "records", "regions"
  add_foreign_key "records", "units"
  add_foreign_key "subgroups", "groups"
end
