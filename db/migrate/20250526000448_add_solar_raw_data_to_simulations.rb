class AddSolarRawDataToSimulations < ActiveRecord::Migration[7.1]
  def change
    add_column :simulations, :solar_raw_data, :json
  end
end
