class Simulation < ApplicationRecord
  belongs_to :city
  belongs_to :energy_company
  store_accessor :solar_result, :annual_generation_kwh, :estimated_savings
  store_accessor :wind_result, :annual_generation_kwh, :estimated_savings

  validates :area_available, :estimated_consumption_kwh_year, presence: true
end
