class SimulationsController < ApplicationController
  def new
    @simulation = Simulation.new
  end

  def create
    @simulation = Simulation.new(simulation_params)
    if @simulation.save
      redirect_to @simulation
    else
      render :new
    end
  end

  def show
    @simulation = Simulation.find(params[:id])
    @result = SimulationService.new(@simulation).perform
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
end
