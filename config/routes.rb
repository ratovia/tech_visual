Rails.application.routes.draw do
  root 'admin/dashboard#index'
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :api do
    post 'shift_generator' => 'shift_generator#create'
  end
end
