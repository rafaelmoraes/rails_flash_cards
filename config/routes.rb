# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: ENV["HOST"]

  scope "(:locale)", locale: Regexp.new(I18n.available_locales.join("|")) do
    devise_for :users, controllers: { registrations: "registrations" }
    root to: "decks#index"

    resources :decks do
      resources :cards
      resource :review, only: :start do
        get "start", to: "start"
      end
    end

    resources :reviews, only: %i[edit update] do
      get "done", to: "done"

      resources :cards, controller: :review_sessions, only: :show do
        patch "answer", to: "answer"
        patch "learned", to: "learned"
        patch "change_difficulty", to: "change_difficulty"
      end
    end

    resources :settings, only: %i[index update]
    namespace :admin do
      resources :invitations, except: %i[edit update]
      resources :users, only: %i[index destroy]
    end
  end
end
