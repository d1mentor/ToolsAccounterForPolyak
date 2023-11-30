Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    resources :users
    resources :tickets
    resources :acts
    resources :instruments
    resources :companies
    get 'cutaways/index'
    get 'cutaways/profile'
    get 'cutaways/blog'
    get 'cutaways/pricing'
    get 'dashboard', to: 'dashboard#dashboard'
    get 'logs', to: 'dashboard#logs'

    get '/my_profile', to: 'profiles#my_profile'
    get '/edit_my_profile', to: 'profiles#edit'
    patch '/update_my_profile', to: 'profiles#update'
    get '/download_qr/:instrument_id', to: 'instruments#download_qr'
    get '/set_telegram_id', to: 'users#set_telegram_id'
    get '/delete_telegram_id', to: 'users#delete_telegram_id'

    get '/notification_settings', to: 'users#notification_settings'
    patch '/update_notification_settings', to: 'users#update_notification_settings'

    get '/profiles', to: 'profiles#profiles'
    get '/qr/:instrument_id', to: 'acts#new_act_from_qr'

    root to: 'profiles#my_profile', as: :authenticated_root

    get 'set_locale/:locale', to: 'locale#set_locale', as: :set_locale
  end

  unauthenticated :user do
    get '/qr/:instrument_id', to: 'acts#new_act_from_qr', as: :unauthenticated_qr
    root to: 'cutaways#index', as: :unauthenticated_root
  end

  get '*path', to: 'application#redirect_to_root', via: :all
end
