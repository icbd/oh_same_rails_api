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

  resources :channels do
    member do
    end
  end

  resources :posts do
    member do
    end
  end
end
