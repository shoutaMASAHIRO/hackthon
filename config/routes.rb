Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  devise_for :users

  root "posts#index"

  # ✅ ユーザー一覧&詳細
  resources :users, only: [:index, :show]

  resources :posts do
    resources :comments, only: [:create, :destroy, :edit, :update]
    resource  :like,     only: [:create, :destroy]
  end
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  
end
