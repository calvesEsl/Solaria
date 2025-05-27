class SimulationsController < ApplicationController
  def index
    @simulations = Simulation.includes(:city, :energy_company).order(created_at: :desc)
  end

  def new
    @simulation = Simulation.new
  end

  def create
    @simulation = Simulation.new(simulation_params)

    if @simulation.save
      result = SimulationService.new(@simulation).perform

      @simulation.update(
        solar_result: result[:solar],
        wind_result: result[:wind],
        better_option: result[:better_option],
        co2_saved_kg: result[:co2_saved_kg],
        payback_years: result[:payback_years],
        solar_peak_days: result[:solar_peak_days],
        avg_wind_speed: result[:avg_wind_speed],
        dominant_wind_direction: result[:dominant_wind_direction],
        uv_index_avg: result[:uv_index_avg],
        cloud_cover_avg: result[:cloud_cover_avg],
        economic_return_5y: result[:economic_return_5y]
      )
      flash[:notice] = "Simulação enviada com sucesso"
      redirect_to @simulation
    else
      flash[:alert] = "Erro ao enviar simulação"
      render :new
    end
  end

  def show
    @simulation = Simulation.find(params[:id])

    if @simulation.solar_result.present? && @simulation.wind_result.present?
      @result = {
        solar: @simulation.solar_result.symbolize_keys,
        wind: @simulation.wind_result.symbolize_keys,
        better_option: @simulation.better_option,
        co2_saved_kg: @simulation.co2_saved_kg,
        payback_years: @simulation.payback_years,
        solar_peak_days: @simulation.solar_peak_days,
        avg_wind_speed: @simulation.avg_wind_speed,
        dominant_wind_direction: @simulation.dominant_wind_direction,
        uv_index_avg: @simulation.uv_index_avg,
        cloud_cover_avg: @simulation.cloud_cover_avg,
        economic_return_5y: @simulation.economic_return_5y
      }
    else
      @result = SimulationService.new(@simulation).perform
      @simulation.update(
        solar_result: @result[:solar],
        wind_result: @result[:wind],
        better_option: @result[:better_option],
        co2_saved_kg: @result[:co2_saved_kg],
        payback_years: @result[:payback_years],
        solar_peak_days: @result[:solar_peak_days],
        avg_wind_speed: @result[:avg_wind_speed],
        dominant_wind_direction: @result[:dominant_wind_direction],
        uv_index_avg: @result[:uv_index_avg],
        cloud_cover_avg: @result[:cloud_cover_avg],
        economic_return_5y: @result[:economic_return_5y]
      )
    end

    @solar = @result[:solar]
    @wind = @result[:wind]
    @better_option = @result[:better_option]

    @solar_indicators = {
      co2_saved_kg: @result[:co2_saved_kg],
      payback_years: @result[:payback_years],
      solar_peak_days: @result[:solar_peak_days],
      uv_index_avg: @result[:uv_index_avg],
      cloud_cover_avg: @result[:cloud_cover_avg],
      economic_return_5y: @result[:economic_return_5y]
    }

    @wind_indicators = {
      avg_wind_speed: @result[:avg_wind_speed],
      dominant_wind_direction: @result[:dominant_wind_direction],
      economic_return_5y: @wind[:economic_return_5y]
    }

    respond_to do |format|
      format.html
      format.xlsx { render xlsx: "export", filename: "simulacao_#{@simulation.id}.xlsx" }
    end
  end

  def export_excel
    @simulation = Simulation.find(params[:id])
    set_result_data

    xlsx_package = Axlsx::Package.new
    wb = xlsx_package.workbook

    styles = wb.styles
    header = styles.add_style(b: true, bg_color: 'FFCC00', alignment: { horizontal: :center })
    currency = styles.add_style(num_fmt: 5)
    centered = styles.add_style(alignment: { horizontal: :center })

    wb.add_worksheet(name: "Simulação") do |sheet|
      sheet.add_row ["Tipo", "Unidades", "Geração Anual (kWh)", "Economia Estimada (R$)"], style: header
      sheet.add_row ["Solar", @solar[:panels], @solar[:annual_generation_kwh], @solar[:estimated_savings]], style: [centered, centered, centered, currency]
      sheet.add_row ["Eólica", @wind[:turbines], @wind[:annual_generation_kwh], @wind[:estimated_savings]], style: [centered, centered, centered, currency]
      sheet.add_row []

      sheet.add_row ["Indicadores Solares"], style: header
      sheet.add_row ["Dias com pico solar", @solar_indicators[:solar_peak_days]]
      sheet.add_row ["Índice UV médio", @solar_indicators[:uv_index_avg]]
      sheet.add_row ["Cobertura média de nuvens (%)", @solar_indicators[:cloud_cover_avg]]
      sheet.add_row ["CO₂ evitado (kg)", @solar_indicators[:co2_saved_kg]]
      sheet.add_row ["Payback estimado (anos)", @solar_indicators[:payback_years]]
      sheet.add_row ["Retorno econômico em 5 anos (R$)", @solar_indicators[:economic_return_5y]]

      sheet.add_row []
      sheet.add_row ["Indicadores Eólicos"], style: header
      sheet.add_row ["Velocidade média do vento (m/s)", @wind_indicators[:avg_wind_speed]]
      sheet.add_row ["Direção dominante do vento (°)", @wind_indicators[:dominant_wind_direction]]
    end

    send_data xlsx_package.to_stream.read, filename: "simulacao_#{@simulation.id}.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  def export_power_bi
    @simulation = Simulation.find(params[:id])
    set_result_data

    xlsx_package = Axlsx::Package.new
    wb = xlsx_package.workbook
    header = wb.styles.add_style(b: true, bg_color: '0070C0', fg_color: 'FFFFFF', alignment: { horizontal: :center })

    wb.add_worksheet(name: "PowerBI") do |sheet|
      sheet.add_row ["Categoria", "Indicador", "Valor"], style: header

      sheet.add_row ["Solar", "Unidades", @solar[:panels]]
      sheet.add_row ["Solar", "Geração Anual (kWh)", @solar[:annual_generation_kwh]]
      sheet.add_row ["Solar", "Economia Estimada (R$)", @solar[:estimated_savings]]
      sheet.add_row ["Solar", "Dias com pico solar", @solar_indicators[:solar_peak_days]]
      sheet.add_row ["Solar", "Índice UV médio", @solar_indicators[:uv_index_avg]]
      sheet.add_row ["Solar", "Cobertura média de nuvens (%)", @solar_indicators[:cloud_cover_avg]]
      sheet.add_row ["Solar", "CO₂ evitado (kg)", @solar_indicators[:co2_saved_kg]]
      sheet.add_row ["Solar", "Payback (anos)", @solar_indicators[:payback_years]]
      sheet.add_row ["Solar", "Retorno 5 anos (R$)", @solar_indicators[:economic_return_5y]]

      sheet.add_row ["Eólica", "Unidades", @wind[:turbines]]
      sheet.add_row ["Eólica", "Geração Anual (kWh)", @wind[:annual_generation_kwh]]
      sheet.add_row ["Eólica", "Economia Estimada (R$)", @wind[:estimated_savings]]
      sheet.add_row ["Eólica", "Velocidade média do vento", @wind_indicators[:avg_wind_speed]]
      sheet.add_row ["Eólica", "Direção dominante do vento", @wind_indicators[:dominant_wind_direction]]

      sheet.add_row ["Geral", "Melhor opção", @better_option]
    end

    send_data xlsx_package.to_stream.read, filename: "powerbi_simulacao_#{@simulation.id}.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
  end

  private

  def simulation_params
    params.require(:simulation).permit(
      :city_id, :energy_company_id, :area_available,
      :simulate_solar_batch, :simulate_wind_batch,
      :panel_quantity, :turbine_quantity,
      :estimated_consumption_kwh_year
    )
  end

  def set_result_data
    @solar = @simulation.solar_result.symbolize_keys
    @wind = @simulation.wind_result.symbolize_keys
    @better_option = @simulation.better_option

    @solar_indicators = {
      co2_saved_kg: @simulation.co2_saved_kg,
      payback_years: @simulation.payback_years,
      solar_peak_days: @simulation.solar_peak_days,
      uv_index_avg: @simulation.uv_index_avg,
      cloud_cover_avg: @simulation.cloud_cover_avg,
      economic_return_5y: @simulation.economic_return_5y
    }

    @wind_indicators = {
      avg_wind_speed: @simulation.avg_wind_speed,
      dominant_wind_direction: @simulation.dominant_wind_direction
    }
  end
end
