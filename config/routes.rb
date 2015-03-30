Rails.application.routes.draw do

  resources :restaurants do
    resources :reviews
  end
end
