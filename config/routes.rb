Rails.application.routes.draw do
  root 'shifts#index'
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
end
