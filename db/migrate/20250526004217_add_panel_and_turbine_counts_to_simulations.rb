class AddPanelAndTurbineCountsToSimulations < ActiveRecord::Migration[7.1]
  def change
    add_column :simulations, :panel_quantity, :integer
    add_column :simulations, :turbine_quantity, :integer
  end
end
