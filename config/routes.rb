Rails.application.routes.draw do
  resources :transactions, only: [:index, :show]
  resources :stations, only: [:index, :show]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
