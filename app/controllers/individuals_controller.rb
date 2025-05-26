class IndividualsController < ApplicationController
  def index
    @individuals = Individual.order(:name).page(params[:page]).per(10)
  end
end
