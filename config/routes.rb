Rails.application.routes.draw do
  
  get 'home', to: 'home#index', as: :home
  
  resources :bottles
  get 'bottles/:id/delete', to: 'bottles#delete', as: :delete_bottle
  post 'bottles/:id/reprint', to: 'bottles#reprint', as: :reprint_bottle

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
  get 'scanbottle/delete', to: 'scanbottle#delete', as: :scan_bottle_delete
  delete 'scanbottle/destroy', to: 'scanbottle#destroy', as: :scan_bottle_destroy

  resources :sessions
  resources :users
  get 'user/edit' => 'users#edit', :as => :edit_current_user
  get 'signup' => 'users#new', :as => :signup
  get 'users' => 'users#index', :as => :user_index
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  post 'password/forgot', to: 'password#forgot'
  post 'password/reset', to: 'password#reset'

  # Default route
  root :to => 'sessions#new'

end
