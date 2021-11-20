# frozen_string_literal: true

Rails.application.routes.draw do
  get 'searches/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  # Almost every application defines a route for the root path ("/") at the top of this file.
  root to: 'articles#index'

  resources :articles, only: :index do
    get :search, on: :collection
  end

  resources :searches, only: :index
end
