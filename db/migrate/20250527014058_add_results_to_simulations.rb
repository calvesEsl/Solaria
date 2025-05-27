class AddResultsToSimulations < ActiveRecord::Migration[7.1]
  def change
    add_column :simulations, :solar_result, :jsonb
    add_column :simulations, :wind_result, :jsonb
    add_column :simulations, :better_option, :string
  end
end
