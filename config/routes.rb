Minotaur::Application.routes.draw do

  root to: 'construction#index'

  get '/sandman', to: 'sandman#index'
  match '/sandman/:action', to: 'sandman#:action', via: 'get'

  get '/hollywood', to: 'hollywood#index'
  match '/hollywood/:action', to: 'hollywood#:action', via: 'get'

  resources :construction
  resources :medidations

end
