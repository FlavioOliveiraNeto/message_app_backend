Rails.application.routes.draw do
  post '/login', to: 'authentication#authenticate'
  resources :messages, only: [:index, :create]
end
