require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }

  authenticate :user do
    resources :products, only: [:show, :index] do
      member do
        post :preset
        post :configure
      end
    end

    resources :tasks, only: [:index, :create, :show, :destroy] do
      collection do
        post :mass_destroy
      end
      member do
        get :finish
        get :deliver
        get :accept
        get :reject
      end

    end

    resources :plans, only: [:index, :new, :create, :show, :destroy]
    resources :suppliers
  end

  authenticate :user, lambda { |u| u.email == ENV['ADMIN_EMAIL'] } do
    mount Sidekiq::Web => '/sidekiq'
  end

  root 'products#index'
end
