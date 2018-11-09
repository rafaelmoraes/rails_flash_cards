# frozen_string_literal: true

# Migration to create table to user settings
class CreateSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :settings do |t|
      t.references :user, foreign_key: true

      t.string :locale, limit: 5, default: "pt-BR", null: false
      t.string :color_scheme,
               default: Setting.default_color_scheme,
               limit: 5,
               null: false
      t.integer :cards_per_review, default: 30, null: false
      t.integer :repeat_easy_card, default: 1, null: false
      t.integer :repeat_medium_card, default: 2, null: false
      t.integer :repeat_hard_card, default: 3, null: false

      t.timestamps
    end
  end
end
