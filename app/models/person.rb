class Person < ApplicationRecord
  self.inheritance_column = :type
  
  belongs_to :city, inverse_of: :people
  belongs_to :user
end
