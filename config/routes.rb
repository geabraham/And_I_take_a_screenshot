Minotaur::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root to: 'activation_codes#index'

  resources :activation_codes, only: [:index] do
    get :validate, on: :member
  end

  resources :patient_enrollments, only: [:new] do
    post :register, on: :member
  end

  get :patient_management, controller: :patient_management, to: :select_study_and_site
  resources :study_sites, only: [:index]

  get :logout, controller: :application
end
