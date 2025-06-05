class EnergyCompany < ApplicationRecord
  has_one_attached :bill_image

  validates :name, :price_per_kwh, presence: true
  belongs_to :city, inverse_of: :energy_companies

  def city_name
    city&.name
  end
end
