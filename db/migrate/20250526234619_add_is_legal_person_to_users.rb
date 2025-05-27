class AddIsLegalPersonToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :is_legal_person, :boolean
  end
end
