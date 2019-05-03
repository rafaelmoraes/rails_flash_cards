class ChangeCardsFrontAndBackLimitSize < ActiveRecord::Migration[6.0]
  def change
    change_column :cards, :front, :string, limit: 500
    change_column :cards, :back, :string, limit: 500
  end
end
