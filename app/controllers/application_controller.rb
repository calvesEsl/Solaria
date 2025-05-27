class ApplicationController < ActionController::Base
  layout :layout_by_resource
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :is_legal_person])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :is_legal_person])
  end

  private

  def layout_by_resource
    devise_controller? ? "devise" : "application"
  end
end
