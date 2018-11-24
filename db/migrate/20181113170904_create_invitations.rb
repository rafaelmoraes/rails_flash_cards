# frozen_string_literal: true

class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations do |t|
      t.references :user, foreign_key: true

      t.string :token, null: false, unique:  true, index: true
      t.string :guest_name, null: false, limit: 90, unique: true
      t.string :guest_email, limit: 155, unique: true
      t.string :locale, limit: 5, default: "pt-BR", null: false

      t.timestamps
    end
  end
end
