class ChangeCityToReferenceInEnergyCompanies < ActiveRecord::Migration[7.0]
  def change
    remove_column :energy_companies, :city, :string
    add_reference :energy_companies, :city, foreign_key: true
  end
end
