class CreateStates < ActiveRecord::Migration[7.1]
  def change
    create_table :states do |t|
      t.integer :code
      t.string :name
      t.string :acronym
      t.string :region
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
