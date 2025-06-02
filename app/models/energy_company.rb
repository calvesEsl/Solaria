class EnergyCompany < ApplicationRecord
  has_one_attached :bill_image

  validates :name, :price_per_kwh, presence: true
end
