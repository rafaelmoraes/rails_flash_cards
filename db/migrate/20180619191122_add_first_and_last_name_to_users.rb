# frozen_string_literal: true

#Migration to add extra attributes to model User
class AddFirstAndLastNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string, null: false, limit: 40
    add_column :users, :last_name, :string, null: false, limit: 40
  end
end
