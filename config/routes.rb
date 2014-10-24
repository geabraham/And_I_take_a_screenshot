BlueprintUI::Application.routes.draw do

  root to: 'medidations#index'

  get '/sandman', to: 'sandman#index'
  match '/sandman/:action', to: 'sandman#:action', via: 'get'

  get '/hollywood', to: 'hollywood#index'
  match '/hollywood/:action', to: 'hollywood#:action', via: 'get'

  resources :medidations

end
