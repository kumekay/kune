Kune::Application.routes.draw do
  ActiveAdmin.routes(self)
  mount RedactorRails::Engine => '/redactor_rails'
  resources :articles do
    resources :categories, only: [:show], shallow: true
  end
  resources :comments, only: [:create, :destroy]
  root :to => "articles#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
end