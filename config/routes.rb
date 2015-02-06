Minotaur::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root to: 'activation_codes#index'

  resources :activation_codes, only: [:index] do
    get :validate, on: :member
  end

  resources :patient_enrollments, only: [:new] do
    post :register, on: :member
  end

  resource :patient_management, controller: :patient_management, only: [] do
    get :index, to: :select_study_and_site
    post :invite
  end

  resources :study_sites, only: [:index]

  get :logout, controller: :application

  get '*path', controller: :application, to: :routing_error
end
