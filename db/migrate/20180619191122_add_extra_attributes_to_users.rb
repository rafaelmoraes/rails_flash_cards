# frozen_string_literal: true

# Migration to add extra attributes to model User
class AddExtraAttributesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :name, :string, null: false, limit: 90
    add_column :users, :invitation_token, :string, null: false, limit: 30
    add_column :users, :admin, :boolean, null: false, default: false
  end
end
