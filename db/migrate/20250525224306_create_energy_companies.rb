class CreateEnergyCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :energy_companies do |t|
      t.string :name, null: false
      t.decimal :price_per_kwh, precision: 6, scale: 4

      t.timestamps
    end
  end
end
