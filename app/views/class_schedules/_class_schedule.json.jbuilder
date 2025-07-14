json.extract! class_schedule, :id, :activity_id, :room_id, :trainer_id, :weekday, :start_time, :end_time, :created_at, :updated_at
json.url class_schedule_url(class_schedule, format: :json)
