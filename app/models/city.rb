class City < ApplicationRecord
  belongs_to :state
  has_many :people, inverse_of: :city

  validates :code_ibge, :name, presence: true
end
