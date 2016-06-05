Rails.application.routes.draw do

  root 'events#index'
  resources :events
  resources :categories

	match '/profile/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], :as => :finish_signup
	match '/profile/:id' => 'users#user_show', via: [:get, :patch], :as => :user_show

	devise_for :users, :controllers => { registration: 'registration', omniauth_callbacks: 'omniauth_callbacks' }

end
