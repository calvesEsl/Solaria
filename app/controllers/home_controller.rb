class HomeController < ApplicationController
  include BaseCrud::Base

  before_action :authenticate_user!

  def index

  end

  def resource_class
    User
  end

  def about
  end

  def energies
  end

  def reports
  end

  private

  def resource_params
    params.require(:user).permit(:name)
  end
end
