json.extract! company, :id, :tariff_id, :name, :contact_email, :contact_phone, :active, :created_at, :updated_at
json.url company_url(company, format: :json)
