class Simulation < ApplicationRecord
  belongs_to :city
  belongs_to :energy_company

  validates :area_available, :estimated_consumption_kwh_year, presence: true
end
