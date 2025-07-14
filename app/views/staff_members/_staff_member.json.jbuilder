json.extract! staff_member, :id, :name, :email, :role, :gym_location_id, :created_at, :updated_at
json.url staff_member_url(staff_member, format: :json)
