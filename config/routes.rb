Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: 'json' } do
    devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

    resources :blogs
    resources :comments
    resources :likes

  end



end
