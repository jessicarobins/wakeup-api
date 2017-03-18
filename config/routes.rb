Rails.application.routes.draw do
  resources :transaction_types
  resources :transactions
  resources :trips
  resources :stations
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
