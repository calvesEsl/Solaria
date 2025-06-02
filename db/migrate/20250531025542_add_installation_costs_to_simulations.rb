class AddInstallationCostsToSimulations < ActiveRecord::Migration[7.1]
  def change
    add_column :simulations, :cost_per_panel, :decimal
    add_column :simulations, :cost_per_turbine, :decimal
  end
end
