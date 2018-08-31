# frozen_string_literal: true

# Migration to add extra attributes to model User
class AddNameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string, null: false, limit: 90
  end
end
