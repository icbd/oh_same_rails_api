Rails.application.routes.draw do
  post 'auth/login'
  post 'auth/register'
  get 'auth/logout'

  root 'hello#index'

  resources :users do
    member do
    end
  end

  
end
