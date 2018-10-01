# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|pt-BR/ do
    devise_for :users
    root to: "decks#index"

    resources :decks do
      resources :cards
      resource :review, only: :start do
        get "start", to: "start"
      end
    end

    resources :reviews, only: %i[edit update] do
      put "reset", to: "reset"
      get "done", to: "done"

      resources :cards, controller: :review_sessions, only: :show do
        get "hit", to: "hit"
        get "miss", to: "miss"
        get "learned", to: "learned"
        get "change_difficulty", to: "change_difficulty"
      end
    end

    resources :settings, only: %i[index update]
  end
end
