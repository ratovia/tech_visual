Rails.application.routes.draw do
  root 'shifts#index'
  get 'users/:id' => 'users#show'
end
