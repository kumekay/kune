require 'sidekiq/web'

Kune::Application.routes.draw do
  post "subscriptions/subscribe", as: "subscribe"
  get "subscriptions/unsubscribe", as: "unsubscribe"
  ActiveAdmin.routes(self)
  mount RedactorRails::Engine => '/redactor_rails'
  resources :articles do
    resources :categories, only: [:show], shallow: true
    resources :comments, only: [:create, :destroy]
  end
  root to: redirect("/articles")
  devise_for :users, :controllers => {:registrations => "registrations"}
  
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end