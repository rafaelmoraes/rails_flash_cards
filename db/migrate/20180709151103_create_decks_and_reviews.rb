# frozen_string_literal: true

# Migration create tables decks, reviews and decks_reviews
class CreateDecksAndReviews < ActiveRecord::Migration[5.2]
  def create_decks
    create_table :decks do |t|
      t.references :user, foreign_key: true, on_delete: :cascade
      t.string :name, limit: 75, null: false
      t.string :detail, limit: 255
      t.integer :cards_count, null: false, default: 0

      t.timestamps
    end
  end

  def create_reviews
    create_table :reviews do |t|
      t.references :user, foreign_key: true
      t.references :deck, foreign_key: true

      t.integer :cards_per_review, default: 0, null: false
      t.integer :repeat_easy_card, default: 0, null: false
      t.integer :repeat_hard_card, default: 0, null: false
      t.integer :repeat_medium_card, default: 0, null: false
      t.integer :cards_count, default: 0, null: false

      t.timestamps
    end
  end

  def create_decks_reviews
    create_table :decks_reviews do |t|
      t.belongs_to :deck, index: true
      t.belongs_to :review, index: true
    end
  end

  def change
    create_decks
    create_reviews
    create_decks_reviews
  end
end
