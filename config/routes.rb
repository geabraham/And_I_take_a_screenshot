Minotaur::Application.routes.draw do

  root to: 'activation_codes#index'

  resources :activation_codes, only: [:index]
  post 'activate', to: 'activation_codes#activate'
  
end
