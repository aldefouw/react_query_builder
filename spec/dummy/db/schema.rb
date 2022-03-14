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

ActiveRecord::Schema.define(version: 2022_02_21_195955) do

  create_table "people", force: :cascade do |t|
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.boolean "active"
    t.boolean "trained"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "qb_field_mappings", force: :cascade do |t|
    t.string "model"
    t.text "labels"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "qb_saved_queries", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.text "q"
    t.text "display_fields"
    t.date "last_run"
    t.string "query_type"
    t.string "last_run_by"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end


  create_view "qb_people", sql_definition: <<-SQL
      SELECT people.id,
         people.last_name,
         people.first_name,
         people.middle_name,
         people.active,
         people.trained
  FROM people
  SQL
end
