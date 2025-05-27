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

ActiveRecord::Schema[7.1].define(version: 2025_05_27_014058) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.index ["city_id"], name: "index_people_on_city_id"
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
    t.index ["city_id"], name: "index_simulations_on_city_id"
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
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cities", "states"
  add_foreign_key "people", "cities"
  add_foreign_key "simulations", "cities"
  add_foreign_key "simulations", "energy_companies"
end
