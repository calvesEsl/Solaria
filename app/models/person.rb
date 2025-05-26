class Person < ApplicationRecord
  belongs_to :city, inverse_of: :people
end
