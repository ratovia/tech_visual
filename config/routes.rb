Rails.application.routes.draw do
  root "git_lessons#show"
  resources :node_trees
  resources :git_lessons, only: :show
end
