# db/migrate/xxxx_create_simulations.rb
class CreateSimulations < ActiveRecord::Migration[7.1]
  def change
    create_table :simulations do |t|
      t.references :city, null: false, foreign_key: true
      t.references :energy_company, null: false, foreign_key: true
      t.decimal :area_available, precision: 10, scale: 2
      t.boolean :simulate_solar_batch, default: false
      t.boolean :simulate_wind_batch, default: false
      t.decimal :estimated_consumption_kwh_year, precision: 10, scale: 2

      t.timestamps
    end
  end
end
