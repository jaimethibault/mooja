Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/god', as: 'rails_admin'
  ActiveAdmin.routes(self)
  devise_for :users,
    controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root to: 'pages#home'
  resources :surfcamps, only: [:index, :show] do
    resources :bookings, only: [:create]
  end
  resources :bookings, only: [:show] do
    resources :payments, only: [:new, :create]
  end
  mount Attachinary::Engine => "/attachinary"
end
