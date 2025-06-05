Rails.application.routes.draw do
  get 'assistant/chatbot'
  post 'checkout/create', to: 'checkout#create', as: 'checkout_create'
  get 'plans', to: 'plans#index', as: 'plans'
  devise_for :users
  get 'home/index'
  root 'home#index'
  get '/assistente', to: 'assistant#chat'
  post '/assistant/chatbot', to: 'assistant#chatbot'

  get 'about', to: 'home#about'
  get 'energies', to: 'home#energies'
  get 'reports', to: 'home#reports'

  get "up" => "rails/health#show", as: :rails_health_check

  resources :plans, only: [:index]
  # Define other routes if needed
  resources :people
  resource :individual, only: [:show, :edit, :update, :create]
  resources :companies
  resources :cities, only: [:index]
  resources :simulations do
    member do
      get :export_excel
      get :export_power_bi
    end
  end

  resources :energy_companies do
    post :extract_data, on: :collection
  end

end
