# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  root to: 'decks#index'

  resources :decks do
    resources :cards
  end
end
