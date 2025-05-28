class CompaniesController < ApplicationController
  def index
    @companies = Company.order(:name).page(params[:page])

    @companies = @companies.where("name ILIKE ?", "%#{params[:name]}%") if params[:name].present?
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)
    @company.user = current_user
    if @company.save
      redirect_to edit_company_path(@company), notice: 'Filial criada com sucesso.'
    else
      puts @company.errors.full_messages
      render :new
    end
  end

  def update
    if @company.update(company_params)
      redirect_to edit_company_path(@company), notice: 'Filial atualizada com sucesso.'
    else
      render :edit
    end
  end

  def edit
    @company = Company.find(params[:id])
  end

  private

  def company_params
    params.require(:company).permit(:name, :email, :phone, :cnpj, :city_id)
  end
end
