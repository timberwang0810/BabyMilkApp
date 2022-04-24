Rails.application.routes.draw do
  resources :bottles
  resources :visits
  resources :patients
  resources :users
  patch 'patients/:id/discharge' => 'patients#discharge', as: :discharge_patient
  
  patch 'scanbottle/update', to: 'scanbottle#update', as: :scan_bottle_update
  get 'scanbottle/edit', to: 'scanbottle#edit', as: :scan_bottle_edit
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html


  resources :sessions
  get 'user/edit' => 'users#edit', :as => :edit_current_user
  get 'signup' => 'users#new', :as => :signup
  get 'login' => 'sessions#new', :as => :login
  get 'logout' => 'sessions#destroy', :as => :logout

  # Default route
  root :to => 'patients#index', :as => :home
end
