json.extract! attendance, :id, :user_id, :class_session_id, :attended_at, :created_at, :updated_at
json.url attendance_url(attendance, format: :json)
