# frozen_string_literal: true

# Migration to create the table to model Card
class CreateCards < ActiveRecord::Migration[5.2]
  def change
    create_table :cards do |t|
      t.references :deck, foreign_key: true, on_delete: :cascade
      t.references :user, foreign_key: true, on_delete: :cascade
      t.string :front, limit: 150, null: false
      t.string :back, limit: 150, null: false
      t.string :difficulty_level, null: false, limit: 6, default: 'medium'
      t.integer :views_count, null: false, default: 0
      t.boolean :learned, null: false, default: false
      t.timestamps
    end
  end
end
