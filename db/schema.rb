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

ActiveRecord::Schema[7.1].define(version: 2025_06_04_170552) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "cities", force: :cascade do |t|
    t.integer "code_ibge"
    t.string "name"
    t.float "latitude"
    t.float "longitude"
    t.boolean "capital"
    t.bigint "state_id", null: false
    t.string "siafi_id"
    t.integer "ddd"
    t.string "timezone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "energy_companies", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price_per_kwh", precision: 6, scale: 4
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "city_id"
    t.index ["city_id"], name: "index_energy_companies_on_city_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "city_id"
    t.string "cpf"
    t.string "cnpj"
    t.string "endereco"
    t.decimal "calculation_area", precision: 10, scale: 2
    t.string "type"
    t.bigint "user_id", null: false
    t.index ["city_id"], name: "index_people_on_city_id"
    t.index ["user_id"], name: "index_people_on_user_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "price_cents"
    t.string "stripe_price_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "simulations", force: :cascade do |t|
    t.bigint "city_id", null: false
    t.bigint "energy_company_id", null: false
    t.decimal "area_available", precision: 10, scale: 2
    t.boolean "simulate_solar_batch", default: false
    t.boolean "simulate_wind_batch", default: false
    t.decimal "estimated_consumption_kwh_year", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "solar_raw_data"
    t.integer "panel_quantity"
    t.integer "turbine_quantity"
    t.jsonb "solar_result"
    t.jsonb "wind_result"
    t.string "better_option"
    t.float "co2_saved_kg"
    t.float "payback_years"
    t.integer "solar_peak_days"
    t.float "avg_wind_speed"
    t.integer "dominant_wind_direction"
    t.float "uv_index_avg"
    t.float "cloud_cover_avg"
    t.float "economic_return_5y"
    t.decimal "cost_per_panel"
    t.decimal "cost_per_turbine"
    t.decimal "wind_return_5y"
    t.float "wind_payback_years"
    t.bigint "company_id"
    t.index ["city_id"], name: "index_simulations_on_city_id"
    t.index ["company_id"], name: "index_simulations_on_company_id"
    t.index ["energy_company_id"], name: "index_simulations_on_energy_company_id"
  end

  create_table "states", force: :cascade do |t|
    t.integer "code"
    t.string "name"
    t.string "acronym"
    t.string "region"
    t.float "latitude"
    t.float "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "is_legal_person"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cities", "states"
  add_foreign_key "energy_companies", "cities"
  add_foreign_key "people", "cities"
  add_foreign_key "people", "users"
  add_foreign_key "simulations", "cities"
  add_foreign_key "simulations", "energy_companies"
  add_foreign_key "simulations", "people", column: "company_id"
end
