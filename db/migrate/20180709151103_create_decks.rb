# frozen_string_literal: true

# Migration create tables decks, reviews and decks_reviews
class CreateDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :decks do |t|
      t.references :user, foreign_key: true, on_delete: :cascade

      t.string :name, limit: 75, null: false
      t.string :detail, limit: 155
      t.string :hex_color, limit: 7, null: false, default: "#ffffff"

      t.integer :cards_count, null: false, default: 0

      t.timestamps
    end
  end
end
