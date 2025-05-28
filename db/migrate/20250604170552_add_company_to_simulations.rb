class AddCompanyToSimulations < ActiveRecord::Migration[7.1]
  def change
    add_reference :simulations, :company, foreign_key: { to_table: :people }
  end
end
