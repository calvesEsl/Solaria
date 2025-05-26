class CompaniesController < ApplicationController
  def index
    @companies = Company.order(:name).page(params[:page])
  end
end
