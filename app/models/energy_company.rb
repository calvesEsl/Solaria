class EnergyCompany < ApplicationRecord
  validates :name, :price_per_kwh, presence: true
end