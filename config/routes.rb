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
  
  patch 'scanbottle/update', to: 'scanbottle#update', as: :scan_bottle_update
  get 'scanbottle/edit', to: 'scanbottle#edit', as: :scan_bottle_edit

  resources :sessions
  get 'user/edit' => 'users#edit', :as => :edit_current_user
  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  # Default route
  root :to => 'home#index'

end
