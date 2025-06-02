require 'net/http'
require 'json'

class SimulationService
  SOLAR_API_KEY = ENV['OPENWEATHERMAP_API_KEY']
  ONECALL_URL   = 'https://api.openweathermap.org/data/3.0/onecall'
  SOLAR_URL     = 'https://api.openweathermap.org/energy/1.0/solar/data'

  COST_PER_PANEL_DEFAULT   = 3500.0
  COST_PER_TURBINE_DEFAULT = 12000.0

  def initialize(simulation)
    @simulation = simulation
    @lat        = simulation.city.latitude
    @lon        = simulation.city.longitude
    @price_kwh  = simulation.energy_company.price_per_kwh.to_f
    @area       = simulation.area_available
  end

  def perform(solar_data: nil)
    solar_data ||= fetch_solar_data
    wind_data = fetch_wind_data

    solar_result = calculate_solar(solar_data)
    wind_result  = calculate_wind(wind_data)

    solar_indicators = calculate_solar_indicators(solar_result, wind_data)
    wind_indicators  = calculate_wind_indicators(wind_data, wind_result)

    better = solar_result[:estimated_savings] > wind_result[:estimated_savings] ? 'Solar' : 'Wind'

    puts "[DEBUG] Solar Savings: #{solar_result[:estimated_savings]} | Geração: #{solar_result[:annual_generation_kwh]}"
    puts "[DEBUG] Wind Savings: #{wind_result[:estimated_savings]} | Geração: #{wind_result[:annual_generation_kwh]}"

    {
      solar: solar_result,
      wind: wind_result,
      better_option: better,
      payback_years: solar_indicators[:payback_years],         # solar
      economic_return_5y: solar_indicators[:economic_return_5y], # solar
      wind_payback_years: wind_indicators[:wind_payback_years], # eólica
      wind_return_5y: wind_indicators[:wind_return_5y]          # eólica
    }.merge(
      solar_indicators.except(:payback_years, :economic_return_5y)
    ).merge(
      wind_indicators.except(:wind_payback_years, :wind_return_5y)
    )
  end

  private

  def fetch_solar_data
    date = Date.today.strftime('%Y-%m-%d')
    tz   = '+00:00'
    url = URI("#{SOLAR_URL}?lat=#{@lat}&lon=#{@lon}&date=#{date}&tz=#{tz}&appid=02af3cba5dd0598967b9f93f13a1034c")

    puts "[API] Chamando solar: #{url}"
    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      puts "[API ERROR] Solar data failed: #{response.code} - #{response.body}"
      {}
    end
  end

  def fetch_wind_data
    url = URI("#{ONECALL_URL}?lat=#{@lat}&lon=#{@lon}&exclude=minutely,hourly,daily,alerts&units=metric&appid=02af3cba5dd0598967b9f93f13a1034c")
    puts "[API] Chamando vento: #{url}"

    response = Net::HTTP.get_response(url)

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      puts "[DEBUG] wind_speed: #{data.dig('current', 'wind_speed')}"
      data
    else
      puts "[API ERROR] Wind data failed: #{response.code} - #{response.body}"
      {}
    end
  end

  def calculate_solar(data)
    radiation = data.dig('irradiance', 'daily', 0, 'clear_sky', 'ghi').to_f / 1000.0

    if radiation.zero?
      puts '[FALLBACK] Radiação não encontrada — usando média nacional 5.2 kWh/m²/dia'
      radiation = 5.2
    end

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
    wind_speed = data.dig('current', 'wind_speed').to_f

    if wind_speed.zero?
      puts '[SIMULAÇÃO] wind_speed ausente ou igual a zero — ignorando geração eólica'
      return {
        turbines: 0,
        annual_generation_kwh: 0,
        estimated_savings: 0.0
      }
    end

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

  def calculate_solar_indicators(solar_result, wind_data)
    estimated_savings = solar_result[:estimated_savings]
    co2_saved_kg = (solar_result[:annual_generation_kwh] * 0.084).round(2)

    cost_per_panel = @simulation.cost_per_panel || COST_PER_PANEL_DEFAULT
    investment_cost = solar_result[:panels] * cost_per_panel

    {
      solar_peak_days: 220,
      uv_index_avg: wind_data.dig('current', 'uvi').to_f,
      cloud_cover_avg: wind_data.dig('current', 'clouds').to_f,
      co2_saved_kg: co2_saved_kg,
      payback_years: (estimated_savings > 0 ? (investment_cost / estimated_savings).round(1) : nil),
      economic_return_5y: (estimated_savings * 5).round(2)
    }
  end

  def calculate_wind_indicators(wind_data, wind_result)
    estimated_savings = wind_result[:estimated_savings]
    cost_per_turbine = @simulation.cost_per_turbine || COST_PER_TURBINE_DEFAULT
    investment_cost = wind_result[:turbines] * cost_per_turbine

    {
      avg_wind_speed: wind_data.dig('current', 'wind_speed').to_f,
      dominant_wind_direction: wind_data.dig('current', 'wind_deg'),
      wind_payback_years: (estimated_savings > 0 ? (investment_cost / estimated_savings).round(1) : nil),
      wind_return_5y: (estimated_savings * 5).round(2)
    }
  end
end
