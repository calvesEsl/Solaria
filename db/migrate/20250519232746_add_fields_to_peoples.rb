class AddFieldsToPeoples < ActiveRecord::Migration[7.1]
  def change
    change_table :people do |t|
      t.references :city, foreign_key: true, index: true
      t.string :cpf
      t.string :cnpj
      t.string :endereco
      t.decimal :calculation_area, precision: 10, scale: 2
    end
  end
end
