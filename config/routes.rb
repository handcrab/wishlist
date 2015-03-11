Rails.application.routes.draw do
  devise_for :users,
             controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  root 'wishes#index'
  authenticated :user do
    # root to: 'wishes#all', as: :authenticated_root
    root to: 'wishes#personal', as: :authenticated_root
  end

  resources :wishes do
    collection do
      get 'owned'
      get 'personal'
    end
    patch 'toggle_owned', on: :member
    patch 'toggle_public', on: :member
  end

  get 'users/:id/wishes', to: 'wishes#user_public', as: :user_public
end
