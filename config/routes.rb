# frozen_string_literal: true

Rails.application.routes.draw do
  devise_scope :user do
    root to: 'devise/sessions#new'
  end
  devise_for :users

  shallow do
    resources :decks do
      resources :cards
    end
  end
end
