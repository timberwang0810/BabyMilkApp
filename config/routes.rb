Rails.application.routes.draw do
  
  get 'home', to: 'home#index', as: :home
  
  resources :bottles
  resources :visits
  resources :patients
  resources :users
  patch 'patients/:id/discharge' => 'patients#discharge', as: :discharge_patient
  resources :verifications, only: [:new, :create, :success]
  get 'verifications/success/:patient_id/:bottle_id', to: 'verifications#success', as: :success
  get 'verifications/failed/:patient_id/:bottle_id', to: 'verifications#failed', as: :failed
  get 'verifications/expired/:patient_id/:bottle_id', to: 'verifications#expired', as: :expired

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

end
