Rails.application.routes.draw do
  root 'items#index'
  resources :items do
    resources :purchases, only: [:show]
    resources :sales, only: [:show]
  end
end
