Rails.application.routes.draw do
  root 'items#index'
  get 'items/:id/undelete', to: 'items#undelete', as: 'undelete_item'
  resources :items do
    resources :purchases, only: [:show]
    resources :sales, only: [:show]
  end
end
