class AddWindReturn5yToSimulations < ActiveRecord::Migration[7.1]
  def change
    add_column :simulations, :wind_return_5y, :decimal
  end
end
