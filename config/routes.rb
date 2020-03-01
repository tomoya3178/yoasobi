Rails.application.routes.draw do
  root 'infos#index'
  resources :places
  resources :infos
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
