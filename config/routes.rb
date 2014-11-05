Minotaur::Application.routes.draw do

  root to: 'patient_registration#index'

  resources :patient_registrations, only: [:index]
  
end
