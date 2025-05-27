class AddDetailsToSimulations < ActiveRecord::Migration[7.1]
  def change
    add_column :simulations, :co2_saved_kg, :float
    add_column :simulations, :payback_years, :float
    add_column :simulations, :solar_peak_days, :integer
    add_column :simulations, :avg_wind_speed, :float
    add_column :simulations, :dominant_wind_direction, :integer
    add_column :simulations, :uv_index_avg, :float
    add_column :simulations, :cloud_cover_avg, :float
    add_column :simulations, :economic_return_5y, :float
  end
end