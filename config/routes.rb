Kune::Application.routes.draw do
  ActiveAdmin.routes(self)
  mount RedactorRails::Engine => '/redactor_rails'
  resources :articles
  root :to => "articles#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
end