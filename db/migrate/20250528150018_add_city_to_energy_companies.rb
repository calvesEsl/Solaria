class AddCityToEnergyCompanies < ActiveRecord::Migration[7.1]
  def change
    add_column :energy_companies, :city, :string
  end
end
