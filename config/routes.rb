Rails.application.routes.draw do
  root to: 'static_pages#home'
  get 'static_pages/mission'

  get "oauth/callback" => "oauths#callback" # for use with Github, Facebook
  get "oauth/:provider" => "oauths#oauth", :as => :auth_at_provider
  post 'logout' => 'oauths#destroy', :as => :logout

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
