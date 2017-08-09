Rails.application.routes.draw do
  root 'hello#index'
  get '/t', to: 'hello#t'

  post 'auth/login'
  post 'auth/register'
  post 'auth/auth'
  post 'auth/logout'
  post 'auth/uptoken'


  resources :users do
    member do
    end
  end

  resource :channels do
    member do
    end
  end

  get 'temp', to: "channels#create"

end
