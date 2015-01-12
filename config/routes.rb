Minotaur::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root to: 'activation_codes#index'

  resources :activation_codes, only: [:index] do
    get 'activate', on: :member
  end

  resource :patient_enrollments, only: [:new, :create]

  get :patient_management, controller: :patient_management, to: :select_study_and_site
end
