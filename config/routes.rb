UserTesting::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end

  devise_for :users, :controllers => { :sessions => "users/sessions" }, :path => "", :path_names => { :sign_in => '', :sign_out => 'logout', :password => 'secret', :confirmation => 'verification', :unlock => 'unblock', :registration => 'users/registration', :sign_up => 'new' }

  resources :users, :only => [:show, :index]
end
