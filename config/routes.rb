Rails.application.routes.draw do
  resources :check_ins, only: [:new, :create, :show, :update] do
    resources :screeners, only: [:new, :create]
  end

  root to: "check_ins#new"
end
