Clouds::Application.routes.draw do
  devise_for :users

  resources :posts, :only => [ :index ]
  resources :users, :only => [ :index, :show ] do
    resources :posts
  end

  root :to => "welcome#index"
end
