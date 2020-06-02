# frozen_string_literal: true

Rails.application.routes.draw do

  root to: 'home#index'

  scope 'dashboard' do
    get '/', to: 'dashboard#index', as: 'dashboard'
    get 'stats', to: 'dashboard#stats', as: 'dashboard_stats'
    get 'timeline', to: 'dashboard#timeline', as: 'dashboard_timeline'
    get 'jumbotron', to: 'dashboard#jumbotron', as: 'dashboard_jumbotron'
  end

  resources :elastic_endpoints, path: 'elastic/clusters'

  namespace :integration, path: 'integrations' do
    resources :slacks, path: 'slack'
    resources :trellos, path: 'trello'
    resources :emails, path: 'email'
  end

  resources :jobs, only: [:index, :show]

  resources :permanents, path: 'alerts' do
    collection do
      get 'tips/:show', to: 'alerts#tips', as: 'tips'
      get ':id/disable', to: 'permanents#disable', as: 'disable'
      get ':id/enable', to: 'permanents#enable', as: 'enable'
    end
  end

  resources :schedules, except: [:show] do
    collection do
      put ':id/trigger', to: 'schedules#trigger', as: 'trigger'
    end
  end

  resources :searches, except: [:show]
  resources :settings, only: [:index, :update]
  resources :tasks, only: [:index, :update, :show]

  resources :temporaries, only: %i[index create], path: 'debugger'

  devise_for :users,
             skip: %i[database_authenticatable],
             path: 'u',
             path_names: {
               sign_in: 'user',
               sign_out: 'goodbye',
               sign_up: 'request'
             },
             controllers: {
               omniauth_callbacks: 'users/omniauth_callbacks',
               sessions: 'users/sessions',
               passwords: 'users/passwords',
               registrations: 'users/registrations',
               two_factor_authentication: 'users/two_factor_authentication'
             }

  devise_scope :user do
    get 'u/otp/:email', to: 'users/registrations#otp_setup', as: 'otp_registration'
  end

  resources :accounts, except: [:new, :create, :edit] do
    collection do
      get 'pending', to: 'accounts#pending'
    end
  end

  #mount Hostmon::Engine => "/hostmon", :as => "hostmon" 
end
