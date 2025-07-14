json.extract! reservation, :id, :user_id, :class_session_id, :status, :booked_at, :created_at, :updated_at
json.url reservation_url(reservation, format: :json)
