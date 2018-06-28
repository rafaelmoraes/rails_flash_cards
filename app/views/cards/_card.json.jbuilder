json.extract! card, :id, :front, :back, :difficulty_level, :learned, :views_count, :deck_id, :created_at, :updated_at
json.url card_url(card, format: :json)
