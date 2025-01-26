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

ActiveRecord::Schema[8.0].define(version: 2024_12_29_154317) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "consolidations", force: :cascade do |t|
    t.bigint "consolidatable_id", null: false
    t.string "consolidatable_type", null: false
    t.string "var_name", null: false
    t.string "var_type", null: false
    t.float "float_value"
    t.bigint "integer_value"
    t.boolean "boolean_value"
    t.string "string_value"
    t.datetime "datetime_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["consolidatable_id", "consolidatable_type", "var_name"], name: "consolidations_main_index"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "series_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sortable_id"
    t.string "sortable_type"
    t.index ["series_id"], name: "index_items_on_series_id"
    t.index ["sortable_id", "sortable_type"], name: "index_items_on_sortable_id_and_sortable_type"
  end

  create_table "pictures", force: :cascade do |t|
    t.string "path"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "postable", default: true
    t.index ["postable"], name: "index_pictures_on_postable"
  end

  create_table "relations", force: :cascade do |t|
    t.bigint "item1_id", null: false
    t.bigint "item2_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item1_id", "item2_id"], name: "index_relations_on_item1_id_and_item2_id", unique: true
    t.index ["item1_id"], name: "index_relations_on_item1_id"
    t.index ["item2_id"], name: "index_relations_on_item2_id"
  end

  create_table "series", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "items", "series"
  add_foreign_key "relations", "items", column: "item1_id"
  add_foreign_key "relations", "items", column: "item2_id"
end
