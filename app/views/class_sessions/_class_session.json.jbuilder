json.extract! class_session, :id, :class_schedule_id, :activity_id, :room_id, :trainer_id, :starts_at, :ends_at, :max_participants, :created_at, :updated_at
json.url class_session_url(class_session, format: :json)
