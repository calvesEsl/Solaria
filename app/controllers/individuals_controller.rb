class IndividualsController < ApplicationController
  before_action :authenticate_user!

  def show
    @individual = current_user.individual
    redirect_to root_path, alert: 'Dados não encontrados.' unless @individual
  end

  def edit
    @individual = current_user.individual
  end

  def update
    @individual = current_user.individual
    if @individual.update(individual_params)
      redirect_to individual_path, notice: 'Dados atualizados com sucesso.'
    else
      render :show
    end
  end

  private

  def company_params
    params.require(:company).permit(:name, :email, :phone, :cnpj, :city_id, :user_id)
  end
end
