Rails.application.routes.draw do
  root to: 'static_pages#home'
  get 'static_pages/mission'

  get 'oauth/callback', to: 'oauths#callback' # for use with Github, Facebook
  get 'oauth/:provider', as: :auth_at_provider, to: 'oauths#oauth'
  post 'logout', as: :logout, to: 'oauths#destroy'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
