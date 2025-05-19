class CreateCities < ActiveRecord::Migration[7.1]
  def change
    create_table :cities do |t|
      t.integer :code_ibge
      t.string :name
      t.float :latitude
      t.float :longitude
      t.boolean :capital
      t.references :state, null: false, foreign_key: true
      t.string :siafi_id
      t.integer :ddd
      t.string :timezone

      t.timestamps
    end
  end
end
