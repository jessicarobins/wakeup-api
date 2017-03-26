Rails.application.routes.draw do
  resources :transactions, only: [:show]
  resources :stations, only: [:index, :show] do
    member do
      get 'show_by_route_name'
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
