class Simulation < ApplicationRecord
  belongs_to :city
  belongs_to :energy_company
  belongs_to :company, class_name: "Person", optional: true

  store_accessor :solar_result, :annual_generation_kwh, :estimated_savings
  store_accessor :wind_result, :annual_generation_kwh, :estimated_savings

  validates :area_available, :estimated_consumption_kwh_year, presence: true


  def city_name
    city&.name || '-'
  end

  def energy_company_name
    energy_company&.name || '-'
  end

  def created_at_short
    I18n.l(created_at, format: :short)
  end
end
