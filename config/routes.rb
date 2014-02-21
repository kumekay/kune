Kune::Application.routes.draw do
  resources :articles
  root :to => "articles#index"
  devise_for :users, :controllers => {:registrations => "registrations"}
  resources :users
end