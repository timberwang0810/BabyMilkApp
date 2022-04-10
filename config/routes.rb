Rails.application.routes.draw do
  resources :bottles
  resources :visits
  resources :patients
  resources :users
  patch 'patients/:id/discharge' => 'patients#discharge', as: :discharge_patient
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
