class DropIndividualsTable < ActiveRecord::Migration[7.0]
  def change
    drop_table :individuals
  end
end
