# frozen_string_literal: true

Rails.application.routes.draw do
  # Necessary to use locale in URL
  scope '(:locale)', locale: /en|pt/ do
    devise_for :users
    root to: 'decks#index'

    resources :decks do
      resources :cards
    end
  end
end
