class CreateDecks < ActiveRecord::Migration[5.2]
  def change
    create_table :decks do |t|
      t.references :user, foreign_key: true
      t.string :name, limit: 75
      t.string :detail, limit: 255
      t.integer :cards_count

      t.timestamps
    end
  end
end
