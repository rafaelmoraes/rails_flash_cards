# frozen_string_literal: true

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|pt-BR/ do
    devise_for :users
    root to: "decks#index"

    resources :decks do
      resources :cards
      resource :review, only: %i[settings update_settings start reset] do
        get "settings", to: "settings"
        put "update_settings", to: "update_settings"
        patch "update_settings", to: "update_settings"

        get "start", to: "start"
        put "reset", to: "reset"

        resources :cards, controller: :review_cards, only: :show do
          get "fail", to: "fail"
          get "hit", to: "hit"
        end
      end
    end

    resources :settings, only: %i[index update]
  end
end
