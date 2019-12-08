json.extract! staffevent, :id, :staff_id, :event_date, :event_reason, :event_notes, :created_at, :updated_at
json.url staffevent_url(staffevent, format: :json)
