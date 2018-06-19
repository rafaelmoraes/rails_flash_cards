class CreateCards < ActiveRecord::Migration[5.2]
  def up

    create_table :cards do |t|
      t.references :deck, foreign_key: true
      t.string :front, limit: 150, null: false
      t.string :back, limit: 150, null: false
      t.boolean :learned, null: false, default: false
      t.integer :views_count, null: false, default: 0

      t.timestamps
    end

    execute <<-SQL
      CREATE TYPE card_level AS ENUM ('easy', 'medium', 'hard');
      ALTER TABLE cards ADD COLUMN difficulty_level card_level NOT NULL DEFAULT 'medium';
    SQL
  end

  def down
    execute "DROP TYPE card_level;"

    drop_table :cards
  end
end
