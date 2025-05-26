require 'net/http'
require 'json'

class SimulationService

  SOLAR_API_KEY = ENV['OPENWEATHERMAP_API_KEY']
  SOLAR_URL = 'https://api.openweathermap.org/data/2.5/solar_radiation'
  ONECALL_URL = 'https://api.openweathermap.org/data/3.0/onecall'

  def initialize(simulation)
    @simulation = simulation
    @lat = simulation.city.latitude
    @lon = simulation.city.longitude
    @price_kwh = simulation.energy_company.price_per_kwh.to_f
    @area = simulation.area_available
  end

  def perform(solar_data: nil)
    solar_data ||= fetch_solar_data
    wind_data = fetch_wind_data

    solar_result = calculate_solar(solar_data)
    wind_result  = calculate_wind(wind_data)

    {
      solar: solar_result,
      wind: wind_result,
      better_option: solar_result[:estimated_savings] > wind_result[:estimated_savings] ? 'Solar' : 'Wind'
    }
  end

  private

  def fetch_solar_data
    date = Date.today.strftime('%Y-%m-%d')
    tz   = '+00:00'
    url = URI("https://api.openweathermap.org/energy/1.0/solar/data?lat=#{@lat}&lon=#{@lon}&date=#{date}&tz=#{tz}&appid=02af3cba5dd0598967b9f93f13a1034c")

    puts "[API] Chamando: #{url}"
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      puts "[API ERROR] #{response.code} - #{response.body}"
      {}
    end
  end

  def fetch_wind_data
    url = URI("#{ONECALL_URL}?lat=#{@lat}&lon=#{@lon}&appid=02af3cba5dd0598967b9f93f13a1034c")
    JSON.parse(Net::HTTP.get(url))
  end

  def calculate_solar(data)
    radiation = data.dig('irradiance', 'daily', 0, 'clear_sky', 'ghi').to_f / 1000.0

    panels = if @simulation.simulate_solar_batch
               @simulation.panel_quantity.presence || (@area / 1.7).floor
             else
               1
             end

    annual_generation = (radiation * 365 * panels * 0.8).round(2)
    estimated_savings = (annual_generation * @price_kwh).round(2)

    {
      panels: panels,
      annual_generation_kwh: annual_generation,
      estimated_savings: estimated_savings
    }
  end

  def calculate_wind(data)
    wind_speed = data.dig('current', 'wind_speed')
    wind_energy = (0.5 * wind_speed**3).round(2)

    turbines = if @simulation.simulate_wind_batch
                 @simulation.turbine_quantity.presence || (@area / 3.0).floor
               else
                 1
               end

    annual_generation = (wind_energy * 8760 * turbines * 0.4).round(2)
    estimated_savings = (annual_generation * @price_kwh).round(2)

    {
      turbines: turbines,
      annual_generation_kwh: annual_generation,
      estimated_savings: estimated_savings
    }
  end
end
