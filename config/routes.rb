# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|pt-BR/ do
    devise_for :users
    root to: 'decks#index'

    resources :decks do
      resources :cards
    end

    resources :reviews do
      get 'settings', to: 'settings'
      put 'start', to: 'start'
      put 'pause', to: 'pause'
      put 'reset', to: 'reset'

      resources :cards, controller: :review_cards do
        get 'previous', to: 'previous'
        get 'next', to: 'next'
      end
    end

    resources :settings, only: %i[index update]
  end
end
