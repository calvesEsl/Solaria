class CreateIndividuals < ActiveRecord::Migration[7.1]
  def change
    create_table :individuals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
