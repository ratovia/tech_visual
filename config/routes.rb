Rails.application.routes.draw do
  root 'admin/dashboard#index'
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api do
    resource :shift_generator, only: :show
  end
end
