Minotaur::Application.routes.draw do

  root to: 'patient_registrations#index'

  resources :patient_registrations, only: [:index]
  
end
