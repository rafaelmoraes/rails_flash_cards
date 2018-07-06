# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /en|pt-BR/ do
    devise_for :users
    root to: 'decks#index'

    resources :decks do
      resources :cards
      member do
        scope :review do
          get 'settings', to: 'review#settings'
          put 'start', to: 'review#start'
          put 'update', to: 'review#update'
          put 'pause', to: 'review#pause'
          put 'reset', to: 'review#reset'
          scope :cards do
            get ':card_id', to: 'review_cards#show'
            get ':card_id/previous', to: 'review_cards#previous'
            get ':card_id/next', to: 'review_cards#next'
          end
        end
      end
    end

    resources :settings, only: %i[index update]
  end
end
