Rails.application.routes.draw do
  root :to => 'simple_calculator#index'
  namespace :operation do
    post :binary_operations, to: 'binary_operations#create_or_update', as: :binary_operations_create_or_update
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
