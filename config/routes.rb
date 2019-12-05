Rails.application.routes.draw do
  root 'shifts#index'
  get 'admin' => 'users#show'
end
