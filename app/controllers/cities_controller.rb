class CitiesController < ApplicationController
  def index
    @cities = City.where("name ILIKE ?", "%#{params[:q]}%").limit(10)
    render json: @cities.map { |c| { id: c.id, text: c.name } }
  end
end
