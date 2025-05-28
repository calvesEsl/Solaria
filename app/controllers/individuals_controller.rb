class IndividualsController < ApplicationController
  def index
    @individuals = Individual.order(:name).page(params[:page]).per(10)
  end

  def show
    @individual = Individual.find(params[:id])
  end
end
