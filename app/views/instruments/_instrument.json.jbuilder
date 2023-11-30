json.extract! instrument, :id, :state, :name, :images, :price, :price_currency, :company_id, :created_at, :updated_at
json.url instrument_url(instrument, format: :json)
