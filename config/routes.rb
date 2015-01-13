Minotaur::Application.routes.draw do

  mount JasmineRails::Engine => '/specs' if defined?(JasmineRails)
  root to: 'activation_codes#index'

  resources :activation_codes, only: [:index, :show] do
    get 'activate', on: :member
  end

  get 'activation_code/:activation_code/activate', to: "activation_codes#activate"

  resource :patient_enrollments, only: [:new, :create]

end
