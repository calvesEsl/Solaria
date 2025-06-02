class AddWindPaybackYearsToSimulations < ActiveRecord::Migration[7.1]
  def change
    add_column :simulations, :wind_payback_years, :float
  end
end
