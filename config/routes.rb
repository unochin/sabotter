Rails.application.routes.draw do
  root to: 'static_pages#home'
  get 'static_pages/mission'

  get 'oauth/callback', to: 'oauths#callback' # for use with Github, Facebook
  get 'oauth/:provider', as: :auth_at_provider, to: 'oauths#oauth'
  post 'logout', as: :logout, to: 'oauths#destroy'

  resource :user, only: %i[show] do
    resources :tasks
    put 'pause/tasks/:task_id', as: :toggle_pause, to: 'tasks#toggle_pause_flag'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
