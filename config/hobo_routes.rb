# This is an auto-generated file: don't edit!
# You can add your own routes in the config/routes.rb file
# which will override the routes in this file.

GestorMovimientos::Application.routes.draw do


  # Resource routes for controller users
  resources :users, :only => [:edit, :show, :create, :update, :destroy] do
    member do
      get 'account'
      put 'accept_invitation', :action => 'do_accept_invitation'
      get 'accept_invitation'
      put 'reset_password', :action => 'do_reset_password'
      get 'reset_password'
    end
  end

  # User routes for controller users
  post 'login(.:format)' => 'users#login', :as => 'user_login_post'
  get 'login(.:format)' => 'users#login', :as => 'user_login'
  get 'logout(.:format)' => 'users#logout', :as => 'user_logout'
  get 'forgot_password(.:format)' => 'users#forgot_password', :as => 'user_forgot_password'
  post 'forgot_password(.:format)' => 'users#forgot_password', :as => 'user_forgot_password_post'


  # Resource routes for controller movimientos
  resources :movimientos

  namespace :concerns do

  end

  namespace :admin do


    # Resource routes for controller admin/users
    resources :users do
      collection do
        post 'invite', :action => 'do_invite'
        get 'invite'
      end
    end

  end

end
