json.extract! ticket, :id, :closed_at, :closed, :user_id, :created_at, :updated_at
json.url ticket_url(ticket, format: :json)
