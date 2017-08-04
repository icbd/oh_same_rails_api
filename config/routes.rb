Rails.application.routes.draw do
  post 'auth/login'
  post 'auth/register'
  post 'auth/auth'
  get 'auth/logout'


  root 'hello#index'
  get '/t', to: 'hello#t'

  resources :users do
    member do
    end
  end

end
