class AddTypeToPeople < ActiveRecord::Migration[7.1]
  def change
    add_column :people, :type, :string
  end
end
