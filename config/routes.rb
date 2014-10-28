Minotaur::Application.routes.draw do

  root to: 'construction#index'

  resources :construction
  resources :medidations

end
