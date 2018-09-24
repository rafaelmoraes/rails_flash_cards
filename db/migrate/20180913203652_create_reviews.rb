class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :user, foreign_key: true, on_delete: :cascade
      t.references :deck, foreign_key: true, on_delete: :cascade

      t.integer :cards_per_day, default: 30, null: false
      t.integer :repeat_easy, default: 1, null: false
      t.integer :repeat_hard, default: 3, null: false
      t.integer :repeat_medium, default: 2, null: false

      t.integer :queue, array: true, default: [], null: false

      t.integer :offensive, default: 0, null: false
      t.integer :reviews_completed, default: 0, null: false

      t.date :session_date, default: Time.now.to_date, null: false
      t.boolean :daily_review_done, default: false, null: false

      t.timestamps
    end
  end
end
