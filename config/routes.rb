Clouds::Application.routes.draw do
  devise_for :users

  resources :posts, :only => [ :index, :new, :create ]
  resources :users, :only => [ :index, :show ] do
    resources :posts, :except => [ :new, :create ]
  end

  root :to => "welcome#index"
end
