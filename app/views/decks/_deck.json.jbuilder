json.extract! deck, :id, :name, :detail, :cards_count, :created_at, :updated_at
json.url deck_url(deck, format: :json)
