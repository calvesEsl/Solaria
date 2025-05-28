class City < ApplicationRecord
  belongs_to :state
  has_many :people, inverse_of: :city
  has_many :energy_companies, inverse_of: :city

  validates :code_ibge, :name, presence: true
end
