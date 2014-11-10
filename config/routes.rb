Minotaur::Application.routes.draw do

  root to: 'activation_codes#index'

  resources :activation_codes, only: [:index] do
    post 'activate', on: :member
  end
  
end
