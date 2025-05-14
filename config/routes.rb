Rails.application.routes.draw do
  root 'people#index'

  get "up" => "rails/health#show", as: :rails_health_check

  # Define other routes if needed
  resources :people
end
