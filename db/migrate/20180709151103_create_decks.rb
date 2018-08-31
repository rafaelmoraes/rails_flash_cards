# frozen_string_literal: true

# Migration create tables decks, reviews and decks_reviews
class CreateDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :decks do |t|
      t.references :user, foreign_key: true, on_delete: :cascade

      t.string :name, limit: 75, null: false
      t.string :detail, limit: 255

      t.integer :cards_count, null: false, default: 0
      t.integer :cards_per_review, default: 30, null: false

      t.integer :repeat_easy_card, default: 1, null: false
      t.integer :repeat_hard_card, default: 3, null: false
      t.integer :repeat_medium_card, default: 2, null: false

      t.integer :card_id_on_review, default: nil, null: true
      t.binary :card_ids_on_review, array: true, default: [], null: false

      t.timestamps
    end
  end
end
