Rails.application.routes.draw do
  devise_for :users
  get 'home/index'
  root 'home#index'

  get 'about', to: 'home#about'
  get 'energies', to: 'home#energies'
  get 'reports', to: 'home#reports'

  get "up" => "rails/health#show", as: :rails_health_check

  # Define other routes if needed
  resources :people
  resources :individuals
  resources :companies
  resources :cities, only: [:index]
  resources :simulations do
    member do
      get :export_excel
      get :export_power_bi
    end
  end
end
